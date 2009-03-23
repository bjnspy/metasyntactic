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

#import "Controller.h"

#import "AppDelegate.h"
#import "Application.h"
#import "ApplicationTabBarController.h"
#import "AlertUtilities.h"
#import "DataProvider.h"
#import "DateUtilities.h"
#import "LocationManager.h"
#import "Model.h"
#import "NetflixCache.h"
#import "PosterCache.h"
#import "OperationQueue.h"
#import "ScoreCache.h"
#import "TrailerCache.h"
#import "UpcomingCache.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@interface Controller()
@property (assign) AppDelegate* appDelegate;
@property (retain) NSLock* determineLocationLock;
@property (retain) LocationManager* locationManager;
@end


@implementation Controller

@synthesize appDelegate;
@synthesize determineLocationLock;
@synthesize locationManager;

- (void) dealloc {
    self.appDelegate = nil;
    self.determineLocationLock = nil;
    self.locationManager = nil;

    [super dealloc];
}


- (Model*) model {
    return appDelegate.model;
}


- (id) initWithAppDelegate:(AppDelegate*) appDelegate_ {
    if (self = [super init]) {
        self.appDelegate = appDelegate_;
        self.locationManager = [LocationManager managerWithController:self];
        self.determineLocationLock = [[[NSRecursiveLock alloc] init] autorelease];
    }

    return self;
}


+ (Controller*) controllerWithAppDelegate:(AppDelegate*) appDelegate {
    return [[[Controller alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (void) spawnDataProviderLookupThread {
    NSAssert([NSThread isMainThread], nil);
    [self.model.dataProvider update:self.model.searchDate delegate:self context:nil force:NO];
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(id) context {
    // Save the results.
    [self.model.dataProvider saveResult:lookupResult];
}


- (void) onDataProviderUpdateFailure:(NSString*) error
                             context:(id) context {
    [self performSelectorOnMainThread:@selector(reportError:)
                           withObject:error
                        waitUntilDone:NO];
}


- (void) reportError:(NSString*) error {
    /*
     UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
     message:NSLocalizedString(@"No information found", nil)
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"OK", nil)
     otherButtonTitles:nil] autorelease];

     [alert show];
     */
}


- (void) spawnDetermineLocationThread {
    NSAssert([NSThread isMainThread], nil);
    [[AppDelegate operationQueue] performSelector:@selector(determineLocationBackgroundEntryPoint)
                                         onTarget:self
                                             gate:determineLocationLock
                                          priority:High];
}


- (void) updateScoreCache {
    [self.model.scoreCache update];
}


- (void) updateUpcomingCache {
    [self.model.upcomingCache update];
}


- (void) updateDVDCache {
    [self.model.dvdCache update];
    [self.model.blurayCache update];
}


- (void) updateNetflixCache {
    [self.model.netflixCache update];
}


- (void) updateLargePosterCache {
    [self.model.largePosterCache update];
}


- (void) updateAllCaches {
    // we want this first so that we download all the indices.
    [self updateLargePosterCache];

    [self updateScoreCache];
    [self updateUpcomingCache];
    [self updateDVDCache];
    [self updateNetflixCache];

    NSArray* movies = self.model.movies;

    [self.model.posterCache     update:movies];
    [self.model.trailerCache    update:movies];
    [self.model.imdbCache       update:movies];
    [self.model.wikipediaCache  update:movies];
    [self.model.amazonCache     update:movies];
    [self.model.netflixCache lookupNetflixMoviesForLocalMovies:movies];
}


- (void) onDataProviderUpdateComplete {
    NSAssert([NSThread isMainThread], nil);
    [self updateAllCaches];
    //[self.model.largePosterCache updateIndices];
}


- (void) start {
    NSAssert([NSThread isMainThread], nil);
    [self spawnDetermineLocationThread];
}


- (void) determineLocationBackgroundEntryPoint {
    NSString* address = self.model.userAddress;
    Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:address];

    [self performSelectorOnMainThread:@selector(reportUserLocation:)
                           withObject:location
                        waitUntilDone:NO];
}


- (void) reportUserLocation:(Location*) location {
    NSAssert([NSThread isMainThread], nil);
    if (self.model.userAddress.length > 0 && location == nil) {
        [AlertUtilities showOkAlert:NSLocalizedString(@"Could not find location.", nil)];
    }

    [self spawnDataProviderLookupThread];
}


- (void) markDataProviderOutOfDate {
    [self.model.dataProvider markOutOfDate];
}


- (void) setSearchDate:(NSDate*) searchDate {
    if ([DateUtilities isSameDay:searchDate date:self.model.searchDate]) {
        return;
    }

    [self.model setSearchDate:searchDate];

    [self markDataProviderOutOfDate];
    [self spawnDataProviderLookupThread];
}


- (void) setUserAddress:(NSString*) userAddress {
    if ([userAddress isEqual:self.model.userAddress]) {
        return;
    }

    [self.model setUserAddress:userAddress];

    [self markDataProviderOutOfDate];
    [self spawnDetermineLocationThread];

    // Force a refresh so the UI displays this new address.
    [AppDelegate majorRefresh:YES];
}


- (void) setSearchRadius:(NSInteger) radius {
    [self.model setSearchRadius:radius];
}


- (void) setScoreProviderIndex:(NSInteger) index {
    if (index == self.model.scoreProviderIndex) {
        return;
    }

    [self.model setScoreProviderIndex:index];
}


- (void) setAutoUpdateLocation:(BOOL) value {
    [self.model setAutoUpdateLocation:value];
    [locationManager autoUpdateLocation];
}


- (void) setDvdBlurayEnabled:(BOOL) value {
    [self.model setDvdBlurayEnabled:value];
    [appDelegate.tabBarController resetTabs];
    [self updateDVDCache];
}


- (void) setUpcomingEnabled:(BOOL) value {
    [self.model setUpcomingEnabled:value];
    [appDelegate.tabBarController resetTabs];
    [self updateUpcomingCache];
}


- (void) setNetflixEnabled:(BOOL) value {
    [self.model setNetflixEnabled:value];
    [appDelegate.tabBarController resetTabs];
    [Application resetNetflixDirectories];
    [self updateNetflixCache];
}


- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId {
    [self.model setNetflixKey:key secret:secret userId:userId];
    [self updateNetflixCache];
}

@end