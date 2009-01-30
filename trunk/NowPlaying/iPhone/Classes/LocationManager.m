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

#import "Location.h"
#import "LocationUtilities.h"
#import "Controller.h"
#import "Model.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"

@interface LocationManager()
@property (retain) Controller* controller;
@property (retain) CLLocationManager* locationManager;
@property (retain) NSLock* gate;
@property (retain) UINavigationItem* navigationItem;
@property (retain) UIBarButtonItem* buttonItem;
@end


@implementation LocationManager

@synthesize controller;
@synthesize locationManager;
@synthesize gate;
@synthesize navigationItem;
@synthesize buttonItem;


- (void) dealloc {
    self.controller = nil;
    self.locationManager = nil;
    self.gate = nil;
    self.navigationItem = nil;
    self.buttonItem = nil;

    [super dealloc];
}


- (id) initWithController:(Controller*) controller_ {
    if (self = [super init]) {
        self.controller = controller_;
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];

        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;

        self.buttonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(onButtonTapped:)] autorelease];

        firstTime = YES;
        [self autoUpdateLocation];
    }

    return self;
}


+ (LocationManager*) managerWithController:(Controller*) controller {
    return [[[LocationManager alloc] initWithController:controller] autorelease];
}


- (Model*) model {
    return controller.model;
}


- (void) updateSpinnerImage:(NSNumber*) number {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (running == NO) {
        return;
    }

    NSInteger i = number.intValue;
    buttonItem.image =
    [UIImage imageNamed:[NSString stringWithFormat:@"Spinner%d.png", i]];

    [self performSelector:@selector(updateSpinnerImage:)
               withObject:[NSNumber numberWithInt:((i + 1) % 10)]
               afterDelay:0.1];
}


- (void) startUpdatingSpinner {
    buttonItem.style = UIBarButtonItemStyleDone;
    [self updateSpinnerImage:[NSNumber numberWithInt:1]];
}


- (void) stopUpdatingSpinner {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    buttonItem.style = UIBarButtonItemStylePlain;
    buttonItem.image = [UIImage imageNamed:@"CurrentPosition.png"];
}


- (void) startUpdatingLocation {
    if (running) {
        // the user may have stopped the spinner, and then started it up
        // again while the current request is still running.
        [self startUpdatingSpinner];
        return;
    }
    running = YES;
    [self startUpdatingSpinner];

    [locationManager startUpdatingLocation];
}


- (void) autoUpdateLocation {
    if (self.model.autoUpdateLocation) {
        [self startUpdatingLocation];
    }
}


- (void) enqueueUpdateRequest:(NSInteger) delay {
    [self performSelector:@selector(autoUpdateLocation) withObject:nil afterDelay:delay];
}


- (void) stopAll {
    running = NO;
    [locationManager stopUpdatingLocation];
    [self stopUpdatingSpinner];
}


- (void) locationManager:(CLLocationManager*) manager
        didFailWithError:(NSError*) error {
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
            [locationManager stopUpdatingLocation];
            [ThreadingUtilities backgroundSelector:@selector(findLocationBackgroundEntryPoint:)
                                          onTarget:self
                                          argument:newLocation
                                              gate:gate
                                           visible:YES
                                              name:@"FindLocation"];
        }
    }
}


- (void) findLocationBackgroundEntryPoint:(CLLocation*) location {
    Location* userLocation = [LocationUtilities findLocation:location];

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
    if (running) {
        // just stop the spinner.  we'll continue doing whatever
        // it was that we were doign.
        [self stopUpdatingSpinner];
    } else {
        // start up the whole shebang.
        [self startUpdatingLocation];
    }
}


- (void) addLocationSpinner:(UINavigationItem*) navigationItem_ {
    self.navigationItem = navigationItem_;
    navigationItem.rightBarButtonItem = buttonItem;
}

@end