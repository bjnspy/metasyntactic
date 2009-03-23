// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "LocationManager.h"

#import "AlertUtilities.h"
#import "AppDelegate.h"
#import "Controller.h"
#import "Location.h"
#import "LocationUtilities.h"
#import "Model.h"
#import "NotificationCenter.h"
#import "OperationQueue.h"
#import "UserLocationCache.h"

@interface LocationManager()
@property (retain) Controller* controller_;
@property (retain) CLLocationManager* locationManager_;
@property (retain) NSLock* gate_;
@property (retain) UINavigationItem* navigationItem_;
@property (retain) UIBarButtonItem* buttonItem_;
@property BOOL running_;
@property BOOL firstTime_;
@property BOOL userInvoked_;
@end


@implementation LocationManager

@synthesize controller_;
@synthesize locationManager_;
@synthesize gate_;
@synthesize navigationItem_;
@synthesize buttonItem_;
@synthesize running_;
@synthesize firstTime_;
@synthesize userInvoked_;

property_wrapper(Controller*, controller, Controller);
property_wrapper(NSLock*, gate, Gate);
property_wrapper(CLLocationManager*, locationManager, LocationManager);
property_wrapper(UINavigationItem*, navigationItem, NavigationItem);
property_wrapper(UIBarButtonItem*, buttonItem, ButtonItem);
property_wrapper(BOOL, running, Running);
property_wrapper(BOOL, firstTime, FirstTime);
property_wrapper(BOOL, userInvoked, UserInvoked);

- (void) dealloc {
    self.controller = nil;
    self.locationManager = nil;
    self.gate = nil;
    self.navigationItem = nil;
    self.buttonItem = nil;

    [super dealloc];
}


- (id) initWithController:(Controller*) controller__ {
    if (self = [super init]) {
        self.controller = controller__;
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];

        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;

        self.buttonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(onButtonTapped:)] autorelease];

        self.firstTime = YES;
        [self autoUpdateLocation];
    }

    return self;
}


+ (LocationManager*) managerWithController:(Controller*) controller {
    return [[[LocationManager alloc] initWithController:controller] autorelease];
}


- (Model*) model {
    return [AppDelegate appDelegate].model;
}


- (void) updateSpinnerImage:(NSNumber*) number {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.running == NO) {
        return;
    }

    NSInteger i = number.intValue;
    self.buttonItem.image =
    [UIImage imageNamed:[NSString stringWithFormat:@"Spinner%d.png", i]];

    [self performSelector:@selector(updateSpinnerImage:)
               withObject:[NSNumber numberWithInt:((i + 1) % 10)]
               afterDelay:0.1];
}


- (void) startUpdatingSpinner:(BOOL) wasUserInvoked {
    self.userInvoked = wasUserInvoked;
    self.buttonItem.style = UIBarButtonItemStyleDone;
    [self updateSpinnerImage:[NSNumber numberWithInt:1]];
}


- (void) stopUpdatingSpinner {
    self.userInvoked = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.buttonItem.style = UIBarButtonItemStylePlain;
    self.buttonItem.image = [UIImage imageNamed:@"CurrentPosition.png"];
}


- (void) startUpdatingLocation:(BOOL) wasUserInvoked {
    if (self.running) {
        // the user may have stopped the spinner, and then started it up
        // again while the current request is still running.
        [self startUpdatingSpinner:userInvoked_];
        return;
    }
    self.running = YES;
    [self startUpdatingSpinner:wasUserInvoked];

    [self.locationManager startUpdatingLocation];
}


- (void) autoUpdateLocation {
    if (self.model.autoUpdateLocation) {
        [self startUpdatingLocation:NO];
    }
}


- (void) enqueueUpdateRequest:(NSInteger) delay {
    [self performSelector:@selector(autoUpdateLocation)
               withObject:nil
               afterDelay:delay];
}


- (void) stopAll {
    self.running = NO;
    [self.locationManager stopUpdatingLocation];
    [self stopUpdatingSpinner];
}


- (void) locationManager:(CLLocationManager*) manager
        didFailWithError:(NSError*) error {
    if (self.userInvoked) {
        [AlertUtilities showOkAlert:NSLocalizedString(@"Could not find location.", nil)];
    }

    [self stopAll];

    // intermittent failures are not uncommon. retry in a minute.
    [self enqueueUpdateRequest:ONE_MINUTE];
}


- (void) locationManager:(CLLocationManager*) manager
     didUpdateToLocation:(CLLocation*) newLocation
            fromLocation:(CLLocation*) oldLocation {
    NSLog(@"Location found! Timestamp: %@. Accuracy: %f", newLocation.timestamp, newLocation.horizontalAccuracy);
    if (newLocation != nil) {
        if (ABS(newLocation.timestamp.timeIntervalSinceNow) < ONE_MINUTE) {
            [self.locationManager stopUpdatingLocation];
            [[AppDelegate operationQueue] performSelector:@selector(findLocationBackgroundEntryPoint:)
                                                 onTarget:self
                                               withObject:newLocation
                                                     gate:self.gate
                                                  priority:High];
        }
    }
}


- (void) findLocationBackgroundEntryPoint:(CLLocation*) location {
    Location* userLocation;

    NSString* notification = NSLocalizedString(@"location", nil);
    [AppDelegate addNotification:notification];
    {
        userLocation = [LocationUtilities findLocation:location];
    }
    [AppDelegate removeNotification:notification];

    [self performSelectorOnMainThread:@selector(reportFoundUserLocation:) withObject:userLocation waitUntilDone:NO];
}


- (void) reportFoundUserLocation:(Location*) userLocation {
    NSAssert([NSThread isMainThread], nil);
    [self stopAll];

    if (userLocation == nil) {
        [self enqueueUpdateRequest:ONE_MINUTE];
    } else {
        [self enqueueUpdateRequest:5 * ONE_MINUTE];
    }

    if (userLocation == nil) {
        return;
    }

    NSString* displayString = userLocation.fullDisplayString;
    displayString = [displayString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self.model.userLocationCache setLocation:userLocation forUserAddress:displayString];
    [self.controller setUserAddress:displayString];
}


- (void) onButtonTapped:(id) sender {
    if (self.running) {
        // just stop the spinner.  we'll continue doing whatever
        // it was that we were doign.
        [self stopUpdatingSpinner];
    } else {
        // start up the whole shebang.
        [self startUpdatingLocation:YES];
    }
}


- (void) addLocationSpinner:(UINavigationItem*) item {
    self.navigationItem = item;
    self.navigationItem.rightBarButtonItem = self.buttonItem;
}

@end