//
//  LocationManager.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"

#import "Location.h"
#import "LocationUtilities.h"
#import "NowPlayingController.h"
#import "NowPlayingModel.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"

@interface LocationManager()
@property (retain) NowPlayingController* controller;
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


- (id) initWithController:(NowPlayingController*) controller_ {
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
        
        [self autoUpdateLocation];
    }
    
    return self;
}


+ (LocationManager*) managerWithController:(NowPlayingController*) controller {
    return [[[LocationManager alloc] initWithController:controller] autorelease];
}


- (NowPlayingModel*) model {
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
    [self performSelector:@selector(updateLocation) withObject:nil afterDelay:delay];
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
    if (newLocation != nil) {
        if (ABS(newLocation.timestamp.timeIntervalSinceNow) < 10) {
            [locationManager stopUpdatingLocation];
            
            [ThreadingUtilities performSelector:@selector(findLocationBackgroundEntryPoint:)
                                       onTarget:self
                       inBackgroundWithArgument:newLocation
                                           gate:gate
                                        visible:YES];
        }
    }
}


- (void) findLocationBackgroundEntryPoint:(CLLocation*) location {
    Location* userLocation = [LocationUtilities findLocation:location];
    
    [self performSelectorOnMainThread:@selector(reportFoundUserLocation:) withObject:userLocation waitUntilDone:NO];
}


- (void) reportFoundUserLocation:(Location*) userLocation {
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
    navigationItem.leftBarButtonItem = buttonItem;
}

@end