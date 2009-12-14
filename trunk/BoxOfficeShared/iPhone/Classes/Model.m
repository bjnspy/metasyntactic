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
#import "BookmarkCache.h"
#import "BoxOfficeSharedApplication.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "FavoriteTheater.h"
#import "FavoriteTheaterCache.h"
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
@property (retain) PersonPosterCache* personPosterCache;
@property (retain) id<DataProvider> dataProvider;
@property (retain) NSNumber* isSearchDateTodayData;
@property NSInteger cachedScoreProviderIndex;
@property NSInteger searchRadiusData;
@end

@implementation Model

static NSString* ALL_MOVIES_SELECTED_SEGMENT_INDEX          = @"allMoviesSelectedSegmentIndex";
static NSString* ALL_THEATERS_SELECTED_SEGMENT_INDEX        = @"allTheatersSelectedSegmentIndex";
static NSString* AUTO_UPDATE_LOCATION                       = @"autoUpdateLocation";
static NSString* DVD_BLURAY_DISABLED                        = @"dvdBlurayDisabled";
static NSString* DVD_MOVIES_HIDE_BLURAY                     = @"dvdMoviesHideBluray";
static NSString* DVD_MOVIES_HIDE_DVDS                       = @"dvdMoviesHideDVDs";
static NSString* DVD_MOVIES_SELECTED_SEGMENT_INDEX          = @"dvdMoviesSelectedSegmentIndex";
static NSString* LOADING_INDIACTORS_DISABLED                = @"loadingIndicatorsDisabled";
static NSString* LOCAL_SEARCH_SELECTED_SCOPE_BUTTON_INDEX   = @"localSearchSelectedScopeButtonIndex";
static NSString* NAVIGATION_STACK_TYPES                     = @"navigationStackTypes";
static NSString* NAVIGATION_STACK_VALUES                    = @"navigationStackValues";
static NSString* NETFLIX_DISABLED                           = @"netflixDisabled";
static NSString* NETFLIX_FILTER_SELECTED_SEGMENT_INDEX      = @"netflixFilterSelectedSegmentIndex";
static NSString* NETFLIX_NOTIFICATIONS_DISABLED             = @"netflixNotificationsDisabled";
static NSString* NETFLIX_SEARCH_SELECTED_SCOPE_BUTTON_INDEX = @"netflixSearchSelectedScopeButtonIndex";
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

@synthesize isSearchDateTodayData;

@synthesize personPosterCache;
@synthesize cachedScoreProviderIndex;
@synthesize searchRadiusData;

- (void) dealloc {
  self.dataProvider = nil;
  self.isSearchDateTodayData = nil;

  self.personPosterCache = nil;
  self.cachedScoreProviderIndex = 0;
  self.searchRadiusData = 0;

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
                               @"CN", // China
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
                               @"TH", // Thailand
                               @"TR", // Turkey
                               @"TW", // Taiwan
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


- (id) init {
  if ((self = [super init])) {
    self.dataProvider = [GoogleDataProvider provider];

    [self clearCaches];

    self.searchRadius = -1;
    self.cachedScoreProviderIndex = -1;
    cachedAllMoviesSelectedSegmentIndex = -1;
  }

  return self;
}


- (TrailerCache*) trailerCache {
  return [TrailerCache cache];
}


- (InternationalDataCache*) internationalDataCache {
  return [InternationalDataCache cache];
}


- (ScoreCache*) scoreCache {
  return [ScoreCache cache];
}


- (PosterCache*) posterCache {
  return [PosterCache cache];
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


- (NSDate*) releaseDateForMovie:(Movie*) movie {
  NSDate* date = movie.releaseDate;
  if (date != nil) {
    return date;
  }

  date = [self.internationalDataCache releaseDateForMovie:movie];
  if (date != nil) {
    return date;
  }

  date = [[UpcomingCache cache] releaseDateForMovie:movie];
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

  return [self.internationalDataCache lengthForMovie:movie];
}


- (NSString*) ratingForMovie:(Movie*) movie {
  NSString* rating = movie.rating;
  if (rating.length > 0) {
    return rating;
  }

  rating = [self.internationalDataCache ratingForMovie:movie];
  if (rating.length > 0) {
    return rating;
  }

  return nil;
}


- (NSString*) ratingAndRuntimeForMovie:(Movie*) movie {
  return [self.internationalDataCache ratingAndRuntimeForMovie:movie];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
  NSArray* directors = movie.directors;
  if (directors.count > 0) {
    return directors;
  }

  directors = [[NetflixCache cache] directorsForMovie:movie];
  if (directors.count > 0 || movie.isNetflix) {
    return directors;
  }

  directors = [self.internationalDataCache directorsForMovie:movie];
  if (directors.count > 0) {
    return directors;
  }

  directors = [[UpcomingCache cache] directorsForMovie:movie];
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

  cast = [[NetflixCache cache] castForMovie:movie];
  if (cast.count > 0 || movie.isNetflix) {
    return cast;
  }

  cast = [self.internationalDataCache castForMovie:movie];
  if (cast.count > 0) {
    return cast;
  }

  cast = [[UpcomingCache cache] castForMovie:movie];
  if (cast.count > 0) {
    return cast;
  }

  return [NSArray array];
}


- (NSArray*) genresForMovie:(Movie*) movie {
  if (movie.genres.count > 0) {
    return movie.genres;
  }

  return [[UpcomingCache cache] genresForMovie:movie];
}


- (NSString*) imdbAddressForMovie:(Movie*) movie {
  NSString* result = movie.imdbAddress;
  if (result.length > 0) {
    return result;
  }

  result = [self.internationalDataCache imdbAddressForMovie:movie];
  if (result.length > 0) {
    return result;
  }

  result = [[IMDbCache cache] addressForMovie:movie];
  if (result.length > 0) {
    return result;
  }

  return nil;
}


- (NSString*) amazonAddressForMovie:(Movie*) movie {
  return [[AmazonCache cache] addressForMovie:movie];
}


- (NSString*) wikipediaAddressForMovie:(Movie*) movie {
  return [[WikipediaCache cache] addressForMovie:movie];
}


- (DVD*) dvdDetailsForMovie:(Movie*) movie {
  DVD* dvd = [[DVDCache cache] detailsForMovie:movie];
  if (dvd != nil) {
    return dvd;
  }

  dvd = [[BlurayCache cache] detailsForMovie:movie];
  if (dvd != nil) {
    return dvd;
  }

  return nil;
}


- (NSString*) netflixAddressForMovie:(Movie*) movie {
  return [[NetflixCache cache] netflixAddressForMovie:movie];
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
  UIImage* image = [self.posterCache posterForMovie:movie loadFromDisk:loadFromDisk];
  if (image != nil) {
    return image;
  }

  return [[LargePosterCache cache] posterForMovie:movie loadFromDisk:loadFromDisk];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie loadFromDisk:(BOOL) loadFromDisk {
  UIImage* image = [self.posterCache smallPosterForMovie:movie loadFromDisk:loadFromDisk];
  if (image != nil) {
    return image;
  }

  return [[LargePosterCache cache] smallPosterForMovie:movie loadFromDisk:loadFromDisk];
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
  Location* location = [[UserLocationCache cache] locationForUserAddress:self.userAddress];
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

    if ([[FavoriteTheaterCache cache] isFavoriteTheater:theater] || ![self tooFarAway:distance]) {
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

  Movie* movie1 = t1;
  Movie* movie2 = t2;

  BOOL movie1Bookmarked = [[BookmarkCache cache] isBookmarked:movie1];
  BOOL movie2Bookmarked = [[BookmarkCache cache] isBookmarked:movie2];

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
  return [self.scoreCache scoreForMovie:movie];
}


- (Score*) rottenTomatoesScoreForMovie:(Movie*) movie {
  return [self.scoreCache rottenTomatoesScoreForMovie:movie];
}


- (Score*) metacriticScoreForMovie:(Movie*) movie {
  return [self.scoreCache metacriticScoreForMovie:movie];
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
    return [[NetflixCache cache] synopsisForMovie:movie];
  }

  synopsis = [self.internationalDataCache synopsisForMovie:movie];
  if (synopsis.length > 0) {
    [options addObject:synopsis];
  }

  if (options.count == 0 || [LocaleUtilities isEnglish]) {
    synopsis = [self scoreForMovie:movie].synopsis;
    if (synopsis.length > 0) {
      [options addObject:synopsis];
    }

    synopsis = [[UpcomingCache cache] synopsisForMovie:movie];
    if (synopsis.length > 0) {
      [options addObject:synopsis];
    }

    synopsis = [[NetflixCache cache] synopsisForMovie:movie];
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
  NSArray* result = [self.internationalDataCache trailersForMovie:movie];
  if (result.count > 0) {
    return result;
  }

  result = [self.trailerCache trailersForMovie:movie];
  if (result.count > 0) {
    return result;
  }

  return [[UpcomingCache cache] trailersForMovie:movie];
}


- (NSArray*) reviewsForMovie:(Movie*) movie {
  return [self.scoreCache reviewsForMovie:movie];
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
