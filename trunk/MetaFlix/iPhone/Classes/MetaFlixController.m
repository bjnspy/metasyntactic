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

#import "MetaFlixController.h"

#import "Application.h"
#import "AlertUtilities.h"
#import "DateUtilities.h"
#import "LocationManager.h"
#import "MetaFlixAppDelegate.h"
#import "MetaFlixModel.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@interface MetaFlixController()
@property (assign) MetaFlixAppDelegate* appDelegate;
@property (retain) NSLock* determineLocationLock;
@property (retain) LocationManager* locationManager;
@end


@implementation MetaFlixController

@synthesize appDelegate;
@synthesize determineLocationLock;
@synthesize locationManager;

- (void) dealloc {
    self.appDelegate = nil;
    self.determineLocationLock = nil;
    self.locationManager = nil;

    [super dealloc];
}


- (MetaFlixModel*) model {
    return appDelegate.model;
}


- (id) initWithAppDelegate:(MetaFlixAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        self.appDelegate = appDelegate_;
        self.locationManager = [LocationManager managerWithController:self];
        self.determineLocationLock = [[[NSRecursiveLock alloc] init] autorelease];
    }

    return self;
}


+ (MetaFlixController*) controllerWithAppDelegate:(MetaFlixAppDelegate*) appDelegate {
    return [[[MetaFlixController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (BOOL) tooSoon:(NSDate*) lastDate {
    if (lastDate == nil) {
        return NO;
    }

    NSDate* now = [NSDate date];

    if (![DateUtilities isSameDay:now date:lastDate]) {
        // different days. we definitely need to refresh
        return NO;
    }

    NSDateComponents* lastDateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:lastDate];
    NSDateComponents* nowDateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:now];

    // same day, check if they're at least 8 hours apart.
    if (nowDateComponents.hour >= (lastDateComponents.hour + 8)) {
        return NO;
    }

    // it's been less than 8 hours. it's too soon to refresh
    return YES;
}


- (void) spawnDetermineLocationThread {
    NSAssert([NSThread isMainThread], nil);
    [ThreadingUtilities backgroundSelector:@selector(determineLocationBackgroundEntryPoint)
                                  onTarget:self
                                      gate:determineLocationLock
                                   visible:YES];
}


- (void) spawnNetflixThread {
    NSAssert([NSThread isMainThread], nil);
    [self.model.netflixCache update];
}


- (void) spawnUpdateRemainderThreads {
    NSAssert([NSThread isMainThread], nil);
    [self spawnNetflixThread];
}


- (void) onDataProviderUpdateComplete {
    NSAssert([NSThread isMainThread], nil);
    [self spawnUpdateRemainderThreads];
}


- (void) start {
    NSAssert([NSThread isMainThread], nil);
    [self spawnDetermineLocationThread];
}


- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId {
    [self.model setNetflixKey:key secret:secret userId:userId];
    [self spawnNetflixThread];
}

@end