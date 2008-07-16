//
//  BoxOfficeModel.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/26/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "Movie.h"
#import "Theater.h"
#import "DifferenceEngine.h"
#import "Application.h"
#import "ExtraMovieInformation.h"
#import "Utilities.h"

@implementation BoxOfficeModel

static NSString* currentVersion = @"1.2.19";
static NSString* VERSION = @"version";
static NSString* LAST_QUICK_UPDATE_TIME                 = @"lastQuickUpdateTime";
static NSString* LAST_FULL_UPDATE_TIME                  = @"lastFullUpdateTime";
static NSString* SEARCH_DATES                           = @"searchDates";
static NSString* SEARCH_RESULTS                         = @"searchResults";
static NSString* SEARCH_RADIUS                          = @"searchRadius";
static NSString* ZIPCODE                                = @"postalCode";
static NSString* SUPPLEMENTARY_DATA                     = @"supplementaryData";
static NSString* CURRENTLY_SELECTED_MOVIE               = @"currentlySelectedMovie";
static NSString* CURRENTLY_SELECTED_THEATER             = @"currentlySelectedTheater";
static NSString* SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX = @"selectedTabBarViewControllerIndex";
static NSString* ALL_MOVIES_SELECTED_SEGMENT_INDEX      = @"allMoviesSelectedSegmentIndex";
static NSString* ALL_THEATERS_SELECTED_SEGMENT_INDEX    = @"allTheatersSelectedSegmentIndex";
static NSString* FAVORITE_THEATERS                      = @"favoriteTheaters";
static NSString* MOVIE_TRAILERS                         = @"movieTrailers";
static NSString* ADDRESS_LOCATION_MAP                   = @"addressLocationMap";
static NSString* CURRENTLY_SHOWING_REVIEWS              = @"currentlyShowingReviews";

static NSArray* KEYS;

+ (void) initialize {
    if (self == [BoxOfficeModel class]) {
        KEYS = [[NSArray arrayWithObjects:
                 VERSION,
                 LAST_QUICK_UPDATE_TIME,
                 LAST_FULL_UPDATE_TIME,
                 SEARCH_DATES, 
                 SEARCH_RESULTS,
                 SEARCH_RADIUS,
                 ZIPCODE,
                 SUPPLEMENTARY_DATA,
                 CURRENTLY_SELECTED_MOVIE,
                 CURRENTLY_SELECTED_THEATER,
                 SELECTED_TAB_BAR_VIEW_CONTROLLER_INDEX,
                 ALL_MOVIES_SELECTED_SEGMENT_INDEX,
                 ALL_THEATERS_SELECTED_SEGMENT_INDEX,
                 FAVORITE_THEATERS,
                 MOVIE_TRAILERS,
                 ADDRESS_LOCATION_MAP,
                 CURRENTLY_SHOWING_REVIEWS,
                 nil] retain];
    }
}

@synthesize notificationCenter;
@synthesize posterCache;
@synthesize trailerCache;
@synthesize addressLocationCache;
@synthesize reviewCache;
@synthesize backgroundTaskCount;
@synthesize activityView;
@synthesize activityIndicatorView;

@synthesize moviesData;
@synthesize theatersData;
@synthesize supplementaryInformationData;
@synthesize movieMap;
@synthesize favoriteTheatersData;

- (void) dealloc {
    self.notificationCenter = nil;
    self.trailerCache = nil;
    self.posterCache = nil;
    self.addressLocationCache = nil;
    self.reviewCache = nil;
    self.activityView = nil;
    self.activityIndicatorView = nil;
    
    self.moviesData = nil;
    self.theatersData = nil;
    self.supplementaryInformationData = nil;
    self.movieMap = nil;
    self.favoriteTheatersData = nil;
    
    [super dealloc];
}

- (void) updatePosterCache {
    [self.posterCache update:self.movies];
}

- (void) updateTrailerCache {
    [self.trailerCache update:self.movies];
}

- (void) updateReviewCache {
    [self.reviewCache update:self.supplementaryInformation];
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

- (void) clearOldSearchResults {
    NSMutableDictionary* searchDates = [self getSearchDates];    
    NSMutableDictionary* searchResults = [self getSearchResults];
    
    for (NSString* key in [searchDates allKeys]) {
        NSDate* searchDate = [searchDates objectForKey:key];
        
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:searchDate];
        if (time > (24 * 60 * 60)) {
            [searchDates removeObjectForKey:key];
            [searchResults removeObjectForKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:searchDates forKey:SEARCH_DATES];
    [[NSUserDefaults standardUserDefaults] setObject:searchResults forKey:SEARCH_RESULTS];
}

- (void) checkUserDefaults {
    NSString* version = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION];
    if (version == nil || ![currentVersion isEqual:version]) {
        for (NSString* key in KEYS) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:[Application moviesFile] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[Application theatersFile] error:NULL];
        [[NSFileManager defaultManager] removeItemAtPath:[Application reviewsFile] error:NULL];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:VERSION];
    }
}

- (id) initWithCenter:(NotificationCenter*) notificationCenter_ {
    if (self = [super init]) {
        [self checkUserDefaults];
        
        self.notificationCenter = notificationCenter_;
        self.posterCache = [PosterCache cache];
        self.trailerCache = [TrailerCache cache];
        self.addressLocationCache = [AddressLocationCache cache];
        self.reviewCache = [ReviewCache cache];
        
        self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGRect frame = self.activityIndicatorView.frame;
        frame.size.width += 4;
        
        self.activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
        [self.activityView addSubview:self.activityIndicatorView];
        
        backgroundTaskCount = 0;
        searchRadius = -1;
        
        [self updatePosterCache];
        [self updateAddressLocationCache];
        [self updatePostalCodeAddressLocation];
        [self updateTrailerCache];
        [self updateReviewCache];
    }
    
    return self;
}

+ (BoxOfficeModel*) modelWithCenter:(NotificationCenter*) notificationCenter {
    return [[[BoxOfficeModel alloc] initWithCenter:notificationCenter] autorelease];
}

- (void) addBackgroundTask:(NSString*) description {
    backgroundTaskCount++;
    
    if (backgroundTaskCount == 1) {
        [self.activityIndicatorView startAnimating];
    }
    
    [self.notificationCenter addStatusMessage:description];
}

- (void) removeBackgroundTask:(NSString*) description {
    backgroundTaskCount--;
    
    if (backgroundTaskCount == 0) {
        [self.activityIndicatorView stopAnimating];
    }
    
    [self.notificationCenter addStatusMessage:description];
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

- (BOOL) sortingMoviesByTitle {
    return [self allMoviesSelectedSegmentIndex] == 0;
}

- (BOOL) sortingMoviesByRating {
    return [self allMoviesSelectedSegmentIndex] == 1;
}

- (BOOL) sortingMoviesByReleaseDate {
    return [self allMoviesSelectedSegmentIndex] == 2;
}

- (NSInteger) allTheatersSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:ALL_THEATERS_SELECTED_SEGMENT_INDEX];
}

- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:ALL_THEATERS_SELECTED_SEGMENT_INDEX];
}

- (NSString*) postalCode {
    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:ZIPCODE];
    if (result == nil) {
        result =  @"";
    }
    
    return result;
}

- (int) searchRadius {
    if (searchRadius == -1) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_RADIUS]) {
            searchRadius = 5;
        } else {
            searchRadius = MAX(5, [[NSUserDefaults standardUserDefaults] integerForKey:SEARCH_RADIUS]);
        }
    }
 
    return searchRadius;
}

- (void) setSearchRadius:(NSInteger) radius {
    searchRadius = radius;
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:SEARCH_RADIUS];
}

- (NSArray*) loadMovies {
    NSArray* array = [NSArray arrayWithContentsOfFile:[Application moviesFile]];
    if (array == nil) {
        return [NSArray array];
    }
    
    NSMutableArray* decodedMovies = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        Movie* movie = [Movie movieWithDictionary:[array objectAtIndex:i]];
        [decodedMovies addObject:movie];
    }
    
    return decodedMovies;
}

- (NSArray*) movies {
    if (self.moviesData == nil) {
        self.moviesData = [self loadMovies];
    }
    
    return self.moviesData;
}

- (void) setMovies:(NSArray*) movies {    
    self.moviesData = movies;
    
    [self updatePosterCache];
    [self updateTrailerCache];
    
    self.movieMap = nil;
}

- (NSDictionary*) loadSupplementaryInformation {
    NSDictionary* dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SUPPLEMENTARY_DATA];
    if (dictionary == nil) {
        return [NSDictionary dictionary];
    }
    
    NSMutableDictionary* decodedData = [NSMutableDictionary dictionary];
    for (NSString* key in dictionary) {
        [decodedData setObject:[ExtraMovieInformation infoWithDictionary:[dictionary objectForKey:key]] forKey:key];
    }
    
    return decodedData;
}

- (NSDictionary*) supplementaryInformation {
    if (self.supplementaryInformationData == nil) {
        self.supplementaryInformationData = [self loadSupplementaryInformation];
    }
    
    return self.supplementaryInformationData;
}

- (void) saveSupplementaryInformation:(NSDictionary*) dictionary {
    NSMutableDictionary* encodedDictionary = [NSMutableDictionary dictionary];
    
    for (NSString* key in dictionary) {
        [encodedDictionary setObject:[[dictionary objectForKey:key] dictionary] forKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedDictionary forKey:SUPPLEMENTARY_DATA];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LAST_QUICK_UPDATE_TIME];
}

- (void) setSupplementaryInformation:(NSDictionary*) dictionary {
    self.supplementaryInformationData = dictionary;
    [self saveSupplementaryInformation:dictionary];
    
    self.movieMap = nil;
    [self updateReviewCache];
}

- (NSDate*) lastQuickUpdateTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:LAST_QUICK_UPDATE_TIME];
}

- (void) clearLastQuickUpdateTime {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_QUICK_UPDATE_TIME];
}

- (NSDate*) lastFullUpdateTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:LAST_FULL_UPDATE_TIME];
}

- (void) clearLastFullUpdateTime {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_FULL_UPDATE_TIME];
}

- (NSArray*) loadTheaters {
    NSArray* array = [NSArray arrayWithContentsOfFile:[Application theatersFile]];
    if (array == nil) {
        return [NSArray array];
    }
    
    NSMutableArray* decodedTheaters = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        [decodedTheaters addObject:[Theater theaterWithDictionary:[array objectAtIndex:i]]];
    }
    
    return decodedTheaters;
}

- (NSArray*) theaters {
    if (self.theatersData == nil) {
        self.theatersData = [self loadTheaters];
    }
    
    return self.theatersData;
}

- (void) setTheaters:(NSArray*) theaters {
    self.theatersData = theaters;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LAST_FULL_UPDATE_TIME];
    [self updateAddressLocationCache];
}

- (NSArray*) loadFavoriteTheaters {
    NSArray* result = [[NSUserDefaults standardUserDefaults] arrayForKey:FAVORITE_THEATERS];
    if (result == nil) {
        return [NSArray array];
    }
    
    return result;
}

- (void) saveFavoriteTheaters {
    [[NSUserDefaults standardUserDefaults] setObject:self.favoriteTheatersData forKey:FAVORITE_THEATERS];
}

- (void) addFavoriteTheater:(Theater*) theater {
    NSDictionary* dictionary = [theater dictionary];
    
    if (![self.favoriteTheaters containsObject:dictionary]) {
        [self.favoriteTheaters addObject:dictionary];
    }
    
    [self saveFavoriteTheaters];
}

- (NSMutableArray*) favoriteTheaters {
    if (self.favoriteTheatersData == nil) {
        self.favoriteTheatersData = [NSMutableArray arrayWithArray:[self loadFavoriteTheaters]];
    }
    
    return self.favoriteTheatersData;
}

- (BOOL) isFavoriteTheater:(Theater*) theater {
    NSMutableArray* array = [self favoriteTheaters];
    
    for (int i = 0; i < array.count; i++) {
        Theater* currentTheater = [Theater theaterWithDictionary:[array objectAtIndex:i]];
        
        if ([currentTheater.identifier isEqual:theater.identifier]) {
            return YES;
        }
    }
    
    return false;
}

- (void) removeFavoriteTheater:(Theater*) theater {
    NSMutableArray* array = [self favoriteTheaters];
    
    for (int i = 0; i < array.count; i++) {
        Theater* currentTheater = [Theater theaterWithDictionary:[array objectAtIndex:i]];
        
        if ([currentTheater.identifier isEqual:theater.identifier]) {
            [array removeObjectAtIndex:i];
            break;
        }
    }
    
    [self saveFavoriteTheaters];
}

- (UIImage*) posterForMovie:(Movie*) movie {
    return [self.posterCache posterForMovie:movie];
}

- (Location*) locationForAddress:(NSString*) address {
    return [self.addressLocationCache locationForAddress:address];
}

- (Location*) locationForPostalCode:(NSString*) postalCode {
    return [self.addressLocationCache locationForPostalCode:postalCode];
}

- (NSMutableArray*) theatersShowingMovie:(Movie*) movie {
    NSMutableArray* array = [NSMutableArray array];
    
    for (Theater* theater in self.theaters) {
        for (NSString* movieId in theater.movieToShowtimesMap) {
            if ([[movie identifier] isEqual:movieId]) {
                [array addObject:theater];
                break;
            }
        }
    }
    
    return array;
}

- (NSMutableArray*) moviesAtTheater:(Theater*) theater {
    NSMutableArray* array = [NSMutableArray array];
    
    for (Movie* movie in self.movies) {
        if ([theater.movieToShowtimesMap objectForKey:movie.identifier]) {
            [array addObject:movie];
        }
    }
    
    return array;
}

- (NSArray*) movieShowtimes:(Movie*) movie
                 forTheater:(Theater*) theater {
    NSArray* result = [theater.movieToShowtimesMap objectForKey:movie.identifier];
    if (result == nil) {
        return [NSArray array];
    }
    
    return result;
}

- (NSDictionary*) theaterDistanceMap {
    Location* userLocation = [self locationForPostalCode:[self postalCode]];
    return [self.addressLocationCache theaterDistanceMap:userLocation theaters:self.theaters];
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
        
        if (![self tooFarAway:distance]) {
            [result addObject:theater];
        }
    }
    
    return result;
}

NSInteger compareMoviesByRating(id t1, id t2, void *context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    BoxOfficeModel* model = context;
    
    int movieRating1 = [model rankingForMovie:movie1];
    int movieRating2 = [model rankingForMovie:movie2];
    
    if (movieRating1 < movieRating2) {
        return NSOrderedDescending;
    } else if (movieRating1 > movieRating2) {
        return NSOrderedAscending;
    }
    
    return compareMoviesByTitle(t1, t2, context);
}

NSInteger compareMoviesByReleaseDate(id t1, id t2, void *context) {
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

NSInteger compareMoviesByTitle(id t1, id t2, void *context) {
    Movie* movie1 = t1;
    Movie* movie2 = t2;
    
    return [movie1.title compare:movie2.title options:NSCaseInsensitiveSearch];
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
    if ([postalCode isEqual:[self postalCode]]) {
        return;
    }
    
    [self clearLastFullUpdateTime];
    [[NSUserDefaults standardUserDefaults] setObject:postalCode forKey:ZIPCODE];
    
    [self updatePostalCodeAddressLocation];
}

- (Movie*) currentlySelectedMovie {
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTLY_SELECTED_MOVIE];
    if (dict == nil) {
        return nil;
    }
    
    return [Movie movieWithDictionary:dict];
}

- (Theater*) currentlySelectedTheater {
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTLY_SELECTED_THEATER];
    if (dict == nil) {
        return nil;
    }
    
    return [Theater theaterWithDictionary:dict];
}

- (BOOL) currentlyShowingReviews {
    return [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTLY_SHOWING_REVIEWS] != nil;
}

- (void) setCurrentlyShowingReviews {
    [[NSUserDefaults standardUserDefaults] setObject:@""
                                              forKey:CURRENTLY_SHOWING_REVIEWS];
}

- (void) setCurrentlySelectedMovie:(Movie*) movie 
                           theater:(Theater*) theater {
    if (movie == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENTLY_SELECTED_MOVIE];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[movie dictionary]
                                                  forKey:CURRENTLY_SELECTED_MOVIE];
    }
    
    if (theater == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENTLY_SELECTED_THEATER];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[theater dictionary]
                                                  forKey:CURRENTLY_SELECTED_THEATER];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENTLY_SHOWING_REVIEWS];
}

- (void) setSearchDate:(NSDate*) date forIdentifier:(NSString*) identifier {
    NSMutableDictionary* searchDates = [self getSearchDates];    
    [searchDates setObject:date forKey:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:searchDates forKey:SEARCH_DATES];
}

- (NSMutableDictionary*) getSearchResults {
    NSDictionary* result = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SEARCH_RESULTS];
    if (result == nil) {
        return [NSMutableDictionary dictionary];
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:result];
}

- (NSMutableDictionary*) getSearchDates {
    NSDictionary* result = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SEARCH_DATES];
    if (result == nil) {
        return [NSMutableDictionary dictionary];
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:result];
}

- (XmlElement*) getDetails:(NSString*) identifier {
    static BOOL firstTime = YES;
    if (firstTime == YES) {
        firstTime = NO;
        [self clearOldSearchResults];
    }
    
    NSDictionary* searchResults = [self getSearchResults];
    NSDictionary* details = [searchResults objectForKey:identifier];
    
    if (details == nil) {
        return nil;
    }
    
    return [XmlElement elementFromDictionary:details];
}

- (XmlElement*) getPersonDetails:(NSString*) identifier {
    return [self getDetails:[NSString stringWithFormat:@"person-%@", identifier]];
}

- (XmlElement*) getMovieDetails:(NSString*) identifier {
    return [self getDetails:[NSString stringWithFormat:@"movie-%@", identifier]];
}

- (void) setDetails:(NSString*) identifier element:(XmlElement*) element {
    if (element == nil) {
        return;
    }
    
    NSMutableDictionary* searchResults = [self getSearchResults];
    [searchResults setObject:[element dictionary] forKey:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:searchResults forKey:SEARCH_RESULTS];
    [self setSearchDate:[NSDate date] forIdentifier:identifier];
}

- (void) setPersonDetails:(NSString*) identifier element:(XmlElement*) element {
    [self setDetails:[NSString stringWithFormat:@"person-%@", identifier] element:element];
}

- (void) setMovieDetails:(NSString*) identifier element:(XmlElement*) element {
    [self setDetails:[NSString stringWithFormat:@"movie-%@", identifier] element:element];
}

- (void) createMovieMap {
    if (self.movieMap == nil) {
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        
        NSArray* keys = [[self supplementaryInformation] allKeys];
        NSMutableArray* lowercaseKeys = [NSMutableArray array];
        for (NSString* key in keys) {
            [lowercaseKeys addObject:[key lowercaseString]];
        }
        
        for (Movie* movie in self.movies) {
            NSString* lowercaseTitle = [movie.title lowercaseString];
            NSInteger index = [lowercaseKeys indexOfObject:lowercaseTitle];
            if (index == NSNotFound) {
                index = [[Application differenceEngine] findClosestMatchIndex:[movie.title lowercaseString] inArray:lowercaseKeys];
            }
            
            if (index != NSNotFound) {
                NSString* key = [keys objectAtIndex:index];
                [dictionary setObject:[[self supplementaryInformation] objectForKey:key] forKey:movie.title];
            }
        }
        
        self.movieMap = dictionary;
    }
}

- (ExtraMovieInformation*) extraInformationForMovie:(Movie*) movie {
    [self createMovieMap];
    
    return [self.movieMap objectForKey:movie.title];
}

- (NSInteger) rankingForMovie:(Movie*) movie {
    ExtraMovieInformation* extraInfo = [self extraInformationForMovie:movie];
    
    if (extraInfo == nil) {
        return -1;
    }
    
    return [extraInfo rankingValue];
}

- (NSString*) synopsisForMovie:(Movie*) movie {
    ExtraMovieInformation* extraInfo = [self extraInformationForMovie:movie];
    if (extraInfo != nil && extraInfo.synopsis != nil) {
        return extraInfo.synopsis;
    }
    
    if (movie.backupSynopsis != nil) {
        return movie.backupSynopsis;
    }
    
    return NSLocalizedString(@"No synopsis available.", nil);
}

- (NSArray*) trailersForMovie:(Movie*) movie {
    return [trailerCache trailersForMovie:movie];
}

- (NSArray*) reviewsForMovie:(Movie*) movie {
    ExtraMovieInformation* extraInfo = [self extraInformationForMovie:movie];
    if (extraInfo == nil) {
        return [NSArray array];
    }
    
    return [reviewCache reviewsForMovie:extraInfo.title];
}

- (void) applicationWillTerminate {
    [trailerCache applicationWillTerminate];
    [reviewCache applicationWillTerminate];
}

- (NSString*) noLocationInformationFound {
    if ([Utilities isNilOrEmpty:[self postalCode]]) {
        return NSLocalizedString(@"Please enter a postal code", nil);
    } else {
        return NSLocalizedString(@"No information found", nil);
    }
}

@end
    