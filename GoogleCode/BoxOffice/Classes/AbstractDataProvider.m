//
//  AbstractDataProvider.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractDataProvider.h"
#import "Application.h"
#import "Utilities.h"
#import "Performance.h"

@implementation AbstractDataProvider

@synthesize model;
@synthesize moviesData;
@synthesize theatersData;

- (void) dealloc {
    self.model;
    self.moviesData = nil;
    self.theatersData = nil;
    
    [super dealloc];
}

- (id) initWithModel:(BoxOfficeModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        [Application createDirectory:[self providerFolder]];
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
    NSArray* array = [NSArray arrayWithContentsOfFile:[self moviesFile]];
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
    NSArray* movies = result.movies;
    NSArray* theaters = result.theaters;
    NSDictionary* performances = result.performances;
    
    if (movies.count > 0 || theaters.count > 0) {
        [self saveArray:movies to:[self moviesFile]];
        [self saveArray:theaters to:[self theatersFile]];
        
        NSString* tempFolder = [Application uniqueTemporaryFolder];
        for (NSString* key in performances) {
            NSDictionary* value = [performances objectForKey:key];
            
            [Utilities writeObject:value toFile:[self performancesFile:key parentFolder:tempFolder]]; 
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:[self performancesFolder] error:NULL];
        [[NSFileManager defaultManager] moveItemAtPath:tempFolder toPath:[self performancesFolder] error:NULL];
        
        [self setLastLookupDate];
    }
}

- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater {
    NSDictionary* theaterPerformances = [NSDictionary dictionaryWithContentsOfFile:[self performancesFile:theater.identifier]];
    NSArray* encodedArray = [theaterPerformances objectForKey:movie.identifier];
    if (encodedArray == nil) {
        return [NSArray array];
    }
    
    NSMutableArray* decodedArray = [NSMutableArray array];
    for (NSDictionary* dict in encodedArray) {
        [decodedArray addObject:[Performance performanceWithDictionary:dict]];
    }
    
    return decodedArray;
}

- (NSArray*) loadTheaters {
    NSArray* array = [NSArray arrayWithContentsOfFile:[self theatersFile]];
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
    [[NSFileManager defaultManager] removeItemAtPath:[self providerFolder] error:NULL];
    [Application createDirectory:[self providerFolder]];
}

- (void) lookup {
    LookupResult* result = [self lookupWorker];
    
    [self saveResult:result];
    
    [self performSelectorOnMainThread:@selector(reportResult:)
                           withObject:result
                        waitUntilDone:NO];
}

- (void) reportResult:(LookupResult*) result {
    NSArray* movies = result.movies;
    NSArray* theaters = result.theaters;
    
    if (movies.count > 0 || theaters.count > 0) {
        self.moviesData = movies;
        self.theatersData = theaters;
        [self.model onProviderUpdated];
    }
}


@end
