// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Controller.h"

#import "Application.h"
#import "BlurayCache.h"
#import "BoxOfficeSharedApplication.h"
#import "BoxOfficeTwitterAccount.h"
#import "DataProvider.h"
#import "DVDCache.h"
#import "HelpCache.h"
#import "InternationalDataCache.h"
#import "LargeMoviePosterCache.h"
#import "LocationManager.h"
#import "Model.h"
#import "MovieCacheUpdater.h"
#import "ScoreCache.h"
#import "Store.h"
#import "TrailerCache.h"
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
  [[NetflixCache cache] update:[[NetflixAccountCache cache] currentAccount]
                      force:force];
}


- (void) updateLargePosterCache {
  [[LargeMoviePosterCache cache] update];
}


- (void) updateInternationalDataCache {
  [[InternationalDataCache cache] update];
}


- (void) updateHelpCache {
  [[HelpCache cache] update];
}


- (void) updateTrailerCache {
  [[TrailerCache cache] update];
}


- (void) updateLocalizableStringsCache {
  [LocalizableStringsCache update];
}


- (void) loginToTwitter {
  [[BoxOfficeTwitterAccount account] login];
}


- (void) updateAllCaches:(BOOL) force {
  [self updateLocalizableStringsCache];
  [self updateTrailerCache];
  [self updateScoreCache];
  [self updateLargePosterCache];
  [self updateInternationalDataCache];
  [self updateUpcomingCache];
  [self updateDVDCache];
  [self updateNetflixCache:force];
  [self updateHelpCache];
  [self loginToTwitter];

  NSArray* movies = [Model model].movies;
  [[MovieCacheUpdater updater] addMovies:movies];
}


- (void) onDataProviderUpdateComplete:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [self updateAllCaches:force];
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
  [[FacebookAccount account] login];
  [[Store store] updatePrices:[NSSet setWithArray:[Store donationsArray]]];

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
