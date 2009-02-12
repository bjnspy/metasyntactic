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
#import "AppDelegate.h"
#import "Model.h"
#import "ThreadingUtilities.h"

@interface TrailerCache()
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) LinkedSet* moviesWithoutTrailers;
@property (retain) LinkedSet* moviesWithTrailers;
@property (retain) NSDictionary* index;
@property (retain) NSArray* indexKeys;
@end


@implementation TrailerCache

@synthesize prioritizedMovies;
@synthesize moviesWithoutTrailers;
@synthesize moviesWithTrailers;
@synthesize index;
@synthesize indexKeys;

- (void) dealloc {
    self.prioritizedMovies = nil;
    self.moviesWithoutTrailers = nil;
    self.moviesWithTrailers = nil;
    self.index = nil;
    self.indexKeys = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.moviesWithoutTrailers = [LinkedSet set];
        self.moviesWithTrailers = [LinkedSet set];

        [ThreadingUtilities backgroundSelector:@selector(backgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
    }

    return self;
}


+ (TrailerCache*) cacheWithModel:(Model*) model {
    return [[[TrailerCache alloc] initWithModel:model] autorelease];
}


- (NSString*) trailerFile:(Movie*) movie {
    NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application trailersDirectory] stringByAppendingPathComponent:name];
}


- (void) update:(NSArray*) movies {
    [ThreadingUtilities backgroundSelector:@selector(updateBackgroundEntryPoint:) onTarget:self argument:movies gate:nil visible:NO];
}


- (void) updateBackgroundEntryPoint:(NSArray*) movies {
    [gate lock];
    {
        for (Movie* movie in movies) {
            NSDate* downloadDate = [FileUtilities modificationDate:[self trailerFile:movie]];

            if (downloadDate == nil) {
                [moviesWithoutTrailers addObject:movie];
            } else {
                if (ABS(downloadDate.timeIntervalSinceNow) > (3 * ONE_DAY)) {
                    [moviesWithTrailers addObject:movie];
                }
            }
        }

        [gate signal];
    }
    [gate unlock];
}


- (void) downloadTrailersWorker:(Movie*) movie
                         engine:(DifferenceEngine*) engine {
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
        return;
    }

    NSArray* trailers = [trailersString componentsSeparatedByString:@"\n"];
    NSMutableArray* final = [NSMutableArray array];
    for (NSString* trailer in trailers) {
        if (trailer.length > 0) {
            [final addObject:trailer];
        }
    }

    [FileUtilities writeObject:final toFile:[self trailerFile:movie]];

    if (final.count > 0) {
        [AppDelegate minorRefresh];
    }
}


- (void) prioritizeMovie:(Movie*) movie {
    [gate lock];
    {
        [prioritizedMovies addObject:movie];
        [gate signal];
    }
    [gate unlock];
}


- (void) generateIndex:(NSString*) indexText {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    NSArray* rows = [indexText componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* values = [row componentsSeparatedByString:@"\t"];
        if (values.count != 3) {
            continue;
        }

        NSString* fullTitle = [values objectAtIndex:0];
        NSString* studio = [values objectAtIndex:1];
        NSString* location = [values objectAtIndex:2];

        [result setObject:[NSArray arrayWithObjects:studio, location, nil]
                  forKey:fullTitle.lowercaseString];
    }

    self.index = result;
    self.indexKeys = index.allKeys;
}


- (void) downloadTrailers:(Movie*) movie engine:(DifferenceEngine*) engine {
    if (movie == nil) {
        return;
    }

    if (index == nil) {
        NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?q=index", [Application host]];
        NSString* indexText = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
        if (indexText == nil) {
            return;
        }

        [self generateIndex:indexText];
    }

    [self downloadTrailersWorker:movie
                          engine:engine];
}


- (void) backgroundEntryPoint {
    DifferenceEngine* engine = [DifferenceEngine engine];

    while (YES) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Movie* movie = nil;
            BOOL isPriority = NO;
            [gate lock];
            {
                NSInteger count = prioritizedMovies.count;
                while ((movie = [prioritizedMovies removeLastObjectAdded]) == nil &&
                       (movie = [moviesWithoutTrailers removeLastObjectAdded]) == nil &&
                       (movie = [moviesWithTrailers removeLastObjectAdded]) == nil) {
                    [gate wait];
                }

                isPriority = prioritizedMovies.count != count;
            }
            [gate unlock];

            // we enqueue lots of priority movies when the user scrolls.  but to
            // be easy on the disk, we only check if we need to do anything when
            // we're on the background.
            BOOL skip = isPriority && [FileUtilities fileExists:[self trailerFile:movie]];
            if (!skip) {
                [self downloadTrailers:movie engine:engine];
            }
        }
        [pool release];
    }
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* trailers = [FileUtilities readObject:[self trailerFile:movie]];
    if (trailers == nil) {
        return [NSArray array];
    }
    return trailers;
}

@end