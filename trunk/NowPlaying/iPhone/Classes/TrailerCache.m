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
#import "NowPlayingModel.h"
#import "ThreadingUtilities.h"

@interface TrailerCache()
@property (retain) LinkedSet* moviesWithoutTrailers;
@property (retain) LinkedSet* moviesWithTrailers;
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) NSDictionary* index;
@property (retain) DifferenceEngine* engine;
@end


@implementation TrailerCache

@synthesize moviesWithoutTrailers;
@synthesize moviesWithTrailers;
@synthesize prioritizedMovies;
@synthesize index;
@synthesize engine;

- (void) dealloc {
    self.moviesWithoutTrailers = nil;
    self.moviesWithTrailers = nil;
    self.prioritizedMovies = nil;
    self.index = nil;
    self.engine = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
        self.moviesWithoutTrailers = [LinkedSet set];
        self.moviesWithTrailers = [LinkedSet set];
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        
        [ThreadingUtilities performSelector:@selector(updateBackgroundEntryPoint)
                                   onTarget:self
                       inBackgroundWithGate:nil
                                    visible:NO];
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


- (void) update:(NSArray*) movies {
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


- (void) prioritizeMovie:(Movie*) movie {
    [gate lock];
    {
        [prioritizedMovies addObject:movie];
        [gate signal];
    }
    [gate unlock];
}


- (void) ensureIndex {
    if (index != nil) {
        return;
    }

    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?q=index", [Application host]];
    NSString* indexText = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (indexText == nil) {
        return;
    }

    NSMutableDictionary* map = [NSMutableDictionary dictionary];
    
    NSArray* rows = [indexText componentsSeparatedByString:@"\n"];
    for (NSString* row in rows) {
        NSArray* values = [row componentsSeparatedByString:@"\t"];
        if (values.count != 3) {
            continue;
        }
        
        NSString* fullTitle = [values objectAtIndex:0];
        NSString* studio = [values objectAtIndex:1];
        NSString* location = [values objectAtIndex:2];
        
        [map setObject:[NSArray arrayWithObjects:studio, location, nil]
                forKey:fullTitle.lowercaseString];
    }
    
    self.index = map;
    self.engine = [DifferenceEngine engine];
}


- (NSArray*) trailersForMovie:(Movie*) movie {
    NSArray* trailers = [FileUtilities readObject:[self trailerFile:movie]];
    if (trailers == nil) {
        return [NSArray array];
    }
    return trailers;
}


- (NSSet*) cachedDirectoriesToClear {
    return [NSSet setWithObject:[Application trailersDirectory]];
}


- (void) updateTrailer:(Movie*) movie {
    [self ensureIndex];
    if (index.count == 0) {
        return;
    }
    
    NSArray* indexKeys = index.allKeys;
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
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (void) updateOneMovie {
    Movie* movie = nil;
    [gate lock];
    {
        while ((movie = [prioritizedMovies removeLastObjectAdded]) == NULL &&
               (movie = [moviesWithoutTrailers removeLastObjectAdded]) == NULL &&
               (movie = [moviesWithTrailers removeLastObjectAdded]) == NULL) {
            [gate wait];
        }
    }
    [gate unlock];
    
    [self updateTrailer:movie];
}


- (void) updateBackgroundEntryPoint {
    while (YES) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self updateOneMovie];
        }
        [pool release];
    }
}

@end