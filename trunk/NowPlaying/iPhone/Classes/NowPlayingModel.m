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
#import "NumbersCache.h"
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
@property (retain) DVDCache* dvdCache;
@property (retain) IMDbCache* imdbCache;
@property (retain) PosterCache* posterCache;
@property (retain) LargePosterCache* largePosterCache;
@property (retain) ScoreCache* scoreCache;
@property (retain) TrailerCache* trailerCache;
@property (retain) UpcomingCache* upcomingCache;
@property (retain) NSMutableArray* favoriteTheatersData;
@property (retain) id<DataProvider> dataProvider;
@end

@implementation NowPlayingModel

static NSString* currentVersion = @"2.3.0";
static NSString* persistenceVersion = @"11";

static NSString* VERSION = @"version";

static NSString* ALL_MOVIES_SELECTED_SEGMENT_INDEX      = @"allMoviesSelectedSegmentIndex";
static NSString* ALL_THEATERS_SELECTED_SEGMENT_INDEX    = @"allTheatersSelectedSegmentIndex";
static NSString* AUTO_UPDATE_LOCATION                   = @"autoUpdateLocation";
static NSString* FAVORITE_THEATERS                      = @"favoriteTheaters";
static NSString* NAVIGATION_STACK_TYPES                 = @"navigationStackTypes";
static NSString* NAVIGATION_STACK_VALUES                = @"navigationStackValues";
static NSString* NUMBERS_SELECTED_SEGMENT_INDEX         = @"numbersSelectedSegmentIndex";
static NSString* RATINGS_PROVIDER_INDEX                 = @"scoreProviderIndex";
static NSString* SEARCH_DATE                            = @"searchDate";
static NSString* SEARCH_RADIUS                          = @"searchRadius";
static NSString* SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX = @"selectedTabBarViewControllerIndex";
static NSString* UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX = @"upcomingMoviesSelectedSegmentIndex";
static NSString* DVD_MOVIES_SELECTED_SEGMENT_INDEX      = @"dvdMoviesSelectedSegmentIndex";
static NSString* USER_ADDRESS                           = @"userLocation";
static NSString* USE_NORMAL_FONTS                       = @"useNormalFonts";


static NSString** KEYS[] = {
    &VERSION,
    &ALL_MOVIES_SELECTED_SEGMENT_INDEX,
    &ALL_THEATERS_SELECTED_SEGMENT_INDEX,
    &AUTO_UPDATE_LOCATION,
    &FAVORITE_THEATERS,
    &NAVIGATION_STACK_TYPES,
    &NAVIGATION_STACK_VALUES,
    &NUMBERS_SELECTED_SEGMENT_INDEX,
    &RATINGS_PROVIDER_INDEX,
    &SEARCH_DATE,
    &SEARCH_RADIUS,
    &SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX,
    &UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX,
    &USER_ADDRESS,
    &USE_NORMAL_FONTS,
};


@synthesize dataProvider;
@synthesize favoriteTheatersData;

@synthesize userLocationCache;
@synthesize dvdCache;
@synthesize imdbCache;
@synthesize posterCache;
@synthesize largePosterCache;
@synthesize scoreCache;
@synthesize trailerCache;
@synthesize upcomingCache;

- (void) dealloc {
    self.dataProvider = nil;
    self.favoriteTheatersData = nil;

    self.userLocationCache = nil;
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


- (void) updateUpcomingCache {
    [upcomingCache update];
}


- (void) updateLargePosterCache {
    [largePosterCache update];
}


+ (void) saveFavoriteTheaters:(NSArray*) favoriteTheaters {
    NSMutableArray* result = [NSMutableArray array];
    for (FavoriteTheater* theater in favoriteTheaters) {
        [result addObject:theater.dictionary];
    }

    [[NSUserDefaults standardUserDefaults] setObject:result forKey:FAVORITE_THEATERS];

}


- (void) restorePreviousUserAddress:(id) previousUserAddress
                       searchRadius:(id) previousSearchRadius
                 autoUpdateLocation:(id) previousAutoUpdateLocation
                     useNormalFonts:(id) previousUseNormalFonts
                   favoriteTheaters:(id) previousFavoriteTheaters {
    if ([previousUserAddress isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:previousUserAddress forKey:USER_ADDRESS];
    }

    if ([previousSearchRadius isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[previousSearchRadius intValue] forKey:SEARCH_RADIUS];
    }

    if ([previousAutoUpdateLocation isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousAutoUpdateLocation boolValue] forKey:AUTO_UPDATE_LOCATION];
    }

    if ([previousUseNormalFonts isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousUseNormalFonts boolValue] forKey:USE_NORMAL_FONTS];
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
        id previousUseNormalFonts = [[NSUserDefaults standardUserDefaults] objectForKey:USE_NORMAL_FONTS];
        id previousFavoriteTheaters = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_THEATERS];

        for (int i = 0; i < ArrayLength(KEYS); i++) {
            NSString** key = KEYS[i];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:*key];
        }

        [Application resetDirectories];


        [self restorePreviousUserAddress:previousUserAddress
                            searchRadius:previousSearchRadius
                      autoUpdateLocation:previousAutoUpdateLocation
                          useNormalFonts:previousUseNormalFonts
                        favoriteTheaters:previousFavoriteTheaters];

        [[NSUserDefaults standardUserDefaults] setObject:persistenceVersion forKey:VERSION];
    }
}


- (id) init {
    if (self = [super init]) {
        [self loadData];

        self.userLocationCache = [UserLocationCache cache];
        self.largePosterCache = [LargePosterCache cache];
        self.imdbCache = [IMDbCache cacheWithModel:self];
        self.trailerCache = [TrailerCache cacheWithModel:self];
        self.dvdCache = [DVDCache cacheWithModel:self];
        self.posterCache = [PosterCache cacheWithModel:self];
        self.scoreCache = [ScoreCache cacheWithModel:self];
        self.upcomingCache = [UpcomingCache cacheWithModel:self];

        searchRadius = -1;

        [self performSelector:@selector(update) withObject:nil afterDelay:2];
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
        @selector(updateLargePosterCache),
    };

    if (value >= ArrayLength(selectors)) {
        return;
    }

    [self performSelector:selectors[value]];
    [self performSelector:@selector(updateCaches:) withObject:[NSNumber numberWithInt:value + 1] afterDelay:1];
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


- (NSInteger) scoreProviderIndex {
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


- (void) setScoreProviderIndex:(NSInteger) index {
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


- (NSInteger) numbersSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:NUMBERS_SELECTED_SEGMENT_INDEX];
}


- (void) setNumbersSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:NUMBERS_SELECTED_SEGMENT_INDEX];
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


- (BOOL) numbersSortingByDailyGross {
    return self.numbersSelectedSegmentIndex == 0;
}


- (BOOL) numbersSortingByWeekendGross {
    return self.numbersSelectedSegmentIndex == 1;
}


- (BOOL) numbersSortingByTotalGross {
    return self.numbersSelectedSegmentIndex == 2;
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
        result =  @"";
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


- (void) markDataProviderOutOfDate {
    [dataProvider setStale];
}


- (void) setSearchDate:(NSDate*) date {
    [self markDataProviderOutOfDate];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:SEARCH_DATE];
}


- (NSArray*) movies {
    return [dataProvider movies];
}


- (NSArray*) theaters {
    return [dataProvider theaters];
}


- (void) onDataProviderUpdated {
    [self updatePosterCache];
    [self updateTrailerCache];
    [self updateIMDbCache];
}


- (NSMutableArray*) loadFavoriteTheaters {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITE_THEATERS];
    if (array.count == 0) {
        return [NSMutableArray array];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[FavoriteTheater theaterWithDictionary:dictionary]];
    }

    return result;
}


- (NSMutableArray*) favoriteTheaters {
    if (favoriteTheatersData == nil) {
        self.favoriteTheatersData = [self loadFavoriteTheaters];
    }

    return favoriteTheatersData;
}


- (void) saveFavoriteTheaters {
    [NowPlayingModel saveFavoriteTheaters:self.favoriteTheaters];
}


- (void) addFavoriteTheater:(Theater*) theater {
    FavoriteTheater* favoriteTheater = [FavoriteTheater theaterWithName:theater.name
                                                    originatingLocation:theater.originatingLocation];
    if (![self.favoriteTheaters containsObject:favoriteTheater]) {
        [self.favoriteTheaters addObject:favoriteTheater];
    }

    [self saveFavoriteTheaters];
}


- (BOOL) isFavoriteTheater:(Theater*) theater {
    for (FavoriteTheater* favorite in self.favoriteTheaters) {
        if ([favorite.name isEqual:theater.name]) {
            return YES;
        }
    }

    return NO;
}


- (void) removeFavoriteTheater:(Theater*) theater {
    FavoriteTheater* favoriteTheater = [FavoriteTheater theaterWithName:theater.name
                                                    originatingLocation:theater.originatingLocation];

    [self.favoriteTheaters removeObject:favoriteTheater];
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

    return [dvdCache imdbAddressForMovie:movie];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    UIImage* image = [posterCache smallPosterForMovie:movie];
    if (image != nil) {
        return image;
    }

    image = [upcomingCache posterForMovie:movie];
    if (image != nil) {
        return image;
    }

    image = [dvdCache posterForMovie:movie];
    if (image != nil) {
        return image;
    }

    return [largePosterCache firstPosterForMovie:movie];
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
    return [dataProvider synchronizationDateForTheater:theater.name];
}


- (BOOL) isStale:(Theater*) theater {
    NSDate* globalSyncDate = [dataProvider lastLookupDate];
    NSDate* theaterSyncDate = [self synchronizationDateForTheater:theater];
    if (globalSyncDate == nil || theaterSyncDate == nil) {
        return NO;
    }

    return ![DateUtilities isSameDay:globalSyncDate date:theaterSyncDate];
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
    Location* location = theater.location;
    if (location.address.length != 0 && location.city.length != 0) {
        return [NSString stringWithFormat:@"%@, %@", location.address, location.city];
    } else {
        return location.address;
    }
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
    if (distance != UNKNOWN_DISTANCE && self.searchRadius < 50 && distance > self.searchRadius) {
        return true;
    }

    return false;
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
    Movie* movie1 = t1;
    Movie* movie2 = t2;

    return [movie1.displayTitle compare:movie2.displayTitle options:NSCaseInsensitiveSearch];
}


NSInteger compareTheatersByName(id t1, id t2, void *context) {
    Theater* theater1 = t1;
    Theater* theater2 = t2;

    return [theater1.name compare:theater2.name options:NSCaseInsensitiveSearch];
}


NSInteger compareTheatersByDistance(id t1, id t2, void *context) {
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
    [self markDataProviderOutOfDate];

    [[NSUserDefaults standardUserDefaults] setObject:userAddress forKey:USER_ADDRESS];
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


- (NSString*) noLocationInformationFound {
    if (self.userAddress.length == 0) {
        return NSLocalizedString(@"Please enter your location", nil);
    } else if ([GlobalActivityIndicator hasVisibleBackgroundTasks]) {
        return NSLocalizedString(@"Downloading data", nil);
    } else if (![NetworkUtilities isNetworkAvailable]) {
        return NSLocalizedString(@"Network unavailable", nil);
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
    [scoreCache prioritizeMovie:movie];
    [trailerCache prioritizeMovie:movie];
}


- (NSString*) feedbackUrl {
    NSString* body = [NSString stringWithFormat:@"\n\nLocation: %@\nSearch Distance: %d\nSearch Date: %@\nReviews: %@\nAuto-Update Location: %@",
                      self.userAddress,
                      self.searchRadius,
                      [DateUtilities formatShortDate:self.searchDate],
                      self.currentScoreProvider,
                      (self.autoUpdateLocation ? @"yes" : @"no")];

    NSString* encodedBody = [Utilities stringByAddingPercentEscapes:body];
    NSString* result = [@"mailto:cyrus.najmabadi@gmail.com?subject=Now%20Playing%20Feedback&body=" stringByAppendingString:encodedBody];
    return result;
}

@end