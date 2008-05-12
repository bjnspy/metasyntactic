//
//  BoxOfficeModel.m
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "Movie.h"
#import "Theater.h"
#import "DifferenceEngine.h"

@implementation BoxOfficeModel

@synthesize posterCache;
@synthesize addressLocationCache;
@synthesize backgroundTaskCount;
@synthesize activityView;

- (void) dealloc {
	self.posterCache.model = nil;
    self.posterCache = nil;
	
	self.addressLocationCache.model = nil;
    self.addressLocationCache = nil;
	
	self.activityView = nil;
    [super dealloc];
}

+ (BoxOfficeModel*) model {
    return [[[BoxOfficeModel alloc] init] autorelease];
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

- (id) init {
    if (self = [super init]) {
        self.posterCache = [PosterCache cacheWithModel:self];
        self.addressLocationCache = [AddressLocationCache cacheWithModel:self];
		self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleBlueSmall] autorelease];
        backgroundTaskCount = 0;
		
        [self updatePosterCache];
        [self updateAddressLocationCache];
        [self updateZipcodeAddressLocation];
    }
    
    return self;
}

- (void) addBackgroundTask {
	backgroundTaskCount++;
	
	if (backgroundTaskCount == 1) {
		[self.activityView startAnimating];
	}
}

- (void) removeBackgroundTask {
	backgroundTaskCount--;
	
	if (backgroundTaskCount == 0) {
		[self.activityView stopAnimating];
	}
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
    NSString* result = [[NSUserDefaults standardUserDefaults] stringForKey:@"zipCode"];
    if (result == nil) {
        result =  @"";
    }
    
    return result;
}

- (void) setZipcode:(NSString*) zipcode {
    if ([zipcode isEqual:[self zipcode]]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:zipcode forKey:@"zipCode"];
    
    [self updateZipcodeAddressLocation];
}

- (int) searchRadius {
    return MAX(5, [[NSUserDefaults standardUserDefaults] integerForKey:@"searchRadius"]);
}

- (void) setSearchRadius:(NSInteger) searchRadius {
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:@"searchRadius"];
}

- (NSArray*) movies {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"movies"];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"movies"];
    
    [self updatePosterCache];
}

- (NSArray*) theaters {
    NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"theaters"];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"theaters"];
    
    [self updateAddressLocationCache];
}

- (XmlElement*) tickets {
    NSDictionary* dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tickets"];
    if (dictionary == nil) {
        return nil;
    }
    
    return [XmlElement elementFromDictionary:dictionary];
}

- (void) setTickets:(XmlElement*) tickets {
    [[NSUserDefaults standardUserDefaults] setObject:[tickets dictionary] forKey:@"tickets"];
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
    
    DifferenceEngine* engine = [DifferenceEngine engine];
    
    for (Theater* theater in self.theaters) {
        for (NSString* movieName in theater.movieToShowtimesMap) {
            if ([[theater.movieToShowtimesMap objectForKey:movieName] count] == 0) {
                continue;
            }
            
            if ([engine similar:movie.title other:movieName]) {
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
            
            if ([DifferenceEngine areSimilar:movie.title other:movieName]) {
                [array addObject:movie];
                break;
            }
        }
    }
    
    return array;
}

- (NSArray*) movieShowtimes:(Movie*) movie
                 forTheater:(Theater*) theater {
    
    DifferenceEngine* engine = [DifferenceEngine engine];
    
    NSString* bestName = nil;
    NSInteger bestDistance = NSIntegerMax;
    
    for (NSString* name in [theater.movieToShowtimesMap allKeys]) {
        NSInteger distance = [engine editDistanceFrom:name to:movie.title];
        if (distance < bestDistance) {
            bestDistance = distance;
            bestName = name;
        }
    }
    
    if ([engine similar:bestName other:movie.title]) {
        return [theater.movieToShowtimesMap objectForKey:bestName];
    }
    
    return [NSArray array];
}

- (NSDictionary*) theaterDistanceMap {
    Location* userLocation = [self locationForZipcode:[self zipcode]];
    
    NSMutableDictionary* theaterDistanceMap = [NSMutableDictionary dictionary];
    for (Theater* theater in self.theaters) {
        double d;
        if (userLocation != nil) {
            d = [userLocation distanceTo:[self locationForAddress:theater.address]];
        } else {
            d = UNKNOWN_DISTANCE;
        }
        
        NSNumber* value = [NSNumber numberWithDouble:d];
        NSString* key = theater.address;
        [theaterDistanceMap setObject:value forKey:key];
    }    
    
    return theaterDistanceMap;
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

@end
    