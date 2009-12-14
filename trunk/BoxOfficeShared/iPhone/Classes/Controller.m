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
#import "BlurayCache.h"
#import "BoxOfficeSharedApplication.h"
#import "CacheUpdater.h"
#import "DataProvider.h"
#import "DVDCache.h"
#import "HelpCache.h"
#import "InternationalDataCache.h"
#import "LargePosterCache.h"
#import "LocationManager.h"
#import "Model.h"
#import "ScoreCache.h"
#import "UpcomingCache.h"
#import "UserLocationCache.h"

@interface Controller()
@property (retain) NSLock* determineLocationGate;
@end


@implementation Controller

static Controller* controller = nil;

+ (void) initialize {
  if (self == [Controller class]) {
    controller = [[Controller alloc] initWithModel:[Model model]];
  }
}

@synthesize determineLocationGate;

- (void) dealloc {
  self.determineLocationGate = nil;

  [super dealloc];
}


- (id) initWithModel:(Model*) model {
  if ((self = [super initWithModel:model])) {
    self.determineLocationGate = [[[NSRecursiveLock alloc] init] autorelease];
  }

  return self;
}


+ (Controller*) controller {
  return controller;
}


- (NetflixCache*) netflixCache {
  return [NetflixCache cache];
}


- (void) spawnDataProviderLookupThread:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [[Model model].dataProvider update:[Model model].searchDate delegate:self context:nil force:force];
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(id) context {
  // Save the results.
  [[Model model].dataProvider saveResult:lookupResult];
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
  [[ScoreCache cache] update];
}


- (void) updateUpcomingCache {
  [[UpcomingCache cache] update];
}


- (void) updateDVDCache {
  [[DVDCache cache] update];
  [[BlurayCache cache] update];
}


- (void) updateNetflixCache:(BOOL) force {
  [self.netflixCache update:[[NetflixAccountCache cache] currentAccount]
                      force:force];
}


- (void) updateLargePosterCache {
  [[LargePosterCache cache] update];
}


- (void) updateInternationalDataCache {
  [[InternationalDataCache cache] update];
}


- (void) updateHelpCache {
  [[HelpCache cache] update];
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

  NSArray* movies = [Model model].movies;
  [[CacheUpdater cacheUpdater] addMovies:movies];
}


- (void) onDataProviderUpdateComplete:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [self updateAllCaches:force];
  //[[Model model].largePosterCache updateIndices];
}


- (void) spawnCheckIfInReviewPeriodThread {
  if (![Model model].isInReviewPeriod) {
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
  [[Model model] checkCountry];

  [self spawnCheckIfInReviewPeriodThread];
  [self spawnDetermineLocationThread:force];
}


- (void) determineLocationBackgroundEntryPoint:(NSNumber*) force {
  NSLog(@"Controller:determineLocationBackgroundEntryPoint");
  NSString* address = [Model model].userAddress;
  Location* location = [[UserLocationCache cache] downloadUserAddressLocationBackgroundEntryPoint:address];

  [ThreadingUtilities foregroundSelector:@selector(reportUserLocation:force:)
                                onTarget:self
                              withObject:location
                              withObject:force];
}


- (void) reportUserLocation:(Location*) location
                      force:(NSNumber*) force {
  NSAssert([NSThread isMainThread], nil);
  if ([Model model].userAddress.length > 0 && location == nil) {
    [AlertUtilities showOkAlert:LocalizedString(@"Could not find location.", nil)];
  }

  [self spawnDataProviderLookupThread:force.boolValue];
}


- (void) setSearchDate:(NSDate*) searchDate {
  if ([DateUtilities isSameDay:searchDate date:[Model model].searchDate]) {
    return;
  }

  [[Model model] setSearchDate:searchDate];

  [[Model model].dataProvider markOutOfDate];
  [self spawnDataProviderLookupThread:YES];
}


- (void) setUserAddress:(NSString*) userAddress {
  if ([userAddress isEqual:[Model model].userAddress]) {
    return;
  }

  [[Model model] setUserAddress:userAddress];

  [[Model model].dataProvider markOutOfDate];
  [self spawnDetermineLocationThread:YES];

  // Refresh the UI so we show the found location.
  [MetasyntacticSharedApplication majorRefresh:YES];
}


- (void) setSearchRadius:(NSInteger) radius {
  [[Model model] setSearchRadius:radius];
}


- (void) setScoreProviderIndex:(NSInteger) index {
  if (index == [Model model].scoreProviderIndex) {
    return;
  }

  [[Model model] setScoreProviderIndex:index];
}


- (void) setAutoUpdateLocation:(BOOL) value {
  [[Model model] setAutoUpdateLocation:value];
  [[LocationManager manager] autoUpdateLocation];

  // Refresh the UI so we show the new state.
  [MetasyntacticSharedApplication majorRefresh:YES];
}


- (void) setDvdBlurayEnabled:(BOOL) value {
  [[Model model] setDvdBlurayCacheEnabled:value];
  [BoxOfficeSharedApplication resetTabs];
  [self updateDVDCache];
}


- (void) setDvdMoviesShowDVDs:(BOOL) value {
  [[Model model] setDvdMoviesShowDVDs:value];
  [self updateDVDCache];
}


- (void) setDvdMoviesShowBluray:(BOOL) value {
  [[Model model] setDvdMoviesShowBluray:value];
  [self updateDVDCache];
}


- (void) setUpcomingEnabled:(BOOL) value {
  [[Model model] setUpcomingCacheEnabled:value];
  [BoxOfficeSharedApplication resetTabs];
  [self updateUpcomingCache];
}


- (void) setNetflixEnabled:(BOOL) value {
  [[Model model] setNetflixCacheEnabled:value];
  [BoxOfficeSharedApplication resetTabs];
  [self updateNetflixCache:NO];
}


- (void) onCurrentNetflixAccountSet {
  [self updateNetflixCache:NO];
}


- (void) checkIfInReviewPeriodBackgroundEntryPoint {
  NSString* address = [NSString stringWithFormat:@"http://%@.appspot.com/LookupApplicationInformation%@?name=%@&version=%@",
                       [Application apiHost], [Application apiVersion],
                       [[NSBundle mainBundle] bundleIdentifier],
                       [Application version]];
  XmlElement* result = [NetworkUtilities xmlWithContentsOfAddress:address];
  if ([@"false" isEqual:[result attributeValue:@"in_review"]]) {
    [ThreadingUtilities foregroundSelector:@selector(clearInReviewPeriod) onTarget:[Model model]];
  }
}

@end
