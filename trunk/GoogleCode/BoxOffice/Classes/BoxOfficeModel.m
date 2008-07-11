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

@implementation BoxOfficeModel

static NSString* LAST_QUICK_UPDATE_TIME = @"lastQuickUpdateTime";
static NSString* LAST_FULL_UPDATE_TIME = @"lastFullUpdateTime";
static NSString* SEARCH_DATES_STRING = @"searchDates";
static NSString* SEARCH_RESULTS_STRING = @"searchResults";
static NSString* SEARCH_RADIUS_STRING = @"searchRadius";
static NSString* MOVIES_STRING = @"movies";
static NSString* THEATERS_STRING = @"theaters";
static NSString* ZIPCODE_STRING = @"zipcode";
static NSString* SUPPLEMENTARY_DATA = @"supplementaryData";
static NSString* CURRENTLY_SELECTED_MOVIE_STRING = @"currentlySelectedMovie";
static NSString* CURRENTLY_SELECTED_THEATER_STRING = @"currentlySelectedTheater";

@synthesize notificationCenter;
@synthesize posterCache;
@synthesize trailerCache;
@synthesize addressLocationCache;
@synthesize backgroundTaskCount;
@synthesize activityView;
@synthesize activityIndicatorView;

@synthesize moviesData;
@synthesize theatersData;
@synthesize supplementaryInformationData;
@synthesize movieMap;

- (void) dealloc {
    self.notificationCenter = nil;
    self.trailerCache = nil;
    self.posterCache = nil;
    self.addressLocationCache = nil;
    self.activityView = nil;
    self.activityIndicatorView = nil;
    
    self.moviesData = nil;
    self.theatersData = nil;
    self.supplementaryInformationData = nil;
    self.movieMap = nil;
    
    [super dealloc];
}

- (void) updatePosterCache {
    [self.posterCache update:self.movies];
}

- (void) updateTrailerCache {
    [self.trailerCache update:self.movies];
}

- (void) updateAddressLocationCache {
    NSMutableArray* addresses = [NSMutableArray array];
    
    for (Theater* theater in self.theaters) {
        [addresses addObject:theater.address];
    }
    
    [self.addressLocationCache updateAddresses:addresses];
}

- (void) updateZipcodeAddressLocation {
    [self.addressLocationCache updateZipcode:self.zipcode];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:searchDates forKey:SEARCH_DATES_STRING];
    [[NSUserDefaults standardUserDefaults] setObject:searchResults forKey:SEARCH_RESULTS_STRING];
}

- (id) initWithCenter:(NotificationCenter*) notificationCenter_ {
    if (self = [super init]) {
        self.notificationCenter = notificationCenter_;
        self.posterCache = [PosterCache cache];
        self.trailerCache = [TrailerCache cache];
        self.addressLocationCache = [AddressLocationCache cache];
        
        self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGRect frame = self.activityIndicatorView.frame;
        frame.size.width += 15;
        
        self.activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
        [self.activityView addSubview:self.activityIndicatorView];
        
        backgroundTaskCount = 0;
        searchRadius = -1;
        
        [self updatePosterCache];
        [self updateAddressLocationCache];
        [self updateZipcodeAddressLocation];
        [self updateTrailerCache];
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
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTabBarViewControllerIndex"];
}

- (void) setSelectedTabBarViewControllerIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selectedTabBarViewControllerIndex"];
}

- (NSInteger) allMoviesSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"allMoviesSelectedSegmentIndex"];
}

- (void) setAllMoviesSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"allMoviesSelectedSegmentIndex"];
}

- (NSInteger) allTheatersSelectedSegmentIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"allTheatersSelectedSegmentIndex"];
}

- (void) setAllTheatersSelectedSegmentIndex:(NSInteger) index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"allTheatersSelectedSegmentIndex"];
}

- (NSString*) zipcode {
    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:ZIPCODE_STRING];
    if (result == nil) {
        result =  @"";
    }
    
    return result;
}

- (int) searchRadius {
    if (searchRadius == -1) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_RADIUS_STRING]) {
            searchRadius = 5;
        } else {
            searchRadius = MAX(5, [[NSUserDefaults standardUserDefaults] integerForKey:SEARCH_RADIUS_STRING]);
        }
    }
 
    return searchRadius;
}

- (void) setSearchRadius:(NSInteger) radius {
    searchRadius = radius;
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:SEARCH_RADIUS_STRING];
}

- (NSArray*) loadMovies {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:MOVIES_STRING];
    if (array == nil) {
        return [NSArray array];
    }
    
    NSMutableArray* decodedMovies = [NSMutableArray array];
    
    for (int i = 0; i < [array count]; i++) {
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

- (void) saveMovies:(NSArray*) movies {
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [movies count]; i++) {
        [array addObject:[[movies objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:MOVIES_STRING];
    
    [self updatePosterCache];
    [self updateTrailerCache];
}

- (void) setMovies:(NSArray*) movies {    
    self.moviesData = movies;
    [self saveMovies:movies];
    
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
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:THEATERS_STRING];
    if (array == nil) {
        return [NSArray array];
    }
    
    NSMutableArray* decodedTheaters = [NSMutableArray array];
    
    for (int i = 0; i < [array count]; i++) {
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

- (void) saveTheaters:(NSArray*) theaters {
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [theaters count]; i++) {
        [array addObject:[[theaters objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:THEATERS_STRING];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:LAST_FULL_UPDATE_TIME];
        
    [self updateAddressLocationCache];
}

- (void) setTheaters:(NSArray*) theaters {
    self.theatersData = theaters;
    [self saveTheaters:theaters];
}

- (UIImage*) posterForMovie:(Movie*) movie {
    return [self.posterCache posterForMovie:movie];
}

- (Location*) locationForAddress:(NSString*) address {
    return [self.addressLocationCache locationForAddress:address];
}

- (Location*) locationForZipcode:(NSString*) zipcode {
    return [self.addressLocationCache locationForZipcode:zipcode];
}

- (NSArray*) theatersShowingMovie:(Movie*) movie {
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

- (NSArray*) moviesAtTheater:(Theater*) theater {
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
    Location* userLocation = [self locationForZipcode:[self zipcode]];
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

- (void) setZipcode:(NSString*) zipcode {
    if ([zipcode isEqual:[self zipcode]]) {
        return;
    }
    
    [self clearLastFullUpdateTime];
    [[NSUserDefaults standardUserDefaults] setObject:zipcode forKey:ZIPCODE_STRING];
    
    [self updateZipcodeAddressLocation];
}

- (Movie*) currentlySelectedMovie {
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTLY_SELECTED_MOVIE_STRING];
    if (dict == nil) {
        return nil;
    }
    
    return [Movie movieWithDictionary:dict];
}

- (Theater*) currentlySelectedTheater {
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTLY_SELECTED_THEATER_STRING];
    if (dict == nil) {
        return nil;
    }
    
    return [Theater theaterWithDictionary:dict];
}

- (void) setCurrentlySelectedMovie:(Movie*) movie 
                           theater:(Theater*) theater {
    if (movie == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENTLY_SELECTED_MOVIE_STRING];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[movie dictionary]
                                                  forKey:CURRENTLY_SELECTED_MOVIE_STRING];
    }
    
    if (theater == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENTLY_SELECTED_THEATER_STRING];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[theater dictionary]
                                                  forKey:CURRENTLY_SELECTED_THEATER_STRING];
    }
}

- (void) setSearchDate:(NSDate*) date forIdentifier:(NSString*) identifier {
    NSMutableDictionary* searchDates = [self getSearchDates];    
    [searchDates setObject:date forKey:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:searchDates forKey:SEARCH_DATES_STRING];
}

- (NSMutableDictionary*) getSearchResults {
    NSDictionary* result = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SEARCH_RESULTS_STRING];
    if (result == nil) {
        return [NSMutableDictionary dictionary];
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:result];
}

- (NSMutableDictionary*) getSearchDates {
    NSDictionary* result = [[NSUserDefaults standardUserDefaults] dictionaryForKey:SEARCH_DATES_STRING];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:searchResults forKey:SEARCH_RESULTS_STRING];
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
        NSMutableArray* movieTitles = [NSMutableArray array];
        
        for (Movie* movie in self.movies) {
            [movieTitles addObject:movie.title];
        }
        
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        
        for (NSString* key in [self supplementaryInformation]) {
            NSString* movieTitle = [[Application differenceEngine] findClosestMatch:key inArray:movieTitles];
            
            if (movieTitle != nil) {
                [dictionary setObject:[[self supplementaryInformation] objectForKey:key]
                               forKey:movieTitle];
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

@end
    