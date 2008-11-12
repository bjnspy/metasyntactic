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

#import "AbstractDataProvider.h"

#import "Application.h"
#import "DateUtilities.h"
#import "FavoriteTheater.h"
#import "FileUtilities.h"
#import "Location.h"
#import "LookupResult.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "Performance.h"
#import "Theater.h"
#import "ThreadingUtilities.h"
#import "UserLocationCache.h"

@interface AbstractDataProvider()
@property (retain) NSLock* gate;
@property (retain) NowPlayingModel* model;
@property (retain) NSArray* moviesData;
@property (retain) NSArray* theatersData;
@property (retain) NSDictionary* synchronizationInformationData;
@property (retain) NSMutableDictionary* performancesData;
@end


@implementation AbstractDataProvider

@synthesize gate;
@synthesize model;
@synthesize moviesData;
@synthesize theatersData;
@synthesize performancesData;
@synthesize synchronizationInformationData;

- (void) dealloc {
    self.gate = nil;
    self.model = nil;
    self.moviesData = nil;
    self.theatersData = nil;
    self.performancesData = nil;
    self.synchronizationInformationData = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
        self.model = model_;
        self.performancesData = [NSMutableDictionary dictionary];
    }

    return self;
}


- (NSString*) performancesDirectory {
    return [[Application dataDirectory] stringByAppendingPathComponent:@"Performances"];
}


- (NSString*) locationFile {
    return [[Application dataDirectory] stringByAppendingPathComponent:@"Location.plist"];
}


- (NSString*) moviesFile {
    return [[Application dataDirectory] stringByAppendingPathComponent:@"Movies.plist"];
}


- (NSString*) theatersFile {
    return [[Application dataDirectory] stringByAppendingPathComponent:@"Theaters.plist"];
}


- (NSString*) synchronizationInformationFile {
    return [[Application dataDirectory] stringByAppendingPathComponent:@"Synchronization.plist"];
}


- (NSString*) lastLookupDateFile {
    return [[Application dataDirectory] stringByAppendingPathComponent:@"lastLookupDate"];
}


- (NSDate*) lastLookupDate {
    NSDate* lastLookupDate = [FileUtilities modificationDate:[self lastLookupDateFile]];
    return lastLookupDate;
}


- (void) setLastLookupDate {
    [FileUtilities writeObject:@"" toFile:[self lastLookupDateFile]];
}


- (void) setStale {
    [FileUtilities removeItem:[self lastLookupDateFile]];
}
    
    
- (Location*) searchLocation {
    return [Location locationWithDictionary:[FileUtilities readObject:self.locationFile]];
}


- (NSArray*) loadMovies {
    NSArray* array = [FileUtilities readObject:self.moviesFile];
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
    if (moviesData == nil) {
        self.moviesData = [self loadMovies];
    }

    return moviesData;
}


- (NSDictionary*) loadSynchronizationInformation {
    NSDictionary* result = [FileUtilities readObject:self.synchronizationInformationFile];
    if (result.count == 0) {
        return [NSDictionary dictionary];
    }
    return result;
}


- (NSDictionary*) synchronizationInformation {
    if (synchronizationInformationData == nil) {
        self.synchronizationInformationData = [self loadSynchronizationInformation];
    }
    return synchronizationInformationData;
}


- (void) saveArray:(NSArray*) array to:(NSString*) file {
    NSMutableArray* encoded = [NSMutableArray array];

    for (id object in array) {
        [encoded addObject:[object dictionary]];
    }

    [FileUtilities writeObject:encoded toFile:file];
}


- (NSString*) performancesFile:(NSString*) theaterName parentDirectory:(NSString*) directory {
    return [[directory stringByAppendingPathComponent:[FileUtilities sanitizeFileName:theaterName]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) performancesFile:(NSString*) theaterName {
    return [self performancesFile:theaterName parentDirectory:self.performancesDirectory];
}


- (void) saveResult:(LookupResult*) result {
    if (result.movies.count > 0 || result.theaters.count > 0) {
        [self saveArray:result.movies to:self.moviesFile];
        [self saveArray:result.theaters to:self.theatersFile];
        
        [FileUtilities writeObject:result.location.dictionary toFile:self.locationFile];
        [FileUtilities writeObject:result.synchronizationInformation toFile:self.synchronizationInformationFile];

        NSString* tempDirectory = [Application uniqueTemporaryDirectory];
        for (NSString* theaterName in result.performances) {
            NSMutableDictionary* value = [result.performances objectForKey:theaterName];

            [FileUtilities writeObject:value toFile:[self performancesFile:theaterName parentDirectory:tempDirectory]];
        }

        [FileUtilities removeItem:self.performancesDirectory];
        [FileUtilities moveItem:tempDirectory to:self.performancesDirectory];

        [self setLastLookupDate];
    }
}


- (NSMutableDictionary*) lookupTheaterPerformances:(Theater*) theater {
    NSMutableDictionary* theaterPerformances = [performancesData objectForKey:theater.name];
    if (theaterPerformances == nil) {
        theaterPerformances = [NSMutableDictionary dictionaryWithDictionary:
                               [FileUtilities readObject:[self performancesFile:theater.name]]];
        [self.performancesData setObject:theaterPerformances forKey:theater.name];
    }
    return theaterPerformances;
}


- (NSArray*) moviePerformances:(Movie*) movie
                    forTheater:(Theater*) theater {
    NSMutableDictionary* theaterPerformances = [self lookupTheaterPerformances:theater];

    NSArray* unsureArray = [theaterPerformances objectForKey:movie.canonicalTitle];
    if (unsureArray.count == 0) {
        return [NSArray array];
    }

    if ([[unsureArray objectAtIndex:0] isKindOfClass:[Performance class]]) {
        return unsureArray;
    }

    NSMutableArray* decodedArray = [NSMutableArray array];
    for (NSDictionary* encodedPerformance in unsureArray) {
        [decodedArray addObject:[Performance performanceWithDictionary:encodedPerformance]];
    }

    [theaterPerformances setObject:decodedArray forKey:movie.canonicalTitle];
    return decodedArray;
}


- (NSArray*) loadTheaters {
    NSArray* array = [FileUtilities readObject:self.theatersFile];
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
    if (theatersData == nil) {
        self.theatersData = [self loadTheaters];
    }

    return theatersData;
}


- (LookupResult*) lookupLocation:(Location*) location
                  filterTheaters:(NSArray*) filterTheater {
    NSAssert(false, @"Someone improperly subclassed!");
    return nil;
}


- (BOOL)        results:(LookupResult*) lookupResult
       containsFavorite:(FavoriteTheater*) favorite {
    for (Theater* theater in lookupResult.theaters) {
        if ([theater.name isEqual:favorite.name]) {
            return YES;
        }
    }

    return NO;
}


- (void) addMissingMoviesFromPerformances:(NSDictionary*) performances
                                 toResult:(LookupResult*) lookupResult
              skippingExistingMovieTitles:(NSMutableSet*) existingMovieTitles
                               withMovies:(NSArray*) currentMovies {
    for (NSString* movieTitle in performances.allKeys) {
        if (![existingMovieTitles containsObject:movieTitle]) {
            [existingMovieTitles addObject:movieTitle];
            
            for (Movie* movie in currentMovies) {
                if ([movie.canonicalTitle isEqual:movieTitle]) {
                    [lookupResult.movies addObject:movie];
                    break;
                }
            }
        }
    }
}


- (void) updateMissingFavorites:(LookupResult*) lookupResult {
    if (lookupResult == nil) {
        return;
    }

    NSArray* favoriteTheaters = self.model.favoriteTheaters;
    if (favoriteTheaters.count == 0) {
        return;
    }

    MultiDictionary* locationToMissingTheaterNames = [MultiDictionary dictionary];

    for (FavoriteTheater* favorite in favoriteTheaters) {
        if (![self results:lookupResult containsFavorite:favorite]) {
            [locationToMissingTheaterNames addObject:favorite.name forKey:favorite.originatingLocation];
        }
    }

    NSMutableSet* existingMovieTitles = [NSMutableSet set];
    for (Movie* movie in lookupResult.movies) {
        [existingMovieTitles addObject:movie.canonicalTitle];
    }

    for (Location* location in locationToMissingTheaterNames.allKeys) {
        NSArray* theaterNames = [locationToMissingTheaterNames objectsForKey:location];
        LookupResult* favoritesLookupResult = [self lookupLocation:location
                                                    filterTheaters:theaterNames];

        if (favoritesLookupResult == nil) {
            continue;
        }

        [lookupResult.theaters addObjectsFromArray:favoritesLookupResult.theaters];
        [lookupResult.performances addEntriesFromDictionary:favoritesLookupResult.performances];
        [lookupResult.synchronizationInformation addEntriesFromDictionary:favoritesLookupResult.synchronizationInformation];

        // the theater may refer to movies that we don't know about.
        for (NSString* theaterName in favoritesLookupResult.performances.allKeys) {
            // the theater may refer to movies that we don't know about.
            [self addMissingMoviesFromPerformances:[favoritesLookupResult.performances objectForKey:theaterName]
                                          toResult:lookupResult
                       skippingExistingMovieTitles:existingMovieTitles
                                        withMovies:favoritesLookupResult.movies];
        }
    }
}


- (BOOL) tooSoon:(NSDate*) lastDate {
    if (lastDate == nil) {
        return NO;
    }

    NSDate* now = [NSDate date];

    if (![DateUtilities isSameDay:now date:lastDate]) {
        // different days. we definitely need to refresh
        return NO;
    }

    NSDateComponents* lastDateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:lastDate];
    NSDateComponents* nowDateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:now];

    // same day, check if they're at least 8 hours apart.
    if (nowDateComponents.hour >= (lastDateComponents.hour + 8)) {
        return NO;
    }

    // it's been less than 8 hours. it's too soon to refresh
    return YES;
}


- (void) update {
    NSArray* arguments = [NSArray arrayWithObjects:self.movies, self.theaters, nil];
    [ThreadingUtilities performSelector:@selector(updateBackgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:arguments
                                   gate:gate
                                visible:YES];
}


- (void) addMissingData:(LookupResult*) lookupResult
         searchLocation:(Location*) searchLocation
          currentMovies:(NSArray*) currentMovies
        currentTheaters:(NSArray*) currentTheaters {
    Location* lastSearchLocation = self.searchLocation;
    if (lastSearchLocation == nil) {
        return;
    }

    // Ok.  so if:
    //   a) the user is the user is doing their main search
    //   b) we do not find data for a theater that should be showing up
    //   c) they're close enough to their last search
    // then we want to give them the old information we have for that
    // theater *as well as* a warning to let them know that it may be
    // out of date.
    //
    // This is to deal with the case where the user is confused because
    // a theater they care about has been filtered out because it didn't
    // report showtimes.
    if ([searchLocation distanceToMiles:lastSearchLocation] > 20) {
        // Not close enough.  Consider this a brand new search in a new
        // location.  Don't include any old theaters.
        return;
    }

    NSMutableSet* existingMovieTitles = [NSMutableSet set];
    for (Movie* movie in lookupResult.movies) {
        [existingMovieTitles addObject:movie.canonicalTitle];
    }
    
    NSMutableSet* missingTheaters = [NSMutableSet setWithArray:currentTheaters];
    [missingTheaters minusSet:[NSSet setWithArray:lookupResult.theaters]];
    
    for (Theater* theater in missingTheaters) {
        // no showtime information available.  fallback to anything we've
        // stored (but warn the user).
        NSString* theaterName = theater.name;
        NSString* performancesFile = [self performancesFile:theaterName];
        NSDictionary* oldPerformances = [FileUtilities readObject:performancesFile];
        
        if (oldPerformances == nil) {
            continue;
        }
                
        [lookupResult.performances setObject:oldPerformances forKey:theaterName];
        [lookupResult.synchronizationInformation setObject:[self synchronizationDateForTheater:theaterName] forKey:theaterName];
        [lookupResult.theaters addObject:theater];
        
        // the theater may refer to movies that we don't know about.
        [self addMissingMoviesFromPerformances:oldPerformances
                                      toResult:lookupResult
                   skippingExistingMovieTitles:existingMovieTitles
                                    withMovies:currentMovies];
    }
}


- (void) updateBackgroundEntryPoint:(NSArray*) arguments {
    if (model.userAddress.length == 0) {
        return;
    }

    if ([self tooSoon:self.lastLookupDate]) {
        return;
    }
            

    Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:self.model.userAddress];
    if (location == nil) {
        return;
    }
    
    // Do the primary search.
    LookupResult* result = [self lookupLocation:location filterTheaters:nil];

    // Try to restore any theaters that went missing
    [self addMissingData:result
          searchLocation:location
           currentMovies:[arguments objectAtIndex:0]
         currentTheaters:[arguments objectAtIndex:1]];

    // Lookup data for the users' favorites.
    [self updateMissingFavorites:result];

    // Save the results.
    [self saveResult:result];

    // Let the rest of the app know about the results.
    [self performSelectorOnMainThread:@selector(reportResult:)
                           withObject:result
                        waitUntilDone:NO];
}


- (void) reportResult:(LookupResult*) result {
    if (result.movies.count > 0 || result.theaters.count > 0) {
        self.moviesData = result.movies;
        self.theatersData = result.theaters;
        self.synchronizationInformationData = result.synchronizationInformation;
        self.performancesData = [NSMutableDictionary dictionary];
        [self.model onDataProviderUpdated];
        [NowPlayingAppDelegate refresh:YES];
    }
}


- (NSDate*) synchronizationDateForTheater:(NSString*) theaterName {
    return [self.synchronizationInformation objectForKey:theaterName];
}

@end