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

#import "TrailerCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "ThreadingUtilities.h"

@implementation TrailerCache

@synthesize model;
@synthesize gate;
@synthesize prioritizedMovies;

- (void) dealloc {
    self.model = nil;
    self.gate = nil;
    self.prioritizedMovies = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super init]) {
        self.model = model_;
        self.gate = [[[NSRecursiveLock alloc] init] autorelease];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
    }

    return self;
}


+ (TrailerCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[TrailerCache alloc] initWithModel:model] autorelease];
}


- (NSString*) trailerFile:(Movie*) movie {
    NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application trailersDirectory] stringByAppendingPathComponent:name];
}


- (void) deleteObsoleteTrailers:(NSArray*) movies {
    NSArray* paths = [FileUtilities directoryContentsPaths:[Application trailersDirectory]];
    NSMutableSet* set = [NSMutableSet setWithArray:paths];

    for (Movie* movie in movies) {
        NSString* filePath = [self trailerFile:movie];
        [set removeObject:filePath];
    }

    for (NSString* filePath in set) {
        NSDate* downloadDate = [FileUtilities modificationDate:filePath];

        if (downloadDate != nil) {
            if (ABS(downloadDate.timeIntervalSinceNow) > ONE_MONTH) {
                [FileUtilities removeItem:filePath];
            }
        }
    }
}


- (NSArray*) getOrderedMovies:(NSArray*) movies {
    NSMutableArray* moviesWithoutTrailers = [NSMutableArray array];
    NSMutableArray* moviesWithTrailers = [NSMutableArray array];

    for (Movie* movie in movies) {
        NSDate* downloadDate = [FileUtilities modificationDate:[self trailerFile:movie]];

        if (downloadDate == nil) {
            [moviesWithoutTrailers addObject:movie];
        } else {
            NSTimeInterval span = downloadDate.timeIntervalSinceNow;
            if (ABS(span) > (3 * ONE_DAY)) {
                [moviesWithTrailers addObject:movie];
            }
        }
    }

    return [NSArray arrayWithObjects:moviesWithoutTrailers, moviesWithTrailers, nil];
}


- (void) update:(NSArray*) movies {
    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:movies
                                   gate:gate
                                visible:NO];
}


- (void) downloadMovieTrailer:(Movie*) movie
                        index:(NSDictionary*) index
                    indexKeys:(NSArray*) indexKeys
                       engine:(DifferenceEngine*) engine {
    if (movie == nil) {
        return;
    }

    NSInteger arrayIndex = [engine findClosestMatchIndex:movie.canonicalTitle.lowercaseString inArray:indexKeys];
    if (arrayIndex == NSNotFound) {
        // no trailer for this movie.  record that fact.  we'll try again later
        [FileUtilities writeObject:[NSArray array] toFile:[self trailerFile:movie]];
        return;
    }

    NSArray* studioAndLocation = [index objectForKey:[indexKeys objectAtIndex:arrayIndex]];
    NSString* studio = [studioAndLocation objectAtIndex:0];
    NSString* location = [studioAndLocation objectAtIndex:1];

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?studio=%@&name=%@", [Application host], studio, location];
    NSString* trailersString = [NetworkUtilities stringWithContentsOfAddress:url
                                                                   important:NO];
    if (trailersString == nil) {
        // didn't get any data.  ignore this for now.
        NSLog(@"", nil);
        return;
    }

    NSArray* trailers = [trailersString componentsSeparatedByString:@"\n"];
    [FileUtilities writeObject:trailers toFile:[self trailerFile:movie]];
    [NowPlayingAppDelegate refresh];
}


- (Movie*) getNextMovie:(NSMutableArray*) movies {
    Movie* movie = [prioritizedMovies removeLastObjectAdded];

    if (movie != nil) {
        return movie;
    }

    if (movies.count > 0) {
        movie = [[[movies lastObject] retain] autorelease];
        [movies removeLastObject];
        return movie;
    }

    return nil;
}


- (void) downloadTrailers:(NSMutableArray*) movies
                    index:(NSDictionary*) index
                indexKeys:(NSArray*) indexKeys {
    DifferenceEngine* engine = [DifferenceEngine engine];

    Movie* movie;
    do {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            movie = [self getNextMovie:movies];
            [self downloadMovieTrailer:movie
                                 index:index
                             indexKeys:indexKeys
                                engine:engine];
        }
        [autoreleasePool release];
    } while (movie != nil);
}


- (void) prioritizeMovie:(Movie*) movie {
    [prioritizedMovies addObject:movie];
}


- (NSDictionary*) generateIndex:(NSString*) indexText {
    NSMutableDictionary* index = [NSMutableDictionary dictionary];

    NSArray* rows = [indexText componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* values = [row componentsSeparatedByString:@"\t"];
        if (values.count != 3) {
            continue;
        }

        NSString* fullTitle = [values objectAtIndex:0];
        NSString* studio = [values objectAtIndex:1];
        NSString* location = [values objectAtIndex:2];

        [index setObject:[NSArray arrayWithObjects:studio, location, nil]
                  forKey:fullTitle.lowercaseString];
    }

    return index;
}


- (void) backgroundEntryPoint:(NSArray*) movies {
    [self deleteObsoleteTrailers:movies];

    NSArray* orderedMovies = [self getOrderedMovies:movies];
    NSMutableArray* moviesWithoutTrailers = [orderedMovies objectAtIndex:0];
    NSMutableArray* moviesWithTrailers = [orderedMovies objectAtIndex:1];
    if (moviesWithoutTrailers.count == 0 && moviesWithTrailers.count == 0) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?q=index", [Application host]];
    NSString* indexText = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (indexText == nil) {
        return;
    }

    NSDictionary* index = [self generateIndex:indexText];
    NSArray* indexKeys = index.allKeys;

    [self downloadTrailers:moviesWithoutTrailers index:index indexKeys:indexKeys];
    [self downloadTrailers:moviesWithTrailers index:index indexKeys:indexKeys];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* trailers = [FileUtilities readObject:[self trailerFile:movie]];
    if (trailers == nil) {
        return [NSArray array];
    }
    return trailers;
}


@end