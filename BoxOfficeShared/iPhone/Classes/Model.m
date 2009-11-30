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

#import "Model.h"

#import "AllMoviesViewController.h"
#import "AllTheatersViewController.h"
#import "AmazonCache.h"
#import "Application.h"
#import "BlurayCache.h"
#import "BoxOfficeSharedApplication.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "FavoriteTheater.h"
#import "GoogleDataProvider.h"
#import "HelpCache.h"
#import "IMDbCache.h"
#import "InternationalDataCache.h"
#import "LargePosterCache.h"
#import "MovieDetailsViewController.h"
#import "PosterCache.h"
#import "ReviewsViewController.h"
#import "Score.h"
#import "ScoreCache.h"
#import "Theater.h"
#import "TheaterDetailsViewController.h"
#import "TicketsViewController.h"
#import "TrailerCache.h"
#import "UpcomingCache.h"
#import "UpcomingMoviesViewController.h"
#import "UserLocationCache.h"
#import "WikipediaCache.h"

@interface Model()
@property (retain) UserLocationCache* userLocationCache;
@property (retain) BlurayCache* blurayCache;
@property (retain) DVDCache* dvdCache;
@property (retain) IMDbCache* imdbCache;
@property (retain) AmazonCache* amazonCache;
@property (retain) WikipediaCache* wikipediaCache;
@property (retain) PersonPosterCache* personPosterCache;
@property (retain) PosterCache* posterCache;
@property (retain) LargePosterCache* largePosterCache;
@property (retain) ScoreCache* scoreCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) UpcomingCache* upcomingCache;
@property (retain) InternationalDataCache* internationalDataCache;
@property (retain) HelpCache* helpCache;
@property (retain) ThreadsafeValue* bookmarkedTitlesData;
@property (retain) ThreadsafeValue* favoriteTheatersData;
@property (retain) id<DataProvider> dataProvider;
@property (retain) NSNumber* isSearchDateTodayData;
@property NSInteger cachedScoreProviderIndex;
@property NSInteger searchRadiusData;
@property (retain) NSArray* netflixAccountsData;
@end

@implementation Model

static NSString* ALL_MOVIES_SELECTED_SEGMENT_INDEX          = @"allMoviesSelectedSegmentIndex";
static NSString* ALL_THEATERS_SELECTED_SEGMENT_INDEX        = @"allTheatersSelectedSegmentIndex";
static NSString* AUTO_UPDATE_LOCATION                       = @"autoUpdateLocation";
static NSString* BOOKMARKED_BLURAY                          = @"bookmarkedBluray";
static NSString* BOOKMARKED_DVD                             = @"bookmarkedDVD";
static NSString* BOOKMARKED_MOVIES                          = @"bookmarkedMovies";
static NSString* BOOKMARKED_TITLES                          = @"bookmarkedTitles";
static NSString* BOOKMARKED_UPCOMING                        = @"bookmarkedUpcoming";
static NSString* DVD_BLURAY_DISABLED                        = @"dvdBlurayDisabled";
static NSString* DVD_MOVIES_HIDE_BLURAY                     = @"dvdMoviesHideBluray";
static NSString* DVD_MOVIES_HIDE_DVDS                       = @"dvdMoviesHideDVDs";
static NSString* DVD_MOVIES_SELECTED_SEGMENT_INDEX          = @"dvdMoviesSelectedSegmentIndex";
static NSString* FAVORITE_THEATERS                          = @"favoriteTheaters";
static NSString* LOADING_INDIACTORS_DISABLED                = @"loadingIndicatorsDisabled";
static NSString* LOCAL_SEARCH_SELECTED_SCOPE_BUTTON_INDEX   = @"localSearchSelectedScopeButtonIndex";
static NSString* NAVIGATION_STACK_TYPES                     = @"navigationStackTypes";
static NSString* NAVIGATION_STACK_VALUES                    = @"navigationStackValues";
static NSString* NETFLIX_ACCOUNTS                           = @"netflixAccounts";
static NSString* NETFLIX_CURRENT_ACCOUNT_INDEX              = @"netflixCurrentAccountIndex";
static NSString* NETFLIX_DISABLED                           = @"netflixDisabled";
static NSString* NETFLIX_FILTER_SELECTED_SEGMENT_INDEX      = @"netflixFilterSelectedSegmentIndex";
static NSString* NETFLIX_KEY                                = @"netflixKey";
static NSString* NETFLIX_NOTIFICATIONS_DISABLED             = @"netflixNotificationsDisabled";
static NSString* NETFLIX_SEARCH_SELECTED_SCOPE_BUTTON_INDEX = @"netflixSearchSelectedScopeButtonIndex";
static NSString* NETFLIX_SECRET                             = @"netflixSecret";
static NSString* NETFLIX_USER_ID                            = @"netflixUserId";
static NSString* NOTIFICATIONS_DISABLED                     = @"notificationsDisabled";
static NSString* SCORE_PROVIDER_INDEX                       = @"scoreProviderIndex";
static NSString* SEARCH_DATE                                = @"searchDate";
static NSString* SEARCH_RADIUS                              = @"searchRadius";
static NSString* SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX     = @"selectedTabBarViewControllerIndex";
static NSString* UNSUPPORTED_COUNTRY                        = @"unsupportedCountry";
static NSString* UPCOMING_AND_DVD_HIDE_UPCOMING             = @"upcomingAndDvdMoviesHideUpcoming";
static NSString* UPCOMING_DISABLED                          = @"upcomingDisabled";
static NSString* UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX     = @"upcomingMoviesSelectedSegmentIndex";
static NSString* USE_NORMAL_FONTS                           = @"useNormalFonts";
static NSString* USER_ADDRESS                               = @"userLocation";

@synthesize dataProvider;

@synthesize bookmarkedTitlesData;
@synthesize favoriteTheatersData;
@synthesize isSearchDateTodayData;

@synthesize userLocationCache;
@synthesize blurayCache;
@synthesize dvdCache;
@synthesize imdbCache;
@synthesize amazonCache;
@synthesize wikipediaCache;
@synthesize personPosterCache;
@synthesize posterCache;
@synthesize largePosterCache;
@synthesize scoreCache;
@synthesize trailerCache;
@synthesize upcomingCache;
@synthesize internationalDataCache;
@synthesize helpCache;
@synthesize cachedScoreProviderIndex;
@synthesize searchRadiusData;
@synthesize netflixAccountsData;

- (void) dealloc {
  self.dataProvider = nil;
  self.bookmarkedTitlesData = nil;
  self.favoriteTheatersData = nil;
  self.isSearchDateTodayData = nil;

  self.userLocationCache = nil;
  self.blurayCache = nil;
  self.dvdCache = nil;
  self.imdbCache = nil;
  self.amazonCache = nil;
  self.wikipediaCache = nil;
  self.personPosterCache = nil;
  self.posterCache = nil;
  self.largePosterCache = nil;
  self.scoreCache = nil;
  self.trailerCache = nil;
  self.upcomingCache = nil;
  self.internationalDataCache = nil;
  self.helpCache = nil;
  self.cachedScoreProviderIndex = 0;
  self.searchRadiusData = 0;

  self.netflixAccountsData = nil;

  [super dealloc];
}

static Model* model = nil;

+ (void) initialize {
  if (self == [Model class]) {
    model = [[Model alloc] init];
  }
}


+ (Model*) model {
  return model;
}


+ (void) saveMovies:(NSArray*) movies key:(NSString*) key {
  NSMutableArray* encoded = [NSMutableArray array];
  for (Movie* movie in movies) {
    [encoded addObject:movie.dictionary];
  }

  [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:key];
}


- (void) synchronize {
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) clearCaches {
  NSInteger runCount = self.runCount;

  if ((runCount % 5) == 0) {
    [Application clearStaleData];
  }
}


- (BOOL) isSupportedCountry {
  NSSet* supportedCountries = [NSSet setWithObjects:
                               @"AR", // Argentina
                               @"AT", // Austria
                               @"AU", // Australia
                               @"BE", // Belgium
                               @"BR", // Brazil
                               @"CA", // Canada
                               @"CH", // Switzerland
                               @"CZ", // Czech Republic
                               @"DE", // Germany
                               @"DK", // Denmark
                               @"ES", // Spain
                               @"FI", // Finland
                               @"FR", // France
                               @"HU", // Hungary
                               @"JP", // Japan
                               @"GB", // Great Britain
                               @"IE", // Ireland
                               @"IT", // Italy
                               @"MY", // Malaysia
                               @"NL", // The Netherlands
                               @"NO", // Norway
                               @"NZ", // New Zealand
                               @"PL", // Poland
                               @"PT", // Portugal
                               @"SG", // Singapore
                               @"SK", // Slovakia
                               @"SE", // Sweden
                               @"TR", // Turkey
                               @"US", // United States
                               nil];

  NSString* userCountry = [LocaleUtilities isoCountry];
  return [supportedCountries containsObject:userCountry];
}


- (void) checkCountry {
  if ([self isSupportedCountry]) {
    return;
  }

  // Only warn once per upgrade.
  NSString* key = [NSString stringWithFormat:@"%@-%@-%@", UNSUPPORTED_COUNTRY, [Application version], [LocaleUtilities isoCountry]];
  if ([[NSUserDefaults standardUserDefaults] boolForKey:key]) {
    return;
  }
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
  [self synchronize];

  NSString* warning =
  [NSString stringWithFormat:
   LocalizedString(@"Your %@'s country is set to: %@\n\nFull support for %@ is coming soon to your country, and several features are already available for you to use today! When more features become ready, you will automatically be notified of updates.", @"The first %@ will be replaced with the device the user is on (i.e.: iPhone), the second %@ is replaced with the program name (i.e.: Now playing)"),
   [UIDevice currentDevice].localizedModel,
   [LocaleUtilities displayCountry],
   [Application name]];

  [AlertUtilities showOkAlert:warning];
}


- (void) migrateNetflixAccount {
  if (self.netflixAccounts.count == 0) {
    NSString* key = [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_KEY];
    NSString* secret = [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_SECRET];
    NSString* userId = [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_USER_ID];
    if (key.length > 0 && secret.length > 0 && userId.length > 0) {
      NetflixAccount* account = [NetflixAccount accountWithKey:key secret:secret userId:userId];
      [self addNetflixAccount:account];
    }

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NETFLIX_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NETFLIX_SECRET];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NETFLIX_USER_ID];
    [self synchronize];
  }
}


- (id) init {
  if ((self = [super init])) {
    self.bookmarkedTitlesData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadBookmarkedTitles) saveSelector:@selector(saveBookmarkedTitles:)];
    self.favoriteTheatersData = [ThreadsafeValue valueWithGate:dataGate delegate:self loadSelector:@selector(loadFavoriteTheaters) saveSelector:@selector(saveFavoriteTheaters:)];

    [self migrateNetflixAccount];

    self.dataProvider = [GoogleDataProvider provider];
    self.userLocationCache = [UserLocationCache cache];
    self.largePosterCache = [LargePosterCache cache];
    self.imdbCache = [IMDbCache cache];
    self.amazonCache = [AmazonCache cache];
    self.wikipediaCache = [WikipediaCache cache];
    self.trailerCache = [TrailerCache cache];
    self.blurayCache = [BlurayCache cache];
    self.dvdCache = [DVDCache cache];
    self.posterCache = [PosterCache cache];
    self.scoreCache = [ScoreCache cache];
    self.upcomingCache = [UpcomingCache cache];
    self.internationalDataCache = [InternationalDataCache cache];
    self.helpCache = [HelpCache cache];

    [self clearCaches];

    self.searchRadius = -1;
    self.cachedScoreProviderIndex = -1;
    cachedAllMoviesSelectedSegmentIndex = -1;
  }

  return self;
}


- (BOOL) loadingIndicatorsEnabled {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:LOADING_INDIACTORS_DISABLED];
}


- (void) setLoadingIndicatorsEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:LOADING_INDIACTORS_DISABLED];
}


- (BOOL) notificationsEnabled {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:NOTIFICATIONS_DISABLED];
}


- (void) setNotificationsEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:NOTIFICATIONS_DISABLED];
}


- (BOOL) netflixNotificationsEnabled {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:NETFLIX_NOTIFICATIONS_DISABLED];
}


- (void) setNetflixNotificationsEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:NETFLIX_NOTIFICATIONS_DISABLED];
}


- (BOOL) largePosterCacheEnabled {
  if ([BoxOfficeSharedApplication largePosterCacheAlwaysEnabled]) {
    return YES;
  }
  return self.userAddress.length > 0;
}


- (BOOL) helpCacheEnabled {
  return self.userAddress.length > 0;
}


- (BOOL) internationalDataCacheEnabled {
  return self.userAddress.length > 0;
}


- (BOOL) dataProviderEnabled {
  return self.userAddress.length > 0;
}


- (BOOL) scoreCacheEnabled {
  return self.userAddress.length > 0;
}


- (BOOL) dvdBlurayCacheEnabled {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:DVD_BLURAY_DISABLED];
}


- (void) setDvdBlurayCacheEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:DVD_BLURAY_DISABLED];
}


- (BOOL) upcomingCacheEnabled {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:UPCOMING_DISABLED];
}


- (void) setUpcomingCacheEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:UPCOMING_DISABLED];
}


- (BOOL) netflixCacheEnabled {
  if ([BoxOfficeSharedApplication netflixCacheAlwaysEnabled]) {
    return YES;
  }

  NSNumber* value = [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_DISABLED];
  if (value == nil) {
    return [LocaleUtilities isUnitedStates];
  }

  return !value.boolValue;
}


- (void) setNetflixCacheEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:NETFLIX_DISABLED];
}


- (NSArray*) loadNetflixAccounts {
  NSArray* result = [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_ACCOUNTS];
  if (result.count == 0) {
    return [NSArray array];
  }

  return [NetflixAccount decodeArray:result];
}


- (NSArray*) netflixAccounts {
  if (netflixAccountsData == nil) {
    self.netflixAccountsData = [self loadNetflixAccounts];
  }

  // return through pointer so that it is retain/autoreleased
  return self.netflixAccountsData;
}


- (void) setNetflixAccounts:(NSArray*) accounts {
  self.netflixAccountsData = accounts;
  [[NSUserDefaults standardUserDefaults] setObject:[NetflixAccount encodeArray:accounts]
                                            forKey:NETFLIX_ACCOUNTS];
  [self synchronize];
}


- (NetflixAccount*) currentNetflixAccount {
  NSArray* accounts = self.netflixAccounts;
  NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:NETFLIX_CURRENT_ACCOUNT_INDEX];
  if (index < 0 || index >= accounts.count) {
    return nil;
  }
  return [[[accounts objectAtIndex:index] retain] autorelease];
}


- (void) setCurrentNetflixAccount:(NetflixAccount*) account {
  if (account == nil) {
    return;
  }

  NSArray* accounts = self.netflixAccounts;
  NSInteger index = [accounts indexOfObject:account];
  if (index >= 0 && index < accounts.count) {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:NETFLIX_CURRENT_ACCOUNT_INDEX];
    [self synchronize];
  }
}


- (void) addNetflixAccount:(NetflixAccount*) account {
  if (account == nil) {
    return;
  }

  NSMutableArray* accounts = [NSMutableArray arrayWithArray:self.netflixAccounts];
  if (![accounts containsObject:account]) {
    [accounts addObject:account];
  }
  [self setNetflixAccounts:accounts];
}


- (void) removeNetflixAccount:(NetflixAccount*) account {
  if (account == nil) {
    return;
  }

  [[account retain] autorelease];

  NetflixAccount* currentAccount = self.currentNetflixAccount;

  NSMutableArray* accounts = [NSMutableArray arrayWithArray:self.netflixAccounts];
  [accounts removeObject:account];
  [self setNetflixAccounts:accounts];

  if ([account isEqual:currentAccount]) {
    if (accounts.count > 0) {
      // they removed the active account.  switch the active account to the first account.
      [self setCurrentNetflixAccount:accounts.firstObject];
    }
  } else {
    // reset the current account unless the index changed
    [self setCurrentNetflixAccount:currentAccount];
  }
}


- (NSInteger) scoreProviderIndexWorker {
  NSNumber* result = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_PROVIDER_INDEX];
  if (result != nil) {
    return [result integerValue];
  }

  // by default, chose 'rottentomatoes' if they're an english speaking
  // country.  otherwise, choose 'google'.
  if ([LocaleUtilities isEnglish]) {
    [self setScoreProviderIndex:0];
  } else {
    [self setScoreProviderIndex:2];
  }

  return [self scoreProviderIndex];
}


- (NSInteger) scoreProviderIndex {
  if (self.cachedScoreProviderIndex == -1) {
    self.cachedScoreProviderIndex = [self scoreProviderIndexWorker];
  }

  return self.cachedScoreProviderIndex;
}


- (void) setScoreProviderIndex:(NSInteger) index {
  self.cachedScoreProviderIndex = index;
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SCORE_PROVIDER_INDEX];
}


- (BOOL) rottenTomatoesScores {
  return self.scoreProviderIndex == 0;
}


- (BOOL) metacriticScores {
  return self.scoreProviderIndex == 1;
}


- (BOOL) googleScores {
  return self.scoreProviderIndex == 2;
}


- (BOOL) noScores {
  return self.scoreProviderIndex == 3;
}


- (NSArray*) scoreProviders {
  return [NSArray arrayWithObjects:
          @"RottenTomatoes",
          @"Metacritic",
          @"Google",
          LocalizedString(@"None", @"This is what a user picks when they don't want any reviews."),
          nil];
}


- (NSString*) currentScoreProvider {
  return [self.scoreProviders objectAtIndex:self.scoreProviderIndex];
}


- (NSInteger) selectedTabBarViewControllerIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX];
}


- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX];
}


- (NSInteger) allMoviesSelectedSegmentIndex {
  if (cachedAllMoviesSelectedSegmentIndex == -1) {
    cachedAllMoviesSelectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:ALL_MOVIES_SELECTED_SEGMENT_INDEX];
  }

  return cachedAllMoviesSelectedSegmentIndex;
}


- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index {
  cachedAllMoviesSelectedSegmentIndex = index;
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:ALL_MOVIES_SELECTED_SEGMENT_INDEX];
}


- (NSInteger) allTheatersSelectedSegmentIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:ALL_THEATERS_SELECTED_SEGMENT_INDEX];
}


- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:ALL_THEATERS_SELECTED_SEGMENT_INDEX];
}

- (NSInteger) upcomingMoviesSelectedSegmentIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX];
}


- (void) setUpcomingMoviesSelectedSegmentIndex:(NSInteger) index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX];
}


- (NSInteger) dvdMoviesSelectedSegmentIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:DVD_MOVIES_SELECTED_SEGMENT_INDEX];
}


- (void) setDvdMoviesSelectedSegmentIndex:(NSInteger) index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:DVD_MOVIES_SELECTED_SEGMENT_INDEX];
}


- (NSInteger) localSearchSelectedScopeButtonIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:LOCAL_SEARCH_SELECTED_SCOPE_BUTTON_INDEX];
}


- (void) setLocalSearchSelectedScopeButtonIndex:(NSInteger) index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:LOCAL_SEARCH_SELECTED_SCOPE_BUTTON_INDEX];
}


- (NSInteger) netflixSearchSelectedScopeButtonIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:NETFLIX_SEARCH_SELECTED_SCOPE_BUTTON_INDEX];
}


- (void) setNetflixSearchSelectedScopeButtonIndex:(NSInteger) index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:NETFLIX_SEARCH_SELECTED_SCOPE_BUTTON_INDEX];
}


- (NSInteger) netflixFilterSelectedSegmentIndex {
  return [[NSUserDefaults standardUserDefaults] integerForKey:NETFLIX_FILTER_SELECTED_SEGMENT_INDEX];
}


- (void) setNetflixFilterSelectedSegmentIndex:(NSInteger) index {
  [[NSUserDefaults standardUserDefaults] setInteger:index forKey:NETFLIX_FILTER_SELECTED_SEGMENT_INDEX];
}


- (BOOL) dvdMoviesShowBoth {
  return self.dvdMoviesShowDVDs && self.dvdMoviesShowBluray;
}


- (BOOL) dvdMoviesShowOnlyDVDs {
  return self.dvdMoviesShowDVDs && !self.dvdMoviesShowBluray;
}


- (BOOL) dvdMoviesShowOnlyBluray {
  return !self.dvdMoviesShowDVDs && self.dvdMoviesShowBluray;
}


- (BOOL) dvdMoviesShowDVDs {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:DVD_MOVIES_HIDE_DVDS];
}


- (BOOL) dvdMoviesShowBluray {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:DVD_MOVIES_HIDE_BLURAY];
}


- (void) setDvdMoviesShowDVDs:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:DVD_MOVIES_HIDE_DVDS];
}


- (void) setDvdMoviesShowBluray:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:DVD_MOVIES_HIDE_BLURAY];
}


- (BOOL) upcomingAndDVDShowUpcoming {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:UPCOMING_AND_DVD_HIDE_UPCOMING];
}


- (void) setUpcomingAndDVDShowUpcoming:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:!value forKey:UPCOMING_AND_DVD_HIDE_UPCOMING];
}


- (BOOL) allMoviesSortingByReleaseDate {
  return self.allMoviesSelectedSegmentIndex == 0;
}


- (BOOL) allMoviesSortingByTitle {
  return self.allMoviesSelectedSegmentIndex == 1;
}


- (BOOL) allMoviesSortingByScore {
  return self.allMoviesSelectedSegmentIndex == 2;
}


- (BOOL) allMoviesSortingByFavorite {
  return self.allMoviesSelectedSegmentIndex == 3;
}


- (BOOL) upcomingMoviesSortingByReleaseDate {
  return self.upcomingMoviesSelectedSegmentIndex == 0;
}


- (BOOL) upcomingMoviesSortingByTitle {
  return self.upcomingMoviesSelectedSegmentIndex == 1;
}


- (BOOL) upcomingMoviesSortingByFavorite {
  return self.upcomingMoviesSelectedSegmentIndex == 2;
}


- (BOOL) dvdMoviesSortingByReleaseDate {
  return self.dvdMoviesSelectedSegmentIndex == 0;
}


- (BOOL) dvdMoviesSortingByTitle {
  return self.dvdMoviesSelectedSegmentIndex == 1;
}


- (BOOL) dvdMoviesSortingByFavorite {
  return self.dvdMoviesSelectedSegmentIndex == 2;
}


- (BOOL) autoUpdateLocation {
  return [[NSUserDefaults standardUserDefaults] boolForKey:AUTO_UPDATE_LOCATION];
}


- (void) setAutoUpdateLocation:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:value forKey:AUTO_UPDATE_LOCATION];
}


- (NSString*) userAddress {
  NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:USER_ADDRESS];
  if (result == nil) {
    result = @"";
  }

  return result;
}


- (NSInteger) searchRadius {
  if (self.searchRadiusData == -1) {
    self.searchRadiusData = [[NSUserDefaults standardUserDefaults] integerForKey:SEARCH_RADIUS];
    if (self.searchRadiusData == 0) {
      self.searchRadiusData = 5;
    }

    self.searchRadiusData = MAX(MIN(self.searchRadiusData, 50), 1);
  }

  return self.searchRadiusData;
}


- (void) setSearchRadius:(NSInteger) radius {
  self.searchRadiusData = radius;
  [[NSUserDefaults standardUserDefaults] setInteger:self.searchRadius forKey:SEARCH_RADIUS];
}


- (NSDate*) searchDate {
  NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_DATE];
  if (date == nil || [date compare:[NSDate date]] == NSOrderedAscending) {
    date = [DateUtilities today];
    [self setSearchDate:date];
  }
  return date;
}


- (void) setSearchDate:(NSDate*) date {
  self.isSearchDateTodayData = nil;
  [[NSUserDefaults standardUserDefaults] setObject:date forKey:SEARCH_DATE];
}


- (BOOL) isSearchDateToday {
  if (isSearchDateTodayData == nil) {
    self.isSearchDateTodayData = [NSNumber numberWithBool:[DateUtilities isToday:self.searchDate]];
  }

  return isSearchDateTodayData.boolValue;
}


- (NSArray*) movies {
  return [dataProvider movies];
}


- (NSArray*) theaters {
  return [dataProvider theaters];
}


- (NSSet*) loadBookmarkedTitles {
  NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:BOOKMARKED_TITLES];
  if (array.count == 0) {
    return [NSMutableSet set];
  }

  return [NSSet setWithArray:array];
}


- (void) saveBookmarkedTitles:(NSSet*) bookmarkedTitles {
  [[NSUserDefaults standardUserDefaults] setObject:bookmarkedTitles.allObjects forKey:BOOKMARKED_TITLES];
}


- (NSSet*) bookmarkedTitles {
  return bookmarkedTitlesData.value;
}


- (BOOL) isBookmarked:(Movie*) movie {
  return [self.bookmarkedTitles containsObject:movie.canonicalTitle];
}


- (void) addBookmark:(Movie*) movie {
  NSMutableSet* set = [NSMutableSet setWithSet:self.bookmarkedTitles];
  [set addObject:movie.canonicalTitle];
  bookmarkedTitlesData.value = set;

  [dataProvider addBookmark:movie.canonicalTitle];
  [upcomingCache addBookmark:movie.canonicalTitle];
  [dvdCache addBookmark:movie.canonicalTitle];
  [blurayCache addBookmark:movie.canonicalTitle];
}


- (void) removeBookmark:(Movie*) movie {
  NSMutableSet* set = [NSMutableSet setWithSet:self.bookmarkedTitles];
  [set removeObject:movie.canonicalTitle];
  bookmarkedTitlesData.value = set;

  [dataProvider removeBookmark:movie.canonicalTitle];
  [upcomingCache removeBookmark:movie.canonicalTitle];
  [dvdCache removeBookmark:movie.canonicalTitle];
  [blurayCache removeBookmark:movie.canonicalTitle];
}


- (NSArray*) bookmarkedItems:(NSString*) key {
  NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
  if (array.count == 0) {
    return [NSArray array];
  }

  NSMutableArray* result = [NSMutableArray array];
  for (NSDictionary* dictionary in array) {
    [result addObject:[Movie createWithDictionary:dictionary]];
  }
  return result;
}


- (NSArray*) bookmarkedMovies {
  return [self bookmarkedItems:BOOKMARKED_MOVIES];
}


- (NSArray*) bookmarkedUpcoming {
  return [self bookmarkedItems:BOOKMARKED_UPCOMING];
}


- (NSArray*) bookmarkedDVD {
  return [self bookmarkedItems:BOOKMARKED_DVD];
}


- (NSArray*) bookmarkedBluray {
  return [self bookmarkedItems:BOOKMARKED_BLURAY];
}


- (void) setBookmarkedMovies:(NSArray*) array {
  [Model saveMovies:array key:BOOKMARKED_MOVIES];
}


- (void) setBookmarkedUpcoming:(NSArray*) array {
  [Model saveMovies:array key:BOOKMARKED_UPCOMING];
}


- (void) setBookmarkedDVD:(NSArray*) array {
  [Model saveMovies:array key:BOOKMARKED_DVD];
}


- (void) setBookmarkedBluray:(NSArray*) array {
  [Model saveMovies:array key:BOOKMARKED_BLURAY];
}


- (NSDictionary*) loadFavoriteTheaters {
  NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITE_THEATERS];
  if (array.count == 0) {
    return [NSDictionary dictionary];
  }

  NSMutableDictionary* result = [NSMutableDictionary dictionary];
  for (NSDictionary* dictionary in array) {
    FavoriteTheater* theater = [FavoriteTheater createWithDictionary:dictionary];
    [result setObject:theater forKey:theater.name];
  }

  return result;
}


- (void) saveFavoriteTheaters:(NSDictionary*) favoriteTheaters {
  NSMutableArray* result = [NSMutableArray array];
  for (FavoriteTheater* theater in favoriteTheaters.allValues) {
    [result addObject:theater.dictionary];
  }

  [[NSUserDefaults standardUserDefaults] setObject:result forKey:FAVORITE_THEATERS];
}


- (NSDictionary*) favoriteTheaters {
  return favoriteTheatersData.value;
}


- (NSArray*) favoriteTheatersArray {
  return self.favoriteTheaters.allValues;
}


- (void) addFavoriteTheater:(Theater*) theater {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:self.favoriteTheaters];

  FavoriteTheater* favoriteTheater = [FavoriteTheater theaterWithName:theater.name
                                                  originatingLocation:theater.originatingLocation];

  [dictionary setObject:favoriteTheater forKey:theater.name];
  favoriteTheatersData.value = dictionary;
}


- (BOOL) isFavoriteTheater:(Theater*) theater {
  return [self.favoriteTheaters objectForKey:theater.name] != nil;
}


- (void) removeFavoriteTheater:(Theater*) theater {
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:self.favoriteTheaters];
  [dictionary removeObjectForKey:theater.name];

  favoriteTheatersData.value = dictionary;
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
  NSDate* date = movie.releaseDate;
  if (date != nil) {
    return date;
  }

  date = [internationalDataCache releaseDateForMovie:movie];
  if (date != nil) {
    return date;
  }

  date = [upcomingCache releaseDateForMovie:movie];
  if (date != nil) {
    return date;
  }

  return nil;
}


- (NSInteger) lengthForMovie:(Movie*) movie {
  NSInteger length = movie.length;
  if (length > 0) {
    return length;
  }

  return [internationalDataCache lengthForMovie:movie];
}


- (NSString*) ratingForMovie:(Movie*) movie {
  NSString* rating = movie.rating;
  if (rating.length > 0) {
    return rating;
  }

  rating = [internationalDataCache ratingForMovie:movie];
  if (rating.length > 0) {
    return rating;
  }

  return nil;
}


- (NSString*) ratingAndRuntimeForMovie:(Movie*) movie {
  return [internationalDataCache ratingAndRuntimeForMovie:movie];
}


- (NetflixCache*) netflixCache {
  return [MutableNetflixCache cache];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
  NSArray* directors = movie.directors;
  if (directors.count > 0) {
    return directors;
  }

  directors = [self.netflixCache directorsForMovie:movie];
  if (directors.count > 0 || movie.isNetflix) {
    return directors;
  }

  directors = [internationalDataCache directorsForMovie:movie];
  if (directors.count > 0) {
    return directors;
  }

  directors = [upcomingCache directorsForMovie:movie];
  if (directors.count > 0) {
    return directors;
  }

  return [NSArray array];
}


- (NSArray*) castForMovie:(Movie*) movie {
  NSArray* cast = movie.cast;
  if (cast.count > 0) {
    return cast;
  }

  cast = [self.netflixCache castForMovie:movie];
  if (cast.count > 0 || movie.isNetflix) {
    return cast;
  }

  cast = [internationalDataCache castForMovie:movie];
  if (cast.count > 0) {
    return cast;
  }

  cast = [upcomingCache castForMovie:movie];
  if (cast.count > 0) {
    return cast;
  }

  return [NSArray array];
}


- (NSArray*) genresForMovie:(Movie*) movie {
  if (movie.genres.count > 0) {
    return movie.genres;
  }

  return [upcomingCache genresForMovie:movie];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
  NSString* result = movie.imdbAddress;
  if (result.length > 0) {
    return result;
  }

  result = [internationalDataCache imdbAddressForMovie:movie];
  if (result.length > 0) {
    return result;
  }

  result = [imdbCache addressForMovie:movie];
  if (result.length > 0) {
    return result;
  }

  return nil;
}


- (NSString*) amazonAddressForMovie:(Movie*) movie {
  return [amazonCache addressForMovie:movie];
}


- (NSString*) wikipediaAddressForMovie:(Movie*) movie {
  return [wikipediaCache addressForMovie:movie];
}


- (DVD*) dvdDetailsForMovie:(Movie*) movie {
  DVD* dvd = [dvdCache detailsForMovie:movie];
  if (dvd != nil) {
    return dvd;
  }

  dvd = [blurayCache detailsForMovie:movie];
  if (dvd != nil) {
    return dvd;
  }

  return nil;
}


- (NSString*) netflixAddressForMovie:(Movie*) movie {
  return [self.netflixCache netflixAddressForMovie:movie];
}


- (UIImage*) posterForMovie:(Movie*) movie
                    sources:(NSArray*) sources
                   selector:(SEL) selector {
  for (id source in sources) {
    UIImage* image = [source performSelector:selector withObject:movie];
    if (image != nil) {
      return image;
    }
  }

  return nil;
}


- (UIImage*) posterForMovie:(Movie*) movie loadFromDisk:(BOOL) loadFromDisk {
  UIImage* image = [posterCache posterForMovie:movie loadFromDisk:loadFromDisk];
  if (image != nil) {
    return image;
  }

  return [largePosterCache posterForMovie:movie loadFromDisk:loadFromDisk];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie loadFromDisk:(BOOL) loadFromDisk {
  UIImage* image = [posterCache smallPosterForMovie:movie loadFromDisk:loadFromDisk];
  if (image != nil) {
    return image;
  }

  return [largePosterCache smallPosterForMovie:movie loadFromDisk:loadFromDisk];
}


- (UIImage*) posterForMovie:(Movie*) movie {
  return [self posterForMovie:movie loadFromDisk:YES];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
  return [self smallPosterForMovie:movie loadFromDisk:YES];
}


- (NSMutableArray*) theatersShowingMovie:(Movie*) movie {
  NSMutableArray* array = [NSMutableArray array];

  for (Theater* theater in self.theaters) {
    if ([theater.movieTitles containsObject:movie.canonicalTitle]) {
      [array addObject:theater];
    }
  }

  return array;
}


- (NSArray*) moviesAtTheater:(Theater*) theater {
  NSMutableArray* array = [NSMutableArray array];

  for (Movie* movie in self.movies) {
    if ([theater.movieTitles containsObject:movie.canonicalTitle]) {
      [array addObject:movie];
    }
  }

  return array;
}


- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater {
  return [dataProvider moviePerformances:movie forTheater:theater];
}


- (NSDate*) synchronizationDateForTheater:(Theater*) theater {
  return [dataProvider synchronizationDateForTheater:theater];
}


- (BOOL) isStale:(Theater*) theater {
  return [dataProvider isStale:theater];
}


- (NSString*) showtimesRetrievedOnString:(Theater*) theater {
  if ([self isStale:theater]) {
    // we're showing out of date information
    NSDate* theaterSyncDate = [self synchronizationDateForTheater:theater];
    return [NSString stringWithFormat:
            LocalizedString(@"Theater last reported show times on\n%@.", @"%@ will be replaced with a date.  i.e.: 04/30/2008"),
            [DateUtilities formatLongDate:theaterSyncDate]];
  } else {
    NSDate* globalSyncDate = [dataProvider lastLookupDate];
    if (globalSyncDate == nil) {
      return @"";
    }

    return [NSString stringWithFormat:
            LocalizedString(@"Show times retrieved on %@.", @"%@ will be replaced with a date.  i.e.: 04/30/2008"),
            [DateUtilities formatLongDate:globalSyncDate]];
  }
}


- (NSString*) simpleAddressForTheater:(Theater*) theater {
  return theater.simpleAddress;
}


- (NSDictionary*) theaterDistanceMap:(Location*) location
                            theaters:(NSArray*) theaters {
  NSMutableDictionary* theaterDistanceMap = [NSMutableDictionary dictionary];

  for (Theater* theater in theaters) {
    double d;
    if (location != nil) {
      d = [location distanceTo:theater.location];
    } else {
      d = UNKNOWN_DISTANCE;
    }

    NSNumber* value = [NSNumber numberWithDouble:d];
    NSString* key = theater.name;
    [theaterDistanceMap setObject:value forKey:key];
  }

  return theaterDistanceMap;
}


- (NSDictionary*) theaterDistanceMap {
  Location* location = [userLocationCache locationForUserAddress:self.userAddress];
  return [self theaterDistanceMap:location
                         theaters:self.theaters];
}


- (BOOL) tooFarAway:(double) distance {
  return
  distance != UNKNOWN_DISTANCE &&
  self.searchRadius < 50 &&
  distance > self.searchRadius;
}


- (NSArray*) theatersInRange:(NSArray*) theaters {
  NSDictionary* theaterDistanceMap = [self theaterDistanceMap];
  NSMutableArray* result = [NSMutableArray array];

  for (Theater* theater in theaters) {
    double distance = [[theaterDistanceMap objectForKey:theater.name] doubleValue];

    if ([self isFavoriteTheater:theater] || ![self tooFarAway:distance]) {
      [result addObject:theater];
    }
  }

  return result;
}


NSInteger compareMoviesByScore(id t1, id t2, void* context) {
  if (t1 == t2) {
    return NSOrderedSame;
  }

  Movie* movie1 = t1;
  Movie* movie2 = t2;
  Model* model = context;

  NSInteger movieRating1 = [model scoreValueForMovie:movie1];
  NSInteger movieRating2 = [model scoreValueForMovie:movie2];

  if (movieRating1 < movieRating2) {
    return NSOrderedDescending;
  } else if (movieRating1 > movieRating2) {
    return NSOrderedAscending;
  }

  return compareMoviesByTitle(t1, t2, context);
}


NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void* context) {
  if (t1 == t2) {
    return NSOrderedSame;
  }

  Model* model = context;
  Movie* movie1 = t1;
  Movie* movie2 = t2;

  NSDate* releaseDate1 = [model releaseDateForMovie:movie1];
  NSDate* releaseDate2 = [model releaseDateForMovie:movie2];

  if (releaseDate1 == nil) {
    if (releaseDate2 == nil) {
      return compareMoviesByTitle(movie1, movie2, context);
    } else {
      return NSOrderedDescending;
    }
  } else if (releaseDate2 == nil) {
    return NSOrderedAscending;
  }

  return -[releaseDate1 compare:releaseDate2];
}


NSInteger compareMoviesByReleaseDateAscending(id t1, id t2, void* context) {
  return -compareMoviesByReleaseDateDescending(t1, t2, context);
}


NSInteger compareMoviesByTitle(id t1, id t2, void* context) {
  if (t1 == t2) {
    return NSOrderedSame;
  }

  Model* model = context;

  Movie* movie1 = t1;
  Movie* movie2 = t2;

  BOOL movie1Bookmarked = [model isBookmarked:movie1];
  BOOL movie2Bookmarked = [model isBookmarked:movie2];

  if (movie1Bookmarked && !movie2Bookmarked) {
    return NSOrderedAscending;
  } else if (movie2Bookmarked && !movie1Bookmarked) {
    return NSOrderedDescending;
  }

  return [movie1.displayTitle compare:movie2.displayTitle options:NSCaseInsensitiveSearch];
}


NSInteger compareTheatersByName(id t1, id t2, void* context) {
  if (t1 == t2) {
    return NSOrderedSame;
  }

  Theater* theater1 = t1;
  Theater* theater2 = t2;

  return [theater1.name compare:theater2.name options:NSCaseInsensitiveSearch];
}


NSInteger compareTheatersByDistance(id t1, id t2, void* context) {
  if (t1 == t2) {
    return NSOrderedSame;
  }

  NSDictionary* theaterDistanceMap = context;

  Theater* theater1 = t1;
  Theater* theater2 = t2;

  double distance1 = [[theaterDistanceMap objectForKey:theater1.name] doubleValue];
  double distance2 = [[theaterDistanceMap objectForKey:theater2.name] doubleValue];

  if (distance1 < distance2) {
    return NSOrderedAscending;
  } else if (distance1 > distance2) {
    return NSOrderedDescending;
  }

  return compareTheatersByName(t1, t2, nil);
}


- (void) setUserAddress:(NSString*) userAddress {
  [[NSUserDefaults standardUserDefaults] setObject:userAddress forKey:USER_ADDRESS];
  [self synchronize];
}


- (Score*) scoreForMovie:(Movie*) movie {
  return [scoreCache scoreForMovie:movie];
}


- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie {
  return [scoreCache rottenTomatoesScoreForMovie:movie];
}


- (Score*) metacriticScoreForMovie:(Movie*) movie {
  return [scoreCache metacriticScoreForMovie:movie];
}


- (NSInteger) scoreValueForMovie:(Movie*) movie {
  Score* score = [self scoreForMovie:movie];
  if (score == nil) {
    return -1;
  }

  return score.scoreValue;
}


- (NSString*) synopsisForMovie:(Movie*) movie {
  NSMutableArray* options = [NSMutableArray array];

  NSString* synopsis = movie.synopsis;
  if (synopsis.length > 0) {
    [options addObject:synopsis];
  }

  if (movie.isNetflix) {
    return [self.netflixCache synopsisForMovie:movie];
  }

  synopsis = [internationalDataCache synopsisForMovie:movie];
  if (synopsis.length > 0) {
    [options addObject:synopsis];
  }

  if (options.count == 0 || [LocaleUtilities isEnglish]) {
    synopsis = [self scoreForMovie:movie].synopsis;
    if (synopsis.length > 0) {
      [options addObject:synopsis];
    }

    synopsis = [upcomingCache synopsisForMovie:movie];
    if (synopsis.length > 0) {
      [options addObject:synopsis];
    }

    synopsis = [self.netflixCache synopsisForMovie:movie];
    if (synopsis.length > 0) {
      [options addObject:synopsis];
    }
  }

  if (options.count == 0) {
    return LocalizedString(@"No synopsis available.", nil);
  }


  NSString* bestOption = @"";
  for (NSString* option in options) {
    if (option.length > bestOption.length) {
      bestOption = option;
    }
  }

  return bestOption;
}


- (NSArray*) trailersForMovie:(Movie*) movie {
  NSArray* result = [internationalDataCache trailersForMovie:movie];
  if (result.count > 0) {
    return result;
  }

  result = [trailerCache trailersForMovie:movie];
  if (result.count > 0) {
    return result;
  }

  return [upcomingCache trailersForMovie:movie];
}


- (NSArray*) reviewsForMovie:(Movie*) movie {
  return [scoreCache reviewsForMovie:movie];
}


- (NSString*) noInformationFound {
  if (self.userAddress.length == 0) {
    return LocalizedString(@"Please enter your location", nil);
  } else if ([[OperationQueue operationQueue] hasPriorityOperations]) {
    return LocalizedString(@"Downloading data", nil);
  } else if (![NetworkUtilities isNetworkAvailable]) {
    return LocalizedString(@"Network unavailable", nil);
  } else if (![self isSupportedCountry]) {
    return [NSString stringWithFormat:
            LocalizedString(@"Local results unavailable", nil),
            [LocaleUtilities displayCountry]];
  } else {
    return LocalizedString(@"No information found", nil);
  }
}


- (BOOL) useSmallFonts {
  return ![[NSUserDefaults standardUserDefaults] boolForKey:USE_NORMAL_FONTS];
}


- (void) setUseSmallFonts:(BOOL) useSmallFonts {
  [[NSUserDefaults standardUserDefaults] setBool:!useSmallFonts forKey:USE_NORMAL_FONTS];
}


- (void) saveNavigationStack:(UINavigationController*) controller {
  NSMutableArray* types = [NSMutableArray array];
  NSMutableArray* values = [NSMutableArray array];

  for (id viewController in controller.viewControllers) {
    NSInteger type = -1;
    id value = nil;
    if ([viewController isKindOfClass:[MovieDetailsViewController class]]) {
      type = MovieDetails;
      value = [[viewController movie] canonicalTitle];
    } else if ([viewController isKindOfClass:[TheaterDetailsViewController class]]) {
      type = TheaterDetails;
      value = [[viewController theater] name];
    } else if ([viewController isKindOfClass:[ReviewsViewController class]]) {
      type = Reviews;
      value = [[viewController movie] canonicalTitle];
    } else if ([viewController isKindOfClass:[TicketsViewController class]]) {
      type = Tickets;
      value = [NSArray arrayWithObjects:[[viewController movie] canonicalTitle], [[viewController theater] name], [viewController title], nil];
    } else if ([viewController isKindOfClass:[AllMoviesViewController class]] ||
               [viewController isKindOfClass:[AllTheatersViewController class]] ||
               [viewController isKindOfClass:[UpcomingMoviesViewController class]] ||
               [viewController isKindOfClass:[DVDViewController class]]) {
      continue;
    } else {
      break;
    }

    if (type == -1 || value == nil) {
      continue;
    }

    [types addObject:[NSNumber numberWithInteger:type]];
    [values addObject:value];
  }

  [[NSUserDefaults standardUserDefaults] setObject:types forKey:NAVIGATION_STACK_TYPES];
  [[NSUserDefaults standardUserDefaults] setObject:values forKey:NAVIGATION_STACK_VALUES];
}


- (NSArray*) navigationStackTypes {
  NSArray* result = [[NSUserDefaults standardUserDefaults] arrayForKey:NAVIGATION_STACK_TYPES];
  if (result == nil) {
    return [NSArray array];
  }

  return result;
}


- (NSArray*) navigationStackValues {
  NSArray* result = [[NSUserDefaults standardUserDefaults] arrayForKey:NAVIGATION_STACK_VALUES];
  if (result == nil) {
    return [NSArray array];
  }

  return result;
}


- (void) clearNavigationStack {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:NAVIGATION_STACK_TYPES];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:NAVIGATION_STACK_VALUES];
  [self synchronize];
}

@end
