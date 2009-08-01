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
    controller = [[Controller alloc] init];
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


- (id) init {
  if ((self = [super init])) {
    self.locationManager = [LocationManager manager];
    self.determineLocationGate = [[[NSRecursiveLock alloc] init] autorelease];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
  }

  return self;
}


- (Model*) model {
  return [Model model];
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


- (void) onApplicationDidReceiveMemoryWarning:(id) argument {
  [self.model.largePosterCache didReceiveMemoryWarning];
  [self.model.imageCache didReceiveMemoryWarning];
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


- (void) start:(BOOL) force {
  NSAssert([NSThread isMainThread], nil);
  [self spawnDetermineLocationThread:force];
}


- (void) start {
  [self start:NO];
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
  [self updateNetflixCache];
}


- (void) addNetflixAccount:(NetflixAccount*) account {
  [self.model addNetflixAccount:account];
  [self updateNetflixCache];
}


- (void) removeNetflixAccount:(NetflixAccount*) account {
  [self.model removeNetflixAccount:account];
  [self updateNetflixCache];
}

@end
