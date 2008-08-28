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

#import "BoxOfficeModel.h"

#import "AbstractNavigationController.h"
#import "AddressLocationCache.h"
#import "AllMoviesViewController.h"
#import "AllTheatersViewController.h"
#import "Application.h"
#import "DateUtilities.h"
#import "DifferenceEngine.h"
#import "ExtraMovieInformation.h"
#import "Location.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "NorthAmericaDataProvider.h"
#import "NotificationCenter.h"
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

@implementation BoxOfficeModel

static NSString* currentVersion = @"1.5.2";
static NSString* persistenceVersion = @"7";

+ (NSString*) VERSION                                   { return @"version"; }
+ (NSString*) SEARCH_DATES                              { return @"searchDates"; }
+ (NSString*) SEARCH_RESULTS                            { return @"searchResults"; }
+ (NSString*) SEARCH_RADIUS                             { return @"searchRadius"; }
+ (NSString*) POSTAL_CODE                               { return @"postalCode"; }
+ (NSString*) SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX    { return @"selectedTabBarViewControllerIndex"; }
+ (NSString*) ALL_MOVIES_SELECTED_SEGMENT_INDEX         { return @"allMoviesSelectedSegmentIndex"; }
+ (NSString*) ALL_THEATERS_SELECTED_SEGMENT_INDEX       { return @"allTheatersSelectedSegmentIndex"; }
+ (NSString*) UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX    { return @"upcomingMoviesSelectedSegmentIndex"; }
+ (NSString*) FAVORITE_THEATERS                         { return @"favoriteTheaters"; }
+ (NSString*) SEARCH_DATE                               { return @"searchDate"; }
+ (NSString*) AUTO_UPDATE_LOCATION                      { return @"autoUpdateLocation"; }
+ (NSString*) RATINGS_PROVIDER_INDEX                    { return @"ratingsProviderIndex"; }
+ (NSString*) DATA_PROVIDER_INDEX                       { return @"dataProviderIndex"; }
+ (NSString*) USE_NORMAL_FONTS                          { return @"useNormalFonts"; }
+ (NSString*) HIDE_EMPTY_THEATERS                       { return @"hideEmptyTheaters"; }
+ (NSString*) NAVIGATION_STACK_TYPES                    { return @"navigationStackTypes"; }
+ (NSString*) NAVIGATION_STACK_VALUES                   { return @"navigationStackValues"; }

@synthesize notificationCenter;

@synthesize dataProviders;
@synthesize movieMap;
@synthesize favoriteTheatersData;

@synthesize addressLocationCache;
@synthesize posterCache;
@synthesize trailerCache;
@synthesize ratingsCache;
@synthesize reviewCache;
@synthesize upcomingCache;

@synthesize backgroundTaskCount;
@synthesize activityView;
@synthesize activityIndicatorView;

- (void) dealloc {
    self.notificationCenter = nil;

    self.dataProviders = nil;
    self.movieMap = nil;
    self.favoriteTheatersData = nil;

    self.addressLocationCache = nil;
    self.posterCache = nil;
    self.trailerCache = nil;
    self.ratingsCache = nil;
    self.reviewCache = nil;
    self.upcomingCache = nil;

    self.backgroundTaskCount = 0;
    self.activityView = nil;
    self.activityIndicatorView = nil;

    [super dealloc];
}


+ (NSString*) version {
    return currentVersion;
}


- (void) updatePosterCache {
    [self.posterCache update:self.movies];
}


- (void) updateTrailerCache {
    [self.trailerCache update:self.movies];
}


- (NSDictionary*) ratings {
    return [self.ratingsCache ratings];
}


- (void) updateReviewCache {
    [self.reviewCache update:self.ratings ratingsProvider:[self ratingsProviderIndex]];
}


- (void) updateUpcomingCache {
    [self.upcomingCache updateMovieDetails];
}


- (void) updateAddressLocationCache {
    NSMutableArray* addresses = [NSMutableArray array];

    for (Theater* theater in self.theaters) {
        [addresses addObject:theater.address];
    }

    [self.addressLocationCache updateAddresses:addresses];
}


- (void) updatePostalCodeAddressLocation {
    [self.addressLocationCache updatePostalCode:self.postalCode];
}


- (void) loadData {
    self.dataProviders = [NSArray arrayWithObjects:
                          [NorthAmericaDataProvider providerWithModel:self],
                          [UnitedKingdomDataProvider providerWithModel:self], nil];

    self.movieMap = [NSDictionary dictionaryWithContentsOfFile:[Application movieMapFile]];

    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:[BoxOfficeModel VERSION]];
    if (version == nil || ![persistenceVersion isEqual:version]) {
        self.movieMap = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel VERSION]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel SEARCH_DATES]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel SEARCH_RESULTS]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel SEARCH_RADIUS]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel POSTAL_CODE]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel NAVIGATION_STACK_TYPES]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel NAVIGATION_STACK_VALUES]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel ALL_MOVIES_SELECTED_SEGMENT_INDEX]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel ALL_THEATERS_SELECTED_SEGMENT_INDEX]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel FAVORITE_THEATERS]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel SEARCH_DATE]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel AUTO_UPDATE_LOCATION]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel RATINGS_PROVIDER_INDEX]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel DATA_PROVIDER_INDEX]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[BoxOfficeModel USE_NORMAL_FONTS]];

        [Application deleteFolders];

        for (id<DataProvider> provider in self.dataProviders) {
            [provider invalidateDiskCache];
        }

        [[NSUserDefaults standardUserDefaults] setObject:persistenceVersion forKey:[BoxOfficeModel VERSION]];
    }
}


- (id) initWithCenter:(NotificationCenter*) notificationCenter_ {
    if (self = [super init]) {
        [self loadData];

        self.notificationCenter = notificationCenter_;

        self.posterCache = [PosterCache cache];
        self.trailerCache = [TrailerCache cache];
        self.addressLocationCache = [AddressLocationCache cache];
        self.reviewCache = [ReviewCache cacheWithModel:self];
        self.ratingsCache = [RatingsCache cacheWithModel:self];
        self.upcomingCache = [UpcomingCache cache];

        self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGRect frame = self.activityIndicatorView.frame;
        frame.size.width += 4;

        self.activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
        [self.activityView addSubview:self.activityIndicatorView];

        backgroundTaskCount = 0;
        searchRadius = -1;

        [self performSelector:@selector(updateCaches:) withObject:nil afterDelay:2];
    }

    return self;
}


- (void) updateCaches:(id) arg {
    [self updatePosterCache];
    [self updateAddressLocationCache];
    [self updatePostalCodeAddressLocation];
    [self updateTrailerCache];
    [self updateReviewCache];
    [self updateUpcomingCache];
}


+ (BoxOfficeModel*) modelWithCenter:(NotificationCenter*) notificationCenter {
    return [[[BoxOfficeModel alloc] initWithCenter:notificationCenter] autorelease];
}


- (void) addBackgroundTask {
    backgroundTaskCount++;

    if (backgroundTaskCount == 1) {
        [self.activityIndicatorView startAnimating];
    }
}


- (void) removeBackgroundTask {
    backgroundTaskCount--;

    if (backgroundTaskCount == 0) {
        [self.activityIndicatorView stopAnimating];
    }
}


- (NSInteger) dataProviderIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[BoxOfficeModel DATA_PROVIDER_INDEX]];
}


- (void) setDataProviderIndex:(NSInteger) index {
    self.movieMap = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[BoxOfficeModel DATA_PROVIDER_INDEX]];
}


- (id<DataProvider>) currentDataProvider {
    return [dataProviders objectAtIndex:[self dataProviderIndex]];
}


- (BOOL) northAmericaDataProvider {
    return [self dataProviderIndex] == 0;
}


- (BOOL) unitedKingdomDataProvider {
    return [self dataProviderIndex] == 1;
}


- (NSInteger) ratingsProviderIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[BoxOfficeModel RATINGS_PROVIDER_INDEX]];
}


- (void) setRatingsProviderIndex:(NSInteger) index {
    self.movieMap = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[BoxOfficeModel RATINGS_PROVIDER_INDEX]];
    [self.ratingsCache onRatingsProviderChanged];
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


- (BOOL) useKilometers {
    // yeah... so the UK supposedly uses metric...
    // except they don't. so we special case them to stick with 'miles' in the UI.
    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
    BOOL isUK = [@"GB" isEqual:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];

    return isMetric && !isUK;
}


- (NSInteger) selectedTabBarViewControllerIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[BoxOfficeModel SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX]];
}


- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[BoxOfficeModel SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX]];
}


- (NSInteger) allMoviesSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[BoxOfficeModel ALL_MOVIES_SELECTED_SEGMENT_INDEX]];
}


- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[BoxOfficeModel ALL_MOVIES_SELECTED_SEGMENT_INDEX]];
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


- (NSInteger) allTheatersSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[BoxOfficeModel ALL_THEATERS_SELECTED_SEGMENT_INDEX]];
}


- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[BoxOfficeModel ALL_THEATERS_SELECTED_SEGMENT_INDEX]];
}


- (BOOL) upcomingMoviesSortingByTitle {
    return self.upcomingMoviesSelectedSegmentIndex == 0;
}


- (BOOL) upcomingMoviesSortingByReleaseDate {
    return self.upcomingMoviesSelectedSegmentIndex == 1;
}


- (NSInteger) upcomingMoviesSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:[BoxOfficeModel UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX]];
}


- (void) setUpcomingMoviesSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:[BoxOfficeModel UPCOMING_MOVIES_SELECTED_SEGMENT_INDEX]];
}


- (BOOL) autoUpdateLocation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[BoxOfficeModel AUTO_UPDATE_LOCATION]];
}


- (void) setAutoUpdateLocation:(BOOL) value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:[BoxOfficeModel AUTO_UPDATE_LOCATION]];
}


- (NSString*) postalCode {
    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:[BoxOfficeModel POSTAL_CODE]];
    if (result == nil) {
        result =  @"";
    }

    return result;
}


- (int) searchRadius {
    if (searchRadius == -1) {
        searchRadius = [[NSUserDefaults standardUserDefaults] integerForKey:[BoxOfficeModel SEARCH_RADIUS]];
        if (searchRadius == 0) {
            searchRadius = 5;
        }

        searchRadius = MAX(MIN(searchRadius, 50), 1);
    }

    return searchRadius;
}


- (void) setSearchRadius:(NSInteger) radius {
    searchRadius = radius;
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:[BoxOfficeModel SEARCH_RADIUS]];
}


- (NSDate*) searchDate {
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:[BoxOfficeModel SEARCH_DATE]];
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
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:[BoxOfficeModel SEARCH_DATE]];
}


- (NSArray*) movies {
    return [[self currentDataProvider] movies];
}


- (NSArray*) theaters {
    return [[self currentDataProvider] theaters];
}


- (void) onRatingsUpdated {
    self.movieMap = nil;
    [self updateReviewCache];
}


- (void) onProviderUpdated {
    self.movieMap = nil;
    [self updatePosterCache];
    [self updateTrailerCache];
    [self updateAddressLocationCache];
}


- (NSMutableArray*) loadFavoriteTheaters {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:[BoxOfficeModel FAVORITE_THEATERS]];
    if (array.count == 0) {
        return [NSMutableArray array];
    }

    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* dictionary in array) {
        [result addObject:[Theater theaterWithDictionary:dictionary]];
    }

    return result;
}


- (NSMutableArray*) favoriteTheaters {
    if (self.favoriteTheatersData == nil) {
        self.favoriteTheatersData = [self loadFavoriteTheaters];
    }

    return self.favoriteTheatersData;
}


- (void) saveFavoriteTheaters {
    NSMutableArray* encodedTheaters = [NSMutableArray array];
    for (Theater* theater in self.favoriteTheatersData) {
        [encodedTheaters addObject:theater.dictionary];
    }

    [[NSUserDefaults standardUserDefaults] setObject:encodedTheaters forKey:[BoxOfficeModel FAVORITE_THEATERS]];
}


- (void) addFavoriteTheater:(Theater*) theater {
    [self.favoriteTheatersData addObject:theater];
    [self saveFavoriteTheaters];
}


- (BOOL) isFavoriteTheater:(Theater*) theater {
    NSArray* array = [self favoriteTheaters];
    for (Theater* currentTheater in array) {
        if ([currentTheater.name isEqual:theater.name]) {
            return YES;
        }
    }

    return NO;
}


- (void) removeFavoriteTheater:(Theater*) theater {
    NSMutableArray* array = [self favoriteTheaters];

    for (int i = 0; i < array.count; i++) {
        Theater* currentTheater = [array objectAtIndex:i];

        if ([currentTheater.identifier isEqual:theater.identifier]) {
            [array removeObjectAtIndex:i];
            break;
        }
    }

    [self saveFavoriteTheaters];
}


- (UIImage*) posterForMovie:(Movie*) movie {
    UIImage* image = [self.posterCache posterForMovie:movie];
    if (image != nil) {
        return image;
    }

    return [self.upcomingCache posterForMovie:movie];
}


- (Location*) locationForAddress:(NSString*) address {
    return [self.addressLocationCache locationForAddress:address];
}


- (NSMutableArray*) theatersShowingMovie:(Movie*) movie {
    NSMutableArray* array = [NSMutableArray array];

    for (Theater* theater in self.theaters) {
        if ([theater.movieIdentifiers containsObject:movie.identifier]) {
            [array addObject:theater];
        }
    }

    return array;
}


- (NSArray*) moviesAtTheater:(Theater*) theater {
    NSMutableArray* array = [NSMutableArray array];

    for (Movie* movie in self.movies) {
        if ([theater.movieIdentifiers containsObject:movie.identifier]) {
            [array addObject:movie];
        }
    }

    return array;
}


- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater {
    return [[self currentDataProvider] moviePerformances:movie forTheater:theater];
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
    return [self.addressLocationCache theaterDistanceMap:self.postalCode
                                                theaters:self.theaters
                                           useKilometers:self.useKilometers];
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
    BoxOfficeModel* model = context;

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


- (void) setPostalCode:(NSString*) postalCode {
    [self markDataProvidersOutOfDate];

    [[NSUserDefaults standardUserDefaults] setObject:postalCode forKey:[BoxOfficeModel POSTAL_CODE]];

    [self updatePostalCodeAddressLocation];
}


- (void) createMovieMap {
    if (self.movieMap == nil) {
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];

        NSArray* keys = [[self ratings] allKeys];
        NSMutableArray* lowercaseKeys = [NSMutableArray array];
        for (NSString* key in keys) {
            [lowercaseKeys addObject:[key lowercaseString]];
        }

        for (Movie* movie in self.movies) {
            NSString* lowercaseTitle = [movie.canonicalTitle lowercaseString];
            NSInteger index = [lowercaseKeys indexOfObject:lowercaseTitle];
            if (index == NSNotFound) {
                index = [[Application differenceEngine] findClosestMatchIndex:[movie.canonicalTitle lowercaseString] inArray:lowercaseKeys];
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

    NSString* key = [self.movieMap objectForKey:movie.canonicalTitle];
    if (key == nil) {
        return nil;
    }

    return [[self ratings] objectForKey:key];
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

    synopsis = [self.upcomingCache synopsisForMovie:movie];
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
    if ([Utilities isNilOrEmpty:[self postalCode]]) {
        return NSLocalizedString(@"Please enter your location", nil);
    } else {
        return NSLocalizedString(@"No information found", nil);
    }
}


- (BOOL) useSmallFonts {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:[BoxOfficeModel USE_NORMAL_FONTS]];
}


- (void) setUseSmallFonts:(BOOL) useSmallFonts {
    [[NSUserDefaults standardUserDefaults] setBool:!useSmallFonts forKey:[BoxOfficeModel USE_NORMAL_FONTS]];
}


- (BOOL) hideEmptyTheaters {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[BoxOfficeModel HIDE_EMPTY_THEATERS]];
}


- (void) setHideEmptyTheaters:(BOOL) hideEmptyTheaters {
    [[NSUserDefaults standardUserDefaults] setBool:hideEmptyTheaters forKey:[BoxOfficeModel HIDE_EMPTY_THEATERS]];
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

    [[NSUserDefaults standardUserDefaults] setObject:types forKey:[BoxOfficeModel NAVIGATION_STACK_TYPES]];
    [[NSUserDefaults standardUserDefaults] setObject:values forKey:[BoxOfficeModel NAVIGATION_STACK_VALUES]];
}


- (NSArray*) navigationStackTypes {
    NSArray* result = [[NSUserDefaults standardUserDefaults] arrayForKey:[BoxOfficeModel NAVIGATION_STACK_TYPES]];
    if (result == nil) {
        return [NSArray array];
    }

    return result;
}


- (NSArray*) navigationStackValues {
    NSArray* result = [[NSUserDefaults standardUserDefaults] arrayForKey:[BoxOfficeModel NAVIGATION_STACK_VALUES]];
    if (result == nil) {
        return [NSArray array];
    }

    return result;
}

@end
