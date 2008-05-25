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

@implementation BoxOfficeModel

static NSString* SEARCH_DATES_STRING = @"searchDates";
static NSString* SEARCH_RESULTS_STRING = @"searchResults";
static NSString* SEARCH_RADIUS_STRING = @"searchRadius";
static NSString* MOVIES_STRING = @"movies";
static NSString* THEATERS_STRING = @"theaters";
static NSString* ZIPCODE_STRING = @"zipcode";
static NSString* CURRENTLY_SELECTED_MOVIE_STRING = @"currentlySelectedMovie";
static NSString* CURRENTLY_SELECTED_THEATER_STRING = @"currentlySelectedTheater";

@synthesize notificationCenter;
@synthesize posterCache;
@synthesize addressLocationCache;
@synthesize backgroundTaskCount;
@synthesize activityView;
@synthesize activityIndicatorView;
@synthesize ticketsElement;

- (void) dealloc {
    self.notificationCenter = nil;
    self.posterCache = nil;
    self.addressLocationCache = nil;
    
    self.activityIndicatorView = nil;
    self.activityView = nil;
    
    self.ticketsElement = nil;
    
    [super dealloc];
}

- (void) updatePosterCache {
    [self.posterCache update:self.movies];
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
        self.addressLocationCache = [AddressLocationCache cache];
        
        self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleBlueSmall] autorelease];
        CGRect frame = self.activityIndicatorView.frame;
        frame.size.width += 15;
        
        self.activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
        [self.activityView addSubview:self.activityIndicatorView];
        
        backgroundTaskCount = 0;
        searchRadius = -1;
        
        [self updatePosterCache];
        [self updateAddressLocationCache];
        [self updateZipcodeAddressLocation];
        [self clearOldSearchResults];
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
        searchRadius = MAX(5, [[NSUserDefaults standardUserDefaults] integerForKey:SEARCH_RADIUS_STRING]);
    }
 
    return searchRadius;
}

- (void) setSearchRadius:(NSInteger) radius {
    searchRadius = radius;
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:SEARCH_RADIUS_STRING];
}

- (NSArray*) movies {
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

- (void) setMovies:(NSArray*) movies {    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [movies count]; i++) {
        [array addObject:[[movies objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:MOVIES_STRING];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastMoviesUpdateTime"];
    
    [self updatePosterCache];
}

- (NSDate*) lastMoviesUpdateTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastMoviesUpdateTime"];
}

- (void) clearLastMoviesUpdateTime {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastMoviesUpdateTime"];
}

- (NSArray*) theaters {
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

- (void) setTheaters:(NSArray*) theaters {
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0; i < [theaters count]; i++) {
        [array addObject:[[theaters objectAtIndex:i] dictionary]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:THEATERS_STRING];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastTheatersUpdateTime"];
        
    [self updateAddressLocationCache];
}

- (NSDate*) lastTheatersUpdateTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTheatersUpdateTime"];
}

- (void) clearLastTheatersUpdateTime {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastTheatersUpdateTime"];
}

- (XmlElement*) tickets {
    if (self.ticketsElement == nil) {
        NSDictionary* dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tickets"];

        if (dictionary != nil) {
            self.ticketsElement = [XmlElement elementFromDictionary:dictionary];
        }
    }
    
    return self.ticketsElement;
}

- (void) setTickets:(XmlElement*) tickets {
    self.ticketsElement = tickets;
    [[NSUserDefaults standardUserDefaults] setObject:[tickets dictionary] forKey:@"tickets"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastTicketsUpdateTime"];
}

- (NSDate*) lastTicketsUpdateTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTicketsUpdateTime"];
}

- (void) clearLastTicketsUpdateTime {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastTicketsUpdateTime"];
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
        for (NSString* movieName in theater.movieToShowtimesMap) {
            if ([[theater.movieToShowtimesMap objectForKey:movieName] count] == 0) {
                continue;
            }
            
            if ([[Application differenceEngine] similar:movie.title other:movieName]) {
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
        for (NSString* movieName in theater.movieToShowtimesMap) {
            if ([[theater.movieToShowtimesMap objectForKey:movieName] count] == 0) {
                continue;
            }
            
            if ([[Application differenceEngine] similar:movie.title other:movieName]) {
                [array addObject:movie];
                break;
            }
        }
    }
    
    return array;
}

- (NSArray*) movieShowtimes:(Movie*) movie
                 forTheater:(Theater*) theater {
    NSString* bestName = nil;
    NSInteger bestDistance = NSIntegerMax;
    
    for (NSString* name in [theater.movieToShowtimesMap allKeys]) {
        NSInteger distance = [[Application differenceEngine] editDistanceFrom:name to:movie.title];
        if (distance < bestDistance) {
            bestDistance = distance;
            bestName = name;
        }
    }
    
    if ([[Application differenceEngine] similar:bestName other:movie.title]) {
        return [theater.movieToShowtimesMap objectForKey:bestName];
    }
    
    return [NSArray array];
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
    
    [self clearLastTheatersUpdateTime];
    [self clearLastTicketsUpdateTime];
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

@end
    