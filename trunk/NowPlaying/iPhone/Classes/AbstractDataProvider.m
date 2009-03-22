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
#import "DataProviderUpdateDelegate.h"
#import "DateUtilities.h"
#import "FavoriteTheater.h"
#import "FileUtilities.h"
#import "Location.h"
#import "LookupRequest.h"
#import "LookupResult.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "NotificationCenter.h"
#import "AppDelegate.h"
#import "Model.h"
#import "OperationQueue.h"
#import "Performance.h"
#import "Theater.h"
#import "UserLocationCache.h"

@interface AbstractDataProvider()
@property (retain) NSLock* gate;
@property (retain) Model* model;
@property (retain) NSArray* moviesData;
@property (retain) NSArray* theatersData;
@property (retain) NSDictionary* synchronizationInformationData;
@property (retain) NSMutableDictionary* performancesData;
@property (retain) NSMutableDictionary* bookmarksData;
@end


@implementation AbstractDataProvider

@synthesize gate;
@synthesize model;
@synthesize moviesData;
@synthesize theatersData;
@synthesize performancesData;
@synthesize synchronizationInformationData;
@synthesize bookmarksData;

- (void) dealloc {
    self.gate = nil;
    self.model = nil;
    self.moviesData = nil;
    self.theatersData = nil;
    self.performancesData = nil;
    self.synchronizationInformationData = nil;
    self.bookmarksData = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
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
    return [FileUtilities modificationDate:[self lastLookupDateFile]];
}


- (void) setLastLookupDate {
    [FileUtilities writeObject:@"" toFile:[self lastLookupDateFile]];
}


- (void) markOutOfDate {
    [Application moveItemToTrash:[self lastLookupDateFile]];
}


- (NSArray*) loadMovies:(NSString*) file {
    NSArray* array = [FileUtilities readObject:file];
    return [Movie decodeArray:array];
}


- (NSArray*) loadMovies {
    return [self loadMovies:self.moviesFile];
}


- (NSArray*) movies {
    if (moviesData == nil) {
        self.moviesData = [self loadMovies];
    }

    return moviesData;
}


- (NSMutableDictionary*) loadBookmarks {
    NSArray* movies = [model bookmarkedMovies];
    if (movies.count == 0) {
        return [NSMutableDictionary dictionary];
    }

    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    for (Movie* movie in movies) {
        [result setObject:movie forKey:movie.canonicalTitle];
    }
    return result;
}


- (NSMutableDictionary*) bookmarks {
    if (bookmarksData == nil) {
        self.bookmarksData = [self loadBookmarks];
    }

    return bookmarksData;
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
    NSAssert(![NSThread isMainThread], nil);

    NSString* tempDirectory = [Application uniqueTemporaryDirectory];
    for (NSString* theaterName in result.performances) {
        NSMutableDictionary* value = [result.performances objectForKey:theaterName];

        [FileUtilities writeObject:value toFile:[self performancesFile:theaterName parentDirectory:tempDirectory]];
    }

    [Application moveItemToTrash:self.performancesDirectory];
    [FileUtilities moveItem:tempDirectory to:self.performancesDirectory];

    [FileUtilities writeObject:[Movie encodeArray:result.movies] toFile:self.moviesFile];
    [self saveArray:result.theaters to:self.theatersFile];

    [FileUtilities writeObject:result.synchronizationInformation toFile:self.synchronizationInformationFile];

    // Do this last.  It signifies that we are done
    [self setLastLookupDate];

    // Let the rest of the app know about the results.
    [self performSelectorOnMainThread:@selector(reportResult:)
                           withObject:result
                        waitUntilDone:NO];
}


- (NSMutableDictionary*) lookupTheaterPerformances:(Theater*) theater {
    NSMutableDictionary* theaterPerformances = [performancesData objectForKey:theater.name];
    if (theaterPerformances == nil) {
        theaterPerformances = [NSMutableDictionary dictionaryWithDictionary:
                               [FileUtilities readObject:[self performancesFile:theater.name]]];
        [performancesData setObject:theaterPerformances
                             forKey:theater.name];
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
        Performance* performance = [Performance performanceWithDictionary:encodedPerformance];

        [decodedArray addObject:performance];
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
                      searchDate:(NSDate*) searchDate
                    theaterNames:(NSArray*) theaterNames {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
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


- (void) updateMissingFavorites:(LookupResult*) lookupResult
                     searchDate:(NSDate*) searchDate {
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
                                                        searchDate:searchDate
                                                      theaterNames:theaterNames];

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


- (void) update:(NSDate*) searchDate
       delegate:(id<DataProviderUpdateDelegate>) delegate
        context:(id) context
          force:(BOOL) force {
    LookupRequest* request = [LookupRequest requestWithSearchDate:searchDate
                                                         delegate:delegate
                                                          context:context
                                                            force:force
                                                    currentMovies:self.movies
                                                  currentTheaters:self.theaters];

    [[AppDelegate operationQueue] performSelector:@selector(updateBackgroundEntryPoint:)
                                         onTarget:self
                                       withObject:request
                                             gate:gate
                                          visible:YES];


}


- (void) addMissingTheaters:(LookupResult*) lookupResult
             searchLocation:(Location*) searchLocation
              currentMovies:(NSArray*) currentMovies
            currentTheaters:(NSArray*) currentTheaters {
    // Ok.  so if:
    //   a) the user is doing their main search
    //   b) we do not find data for a theater that should be showing up
    //   c) they're close enough to their last search
    // then we want to give them the old information we have for that
    // theater* as well as* a warning to let them know that it may be
    // out of date.
    //
    // This is to deal with the case where the user is confused because
    // a theater they care about has been filtered out because it didn't
    // report showtimes.

    NSMutableSet* existingMovieTitles = [NSMutableSet set];
    for (Movie* movie in lookupResult.movies) {
        [existingMovieTitles addObject:movie.canonicalTitle];
    }

    NSMutableSet* missingTheaters = [NSMutableSet setWithArray:currentTheaters];
    [missingTheaters minusSet:[NSSet setWithArray:lookupResult.theaters]];

    for (Theater* theater in missingTheaters) {
        if ([theater.location distanceToMiles:searchLocation] > 50) {
            // Not close enough.  Consider this a brand new search in a new
            // location.  Don't include this old theaters.
            continue;
        }

        // no showtime information available.  fallback to anything we've
        // stored (but warn the user).
        NSString* theaterName = theater.name;
        NSString* performancesFile = [self performancesFile:theaterName];
        NSDictionary* oldPerformances = [FileUtilities readObject:performancesFile];

        if (oldPerformances == nil) {
            continue;
        }

        NSDate* date = [self synchronizationDateForTheater:theater];
        if (ABS(date.timeIntervalSinceNow) > ONE_MONTH) {
            continue;
        }

        [lookupResult.performances setObject:oldPerformances forKey:theaterName];
        [lookupResult.synchronizationInformation setObject:date forKey:theaterName];
        [lookupResult.theaters addObject:theater];

        // the theater may refer to movies that we don't know about.
        [self addMissingMoviesFromPerformances:oldPerformances
                                      toResult:lookupResult
                   skippingExistingMovieTitles:existingMovieTitles
                                    withMovies:currentMovies];
    }
}


- (void) updateBackgroundEntryPointWorker:(LookupRequest*) request {
    if (self.model.userAddress.length == 0) {
        return;
    }

    Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:self.model.userAddress];
    if (location == nil) {
        [request.delegate onDataProviderUpdateFailure:NSLocalizedString(@"Could not find location.", nil) context:request.context];
        return;
    }

    // Do the primary search.
    LookupResult* result = [self lookupLocation:location
                                     searchDate:request.searchDate
                                   theaterNames:nil];
    if (result.movies.count == 0 || result.theaters.count == 0) {
        [request.delegate onDataProviderUpdateFailure:NSLocalizedString(@"No information found", nil) context:request.context];
        return;
    }

    // Lookup data for the users' favorites.
    [self updateMissingFavorites:result searchDate:request.searchDate];

    // Try to restore any theaters that went missing
    [self addMissingTheaters:result
              searchLocation:location
               currentMovies:request.currentMovies
             currentTheaters:request.currentTheaters];

    [request.delegate onDataProviderUpdateSuccess:result context:request.context];
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


- (void) updateBackgroundEntryPoint:(LookupRequest*) request {
    NSArray* notifications = [NSArray arrayWithObjects:NSLocalizedString(@"movies", nil), NSLocalizedString(@"theaters", nil), nil];

    if (request.force || ![self tooSoon:[self lastLookupDate]]) {
        [AppDelegate addNotifications:notifications];
        {
            [self updateBackgroundEntryPointWorker:request];
        }
        [AppDelegate removeNotifications:notifications];
    }

    [(id)request.delegate performSelectorOnMainThread:@selector(onDataProviderUpdateComplete) withObject:nil waitUntilDone:NO];
}


- (void) saveBookmarks {
    [model setBookmarkedMovies:self.bookmarks.allValues];
}


- (void) reportResult:(LookupResult*) result {
    NSAssert([NSThread isMainThread], nil);
    // add in any previously bookmarked movies that we now no longer know about.
    for (Movie* movie in self.bookmarks.allValues) {
        if (![result.movies containsObject:movie]) {
            [result.movies addObject:movie];
        }
    }

    // also determine if any of the data we found match items the user bookmarked
    for (Movie* movie in result.movies) {
        if ([model isBookmarked:movie]) {
            [self.bookmarks setObject:movie forKey:movie.canonicalTitle];
        }
    }
    [self saveBookmarks];

    self.moviesData = result.movies;
    self.theatersData = result.theaters;
    self.synchronizationInformationData = result.synchronizationInformation;
    self.performancesData = [NSMutableDictionary dictionary];

    [AppDelegate majorRefresh:YES];
}


- (NSDate*) synchronizationDateForTheater:(Theater*) theater {
    return [self.synchronizationInformation objectForKey:theater.name];
}


- (BOOL) isStale:(Theater*) theater {
#if 0
    NSDate* globalSyncDate = [self lastLookupDate];
    NSDate* theaterSyncDate = [self synchronizationDateForTheater:theater];
    if (globalSyncDate == nil || theaterSyncDate == nil) {
        return NO;
    }

    return ![DateUtilities isSameDay:globalSyncDate date:theaterSyncDate];
#else
    NSDate* theaterSyncDate = [self synchronizationDateForTheater:theater];
    if (theaterSyncDate == nil) {
        return NO;
    }

    return ![DateUtilities isToday:theaterSyncDate];
#endif
}


- (void) addBookmark:(NSString*) canonicalTitle {
    for (Movie* movie in self.movies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            [self.bookmarks setObject:movie forKey:canonicalTitle];
            [self saveBookmarks];
            return;
        }
    }
}


- (void) removeBookmark:(NSString*) canonicalTitle {
    [self.bookmarks removeObjectForKey:canonicalTitle];
    [self saveBookmarks];
}

@end