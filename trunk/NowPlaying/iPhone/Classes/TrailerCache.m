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

#import "TrailerCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "ThreadingUtilities.h"

@implementation TrailerCache

@synthesize gate;

- (void) dealloc {
    self.gate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.gate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (TrailerCache*) cache {
    return [[[TrailerCache alloc] init] autorelease];
}


- (NSString*) trailerFileName:(NSString*) title {
    return [[FileUtilities sanitizeFileName:title] stringByAppendingPathExtension:@"plist"];
}


- (NSString*) trailerFilePath:(NSString*) title {
    return [[Application trailersFolder] stringByAppendingPathComponent:[self trailerFileName:title]];
}


- (void) deleteObsoleteTrailers:(NSArray*) movies {
    NSArray* contents = [[NSFileManager defaultManager] directoryContentsAtPath:[Application trailersFolder]];
    NSMutableSet* set = [NSMutableSet setWithArray:contents];

    for (Movie* movie in movies) {
        NSString* filePath = [self trailerFileName:movie.canonicalTitle];
        [set removeObject:filePath];
    }

    for (NSString* filePath in set) {
        NSString* fullPath = [[Application trailersFolder] stringByAppendingPathComponent:filePath];

        NSDate* downloadDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:NULL] objectForKey:NSFileModificationDate];

        if (downloadDate != nil) {
            NSTimeInterval span = downloadDate.timeIntervalSinceNow;
            if (ABS(span) > (ONE_HOUR * 1000)) {
                [[NSFileManager defaultManager] removeItemAtPath:fullPath error:NULL];
            }
        }
    }
}


- (NSArray*) getOrderedMovies:(NSArray*) movies {
    NSMutableArray* moviesWithoutTrailers = [NSMutableArray array];
    NSMutableArray* moviesWithTrailers = [NSMutableArray array];

    for (Movie* movie in movies) {
        NSDate* downloadDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self trailerFilePath:movie.canonicalTitle]
                                                                                 error:NULL] objectForKey:NSFileModificationDate];

        if (downloadDate == nil) {
            [moviesWithoutTrailers addObject:movie];
        } else {
            NSTimeInterval span = downloadDate.timeIntervalSinceNow;
            if (ABS(span) > (2 * ONE_DAY)) {
                [moviesWithTrailers addObject:movie];
            }
        }
    }

    return [NSArray arrayWithObjects:moviesWithoutTrailers, moviesWithTrailers, nil];
}


- (void) update:(NSArray*) movies {
    [self deleteObsoleteTrailers:movies];

    NSArray* orderedMovies = [self getOrderedMovies:movies];

    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:orderedMovies
                                   gate:gate
                                visible:NO];
}


- (void)        processRow:(NSString*) row
              moviesTitles:(NSArray*) movieTitles
      lowercaseMovieTitles:(NSArray*) lowercaseMovieTitles
                    engine:(DifferenceEngine*) engine {
    NSArray* values = [row componentsSeparatedByString:@"\t"];
    if (values.count != 3) {
        return;
    }

    NSString* fullTitle = [values objectAtIndex:0];
    NSString* studio = [values objectAtIndex:1];
    NSString* location = [values objectAtIndex:2];

    NSInteger index = [engine findClosestMatchIndex:fullTitle.lowercaseString inArray:lowercaseMovieTitles];
    if (index == NSNotFound) {
        return;
    }

    NSString* movieTitle = [movieTitles objectAtIndex:index];

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?studio=%@&name=%@", [Application host], studio, location];
    NSString* trailersString = [NetworkUtilities stringWithContentsOfAddress:url
                                                            important:NO];
    NSArray* trailers = [trailersString componentsSeparatedByString:@"\n"];

    if (trailers.count) {
        [FileUtilities writeObject:trailers toFile:[self trailerFilePath:movieTitle]];
    }
}


- (void) downloadTrailers:(NSArray*) movies index:(NSString*) index {
    NSMutableArray* movieTitles = [NSMutableArray array];
    NSMutableArray* lowercaseMovieTitles = [NSMutableArray array];

    for (Movie* movie in movies) {
        [movieTitles addObject:movie.canonicalTitle];
        [lowercaseMovieTitles addObject:movie.canonicalTitle.lowercaseString];
    }

    DifferenceEngine* engine = [DifferenceEngine engine];

    NSArray* rows = [index componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];

        [self processRow:row
            moviesTitles:movieTitles
    lowercaseMovieTitles:lowercaseMovieTitles
                  engine:engine];

        [autoreleasePool release];
    }
}


- (void) backgroundEntryPoint:(NSArray*) arguments {
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?q=index", [Application host]];
    NSString* index = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (index == nil) {
        return;
    }

    for (NSArray* movies in arguments) {
        [self downloadTrailers:movies index:index];
    }
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* trailers = [NSArray arrayWithContentsOfFile:[self trailerFilePath:movie.canonicalTitle]];
    if (trailers == nil) {
        return [NSArray array];
    }

    return trailers;
}


@end