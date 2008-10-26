//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "NowPlayingController.h"

#import "Application.h"
#import "ApplicationTabBarController.h"
#import "DataProvider.h"
#import "DateUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ScoreCache.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@implementation NowPlayingController

@synthesize appDelegate;
@synthesize determineLocationLock;
@synthesize dataProviderLock;
@synthesize ratingsLookupLock;
@synthesize upcomingMoviesLookupLock;

- (void) dealloc {
    self.appDelegate = nil;
    self.determineLocationLock = nil;
    self.dataProviderLock = nil;
    self.ratingsLookupLock = nil;
    self.upcomingMoviesLookupLock = nil;

    [super dealloc];
}


- (NowPlayingModel*) model {
    return appDelegate.model;
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


- (void) spawnDataProviderLookupThread {
    if (self.model.userAddress.length == 0) {
        return;
    }

    if ([self tooSoon:[self.model.dataProvider lastLookupDate]]) {
        return;
    }

    [ThreadingUtilities performSelector:@selector(lookup)
                               onTarget:self.model.dataProvider
               inBackgroundWithArgument:nil
                                   gate:dataProviderLock
                                visible:YES
                            lowPriority:NO];
}


- (void) spawnRatingsLookupThread {
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[Application ratingsFile:self.model.currentScoreProvider]
                                                                               error:NULL] objectForKey:NSFileModificationDate];
    if ([self tooSoon:lastLookupDate]) {
        return;
    }

    [ThreadingUtilities performSelector:@selector(ratingsLookupBackgroundThreadEntryPoint)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:ratingsLookupLock
                                visible:YES];
}


- (void) spawnUpcomingMoviesLookupThread {
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[Application upcomingMoviesIndexFile]
                                                                               error:NULL] objectForKey:NSFileModificationDate];

    if (lastLookupDate != nil) {
        if (ABS([lastLookupDate timeIntervalSinceNow]) < (3 * ONE_DAY)) {
            return;
        }
    }

    [ThreadingUtilities performSelector:@selector(updateMoviesList)
                               onTarget:self.model.upcomingCache
               inBackgroundWithArgument:nil
                                   gate:upcomingMoviesLookupLock
                                visible:YES];
}

- (void) spawnDetermineLocationThread {
    [ThreadingUtilities performSelector:@selector(determineLocation)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:determineLocationLock
                                visible:YES];
}


- (void) spawnBackgroundThreads {
    [self spawnRatingsLookupThread];
    [self spawnDataProviderLookupThread];
    [self spawnUpcomingMoviesLookupThread];
}


- (id) initWithAppDelegate:(NowPlayingAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        self.appDelegate = appDelegate_;
        self.dataProviderLock = [[[NSLock alloc] init] autorelease];
        self.ratingsLookupLock = [[[NSLock alloc] init] autorelease];
        self.upcomingMoviesLookupLock = [[[NSLock alloc] init] autorelease];

        [self spawnDetermineLocationThread];
    }

    return self;
}


+ (NowPlayingController*) controllerWithAppDelegate:(NowPlayingAppDelegate*) appDelegate {
    return [[[NowPlayingController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (NSDictionary*) ratingsLookup {
    return [self.model.scoreCache update];
}


- (void) ratingsLookupBackgroundThreadEntryPoint {
    NSDictionary* ratings = [self ratingsLookup];
    [self performSelectorOnMainThread:@selector(setRatings:) withObject:ratings waitUntilDone:NO];
}


- (void) setRatings:(NSDictionary*) ratings {
    if (ratings.count > 0) {
        [self.model onRatingsUpdated];
        [NowPlayingAppDelegate refresh];
    }
}


- (void) determineLocation {
    if (self.model.userAddress.length > 0) {
        Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:self.model.userAddress];

        [self performSelectorOnMainThread:@selector(reportUserLocation:) withObject:location waitUntilDone:NO];
    }
}


- (void) reportUserLocation:(Location*) location {
    if (location == nil) {
#ifdef TARGET_IPHONE_SIMULATOR
#else
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                         message:NSLocalizedString(@"Could not find location.", nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil] autorelease];

        [alert show];
#endif
        return;
    }

    [self spawnBackgroundThreads];
}


- (void) setSearchDate:(NSDate*) searchDate {
    if ([searchDate isEqual:self.model.searchDate]) {
        return;
    }

    [self.model setSearchDate:searchDate];
    [self spawnBackgroundThreads];
    [appDelegate.tabBarController popNavigationControllersToRoot];
}


- (void) setUserAddress:(NSString*) userAddress {
    if ([userAddress isEqual:self.model.userAddress]) {
        return;
    }

    [self.model setUserAddress:userAddress];
    [appDelegate.tabBarController popNavigationControllersToRoot];
    [self spawnDetermineLocationThread];
}


- (void) setSearchRadius:(NSInteger) radius {
    [self.model setSearchRadius:radius];
}


- (void) setRatingsProviderIndex:(NSInteger) index {
    if (index == self.model.ratingsProviderIndex) {
        return;
    }

    [self.model setRatingsProviderIndex:index];
    [self spawnRatingsLookupThread];
}


@end