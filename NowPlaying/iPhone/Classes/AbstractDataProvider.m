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

#import "AbstractDataProvider.h"

#import "Application.h"
#import "FavoriteTheater.h"
#import "FileUtilities.h"
#import "Location.h"
#import "LookupResult.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "NowPlayingModel.h"
#import "Performance.h"
#import "Theater.h"
#import "UserLocationCache.h"

@implementation AbstractDataProvider

@synthesize model;
@synthesize moviesData;
@synthesize theatersData;
@synthesize performancesData;
@synthesize synchronizationInformationData;

- (void) dealloc {
    self.model = nil;
    self.moviesData = nil;
    self.theatersData = nil;
    self.performancesData = nil;
    self.synchronizationInformationData = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        [FileUtilities createDirectory:[self providerFolder]];
        self.performancesData = [NSMutableDictionary dictionary];
    }

    return self;
}


- (NSString*) performancesFolder {
    return [[self providerFolder] stringByAppendingPathComponent:@"Performances"];
}


- (NSString*) moviesFile {
    return [[self providerFolder] stringByAppendingPathComponent:@"Movies.plist"];
}


- (NSString*) theatersFile {
    return [[self providerFolder] stringByAppendingPathComponent:@"Theaters.plist"];
}


- (NSString*) synchronizationFile {
    return [[self providerFolder] stringByAppendingPathComponent:@"Synchronization.plist"];
}


- (NSString*) lastLookupDateFile {
    return [[self providerFolder] stringByAppendingPathComponent:@"lastLookupDate"];
}


- (NSDate*) lastLookupDate {
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self lastLookupDateFile]
                                                                               error:NULL] objectForKey:NSFileModificationDate];

    return lastLookupDate;
}


- (void) setLastLookupDate {
    [FileUtilities writeObject:@"" toFile:[self lastLookupDateFile]];
}


- (void) setStale {
    [[NSFileManager defaultManager] removeItemAtPath:[self lastLookupDateFile] error:NULL];
}


- (NSArray*) loadMovies {
    NSArray* array = [NSArray arrayWithContentsOfFile:self.moviesFile];
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


- (NSDictionary*) loadSynchronizationData {
    NSDictionary* result = [FileUtilities readObject:self.synchronizationFile];
    if (result.count == 0) {
        return [NSDictionary dictionary];
    }
    return result;
}


- (NSDictionary*) synchronizationData {
    if (synchronizationInformationData == nil) {
        self.synchronizationInformationData = [self loadSynchronizationData];
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


- (NSString*) performancesFile:(NSString*) theaterName parentFolder:(NSString*) folder {
    return [[folder stringByAppendingPathComponent:[FileUtilities sanitizeFileName:theaterName]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) performancesFile:(NSString*) theaterName {
    return [self performancesFile:theaterName parentFolder:self.performancesFolder];
}


- (void) saveResult:(LookupResult*) result {
    if (result.movies.count > 0 || result.theaters.count > 0) {
        [self saveArray:result.movies to:self.moviesFile];
        [self saveArray:result.theaters to:self.theatersFile];
        [FileUtilities writeObject:result.synchronizationData toFile:self.synchronizationFile];

        NSString* tempFolder = [Application uniqueTemporaryFolder];
        for (NSString* theaterName in result.performances) {
            NSMutableDictionary* value = [result.performances objectForKey:theaterName];

            [FileUtilities writeObject:value toFile:[self performancesFile:theaterName parentFolder:tempFolder]];
        }

        [[NSFileManager defaultManager] removeItemAtPath:self.performancesFolder error:NULL];
        [[NSFileManager defaultManager] moveItemAtPath:tempFolder toPath:self.performancesFolder error:NULL];

        [self setLastLookupDate];
    }
}


- (NSMutableDictionary*) lookupTheaterPerformances:(Theater*) theater {
    NSMutableDictionary* theaterPerformances = [performancesData objectForKey:theater.name];
    if (theaterPerformances == nil) {
        theaterPerformances = [NSMutableDictionary dictionaryWithDictionary:
                               [NSDictionary dictionaryWithContentsOfFile:[self performancesFile:theater.name]]];
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
    NSArray* array = [NSArray arrayWithContentsOfFile:self.theatersFile];
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


- (NSString*) providerFolder {
    NSAssert(false, @"Someone improperly subclassed!");
    return nil;
}


- (void) invalidateDiskCache {
    [[NSFileManager defaultManager] removeItemAtPath:self.providerFolder error:NULL];
    [FileUtilities createDirectory:self.providerFolder];
}


- (LookupResult*) lookupLocationWorker:(Location*) location
                    theaterNames:(NSArray*) theaterNames {
    NSAssert(false, @"Someone improperly subclassed!");
    return nil;
}


- (LookupResult*) lookupLocation:(Location*) location
                    theaterNames:(NSArray*) theaterNames {
    if (location.postalCode == nil) {
        [self reportUnknownLocation];
        return nil;
    }

    return [self lookupLocationWorker:location theaterNames:theaterNames];
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


- (void) lookupMissingFavorites:(LookupResult*) lookupResult {
    if (lookupResult == nil) {
        return;
    }

    NSArray* favoriteTheaters = self.model.favoriteTheaters;
    if (favoriteTheaters.count == 0) {
        return;
    }

    MultiDictionary* postalCodeToMissingTheaterNames = [MultiDictionary dictionary];

    for (FavoriteTheater* favorite in favoriteTheaters) {
        if (![self results:lookupResult containsFavorite:favorite]) {
            [postalCodeToMissingTheaterNames addObject:favorite.name forKey:favorite.originatingPostalCode];
        }
    }

    NSMutableSet* movieTitles = [NSMutableSet set];
    for (Movie* movie in lookupResult.movies) {
        [movieTitles addObject:movie.canonicalTitle];
    }

    for (NSString* postalCode in postalCodeToMissingTheaterNames.allKeys) {
        NSArray* theaterNames = [postalCodeToMissingTheaterNames objectsForKey:postalCode];

        Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:postalCode];
        LookupResult* favoritesLookupResult = [self lookupLocation:location
                                                      theaterNames:theaterNames];

        if (favoritesLookupResult == nil) {
            continue;
        }

        [lookupResult.theaters addObjectsFromArray:favoritesLookupResult.theaters];
        [lookupResult.performances addEntriesFromDictionary:favoritesLookupResult.performances];

        // the theater may refer to movies that we don't know about.
        for (NSString* theaterName in favoritesLookupResult.performances.allKeys) {
            for (NSString* movieTitle in [[favoritesLookupResult.performances objectForKey:theaterName] allKeys]) {
                if (![movieTitles containsObject:movieTitle]) {
                    [movieTitles addObject:movieTitle];

                    for (Movie* movie in favoritesLookupResult.movies) {
                        if ([movie.canonicalTitle isEqual:movieTitle]) {
                            [lookupResult.movies addObject:movie];
                            break;
                        }
                    }
                }
            }
        }
    }
}


- (void) lookup {
    Location* location = [self.model.userLocationCache downloadUserAddressLocationBackgroundEntryPoint:self.model.userAddress];
    LookupResult* result = [self lookupLocation:location theaterNames:nil];
    [self lookupMissingFavorites:result];

    [self saveResult:result];

    [self performSelectorOnMainThread:@selector(reportResult:)
                           withObject:result
                        waitUntilDone:NO];
}


- (void) reportResult:(LookupResult*) result {
    if (result.movies.count > 0 || result.theaters.count > 0) {
        self.moviesData = result.movies;
        self.theatersData = result.theaters;
        self.synchronizationInformationData = result.synchronizationData;
        self.performancesData = [NSMutableDictionary dictionary];
        [self.model onProviderUpdated];
    }
}


- (NSDate*) synchronizationDateForTheater:(NSString*) theaterName {
    return [self.synchronizationData objectForKey:theaterName];
}


- (void) reportUnknownLocation {
    if ([NSThread isMainThread]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
                                                         message:NSLocalizedString(@"Could not find location.", nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil] autorelease];

        [alert show];
    } else {
        [self performSelectorOnMainThread:@selector(reportUnknownLocation)
                               withObject:nil
                            waitUntilDone:NO];
    }
}


@end