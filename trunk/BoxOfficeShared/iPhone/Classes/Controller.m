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

#import "Application.h"
#import "BoxOfficeSharedApplication.h"
#import "CacheUpdater.h"
#import "DataProvider.h"
#import "LocationManager.h"
#import "Model.h"
#import "UserLocationCache.h"

@interface Controller()
@property (retain) NSLock* determineLocationGate;
@property (retain) LocationManager* locationManager;
@end


@implementation Controller

static Controller* controller = nil;

+ (void) initialize {
  if (self == [Controller class]) {
    controller = [[Controller alloc] initWithModel:[Model model]];
  }
}

@synthesize determineLocationGate;
@synthesize locationManager;

- (void) dealloc {
  self.determineLocationGate = nil;
  self.locationManager = nil;

  [super dealloc];
}


+ (Controller*) controller {
  return controller;
}


- (id) initWithModel:(Model*) model {
  if ((self = [super initWithModel:model])) {
    self.locationManager = [LocationManager manager];
    self.determineLocationGate = [[[NSRecursiveLock alloc] init] autorelease];
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (NetflixCache*) netflixCache {
  return [NetflixCache cache];
}


- (void) spawnDataProviderLookupThread:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [self.model.dataProvider update:self.model.searchDate delegate:self context:nil force:force];
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


- (void) spawnDetermineLocationThread:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [[OperationQueue operationQueue] performSelector:@selector(determineLocationBackgroundEntryPoint:)
                                          onTarget:self
                                        withObject:[NSNumber numberWithBool:force]
                                              gate:determineLocationGate
                                          priority:Now];
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


- (void) updateNetflixCache:(BOOL) force {
  [self.netflixCache update:self.model.currentNetflixAccount force:force];
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


- (void) updateAllCaches:(BOOL) force {
  [self updateLocalizableStringsCache];
  [self updateScoreCache];
  [self updateLargePosterCache];
  [self updateInternationalDataCache];
  [self updateUpcomingCache];
  [self updateDVDCache];
  [self updateNetflixCache:force];
  [self updateHelpCache];

  NSArray* movies = self.model.movies;
  [[CacheUpdater cacheUpdater] addMovies:movies];
}


- (void) onDataProviderUpdateComplete:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [self updateAllCaches:force];
  //[self.model.largePosterCache updateIndices];
}


- (void) spawnCheckIfInReviewPeriodThread {
  if (!self.model.isInReviewPeriod) {
    // no need to do anything.
    return;
  }

  [[OperationQueue operationQueue] performSelector:@selector(checkIfInReviewPeriodBackgroundEntryPoint)
                                          onTarget:self
                                              gate:nil
                                          priority:Now];
}


- (void) startWorker:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [self.model checkCountry];

  [self spawnCheckIfInReviewPeriodThread];
  [self spawnDetermineLocationThread:force];
}


- (void) determineLocationBackgroundEntryPoint:(NSNumber*) force {
  NSLog(@"Controller:determineLocationBackgroundEntryPoint");
  NSString* address = self.model.userAddress;
  Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:address];

  [ThreadingUtilities foregroundSelector:@selector(reportUserLocation:force:)
                                onTarget:self
                              withObject:location
                              withObject:force];
}


- (void) reportUserLocation:(Location*) location
                      force:(NSNumber*) force {
  NSAssert([NSThread isMainThread], nil);
  if (self.model.userAddress.length > 0 && location == nil) {
    [AlertUtilities showOkAlert:LocalizedString(@"Could not find location.", nil)];
  }

  [self spawnDataProviderLookupThread:force.boolValue];
}


- (void) setSearchDate:(NSDate*) searchDate {
  if ([DateUtilities isSameDay:searchDate date:self.model.searchDate]) {
    return;
  }

  [self.model setSearchDate:searchDate];

  [self.model.dataProvider markOutOfDate];
  [self spawnDataProviderLookupThread:YES];
}


- (void) setUserAddress:(NSString*) userAddress {
  if ([userAddress isEqual:self.model.userAddress]) {
    return;
  }

  [self.model setUserAddress:userAddress];

  [self.model.dataProvider markOutOfDate];
  [self spawnDetermineLocationThread:YES];

  // Refresh the UI so we show the found location.
  [MetasyntacticSharedApplication majorRefresh:YES];
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
  [MetasyntacticSharedApplication majorRefresh:YES];
}


- (void) setDvdBlurayEnabled:(BOOL) value {
  [self.model setDvdBlurayCacheEnabled:value];
  [BoxOfficeSharedApplication resetTabs];
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
  [BoxOfficeSharedApplication resetTabs];
  [self updateUpcomingCache];
}


- (void) setNetflixEnabled:(BOOL) value {
  [self.model setNetflixCacheEnabled:value];
  [BoxOfficeSharedApplication resetTabs];
  [self updateNetflixCache:NO];
}


- (void) addNetflixAccount:(NetflixAccount*) account {
  NetflixAccount* currentAccount = self.model.currentNetflixAccount;
  [self.model addNetflixAccount:account];

  // Update this account if it's the first account we're adding.
  if (currentAccount == nil) {
    [self updateNetflixCache:NO];
  }
}


- (void) removeNetflixAccount:(NetflixAccount*) account {
  NetflixAccount* currentAccount = self.model.currentNetflixAccount;
  [self.model removeNetflixAccount:account];

  // We're removing the current netflix account.
  // We need to update our information about the new account we're switching to.
  if ([account isEqual:currentAccount]) {
    [self updateNetflixCache:NO];
  }
}


- (void) setCurrentNetflixAccount:(NetflixAccount*) account {
  NetflixAccount* currentAccount = self.model.currentNetflixAccount;
  [self.model setCurrentNetflixAccount:account];

  // We're setting the account to something different.
  // We need to update our information about that account.
  if (![account isEqual:currentAccount]) {
    [self updateNetflixCache:NO];
  }
}


- (void) checkIfInReviewPeriodBackgroundEntryPoint {
  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupApplicationInformation%@?name=%@&version=%@",
                       [Application apiHost], [Application apiVersion],
                       [[NSBundle mainBundle] bundleIdentifier],
                       [Application version]];
  XmlElement* result = [NetworkUtilities xmlWithContentsOfAddress:address];
  if ([@"false" isEqual:[result attributeValue:@"in_review"]]) {
    [ThreadingUtilities foregroundSelector:@selector(clearInReviewPeriod) onTarget:self.model];
  }
}

@end
