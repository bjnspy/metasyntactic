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

#import "NowPlayingController.h"

#import "Application.h"
#import "ApplicationTabBarController.h"
#import "DataProvider.h"
#import "DateUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ScoreCache.h"
#import "ThreadingUtilities.h"
#import "UpcomingCache.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@implementation NowPlayingController

@synthesize appDelegate;
@synthesize determineLocationLock;

- (void) dealloc {
    self.appDelegate = nil;
    self.determineLocationLock = nil;

    [super dealloc];
}


- (NowPlayingModel*) model {
    return appDelegate.model;
}


- (void) spawnDataProviderLookupThread {
    [self.model.dataProvider update];
}


- (void) spawnScoresLookupThread {
    [self.model.scoreCache update];
}


- (void) spawnDetermineLocationThread {
    [ThreadingUtilities performSelector:@selector(determineLocation)
                               onTarget:self
               inBackgroundWithArgument:nil
                                   gate:determineLocationLock
                                visible:YES];
}


- (void) spawnBackgroundThreads {
    [self spawnScoresLookupThread];
    [self spawnDataProviderLookupThread];
}


- (id) initWithAppDelegate:(NowPlayingAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        self.appDelegate = appDelegate_;

        [self spawnDetermineLocationThread];
    }

    return self;
}


+ (NowPlayingController*) controllerWithAppDelegate:(NowPlayingAppDelegate*) appDelegate {
    return [[[NowPlayingController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (void) determineLocation {
    if (self.model.userAddress.length > 0) {
        Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:self.model.userAddress];

        [self performSelectorOnMainThread:@selector(reportUserLocation:) withObject:location waitUntilDone:NO];
    }
}


- (void) reportUserLocation:(Location*) location {
    if (location == nil) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                         message:NSLocalizedString(@"Could not find location.", nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil] autorelease];

        [alert show];
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


- (void) setScoreProviderIndex:(NSInteger) index {
    if (index == self.model.scoreProviderIndex) {
        return;
    }

    [self.model setScoreProviderIndex:index];
    [self spawnScoresLookupThread];
}


@end