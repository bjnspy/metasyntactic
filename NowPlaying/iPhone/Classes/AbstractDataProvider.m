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
#import "DateUtilities.h"
#import "LookupResult.h"
#import "Movie.h"
#import "NowPlayingModel.h"
#import "Performance.h"
#import "Theater.h"
#import "Utilities.h"

@implementation AbstractDataProvider

static NSString* synchronization_date_key = @"SynchronizationDate";

@synthesize model;
@synthesize moviesData;
@synthesize theatersData;
@synthesize performancesData;

- (void) dealloc {
    self.model = nil;
    self.moviesData = nil;
    self.theatersData = nil;
    self.performancesData = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        [Application createDirectory:[self providerFolder]];
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


- (NSString*) lastLookupDateFile {
    return [[self providerFolder] stringByAppendingPathComponent:@"lastLookupDate"];
}


- (NSDate*) lastLookupDate {
    NSDate* lastLookupDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self lastLookupDateFile]
                                                                               error:NULL] objectForKey:NSFileModificationDate];

    return lastLookupDate;
}


- (void) setLastLookupDate {
    [Utilities writeObject:@"" toFile:[self lastLookupDateFile]];
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


- (void) saveArray:(NSArray*) array to:(NSString*) file {
    NSMutableArray* encoded = [NSMutableArray array];

    for (id object in array) {
        [encoded addObject:[object dictionary]];
    }

    [Utilities writeObject:encoded toFile:file];
}


- (NSString*) performancesFile:(NSString*) theaterName parentFolder:(NSString*) folder {
    return [[folder stringByAppendingPathComponent:[Application sanitizeFileName:theaterName]] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) performancesFile:(NSString*) theaterName {
    return [self performancesFile:theaterName parentFolder:self.performancesFolder];
}


- (void) saveResult:(LookupResult*) result {
    if (result.movies.count > 0 || result.theaters.count > 0) {
        [self saveArray:result.movies to:self.moviesFile];
        [self saveArray:result.theaters to:self.theatersFile];

        NSString* tempFolder = [Application uniqueTemporaryFolder];
        for (NSString* theaterName in result.performances) {
            NSMutableDictionary* value = [result.performances objectForKey:theaterName];
            if ([value objectForKey:synchronization_date_key] == nil) {
                [value setObject:[DateUtilities today] forKey:synchronization_date_key];
            }

            [Utilities writeObject:value toFile:[self performancesFile:theaterName parentFolder:tempFolder]];
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


- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater {
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


- (LookupResult*) lookupWorker {
    NSAssert(false, @"Someone improperly subclassed!");
    return nil;
}


- (void) invalidateDiskCache {
    [[NSFileManager defaultManager] removeItemAtPath:self.providerFolder error:NULL];
    [Application createDirectory:self.providerFolder];
}


- (void) lookup {
    LookupResult* result = [self lookupWorker];

    [self saveResult:result];

    [self performSelectorOnMainThread:@selector(reportResult:)
                           withObject:result
                        waitUntilDone:NO];
}


- (void) reportResult:(LookupResult*) result {
    if (result.movies.count > 0 || result.theaters.count > 0) {
        self.moviesData = result.movies;
        self.theatersData = result.theaters;
        self.performancesData = [NSMutableDictionary dictionary];
        [self.model onProviderUpdated];
    }
}


- (NSDate*) synchronizationDateForTheater:(Theater*) theater {
    return [[self lookupTheaterPerformances:theater] objectForKey:synchronization_date_key];
}


@end