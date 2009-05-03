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

#import "AlertUtilities.h"
#import "AppDelegate.h"
#import "Application.h"
#import "ApplicationTabBarController.h"
#import "CacheUpdater.h"
#import "DataProvider.h"
#import "DateUtilities.h"
#import "LocalizableStringsCache.h"
#import "LocationManager.h"
#import "Model.h"
#import "MutableNetflixCache.h"
#import "OperationQueue.h"
#import "UserLocationCache.h"

@interface Controller()
@property (retain) NSLock* determineLocationGate;
@property (retain) LocationManager* locationManager;
@end


@implementation Controller

static Controller* controller = nil;

@synthesize determineLocationGate;
@synthesize locationManager;

- (void) dealloc {
    self.determineLocationGate = nil;
    self.locationManager = nil;

    [super dealloc];
}


+ (Controller*) controller {
    if (controller == nil) {
        controller = [[Controller alloc] init];
    }

    return controller;
}


- (id) init {
    if (self = [super init]) {
        self.locationManager = [LocationManager manager];
        self.determineLocationGate = [[[NSRecursiveLock alloc] init] autorelease];
    }

    return self;
}


- (Model*) model {
    return [Model model];
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
                                                      message:LocalizedString(@"No information found", nil)
                                                     delegate:nil
                                            cancelButtonTitle:LocalizedString(@"OK", nil)
                                            otherButtonTitles:nil] autorelease];

     [alert show];
     */
}


- (void) spawnDetermineLocationThread {
    NSAssert([NSThread isMainThread], nil);
    [[OperationQueue operationQueue] performSelector:@selector(determineLocationBackgroundEntryPoint)
                                            onTarget:self
                                                gate:determineLocationGate
                                            priority:Now];
}


- (void) didReceiveMemoryWarning {
    [self.model.largePosterCache didReceiveMemoryWarning];
    [self.model.imdbCache didReceiveMemoryWarning];
    [self.model.amazonCache didReceiveMemoryWarning];
    [self.model.wikipediaCache didReceiveMemoryWarning];
    [self.model.trailerCache didReceiveMemoryWarning];
    [self.model.blurayCache didReceiveMemoryWarning];
    [self.model.dvdCache didReceiveMemoryWarning];
    [self.model.posterCache didReceiveMemoryWarning];
    [self.model.scoreCache didReceiveMemoryWarning];
    [self.model.upcomingCache didReceiveMemoryWarning];
    [self.model.netflixCache didReceiveMemoryWarning];
    [self.model.internationalDataCache didReceiveMemoryWarning];
    [self.model.helpCache didReceiveMemoryWarning];
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


- (void) updateInternationalDataCache {
    [self.model.internationalDataCache update];
}


- (void) updateHelpCache {
    [self.model.helpCache update];
}


- (void) updateLocalizableStringsCache {
    [LocalizableStringsCache update];
}


- (void) updateAllCaches {
    [self updateLocalizableStringsCache];
    [self updateScoreCache];
    [self updateLargePosterCache];
    [self updateInternationalDataCache];
    [self updateUpcomingCache];
    [self updateDVDCache];
    [self updateNetflixCache];
    [self updateHelpCache];

    NSArray* movies = self.model.movies;
    [[CacheUpdater cacheUpdater] addMovies:movies];
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
    NSLog(@"Controller:determineLocationBackgroundEntryPoint");
    NSString* address = self.model.userAddress;
    Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:address];

    [self performSelectorOnMainThread:@selector(reportUserLocation:)
                           withObject:location
                        waitUntilDone:NO];
}


- (void) reportUserLocation:(Location*) location {
    NSAssert([NSThread isMainThread], nil);
    if (self.model.userAddress.length > 0 && location == nil) {
        [AlertUtilities showOkAlert:LocalizedString(@"Could not find location.", nil)];
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

    // Refresh the UI so we show the found location.
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

    // Refresh the UI so we show the new state.
    [AppDelegate majorRefresh:YES];
}


- (void) setDvdBlurayEnabled:(BOOL) value {
    [self.model setDvdBlurayCacheEnabled:value];
    [AppDelegate resetTabs];
    [self updateDVDCache];
}


- (void) setDvdMoviesShowDVDs:(BOOL) value {
    [self.model setDvdMoviesShowDVDs:value];
    [self updateDVDCache];
}


- (void) setDvdMoviesShowBluray:(BOOL) value {
    [self.model setDvdMoviesShowBluray:value];
    [self updateDVDCache];
}


- (void) setUpcomingEnabled:(BOOL) value {
    [self.model setUpcomingCacheEnabled:value];
    [AppDelegate resetTabs];
    [self updateUpcomingCache];
}


- (void) setNetflixEnabled:(BOOL) value {
    [self.model setNetflixCacheEnabled:value];
    [AppDelegate resetTabs];
    [Application resetNetflixDirectories];
    [self updateNetflixCache];
}


- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId {
    [self.model setNetflixKey:key secret:secret userId:userId];
    [self updateNetflixCache];
}

@end