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

#import "MetaFlixModel.h"

#import "AbstractNavigationController.h"
#import "AlertUtilities.h"
#import "AmazonCache.h"
#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "FavoriteTheater.h"
#import "FileUtilities.h"
#import "GlobalActivityIndicator.h"
#import "IMDbCache.h"
#import "LargePosterCache.h"
#import "LocaleUtilities.h"
#import "Location.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "MutableNetflixCache.h"
#import "NetflixViewController.h"
#import "NetworkUtilities.h"
#import "MetaFlixAppDelegate.h"
#import "PosterCache.h"
#import "TrailerCache.h"
#import "UserLocationCache.h"
#import "Utilities.h"
#import "WikipediaCache.h"

@interface MetaFlixModel()
@property (retain) UserLocationCache* userLocationCache;
@property (retain) IMDbCache* imdbCache;
@property (retain) AmazonCache* amazonCache;
@property (retain) WikipediaCache* wikipediaCache;
@property (retain) PosterCache* posterCache;
@property (retain) LargePosterCache* largePosterCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) MutableNetflixCache* netflixCache;
@property (retain) NSMutableSet* bookmarkedTitlesData;
@end

@implementation MetaFlixModel

static NSString* currentVersion = @"1.0.0";
static NSString* persistenceVersion = @"101";

static NSString* VERSION = @"version";

static NSString* ALL_MOVIES_SELECTED_SEGMENT_INDEX      = @"allMoviesSelectedSegmentIndex";
static NSString* ALL_THEATERS_SELECTED_SEGMENT_INDEX    = @"allTheatersSelectedSegmentIndex";
static NSString* AUTO_UPDATE_LOCATION                   = @"autoUpdateLocation";
static NSString* BOOKMARKED_TITLES                      = @"bookmarkedTitles";
static NSString* BOOKMARKED_MOVIES                      = @"bookmarkedMovies";
static NSString* BOOKMARKED_UPCOMING                    = @"bookmarkedUpcoming";
static NSString* BOOKMARKED_DVD                         = @"bookmarkedDVD";
static NSString* BOOKMARKED_BLURAY                      = @"bookmarkedBluray";
static NSString* DVD_MOVIES_SELECTED_SEGMENT_INDEX      = @"dvdMoviesSelectedSegmentIndex";
static NSString* DVD_MOVIES_HIDE_DVDS                   = @"dvdMoviesHideDVDs";
static NSString* DVD_MOVIES_HIDE_BLURAY                 = @"dvdMoviesHideBluray";
static NSString* UPCOMING_AND_DVD_HIDE_UPCOMING         = @"upcomingAndDvdMoviesHideUpcoming";
static NSString* FAVORITE_THEATERS                      = @"favoriteTheaters";
static NSString* NAVIGATION_STACK_TYPES                 = @"navigationStackTypes";
static NSString* NAVIGATION_STACK_VALUES                = @"navigationStackValues";
static NSString* PRIORITIZE_BOOKMARKS                   = @"prioritizeBookmarks";
static NSString* SCORE_PROVIDER_INDEX                   = @"scoreProviderIndex";
static NSString* SEARCH_DATE                            = @"searchDate";
static NSString* SEARCH_RADIUS                          = @"searchRadius";
static NSString* SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX = @"selectedTabBarViewControllerIndex";
static NSString* UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX = @"upcomingMoviesSelectedSegmentIndex";
static NSString* USER_ADDRESS                           = @"userLocation";
static NSString* USE_NORMAL_FONTS                       = @"useNormalFonts";
static NSString* RUN_COUNT                              = @"runCount";
static NSString* UNSUPPORTED_COUNTRY                    = @"unsupportedCountry";
static NSString* NETFLIX_ENABLED                        = @"netflixEnabled";
static NSString* NETFLIX_KEY                            = @"netflixKey";
static NSString* NETFLIX_SECRET                         = @"netflixSecret";
static NSString* NETFLIX_USER_ID                        = @"netflixUserId";


static NSString** ALL_KEYS[] = {
&VERSION,
&ALL_MOVIES_SELECTED_SEGMENT_INDEX,
&ALL_THEATERS_SELECTED_SEGMENT_INDEX,
&AUTO_UPDATE_LOCATION,
&BOOKMARKED_TITLES,
&BOOKMARKED_MOVIES,
&BOOKMARKED_UPCOMING,
&BOOKMARKED_DVD,
&BOOKMARKED_BLURAY,
&DVD_MOVIES_SELECTED_SEGMENT_INDEX,
&DVD_MOVIES_HIDE_DVDS,
&DVD_MOVIES_HIDE_BLURAY,
&UPCOMING_AND_DVD_HIDE_UPCOMING,
&FAVORITE_THEATERS,
&NAVIGATION_STACK_TYPES,
&NAVIGATION_STACK_VALUES,
&PRIORITIZE_BOOKMARKS,
&SCORE_PROVIDER_INDEX,
&SEARCH_DATE,
&SEARCH_RADIUS,
&SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX,
&UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX,
&USER_ADDRESS,
&USE_NORMAL_FONTS,
&RUN_COUNT,
&NETFLIX_ENABLED,
&NETFLIX_KEY,
&NETFLIX_SECRET,
&NETFLIX_USER_ID
};


static NSString** STRING_KEYS_TO_MIGRATE[] = {
&USER_ADDRESS,
&NETFLIX_KEY,
&NETFLIX_SECRET,
&NETFLIX_USER_ID,
};

static NSString** INTEGER_KEYS_TO_MIGRATE[] = {
&ALL_MOVIES_SELECTED_SEGMENT_INDEX,
&ALL_THEATERS_SELECTED_SEGMENT_INDEX,
&DVD_MOVIES_SELECTED_SEGMENT_INDEX,
&SCORE_PROVIDER_INDEX,
&SEARCH_RADIUS,
&SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX,
&UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX
};

static NSString** BOOLEAN_KEYS_TO_MIGRATE[] = {
&AUTO_UPDATE_LOCATION,
&DVD_MOVIES_HIDE_DVDS,
&DVD_MOVIES_HIDE_BLURAY,
&UPCOMING_AND_DVD_HIDE_UPCOMING,
&PRIORITIZE_BOOKMARKS,
&USE_NORMAL_FONTS,
&NETFLIX_ENABLED
};

static NSString** STRING_ARRAY_KEYS_TO_MIGRATE[] = {
&BOOKMARKED_TITLES
};

static NSString** MOVIE_ARRAY_KEYS_TO_MIGRATE[] = {
&BOOKMARKED_MOVIES,
&BOOKMARKED_UPCOMING,
&BOOKMARKED_DVD,
&BOOKMARKED_BLURAY
};


@synthesize bookmarkedTitlesData;

@synthesize userLocationCache;
@synthesize imdbCache;
@synthesize amazonCache;
@synthesize wikipediaCache;
@synthesize posterCache;
@synthesize largePosterCache;
@synthesize trailerCache;
@synthesize netflixCache;

- (void) dealloc {
    self.bookmarkedTitlesData = nil;

    self.userLocationCache = nil;
    self.imdbCache = nil;
    self.amazonCache = nil;
    self.wikipediaCache = nil;
    self.posterCache = nil;
    self.largePosterCache = nil;
    self.trailerCache = nil;
    self.netflixCache = nil;

    [super dealloc];
}


+ (NSString*) version {
    return currentVersion;
}

+ (void) saveFavoriteTheaters:(NSArray*) favoriteTheaters {
    NSMutableArray* result = [NSMutableArray array];
    for (FavoriteTheater* theater in favoriteTheaters) {
        [result addObject:theater.dictionary];
    }

    [[NSUserDefaults standardUserDefaults] setObject:result forKey:FAVORITE_THEATERS];
}


+ (void) saveBookmarkedTitles:(NSSet*) bookmarkedTitles {
    [[NSUserDefaults standardUserDefaults] setObject:bookmarkedTitles.allObjects forKey:BOOKMARKED_TITLES];
}


+ (void) saveMovies:(NSArray*) movies key:(NSString*) key {
    NSMutableArray* encoded = [NSMutableArray array];
    for (Movie* movie in movies) {
        [encoded addObject:movie.dictionary];
    }

    [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:key];
}


- (NSDictionary*) valuesToMigrate {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    for (NSInteger i = 0; i < ArrayLength(STRING_KEYS_TO_MIGRATE); i++) {
        NSString* key = *STRING_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSString class]]) {
            [result setObject:previousValue forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(BOOLEAN_KEYS_TO_MIGRATE); i++) {
        NSString* key = *BOOLEAN_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSNumber class]]) {
            [result setObject:previousValue forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(INTEGER_KEYS_TO_MIGRATE); i++) {
        NSString* key = *INTEGER_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSNumber class]]) {
            [result setObject:previousValue forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(STRING_ARRAY_KEYS_TO_MIGRATE); i++) {
        NSString* key = *STRING_ARRAY_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSArray class]]) {
            NSMutableArray* elements = [NSMutableArray array];
            for (id element in previousValue) {
                if ([element isKindOfClass:[NSString class]]) {
                    [elements addObject:element];
                }
            }

            [result setObject:elements forKey:key];
        }
    }

    for (NSInteger i = 0; i < ArrayLength(MOVIE_ARRAY_KEYS_TO_MIGRATE); i++) {
        NSString* key = *MOVIE_ARRAY_KEYS_TO_MIGRATE[i];
        id previousValue = [defaults objectForKey:key];
        if ([previousValue isKindOfClass:[NSArray class]]) {
            NSMutableArray* elements = [NSMutableArray array];
            for (id element in previousValue) {
                if ([element isKindOfClass:[NSDictionary class]] &&
                    [Movie canReadDictionary:element]) {
                    [elements addObject:element];
                }
            }

            [result setObject:elements forKey:key];
        }
    }

    {
        id previousValue = [defaults objectForKey:FAVORITE_THEATERS];
        if ([previousValue isKindOfClass:[NSArray class]]) {
            NSMutableArray* elements = [NSMutableArray array];

            for (id element in previousValue) {
                if ([element isKindOfClass:[NSDictionary class]] &&
                    [FavoriteTheater canReadDictionary:element]) {
                    [elements addObject:element];
                }
            }

            [result setObject:elements forKey:FAVORITE_THEATERS];
        }
    }

    return result;
}


- (void) synchronize {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) loadData {
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION];
    if (version == nil || ![persistenceVersion isEqual:version]) {
        // First, capture any preferences that we can safely migrate
        NSDictionary* currentValues = [self valuesToMigrate];

        // Now, wipe out all keys
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        for (int i = 0; i < ArrayLength(ALL_KEYS); i++) {
            NSString* key = *ALL_KEYS[i];
            [defaults removeObjectForKey:key];
        }

        // And delete and stored state
        [Application resetDirectories];

        // Now restore the saved preferences.
        for (NSString* key in currentValues) {
            [defaults setObject:[currentValues objectForKey:key] forKey:key];
        }

        // Mark that we updated successfully, and flush to disc.
        [[NSUserDefaults standardUserDefaults] setObject:persistenceVersion forKey:VERSION];
        [self synchronize];
    }
}


- (void) clearCaches {
    NSInteger runCount = [[NSUserDefaults standardUserDefaults] integerForKey:RUN_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:(runCount + 1) forKey:RUN_COUNT];
    [self synchronize];

    if ((runCount % 5) == 0) {
        [Application clearStaleData];
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
    NSLocalizedString(@"Your %@'s country is set to: %@\n\nFull support for MetaFlix is coming soon to your country, and several features are already available for you to use today! When more features become ready, you will automatically be notified of updates.", nil),
     [UIDevice currentDevice].localizedModel,
     [LocaleUtilities displayCountry]];

    [AlertUtilities showOkAlert:warning];
}


- (id) init {
    if (self = [super init]) {
        [self checkCountry];
        [self loadData];

        self.userLocationCache = [UserLocationCache cache];
        self.largePosterCache = [LargePosterCache cacheWithModel:self];
        self.imdbCache = [IMDbCache cacheWithModel:self];
        self.amazonCache = [AmazonCache cacheWithModel:self];
        self.wikipediaCache = [WikipediaCache cacheWithModel:self];
        self.trailerCache = [TrailerCache cacheWithModel:self];
        self.posterCache = [PosterCache cacheWithModel:self];
        self.netflixCache = [MutableNetflixCache cacheWithModel:self];

        [self clearCaches];
    }

    return self;
}


+ (MetaFlixModel*) model {
    return [[[MetaFlixModel alloc] init] autorelease];
}


- (BOOL) netflixEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:NETFLIX_ENABLED];
}


- (void) setNetflixEnabled:(BOOL) value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:NETFLIX_ENABLED];

    if (!value) {
        [self setNetflixKey:nil secret:nil userId:nil];
    }
}


- (NSString*) netflixKey {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_KEY];
}


- (NSString*) netflixSecret {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_SECRET];
}


-(NSString*) netflixUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_USER_ID];
}


- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId {
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:NETFLIX_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:secret forKey:NETFLIX_SECRET];
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:NETFLIX_KEY];
}


- (NSArray*) scoreProvider {
    return [NSArray arrayWithObjects:
            @"RottenTomatoes",
            @"Metacritic",
            @"Google",
            NSLocalizedString(@"None", @"This is what a user picks when they don't want any reviews."), nil];
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


- (NSMutableSet*) loadBookmarkedTitles {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:BOOKMARKED_TITLES];
    if (array.count == 0) {
        return [NSMutableSet set];
    }

    return [NSMutableSet setWithArray:array];
}

- (void) ensureBookmarkedTitles {
    if (bookmarkedTitlesData == nil) {
        self.bookmarkedTitlesData = [self loadBookmarkedTitles];
    }
}


- (BOOL) isBookmarked:(Movie*) movie {
    [self ensureBookmarkedTitles];
    return [bookmarkedTitlesData containsObject:movie.canonicalTitle];
}


- (NSSet*) bookmarkedTitles {
    [self ensureBookmarkedTitles];
    return bookmarkedTitlesData;
}


- (void) addBookmark:(Movie*) movie {
    [self ensureBookmarkedTitles];
    [bookmarkedTitlesData addObject:movie.canonicalTitle];
    [MetaFlixModel saveBookmarkedTitles:bookmarkedTitlesData];
}


- (void) removeBookmark:(Movie*) movie {
    [self ensureBookmarkedTitles];
    [bookmarkedTitlesData removeObject:movie.canonicalTitle];
    [MetaFlixModel saveBookmarkedTitles:bookmarkedTitlesData];
}


- (NSArray*) bookmarkedItems:(NSString*) key {
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (array.count == 0) {
        return [NSArray array];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Movie movieWithDictionary:dictionary]];
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
    [MetaFlixModel saveMovies:array key:BOOKMARKED_MOVIES];
}


- (void) setBookmarkedUpcoming:(NSArray*) array {
    [MetaFlixModel saveMovies:array key:BOOKMARKED_UPCOMING];
}


- (void) setBookmarkedDVD:(NSArray*) array {
    [MetaFlixModel saveMovies:array key:BOOKMARKED_DVD];
}


- (void) setBookmarkedBluray:(NSArray*) array {
    [MetaFlixModel saveMovies:array key:BOOKMARKED_BLURAY];
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


- (NSDate*) releaseDateForMovie:(Movie*) movie {
    return movie.releaseDate;
}


- (NSArray*) directorsForMovie:(Movie*) movie {
    NSArray* directors = movie.directors;
    if (directors.count > 0) {
        return directors;
    }

    directors = [netflixCache directorsForMovie:movie];
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

    cast = [netflixCache castForMovie:movie];
    if (cast.count > 0) {
        return cast;
    }

    return [NSArray array];
}


- (NSArray*) genresForMovie:(Movie*) movie {
    return movie.genres;
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

    return nil;
}


- (NSString*) amazonAddressForMovie:(Movie*) movie {
    return [amazonCache amazonAddressForMovie:movie];
}


- (NSString*) wikipediaAddressForMovie:(Movie*) movie {
    return [wikipediaCache wikipediaAddressForMovie:movie];
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
                        sources:[NSArray arrayWithObjects:posterCache, netflixCache, largePosterCache, nil]
                       selector:@selector(posterForMovie:)];
}


- (UIImage*) smallPosterForMovie:(Movie*) movie {
    return [self posterForMovie:movie
                        sources:[NSArray arrayWithObjects:posterCache, netflixCache, largePosterCache, nil]
                       selector:@selector(smallPosterForMovie:)];
}


NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void* context) {
    if (t1 == t2) {
        return NSOrderedSame;
    }

    MetaFlixModel* model = context;
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

    MetaFlixModel* model = context;

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


- (void) setUserAddress:(NSString*) userAddress {
    [[NSUserDefaults standardUserDefaults] setObject:userAddress forKey:USER_ADDRESS];
    [self synchronize];
}

- (NSString*) synopsisForMovie:(Movie*) movie {
    NSMutableArray* options = [NSMutableArray array];
    NSString* synopsis = movie.synopsis;
    if (synopsis.length > 0) {
        [options addObject:synopsis];
    }

    if (options.count == 0 || [LocaleUtilities isEnglish]) {
        synopsis = [netflixCache synopsisForMovie:movie];
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
    return [trailerCache trailersForMovie:movie];
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


- (void) prioritizeMovie:(Movie*) movie {
    [posterCache prioritizeMovie:movie];
    [trailerCache prioritizeMovie:movie];
    [imdbCache prioritizeMovie:movie];
    [amazonCache prioritizeMovie:movie];
    [wikipediaCache prioritizeMovie:movie];
    [netflixCache prioritizeMovie:movie];
}


- (NSString*) feedbackUrl {
    NSString* body = [NSString stringWithFormat:@"\n\nVersion: %@\nCountry: %@\nLanguage: %@",
                      currentVersion,
                      [LocaleUtilities englishCountry],
                      [LocaleUtilities englishLanguage]];

    if (self.netflixEnabled) {
        body = [body stringByAppendingFormat:@"\n\nNetflix:\nUser ID: %@\nKey: %@\nSecret: %@", self.netflixUserId, self.netflixKey, self.netflixSecret];
    }

    NSString* subject;
    if ([LocaleUtilities isJapanese]) {
        subject = [Utilities stringByAddingPercentEscapes:@"MetaFlixのフィードバック"];
    } else {
        subject = @"Now%20Playing%20Feedback";
    }

    NSString* encodedBody = [Utilities stringByAddingPercentEscapes:body];
    NSString* result = [NSString stringWithFormat:@"mailto:cyrus.najmabadi@gmail.com?subject=%@&body=%@", subject, encodedBody];
    return result;
}

@end