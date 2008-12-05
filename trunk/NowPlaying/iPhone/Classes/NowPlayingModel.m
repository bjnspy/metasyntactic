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

#import "NowPlayingModel.h"

#import "AbstractNavigationController.h"
#import "AllMoviesViewController.h"
#import "AllTheatersViewController.h"
#import "Application.h"
#import "BlurayCache.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "FavoriteTheater.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "GoogleDataProvider.h"
#import "IMDbCache.h"
#import "LargePosterCache.h"
#import "LocaleUtilities.h"
#import "Location.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "PosterCache.h"
#import "ReviewsViewController.h"
#import "Score.h"
#import "ScoreCache.h"
#import "Theater.h"
#import "TheaterDetailsViewController.h"
#import "ThreadingUtilities.h"
#import "TicketsViewController.h"
#import "TrailerCache.h"
#import "UpcomingCache.h"
#import "UpcomingMoviesViewController.h"
#import "UserLocationCache.h"
#import "Utilities.h"

@interface NowPlayingModel()
@property (retain) UserLocationCache* userLocationCache;
@property (retain) BlurayCache* blurayCache;
@property (retain) DVDCache* dvdCache;
@property (retain) IMDbCache* imdbCache;
@property (retain) PosterCache* posterCache;
@property (retain) LargePosterCache* largePosterCache;
@property (retain) ScoreCache* scoreCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) UpcomingCache* upcomingCache;
@property (retain) NSMutableDictionary* bookmarkedMoviesData;
@property (retain) NSMutableDictionary* bookmarkedUpcomingMoviesData;
@property (retain) NSMutableDictionary* bookmarkedDVDMoviesData;
@property (retain) NSMutableDictionary* favoriteTheatersData;
@property (retain) id<DataProvider> dataProvider;
@end

@implementation NowPlayingModel

static NSString* currentVersion = @"2.5.0";
static NSString* persistenceVersion = @"13";

static NSString* VERSION = @"version";

static NSString* ALL_MOVIES_SELECTED_SEGMENT_INDEX      = @"allMoviesSelectedSegmentIndex";
static NSString* ALL_THEATERS_SELECTED_SEGMENT_INDEX    = @"allTheatersSelectedSegmentIndex";
static NSString* AUTO_UPDATE_LOCATION                   = @"autoUpdateLocation";
static NSString* BOOKMARKED_MOVIES                      = @"bookmarkedMovies";
static NSString* BOOKMARKED_UPCOMING_MOVIES             = @"bookmarkedUpcomingMovies";
static NSString* BOOKMARKED_DVD_MOVIES                  = @"bookmarkedDVDMovies";
static NSString* DVD_MOVIES_SELECTED_SEGMENT_INDEX      = @"dvdMoviesSelectedSegmentIndex";
static NSString* DVD_MOVIES_HIDE_DVDS                   = @"dvdMoviesHideDVDs";
static NSString* DVD_MOVIES_HIDE_BLURAY                 = @"dvdMoviesHideBluray";
static NSString* FAVORITE_THEATERS                      = @"favoriteTheaters";
static NSString* NAVIGATION_STACK_TYPES                 = @"navigationStackTypes";
static NSString* NAVIGATION_STACK_VALUES                = @"navigationStackValues";
static NSString* PRIORITIZE_BOOKMARKS                   = @"prioritizeBookmarks";
static NSString* RATINGS_PROVIDER_INDEX                 = @"scoreProviderIndex";
static NSString* SEARCH_DATE                            = @"searchDate";
static NSString* SEARCH_RADIUS                          = @"searchRadius";
static NSString* SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX = @"selectedTabBarViewControllerIndex";
static NSString* UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX = @"upcomingMoviesSelectedSegmentIndex";
static NSString* USER_ADDRESS                           = @"userLocation";
static NSString* USE_NORMAL_FONTS                       = @"useNormalFonts";
static NSString* RUN_COUNT                              = @"runCount";
static NSString* UNSUPPORTED_COUNTRY                    = @"unsupportedCountry";

static NSString** KEYS[] = {
    &VERSION,
    &ALL_MOVIES_SELECTED_SEGMENT_INDEX,
    &ALL_THEATERS_SELECTED_SEGMENT_INDEX,
    &AUTO_UPDATE_LOCATION,
    &BOOKMARKED_MOVIES,
    &BOOKMARKED_UPCOMING_MOVIES,
    &BOOKMARKED_DVD_MOVIES,
    &DVD_MOVIES_SELECTED_SEGMENT_INDEX,
    &DVD_MOVIES_HIDE_DVDS,
    &DVD_MOVIES_HIDE_BLURAY,
    &FAVORITE_THEATERS,
    &NAVIGATION_STACK_TYPES,
    &NAVIGATION_STACK_VALUES,
    &PRIORITIZE_BOOKMARKS,
    &RATINGS_PROVIDER_INDEX,
    &SEARCH_DATE,
    &SEARCH_RADIUS,
    &SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX,
    &UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX,
    &USER_ADDRESS,
    &USE_NORMAL_FONTS,
    &RUN_COUNT,
};


@synthesize dataProvider;
@synthesize bookmarkedMoviesData;
@synthesize bookmarkedUpcomingMoviesData;
@synthesize bookmarkedDVDMoviesData;
@synthesize favoriteTheatersData;

@synthesize userLocationCache;
@synthesize blurayCache;
@synthesize dvdCache;
@synthesize imdbCache;
@synthesize posterCache;
@synthesize largePosterCache;
@synthesize scoreCache;
@synthesize trailerCache;
@synthesize upcomingCache;

- (void) dealloc {
    self.dataProvider = nil;
    self.bookmarkedMoviesData = nil;
    self.bookmarkedUpcomingMoviesData = nil;
    self.bookmarkedDVDMoviesData = nil;
    self.favoriteTheatersData = nil;

    self.userLocationCache = nil;
    self.blurayCache = nil;
    self.dvdCache = nil;
    self.imdbCache = nil;
    self.posterCache = nil;
    self.largePosterCache = nil;
    self.scoreCache = nil;
    self.trailerCache = nil;
    self.upcomingCache = nil;

    [super dealloc];
}


+ (NSString*) version {
    return currentVersion;
}


- (void) updateScoreCache {
    [scoreCache update];
}


- (void) updateDVDCache {
    [dvdCache update];
    [blurayCache update];
}


- (void) updateUpcomingCache {
    [upcomingCache update];
}


- (void) updateIMDbCache {
    [imdbCache update:self.movies];
}


- (void) updatePosterCache {
    [posterCache update:self.movies];
}


- (void) updateTrailerCache {
    [trailerCache update:self.movies];
}


+ (void) saveFavoriteTheaters:(NSArray*) favoriteTheaters {
    NSMutableArray* result = [NSMutableArray array];
    for (FavoriteTheater* theater in favoriteTheaters) {
        [result addObject:theater.dictionary];
    }

    [[NSUserDefaults standardUserDefaults] setObject:result forKey:FAVORITE_THEATERS];
}


+ (void) saveMovies:(NSArray*) movies key:(NSString*) key {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in movies) {
        [result addObject:movie.dictionary];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:result forKey:key];
}


+ (void) saveBookmarkedMovies:(NSArray*) bookmarkedMovies {
    [self saveMovies:bookmarkedMovies key:BOOKMARKED_MOVIES];
}


+ (void) saveBookmarkedUpcomingMovies:(NSArray*) bookmarkedMovies {
    [self saveMovies:bookmarkedMovies key:BOOKMARKED_UPCOMING_MOVIES];
}


+ (void) saveBookmarkedDVDMovies:(NSArray*) bookmarkedMovies {
    [self saveMovies:bookmarkedMovies key:BOOKMARKED_DVD_MOVIES];
}


- (NSArray*) restoreMoviesArray:(NSArray*) previousMovies {
    NSMutableArray* result = [NSMutableArray array];
    
    for (id previousMovie in previousMovies) {
        if (![previousMovie isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        if (![Movie canReadDictionary:previousMovie]) {
            continue;
        }
        
        Movie* movie = [Movie movieWithDictionary:previousMovie];
        [result addObject:movie];
    }
    
    return result;
}


- (void) restorePreviousUserAddress:(id) previousUserAddress
                       searchRadius:(id) previousSearchRadius
                 autoUpdateLocation:(id) previousAutoUpdateLocation
                prioritizeBookmarks:(id) previousPrioritizeBookmarks
                     useNormalFonts:(id) previousUseNormalFonts
                   bookmarkedMovies:(id) previousBookmarkedMovies
           bookmarkedUpcomingMovies:(id) previousBookmarkedUpcomingMovies
                bookmarkedDVDMovies:(id) previousBookmarkedDVDMovies
                   favoriteTheaters:(id) previousFavoriteTheaters
                  dvdMoviesHideDVDs:(id) previousDvdMoviesHideDVDs
                dvdMoviesHideBluray:(id) previousDvdMoviesHideBluray {
    if ([previousUserAddress isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:previousUserAddress forKey:USER_ADDRESS];
    }

    if ([previousSearchRadius isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[previousSearchRadius intValue] forKey:SEARCH_RADIUS];
    }

    if ([previousAutoUpdateLocation isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousAutoUpdateLocation boolValue] forKey:AUTO_UPDATE_LOCATION];
    }
    
    if ([previousPrioritizeBookmarks isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousPrioritizeBookmarks boolValue] forKey:PRIORITIZE_BOOKMARKS];
    }

    if ([previousUseNormalFonts isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousUseNormalFonts boolValue] forKey:USE_NORMAL_FONTS];
    }

    if ([previousDvdMoviesHideDVDs isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousDvdMoviesHideDVDs boolValue] forKey:DVD_MOVIES_HIDE_DVDS];
    }

    if ([previousDvdMoviesHideBluray isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousDvdMoviesHideBluray boolValue] forKey:DVD_MOVIES_HIDE_BLURAY];
    }
    
    if ([previousBookmarkedMovies isKindOfClass:[NSArray class]]) {
        NSArray* bookmarkedMovies = [self restoreMoviesArray:previousBookmarkedMovies];
        [NowPlayingModel saveBookmarkedMovies:bookmarkedMovies];
    }
    
    if ([previousBookmarkedUpcomingMovies isKindOfClass:[NSArray class]]) {
        NSArray* bookmarkedUpcomingMovies = [self restoreMoviesArray:previousBookmarkedUpcomingMovies];
        [NowPlayingModel saveBookmarkedUpcomingMovies:bookmarkedUpcomingMovies];
    }
    
    if ([previousBookmarkedDVDMovies isKindOfClass:[NSArray class]]) {
        NSArray* bookmarkedDVDMovies = [self restoreMoviesArray:previousBookmarkedDVDMovies];
        [NowPlayingModel saveBookmarkedDVDMovies:bookmarkedDVDMovies];
    }

    if ([previousFavoriteTheaters isKindOfClass:[NSArray class]]) {
        NSMutableArray* favoriteTheaters = [NSMutableArray array];

        for (id previousTheater in previousFavoriteTheaters) {
            if (![previousTheater isKindOfClass:[NSDictionary class]]) {
                continue;
            }

            if (![FavoriteTheater canReadDictionary:previousTheater]) {
                continue;
            }

            FavoriteTheater* theater = [FavoriteTheater theaterWithDictionary:previousTheater];
            [favoriteTheaters addObject:theater];
        }

        [NowPlayingModel saveFavoriteTheaters:favoriteTheaters];
    }
}


- (void) loadData {
    self.dataProvider = [GoogleDataProvider providerWithModel:self];

    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION];
    if (version == nil || ![persistenceVersion isEqual:version]) {
        id previousUserAddress = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ADDRESS];
        id previousSearchRadius = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_RADIUS];
        id previousAutoUpdateLocation = [[NSUserDefaults standardUserDefaults] objectForKey:AUTO_UPDATE_LOCATION];
        id previousPrioritizeBookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:PRIORITIZE_BOOKMARKS]; 
        id previousUseNormalFonts = [[NSUserDefaults standardUserDefaults] objectForKey:USE_NORMAL_FONTS];
        id previousBookmarkedMovies = [[NSUserDefaults standardUserDefaults] objectForKey:BOOKMARKED_MOVIES];
        id previousBookmarkedUpcomingMovies = [[NSUserDefaults standardUserDefaults] objectForKey:BOOKMARKED_UPCOMING_MOVIES];
        id previousBookmarkedDVDMovies = [[NSUserDefaults standardUserDefaults] objectForKey:BOOKMARKED_DVD_MOVIES];
        id previousFavoriteTheaters = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_THEATERS];
        id previousDvdMoviesHideDVDs = [[NSUserDefaults standardUserDefaults] objectForKey:DVD_MOVIES_HIDE_DVDS];
        id previousDvdMoviesHideBluray = [[NSUserDefaults standardUserDefaults] objectForKey:DVD_MOVIES_HIDE_BLURAY];

        for (int i = 0; i < ArrayLength(KEYS); i++) {
            NSString** key = KEYS[i];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:*key];
        }

        [Application resetDirectories];

        [self restorePreviousUserAddress:previousUserAddress
                            searchRadius:previousSearchRadius
                      autoUpdateLocation:previousAutoUpdateLocation
                     prioritizeBookmarks:previousPrioritizeBookmarks
                          useNormalFonts:previousUseNormalFonts
                        bookmarkedMovies:previousBookmarkedMovies
                bookmarkedUpcomingMovies:previousBookmarkedUpcomingMovies
                     bookmarkedDVDMovies:previousBookmarkedDVDMovies
                        favoriteTheaters:previousFavoriteTheaters
                       dvdMoviesHideDVDs:previousDvdMoviesHideDVDs
                     dvdMoviesHideBluray:previousDvdMoviesHideBluray];

        [[NSUserDefaults standardUserDefaults] setObject:persistenceVersion forKey:VERSION];
    }
}


- (void) synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) clearCaches {
    NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:RUN_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:(runCount + 1) forKey:RUN_COUNT];
    [self synchronize];

    if (runCount % 20 == 0) {
        [userLocationCache clearStaleData];
        [largePosterCache clearStaleData];
        [imdbCache clearStaleData];
        [trailerCache clearStaleData];
        [blurayCache clearStaleData];
        [dvdCache clearStaleData];
        [posterCache clearStaleData];
        [scoreCache clearStaleData];
        [upcomingCache clearStaleData];
    }
}


- (void) checkCountry {
    if ([LocaleUtilities isSupportedCountry]) {
        return;
    }
    
    // Only warn once per upgrade.
    NSString* key = [NSString stringWithFormat:@"%@-%@-%@", UNSUPPORTED_COUNTRY, currentVersion, [LocaleUtilities isoCountry]]; 
    if ([[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    
    NSString* warning =
    [NSString stringWithFormat:
    NSLocalizedString(@"Your %@'s country is set to: %@\n\nFull support for Now Playing is coming soon to your country, and several features are already available for you to use today! When more features become ready, you will automatically be notified of updates.", nil),
     [UIDevice currentDevice].localizedModel,
     [LocaleUtilities displayCountry]];
    
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                     message:warning
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil] autorelease];
    
    [alert show];
}


- (id) init {
    if (self = [super init]) {
        [self checkCountry];
        [self loadData];

        self.userLocationCache = [UserLocationCache cache];
        self.largePosterCache = [LargePosterCache cacheWithModel:self];
        self.imdbCache = [IMDbCache cacheWithModel:self];
        self.trailerCache = [TrailerCache cacheWithModel:self];
        self.blurayCache = [BlurayCache cacheWithModel:self];
        self.dvdCache = [DVDCache cacheWithModel:self];
        self.posterCache = [PosterCache cacheWithModel:self];
        self.scoreCache = [ScoreCache cacheWithModel:self];
        self.upcomingCache = [UpcomingCache cacheWithModel:self];

        [self clearCaches];

        searchRadius = -1;
        cachedScoreProviderIndex = -1;
    }

    return self;
}


- (void) updateCaches:(NSNumber*) number {
    int value = number.intValue;

    SEL selectors[] = {
        @selector(updateScoreCache),
        @selector(updatePosterCache),
        @selector(updateTrailerCache),
        @selector(updateIMDbCache),
        @selector(updateUpcomingCache),
        @selector(updateDVDCache),
    };

    if (value >= ArrayLength(selectors)) {
        return;
    }

    [self performSelector:selectors[value]];
    [self performSelector:@selector(updateCaches:)
               withObject:[NSNumber numberWithInt:value + 1]
               afterDelay:1];
}


- (void) update {
    [self updateCaches:[NSNumber numberWithInt:0]];
}


+ (NowPlayingModel*) model {
    return [[[NowPlayingModel alloc] init] autorelease];
}


- (id<DataProvider>) dataProvider {
    return dataProvider;
}


- (NSInteger) scoreProviderIndexWorker {
    NSNumber* result = [[NSUserDefaults standardUserDefaults] objectForKey:RATINGS_PROVIDER_INDEX];
    if (result != nil) {
        return [result intValue];
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
    if (cachedScoreProviderIndex == -1) {
        cachedScoreProviderIndex = [self scoreProviderIndexWorker];
    }

    return cachedScoreProviderIndex;
}


- (void) setScoreProviderIndex:(NSInteger) index {
    cachedScoreProviderIndex = index;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:RATINGS_PROVIDER_INDEX];
    [self updateScoreCache];

    if (self.noScores && self.allMoviesSortingByScore) {
        [self setAllMoviesSelectedSegmentIndex:0];
    }
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


- (NSArray*) scoreProvider {
    return [NSArray arrayWithObjects:
            @"RottenTomatoes",
            @"Metacritic",
            @"Google",
            NSLocalizedString(@"None", @"This is what a user picks when they don't want any reviews."), nil];
}


- (NSString*) currentScoreProvider {
    return [self.scoreProvider objectAtIndex:self.scoreProviderIndex];
}


- (NSInteger) selectedTabBarViewControllerIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX];
}


- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX];
}


- (NSInteger) allMoviesSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:ALL_MOVIES_SELECTED_SEGMENT_INDEX];
}


- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index {
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


- (BOOL) allMoviesSortingByReleaseDate {
    return self.allMoviesSelectedSegmentIndex == 0;
}


- (BOOL) allMoviesSortingByTitle {
    return self.allMoviesSelectedSegmentIndex == 1;
}


- (BOOL) allMoviesSortingByScore {
    return self.allMoviesSelectedSegmentIndex == 2;
}


- (BOOL) upcomingMoviesSortingByReleaseDate {
    return self.upcomingMoviesSelectedSegmentIndex == 0;
}


- (BOOL) upcomingMoviesSortingByTitle {
    return self.upcomingMoviesSelectedSegmentIndex == 1;
}


- (BOOL) dvdMoviesSortingByReleaseDate {
    return self.dvdMoviesSelectedSegmentIndex == 0;
}


- (BOOL) dvdMoviesSortingByTitle {
    return self.dvdMoviesSelectedSegmentIndex == 1;
}


- (BOOL) prioritizeBookmarks {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PRIORITIZE_BOOKMARKS];
}


- (void) setPrioritizeBookmarks:(BOOL) value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:PRIORITIZE_BOOKMARKS];
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


- (int) searchRadius {
    if (searchRadius == -1) {
        searchRadius = [[NSUserDefaults standardUserDefaults] integerForKey:SEARCH_RADIUS];
        if (searchRadius == 0) {
            searchRadius = 5;
        }

        searchRadius = MAX(MIN(searchRadius, 50), 1);
    }

    return searchRadius;
}


- (void) setSearchRadius:(NSInteger) radius {
    searchRadius = radius;
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:SEARCH_RADIUS];
}


- (NSDate*) searchDate {
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_DATE];
    if (date == nil || [date compare:[NSDate date]] == NSOrderedAscending) {
        return [DateUtilities today];
    }
    return date;
}


- (void) setSearchDate:(NSDate*) date {
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:SEARCH_DATE];
}


- (NSArray*) movies {
    return [dataProvider movies];
}


- (NSArray*) theaters {
    return [dataProvider theaters];
}


- (NSMutableDictionary*) loadMovies:(NSString*) key {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
    if (array.count == 0) {
        return [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (NSDictionary* dictionary in array) {
        Movie* movie = [Movie movieWithDictionary:dictionary];
        [result setObject:movie forKey:movie.canonicalTitle];
    }
    
    return result;
}


- (NSMutableDictionary*) loadBookmarkedMovies {
    return [self loadMovies:BOOKMARKED_MOVIES];
}


- (NSMutableDictionary*) loadBookmarkedUpcomingMovies {
    return [self loadMovies:BOOKMARKED_UPCOMING_MOVIES];
}


- (NSMutableDictionary*) loadBookmarkedDVDMovies {
    return [self loadMovies:BOOKMARKED_DVD_MOVIES];
}


- (void) ensureBookmarkedMovies {
    if (bookmarkedMoviesData == nil) {
        self.bookmarkedMoviesData = [self loadBookmarkedMovies];
    }
    if (bookmarkedUpcomingMoviesData == nil) {
        self.bookmarkedUpcomingMoviesData = [self loadBookmarkedUpcomingMovies];
    }
    if (bookmarkedDVDMoviesData == nil) {
        self.bookmarkedDVDMoviesData = [self loadBookmarkedDVDMovies];
    }
}


- (BOOL) isBookmarkedMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    return [bookmarkedMoviesData objectForKey:movie.canonicalTitle] != nil;
}


- (BOOL) isBookmarkedUpcomingMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    return [bookmarkedUpcomingMoviesData objectForKey:movie.canonicalTitle] != nil;
}


- (BOOL) isBookmarkedDVDMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    return [bookmarkedDVDMoviesData objectForKey:movie.canonicalTitle] != nil;
}


- (NSSet*) allBookmarkedMovies {
    NSMutableSet* set = [NSMutableSet set];
    
    [set addObjectsFromArray:self.bookmarkedMovies];
    [set addObjectsFromArray:self.bookmarkedUpcomingMovies];
    [set addObjectsFromArray:self.bookmarkedDVDMovies];
    
    return set;
}


- (NSArray*) bookmarkedMovies {
    [self ensureBookmarkedMovies];
    return bookmarkedMoviesData.allValues;
}


- (NSArray*) bookmarkedUpcomingMovies {
    [self ensureBookmarkedMovies];
    return bookmarkedUpcomingMoviesData.allValues;
}


- (NSArray*) bookmarkedDVDMovies {
    [self ensureBookmarkedMovies];
    return bookmarkedDVDMoviesData.allValues;
}


- (void) addBookmarkedMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    [bookmarkedMoviesData setObject:movie forKey:movie.canonicalTitle];    
    [NowPlayingModel saveBookmarkedMovies:self.bookmarkedMovies];
}


- (void) addBookmarkedUpcomingMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    [bookmarkedUpcomingMoviesData setObject:movie forKey:movie.canonicalTitle];    
    [NowPlayingModel saveBookmarkedUpcomingMovies:self.bookmarkedUpcomingMovies];
}


- (void) addBookmarkedDVDMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    [bookmarkedDVDMoviesData setObject:movie forKey:movie.canonicalTitle];    
    [NowPlayingModel saveBookmarkedDVDMovies:self.bookmarkedDVDMovies];
}


- (void) removeBookmarkedMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    [bookmarkedMoviesData removeObjectForKey:movie.canonicalTitle];
    [NowPlayingModel saveBookmarkedMovies:self.bookmarkedMovies];
}


- (void) removeBookmarkedUpcomingMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    [bookmarkedUpcomingMoviesData removeObjectForKey:movie.canonicalTitle];
    [NowPlayingModel saveBookmarkedUpcomingMovies:self.bookmarkedUpcomingMovies];
}


- (void) removeBookmarkedDVDMovie:(Movie*) movie {
    [self ensureBookmarkedMovies];
    [bookmarkedDVDMoviesData removeObjectForKey:movie.canonicalTitle];
    [NowPlayingModel saveBookmarkedDVDMovies:self.bookmarkedDVDMovies];
}


- (NSMutableDictionary*) loadFavoriteTheaters {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITE_THEATERS];
    if (array.count == 0) {
        return [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (NSDictionary* dictionary in array) {
        FavoriteTheater* theater = [FavoriteTheater theaterWithDictionary:dictionary];
        [result setObject:theater forKey:theater.name];
    }
    
    return result;
}


- (void) ensureFavoriteTheaters {
    if (favoriteTheatersData == nil) {
        self.favoriteTheatersData = [self loadFavoriteTheaters];
    }
}


- (NSArray*) favoriteTheaters {
    [self ensureFavoriteTheaters];
    return favoriteTheatersData.allValues;
}


- (void) saveFavoriteTheaters {
    [NowPlayingModel saveFavoriteTheaters:self.favoriteTheaters];
}


- (void) addFavoriteTheater:(Theater*) theater {
    [self ensureFavoriteTheaters];
    
    FavoriteTheater* favoriteTheater = [FavoriteTheater theaterWithName:theater.name
                                                    originatingLocation:theater.originatingLocation];
    [favoriteTheatersData setObject:favoriteTheater forKey:theater.name];
    [self saveFavoriteTheaters];
}


- (BOOL) isFavoriteTheater:(Theater*) theater {
    [self ensureFavoriteTheaters];
    
    return [favoriteTheatersData objectForKey:theater.name] != nil;
}


- (void) removeFavoriteTheater:(Theater*) theater {
    [self ensureFavoriteTheaters];
    
    [favoriteTheatersData removeObjectForKey:theater.name];
    [self saveFavoriteTheaters];
}


- (NSDate*) releaseDateForMovie:(Movie*) movie {
    if (movie.releaseDate != nil) {
        return movie.releaseDate;
    }

    return [upcomingCache releaseDateForMovie:movie];
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    if (movie.directors.count > 0) {
        return movie.directors;
    }

    return [upcomingCache directorsForMovie:movie];
}


- (NSArray*) castForMovie:(Movie*) movie {
    if (movie.cast.count > 0) {
        return movie.cast;
    }

    return [upcomingCache castForMovie:movie];
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

    result = [imdbCache imdbAddressForMovie:movie];
    if (result.length > 0) {
        return result;
    }

    result = [upcomingCache imdbAddressForMovie:movie];
    if (result.length > 0) {
        return result;
    }

    result = [dvdCache imdbAddressForMovie:movie];
    if (result.length > 0) {
        return result;
    }

    result = [blurayCache imdbAddressForMovie:movie];
    if (result.length > 0) {
        return result;
    }
    
    return nil;
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


- (UIImage*) posterForMovie:(Movie*) movie {
    return [self posterForMovie:movie
                        sources:[NSArray arrayWithObjects:posterCache, upcomingCache, dvdCache, blurayCache, largePosterCache, nil]
                       selector:@selector(posterForMovie:)];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    return [self posterForMovie:movie
                        sources:[NSArray arrayWithObjects:posterCache, upcomingCache, dvdCache, blurayCache, largePosterCache, nil]
                       selector:@selector(smallPosterForMovie:)];
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


- (BOOL) isStaleWorker:(Theater*) theater {
    return [dataProvider isStale:theater];
}


- (BOOL) isStale:(Theater*) theater {
    NSNumber* stale = theater.isStale;
    if (stale == nil) {
        stale = [NSNumber numberWithBool:[self isStaleWorker:theater]];
        theater.isStale = stale;
    }
    
    return [stale boolValue];
}


- (NSString*) showtimesRetrievedOnString:(Theater*) theater {
    if ([self isStale:theater]) {
        // we're showing out of date information
        NSDate* theaterSyncDate = [self synchronizationDateForTheater:theater];
        return [NSString stringWithFormat:
                NSLocalizedString(@"Theater last reported show times on\n%@.", nil),
                [DateUtilities formatLongDate:theaterSyncDate]];
    } else {
        NSDate* globalSyncDate = [dataProvider lastLookupDate];
        if (globalSyncDate == nil) {
            return @"";
        }

        return [NSString stringWithFormat:
                NSLocalizedString(@"Show times retrieved on %@.", nil),
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


NSInteger compareMoviesByScore(id t1, id t2, void *context) {
    if (t1 == t2) {
        return NSOrderedSame;
    }

    Movie* movie1 = t1;
    Movie* movie2 = t2;
    NowPlayingModel* model = context;

    int movieRating1 = [model scoreValueForMovie:movie1];
    int movieRating2 = [model scoreValueForMovie:movie2];

    if (movieRating1 < movieRating2) {
        return NSOrderedDescending;
    } else if (movieRating1 > movieRating2) {
        return NSOrderedAscending;
    }

    return compareMoviesByTitle(t1, t2, context);
}


NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void *context) {
    if (t1 == t2) {
        return NSOrderedSame;
    }

    NowPlayingModel* model = context;
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


NSInteger compareMoviesByReleaseDateAscending(id t1, id t2, void *context) {
    return -compareMoviesByReleaseDateDescending(t1, t2, context);
}


NSInteger compareMoviesByTitle(id t1, id t2, void *context) {
    if (t1 == t2) {
        return NSOrderedSame;
    }

    NowPlayingModel* model = context;
    
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    
    BOOL movie1Bookmarked = [model isBookmarkedMovie:movie1];
    BOOL movie2Bookmarked = [model isBookmarkedMovie:movie2];
    
    if (movie1Bookmarked && !movie2Bookmarked) {
        return NSOrderedAscending;
    } else if (movie2Bookmarked && !movie1Bookmarked) {
        return NSOrderedDescending;
    }

    return [movie1.displayTitle compare:movie2.displayTitle options:NSCaseInsensitiveSearch];
}


NSInteger compareTheatersByName(id t1, id t2, void *context) {
    if (t1 == t2) {
        return NSOrderedSame;
    }

    Theater* theater1 = t1;
    Theater* theater2 = t2;

    return [theater1.name compare:theater2.name options:NSCaseInsensitiveSearch];
}


NSInteger compareTheatersByDistance(id t1, id t2, void *context) {
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
    return [scoreCache scoreForMovie:movie inMovies:self.movies];
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

    if (options.count == 0 || [LocaleUtilities isEnglish]) {
        synopsis = [self scoreForMovie:movie].synopsis;
        if (synopsis.length > 0) {
            [options addObject:synopsis];
        }

        synopsis = [upcomingCache synopsisForMovie:movie];
        if (synopsis.length > 0) {
            [options addObject:synopsis];
        }
    }

    if (options.count == 0) {
        return NSLocalizedString(@"No synopsis available.", nil);
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
    NSArray* result = [trailerCache trailersForMovie:movie];
    if (result.count > 0) {
        return result;
    }

    return [upcomingCache trailersForMovie:movie];
}


- (NSArray*) reviewsForMovie:(Movie*) movie {
    return [scoreCache reviewsForMovie:movie inMovies:self.movies];
}


- (NSString*) noInformationFound {
    if (self.userAddress.length == 0) {
        return NSLocalizedString(@"Please enter your location", nil);
    } else if ([GlobalActivityIndicator hasVisibleBackgroundTasks]) {
        return NSLocalizedString(@"Downloading data", nil);
    } else if (![NetworkUtilities isNetworkAvailable]) {
        return NSLocalizedString(@"Network unavailable", nil);
    } else if (![LocaleUtilities isSupportedCountry]) {
        return [NSString stringWithFormat:
                NSLocalizedString(@"Local results unavailable", nil),
                [LocaleUtilities displayCountry]];
    } else {
        return NSLocalizedString(@"No information found", nil);
    }
}


- (BOOL) useSmallFonts {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:USE_NORMAL_FONTS];
}


- (void) setUseSmallFonts:(BOOL) useSmallFonts {
    [[NSUserDefaults standardUserDefaults] setBool:!useSmallFonts forKey:USE_NORMAL_FONTS];
}


- (void) saveNavigationStack:(AbstractNavigationController*) controller {
    NSMutableArray* types = [NSMutableArray array];
    NSMutableArray* values = [NSMutableArray array];

    for (id viewController in controller.viewControllers) {
        NSInteger type;
        id value;
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
            NSAssert(false, @"");
        }

        [types addObject:[NSNumber numberWithInt:type]];
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


- (void) prioritizeMovie:(Movie*) movie {
    [posterCache prioritizeMovie:movie];
    [scoreCache prioritizeMovie:movie inMovies:self.movies];
    [trailerCache prioritizeMovie:movie];
    [imdbCache prioritizeMovie:movie];
    [upcomingCache prioritizeMovie:movie];
    [dvdCache prioritizeMovie:movie];
    [blurayCache prioritizeMovie:movie];
}


- (NSString*) feedbackUrl {
    NSString* body = [NSString stringWithFormat:@"\n\nVersion: %@\nLocation: %@\nSearch Distance: %d\nSearch Date: %@\nReviews: %@\nAuto-Update Location: %@\nPrioritize Bookmarks: %@\nCountry: %@\nLanguage: %@",
                      currentVersion,
                      self.userAddress,
                      self.searchRadius,
                      [DateUtilities formatShortDate:self.searchDate],
                      self.currentScoreProvider,
                      (self.autoUpdateLocation ? @"yes" : @"no"),
                      (self.prioritizeBookmarks ? @"yes" : @"no"),
                      [LocaleUtilities englishCountry],
                      [LocaleUtilities englishLanguage]];

    NSString* subject;
    if ([LocaleUtilities isJapanese]) {
        subject = [Utilities stringByAddingPercentEscapes:@"Now Playingのフィードバック"];
    } else {
        subject = @"Now%20Playing%20Feedback";
    }

    NSString* encodedBody = [Utilities stringByAddingPercentEscapes:body];
    NSString* result = [NSString stringWithFormat:@"mailto:cyrus.najmabadi@gmail.com?subject=%@&body=%@", subject, encodedBody];
    return result;
}

@end