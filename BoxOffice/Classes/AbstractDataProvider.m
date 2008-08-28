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
#import "BoxOfficeModel.h"
#import "LookupResult.h"
#import "Movie.h"
#import "Performance.h"
#import "Theater.h"
#import "Utilities.h"

@implementation AbstractDataProvider

@synthesize model;
@synthesize moviesData;
@synthesize theatersData;
@synthesize performances;

- (void) dealloc {
    self.model = nil;
    self.moviesData = nil;
    self.theatersData = nil;
    self.performances = nil;

    [super dealloc];
}


- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        [Application createDirectory:[self providerFolder]];
        self.performances = [NSMutableDictionary dictionary];
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
    if (self.moviesData == nil) {
        self.moviesData = [self loadMovies];
    }

    return self.moviesData;
}


- (void) saveArray:(NSArray*) array to:(NSString*) file {
    NSMutableArray* encoded = [NSMutableArray array];

    for (id object in array) {
        [encoded addObject:[object dictionary]];
    }

    [Utilities writeObject:encoded toFile:file];
}


- (NSString*) performancesFile:(NSString*) identifier parentFolder:(NSString*) folder {
    return [[folder stringByAppendingPathComponent:identifier] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) performancesFile:(NSString*) identifier {
    return [self performancesFile:identifier parentFolder:[self performancesFolder]];
}


- (void) saveResult:(LookupResult*) result {
    if (result.movies.count > 0 || result.theaters.count > 0) {
        [self saveArray:result.movies to:self.moviesFile];
        [self saveArray:result.theaters to:self.theatersFile];

        NSString* tempFolder = [Application uniqueTemporaryFolder];
        for (NSString* key in result.performances) {
            NSDictionary* value = [result.performances objectForKey:key];

            [Utilities writeObject:value toFile:[self performancesFile:key parentFolder:tempFolder]];
        }

        [[NSFileManager defaultManager] removeItemAtPath:self.performancesFolder error:NULL];
        [[NSFileManager defaultManager] moveItemAtPath:tempFolder toPath:self.performancesFolder error:NULL];

        [self setLastLookupDate];
    }
}


- (NSMutableDictionary*) lookupTheaterPerformances:(Theater*) theater {
    NSMutableDictionary* theaterPerformances = [self.performances objectForKey:theater.identifier];
    if (theaterPerformances == nil) {
        theaterPerformances = [NSMutableDictionary dictionaryWithDictionary:
                               [NSDictionary dictionaryWithContentsOfFile:[self performancesFile:theater.identifier]]];
        [self.performances setObject:theaterPerformances forKey:theater.identifier];
    }
    return theaterPerformances;
}


- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater {
    NSMutableDictionary* theaterPerformances = [self lookupTheaterPerformances:theater];

    NSArray* unsureArray = [theaterPerformances objectForKey:movie.identifier];
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

    [theaterPerformances setObject:decodedArray forKey:movie.identifier];
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
    if (self.theatersData == nil) {
        self.theatersData = [self loadTheaters];
    }

    return self.theatersData;
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
        self.performances = [NSMutableDictionary dictionary];
        [self.model onProviderUpdated];
    }
}


@end