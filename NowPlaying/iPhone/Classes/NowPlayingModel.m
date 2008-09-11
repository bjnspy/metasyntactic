// Copyright (C) 2008 Cyrus Najmabadi
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

#import "NowPlayingModel.h"

#import "AbstractNavigationController.h"
#import "AddressLocationCache.h"
#import "AllMoviesViewController.h"
#import "AllTheatersViewController.h"
#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "ExtraMovieInformation.h"
#import "FavoriteTheater.h"
#import "IMDbCache.h"
#import "Location.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "NorthAmericaDataProvider.h"
#import "NumbersCache.h"
#import "PosterCache.h"
#import "RatingsCache.h"
#import "ReviewCache.h"
#import "ReviewsViewController.h"
#import "Theater.h"
#import "TheaterDetailsViewController.h"
#import "TicketsViewController.h"
#import "TrailerCache.h"
#import "UnitedKingdomDataProvider.h"
#import "UpcomingCache.h"
#import "UpcomingMoviesViewController.h"
#import "Utilities.h"

@implementation NowPlayingModel

static NSString* currentVersion = @"1.7.0";
static NSString* persistenceVersion = @"30";

static NSString* VERSION = @"version";

static NSString* ALL_MOVIES_SELECTED_SEGMENT_INDEX      = @"allMoviesSelectedSegmentIndex";
static NSString* ALL_THEATERS_SELECTED_SEGMENT_INDEX    = @"allTheatersSelectedSegmentIndex";
static NSString* AUTO_UPDATE_LOCATION                   = @"autoUpdateLocation";
static NSString* DATA_PROVIDER_INDEX                    = @"dataProviderIndex";
static NSString* FAVORITE_THEATERS                      = @"favoriteTheaters";
static NSString* HIDE_EMPTY_THEATERS                    = @"hideEmptyTheaters";
static NSString* NAVIGATION_STACK_TYPES                 = @"navigationStackTypes";
static NSString* NAVIGATION_STACK_VALUES                = @"navigationStackValues";
static NSString* NUMBERS_SELECTED_SEGMENT_INDEX         = @"numbersSelectedSegmentIndex";
static NSString* RATINGS_PROVIDER_INDEX                 = @"ratingsProviderIndex";
static NSString* SEARCH_DATE                            = @"searchDate";
static NSString* SEARCH_RADIUS                          = @"searchRadius";
static NSString* SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX = @"selectedTabBarViewControllerIndex";
static NSString* UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX = @"upcomingMoviesSelectedSegmentIndex";
static NSString* USER_LOCATION                          = @"userLocation";
static NSString* USE_NORMAL_FONTS                       = @"useNormalFonts";


static NSString** KEYS[] = {
    &VERSION,
    &ALL_MOVIES_SELECTED_SEGMENT_INDEX,
    &ALL_THEATERS_SELECTED_SEGMENT_INDEX,
    &AUTO_UPDATE_LOCATION,
    &DATA_PROVIDER_INDEX,
    &FAVORITE_THEATERS,
    &HIDE_EMPTY_THEATERS,
    &NAVIGATION_STACK_TYPES,
    &NAVIGATION_STACK_VALUES,
    &NUMBERS_SELECTED_SEGMENT_INDEX,
    &RATINGS_PROVIDER_INDEX,
    &SEARCH_DATE,
    &SEARCH_RADIUS,
    &SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX,
    &UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX,
    &USER_LOCATION,
    &USE_NORMAL_FONTS,
};


@synthesize dataProviders;
@synthesize movieMap;
@synthesize favoriteTheatersData;

@synthesize addressLocationCache;
@synthesize imdbCache;
@synthesize numbersCache;
@synthesize posterCache;
@synthesize ratingsCache;
@synthesize reviewCache;
@synthesize trailerCache;
@synthesize upcomingCache;

- (void) dealloc {
    self.dataProviders = nil;
    self.movieMap = nil;
    self.favoriteTheatersData = nil;

    self.addressLocationCache = nil;
    self.imdbCache = nil;
    self.numbersCache = nil;
    self.posterCache = nil;
    self.ratingsCache = nil;
    self.reviewCache = nil;
    self.trailerCache = nil;
    self.upcomingCache = nil;

    [super dealloc];
}


+ (NSString*) version {
    return currentVersion;
}


- (void) updateIMDbCache {
    [imdbCache update:self.movies];
}


- (void) updateNumbersCache {
    return;
    [numbersCache updateIndex];
}


- (void) updatePosterCache {
    [posterCache update:self.movies];
}


- (void) updateTrailerCache {
    [trailerCache update:self.movies];
}


- (NSDictionary*) ratings {
    return ratingsCache.ratings;
}


- (void) updateReviewCache {
    [reviewCache update:self.ratings ratingsProvider:self.ratingsProviderIndex];
}


- (void) updateUpcomingCache {
    [upcomingCache updateMovieDetails];
}


- (void) updateAddressLocationCache {
    NSMutableArray* addresses = [NSMutableArray array];

    for (Theater* theater in self.theaters) {
        [addresses addObject:theater.address];
    }

    [addressLocationCache updateAddresses:addresses];
}


- (void) updateUserAddressLocation {
    [addressLocationCache updatePostalCode:self.userLocation];
}


+ (void) saveFavoriteTheaters:(NSArray*) favoriteTheaters {
    NSMutableArray* result = [NSMutableArray array];
    for (FavoriteTheater* theater in favoriteTheaters) {
        [result addObject:theater.dictionary];
    }

    [[NSUserDefaults standardUserDefaults] setObject:result forKey:FAVORITE_THEATERS];

}


- (void) restorePreviousValues:(id) previousUserLocation
                  searchRadius:(id) previousSearchRadius
            autoUpdateLocation:(id) previousAutoUpdateLocation
             hideEmptyTheaters:(id) previousHideEmptyTheaters
                useNormalFonts:(id) previousUseNormalFonts
              favoriteTheaters:(id) previousFavoriteTheaters {
    if ([previousUserLocation isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:previousUserLocation forKey:USER_LOCATION];
    }

    if ([previousSearchRadius isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[previousSearchRadius intValue] forKey:SEARCH_RADIUS];
    }

    if ([previousAutoUpdateLocation isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousAutoUpdateLocation boolValue] forKey:AUTO_UPDATE_LOCATION];
    }

    if ([previousHideEmptyTheaters isKindOfClass:[NSNumber class]]) {
        [[NSUserDefaults standardUserDefaults] setBool:[previousHideEmptyTheaters boolValue] forKey:HIDE_EMPTY_THEATERS];
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
    self.dataProviders = [NSArray arrayWithObjects:
                          [NorthAmericaDataProvider providerWithModel:self],
                          [UnitedKingdomDataProvider providerWithModel:self], nil];

    self.movieMap = [NSDictionary dictionaryWithContentsOfFile:[Application movieMapFile]];

    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION];
    if (version == nil || ![persistenceVersion isEqual:version]) {
        id previousUserLocation = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOCATION];
        id previousSearchRadius = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_RADIUS];
        id previousAutoUpdateLocation = [[NSUserDefaults standardUserDefaults] objectForKey:AUTO_UPDATE_LOCATION];
        id previousHideEmptyTheaters = [[NSUserDefaults standardUserDefaults] objectForKey:HIDE_EMPTY_THEATERS];
        id previousUseNormalFonts = [[NSUserDefaults standardUserDefaults] objectForKey:USE_NORMAL_FONTS];
        id previousFavoriteTheaters = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITE_THEATERS];

        self.movieMap = nil;
        for (int i = 0; i < ArrayLength(KEYS); i++) {
            NSString** key = KEYS[i];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:*key];
        }

        [Application deleteFolders];

        for (id<DataProvider> provider in self.dataProviders) {
            [provider invalidateDiskCache];
        }

        [self restorePreviousValues:previousUserLocation
                       searchRadius:previousSearchRadius
                 autoUpdateLocation:previousAutoUpdateLocation
                  hideEmptyTheaters:previousHideEmptyTheaters
                     useNormalFonts:previousUseNormalFonts
                   favoriteTheaters:previousFavoriteTheaters];

        [[NSUserDefaults standardUserDefaults] setObject:persistenceVersion forKey:VERSION];
    }
}


- (id) init {
    if (self = [super init]) {
        [self loadData];

        self.addressLocationCache = [AddressLocationCache cache];
        self.imdbCache = [IMDbCache cache];
        self.numbersCache = [NumbersCache cache];
        self.posterCache = [PosterCache cache];
        self.reviewCache = [ReviewCache cacheWithModel:self];
        self.ratingsCache = [RatingsCache cacheWithModel:self];
        self.trailerCache = [TrailerCache cache];
        self.upcomingCache = [UpcomingCache cache];

        searchRadius = -1;

        [self performSelector:@selector(updateCaches:) withObject:[NSNumber numberWithInt:0] afterDelay:2];
    }

    return self;
}


- (void) updateCaches:(NSNumber*) number {
    int value = number.intValue;

    if (value == 0) {
        [self updateAddressLocationCache];
    } else if (value == 1) {
        [self updateNumbersCache];
    } else if (value == 2) {
        [self updatePosterCache];
    } else if (value == 3) {
        [self updateUserAddressLocation];
    } else if (value == 4) {
        [self updateReviewCache];
    } else if (value == 5) {
        [self updateTrailerCache];
    } else if (value == 6) {
        [self updateUpcomingCache];
    } else if (value == 7) {
        [self updateIMDbCache];
    } else {
        return;
    }

    [self performSelector:@selector(updateCaches:) withObject:[NSNumber numberWithInt:value + 1] afterDelay:1];
}


+ (NowPlayingModel*) model {
    return [[[NowPlayingModel alloc] init] autorelease];
}


- (NSInteger) dataProviderIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DATA_PROVIDER_INDEX];
}


- (void) setDataProviderIndex:(NSInteger) index {
    self.movieMap = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:DATA_PROVIDER_INDEX];
}


- (id<DataProvider>) currentDataProvider {
    return [dataProviders objectAtIndex:[self dataProviderIndex]];
}


- (BOOL) northAmericaDataProvider {
    return self.dataProviderIndex == 0;
}


- (BOOL) unitedKingdomDataProvider {
    return self.dataProviderIndex == 1;
}


- (NSInteger) ratingsProviderIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:RATINGS_PROVIDER_INDEX];
}


- (void) setRatingsProviderIndex:(NSInteger) index {
    self.movieMap = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:RATINGS_PROVIDER_INDEX];
    [ratingsCache onRatingsProviderChanged];
    [self updateReviewCache];

    if (self.noRatings && self.allMoviesSortingByScore) {
        [self setAllMoviesSelectedSegmentIndex:0];
    }
}


- (BOOL) rottenTomatoesRatings {
    return self.ratingsProviderIndex == 0;
}


- (BOOL) metacriticRatings {
    return self.ratingsProviderIndex == 1;
}


- (BOOL) noRatings {
    return self.ratingsProviderIndex == 2;
}


- (NSArray*) ratingsProviders {
    return [NSArray arrayWithObjects:@"RottenTomatoes", @"Metacritic", @"None", nil];
}


- (NSString*) currentRatingsProvider {
    return [self.ratingsProviders objectAtIndex:self.ratingsProviderIndex];
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


- (NSInteger) numbersSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:NUMBERS_SELECTED_SEGMENT_INDEX];
}


- (void) setNumbersSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:NUMBERS_SELECTED_SEGMENT_INDEX];
}


- (BOOL) allMoviesSortingByTitle {
    return self.allMoviesSelectedSegmentIndex == 0;
}


- (BOOL) allMoviesSortingByReleaseDate {
    return self.allMoviesSelectedSegmentIndex == 1;
}


- (BOOL) allMoviesSortingByScore {
    return self.allMoviesSelectedSegmentIndex == 2;
}


- (BOOL) upcomingMoviesSortingByTitle {
    return self.upcomingMoviesSelectedSegmentIndex == 0;
}


- (BOOL) upcomingMoviesSortingByReleaseDate {
    return self.upcomingMoviesSelectedSegmentIndex == 1;
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


- (NSString*) userLocation {
    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:USER_LOCATION];
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


- (void) markDataProvidersOutOfDate {
    for (id<DataProvider> provider in self.dataProviders) {
        [provider setStale];
    }
}


- (void) setSearchDate:(NSDate*) date {
    [self markDataProvidersOutOfDate];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:SEARCH_DATE];
}


- (NSArray*) movies {
    return [self.currentDataProvider movies];
}


- (NSArray*) theaters {
    return [self.currentDataProvider theaters];
}


- (void) onRatingsUpdated {
    self.movieMap = nil;
    [self updateReviewCache];
}


- (void) onProviderUpdated {
    self.movieMap = nil;
    [self updateIMDbCache];
    [self updatePosterCache];
    [self updateTrailerCache];
    [self updateAddressLocationCache];
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
                                                  originatingPostalCode:theater.originatingPostalCode];
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
                                                  originatingPostalCode:theater.originatingPostalCode];

    [self.favoriteTheaters removeObject:favoriteTheater];
    [self saveFavoriteTheaters];
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
    NSString* result = [imdbCache imdbAddressForMovie:movie];
    if (result.length > 0) {
        return result;
    }

    return [upcomingCache imdbAddressForMovie:movie];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    UIImage* image = [posterCache posterForMovie:movie];
    if (image != nil) {
        return image;
    }

    return [upcomingCache posterForMovie:movie];
}


- (Location*) locationForAddress:(NSString*) address {
    return [addressLocationCache locationForAddress:address];
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
    return [self.currentDataProvider moviePerformances:movie forTheater:theater];
}


- (NSDate*) synchronizationDateForTheater:(Theater*) theater {
    return [self.currentDataProvider synchronizationDateForTheater:theater.name];
}


- (BOOL) isStale:(Theater*) theater {
    NSDate* globalSyncDate = [self.currentDataProvider lastLookupDate];
    NSDate* theaterSyncDate = [self synchronizationDateForTheater:theater];

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
        NSDate* globalSyncDate = [self.currentDataProvider lastLookupDate];
        return [NSString stringWithFormat:
                NSLocalizedString(@"Show times retrieved on %@.", nil),
                [DateUtilities formatLongDate:globalSyncDate]];
    }
}


- (NSString*) simpleAddressForTheater:(Theater*) theater {
    Location* location = [self locationForAddress:theater.address];
    if (![Utilities isNilOrEmpty:location.address] && ![Utilities isNilOrEmpty:location.city]) {
        return [NSString stringWithFormat:@"%@, %@", location.address, location.city];
    } else {
        return theater.address;
    }
}


- (NSDictionary*) theaterDistanceMap {
    return [addressLocationCache theaterDistanceMap:self.userLocation
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
        double distance = [[theaterDistanceMap objectForKey:theater.address] doubleValue];

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

    int movieRating1 = [model scoreForMovie:movie1];
    int movieRating2 = [model scoreForMovie:movie2];

    if (movieRating1 < movieRating2) {
        return NSOrderedDescending;
    } else if (movieRating1 > movieRating2) {
        return NSOrderedAscending;
    }

    return compareMoviesByTitle(t1, t2, context);
}


NSInteger compareMoviesByReleaseDateDescending(id t1, id t2, void *context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;

    NSDate* releaseDate1 = movie1.releaseDate;
    NSDate* releaseDate2 = movie2.releaseDate;

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

    double distance1 = [[theaterDistanceMap objectForKey:theater1.address] doubleValue];
    double distance2 = [[theaterDistanceMap objectForKey:theater2.address] doubleValue];

    if (distance1 < distance2) {
        return NSOrderedAscending;
    } else if (distance1 > distance2) {
        return NSOrderedDescending;
    }

    return compareTheatersByName(t1, t2, nil);
}


- (void) setUserLocation:(NSString*) userLocation {
    [self markDataProvidersOutOfDate];

    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:USER_LOCATION];

    [self updateUserAddressLocation];
}


- (void) createMovieMap {
    if (movieMap == nil) {
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

        NSArray* keys = self.ratings.allKeys;
        NSMutableArray* lowercaseKeys = [NSMutableArray array];
        for (NSString* key in keys) {
            [lowercaseKeys addObject:key.lowercaseString];
        }

        for (Movie* movie in self.movies) {
            NSString* lowercaseTitle = movie.canonicalTitle.lowercaseString;
            NSInteger index = [lowercaseKeys indexOfObject:lowercaseTitle];
            if (index == NSNotFound) {
                index = [[Application differenceEngine] findClosestMatchIndex:movie.canonicalTitle.lowercaseString inArray:lowercaseKeys];
            }

            if (index != NSNotFound) {
                NSString* key = [keys objectAtIndex:index];
                [dictionary setObject:key forKey:movie.canonicalTitle];
            }
        }

        self.movieMap = dictionary;
        [Utilities writeObject:dictionary toFile:[Application movieMapFile]];
    }
}


- (ExtraMovieInformation*) extraInformationForMovie:(Movie*) movie {
    [self createMovieMap];

    NSString* key = [movieMap objectForKey:movie.canonicalTitle];
    if (key == nil) {
        return nil;
    }

    return [self.ratings objectForKey:key];
}


- (NSInteger) scoreForMovie:(Movie*) movie {
    ExtraMovieInformation* extraInfo = [self extraInformationForMovie:movie];

    if (extraInfo == nil) {
        return -1;
    }

    return extraInfo.scoreValue;
}


- (NSString*) synopsisForMovie:(Movie*) movie {
    NSString* synopsis = movie.synopsis;
    if (![Utilities isNilOrEmpty:synopsis]) {
        return synopsis;
    }

    synopsis = [self extraInformationForMovie:movie].synopsis;
    if (![Utilities isNilOrEmpty:synopsis]) {
        return synopsis;
    }

    synopsis = [upcomingCache synopsisForMovie:movie];
    if (![Utilities isNilOrEmpty:synopsis]) {
        return synopsis;
    }

    return NSLocalizedString(@"No synopsis available.", nil);
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* result = [trailerCache trailersForMovie:movie];
    if (result.count > 0) {
        return result;
    }

    return [upcomingCache trailersForMovie:movie];
}


- (NSArray*) reviewsForMovie:(Movie*) movie {
    ExtraMovieInformation* extraInfo = [self extraInformationForMovie:movie];
    if (extraInfo == nil) {
        return [NSArray array];
    }

    return [reviewCache reviewsForMovie:extraInfo.canonicalTitle];
}


- (NSString*) noLocationInformationFound {
    if ([Utilities isNilOrEmpty:self.userLocation]) {
        return NSLocalizedString(@"Please enter your location", nil);
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


- (BOOL) hideEmptyTheaters {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HIDE_EMPTY_THEATERS];
}


- (void) setHideEmptyTheaters:(BOOL) hideEmptyTheaters {
    [[NSUserDefaults standardUserDefaults] setBool:hideEmptyTheaters forKey:HIDE_EMPTY_THEATERS];
}


- (void) saveNavigationStack:(AbstractNavigationController*) controller {
    NSMutableArray* types = [NSMutableArray array];
    NSMutableArray* values = [NSMutableArray array];

    for (id viewController in controller.viewControllers) {
        NSInteger type;
        id value;
        if ([viewController isKindOfClass:[MovieDetailsViewController class]]) {
            type = MovieDetails;
            value = [[viewController movie] dictionary];
        } else if ([viewController isKindOfClass:[TheaterDetailsViewController class]]) {
            type = TheaterDetails;
            value = [[viewController theater] dictionary];
        } else if ([viewController isKindOfClass:[ReviewsViewController class]]) {
            type = Reviews;
            value = [[viewController movie] dictionary];
        } else if ([viewController isKindOfClass:[TicketsViewController class]]) {
            type = Tickets;
            value = [NSArray arrayWithObjects:[[viewController movie] dictionary], [[viewController theater] dictionary], [viewController title], nil];
        } else if ([viewController isKindOfClass:[AllMoviesViewController class]]) {
            continue;
        } else if ([viewController isKindOfClass:[AllTheatersViewController class]]) {
            continue;
        } else if ([viewController isKindOfClass:[UpcomingMoviesViewController class]]) {
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

@end