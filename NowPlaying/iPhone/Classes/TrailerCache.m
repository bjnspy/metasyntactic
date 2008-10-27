//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "TrailerCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
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
            if (ABS(span) > (3 * ONE_DAY)) {
                [moviesWithTrailers addObject:movie];
            }
        }
    }

    return [NSArray arrayWithObjects:moviesWithoutTrailers, moviesWithTrailers, nil];
}


- (void) update:(NSArray*) movies {
    [self deleteObsoleteTrailers:movies];

    NSArray* orderedMovies = [self getOrderedMovies:movies];
    NSArray* moviesWithoutTrailers = [orderedMovies objectAtIndex:0];
    NSArray* moviesWithTrailers = [orderedMovies objectAtIndex:1];
    if (moviesWithoutTrailers.count == 0 && moviesWithTrailers.count == 0) {
        return;
    }

    [ThreadingUtilities performSelector:@selector(backgroundEntryPoint:)
                               onTarget:self
               inBackgroundWithArgument:orderedMovies
                                   gate:gate
                                visible:NO];
}


- (void) downloadMovieTrailer:(Movie*) movie
                        index:(NSDictionary*) index
                    indexKeys:(NSArray*) indexKeys
                       engine:(DifferenceEngine*) engine {
    NSInteger arrayIndex = [engine findClosestMatchIndex:movie.canonicalTitle.lowercaseString inArray:indexKeys];
    if (arrayIndex == NSNotFound) {
        // no trailer for this movie.  record that fact.  we'll try again later
        [FileUtilities writeObject:[NSArray array] toFile:[self trailerFilePath:movie.canonicalTitle]];
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
    [FileUtilities writeObject:trailers toFile:[self trailerFilePath:movie.canonicalTitle]];
    [NowPlayingAppDelegate refresh];
}


- (void) downloadTrailers:(NSArray*) movies
                    index:(NSDictionary*) index
                indexKeys:(NSArray*) indexKeys {
    DifferenceEngine* engine = [DifferenceEngine engine];

    for (Movie* movie in movies) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            [self downloadMovieTrailer:movie
                                 index:index
                             indexKeys:indexKeys
                                engine:engine];
        }
        [autoreleasePool release];
    }
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


- (void) backgroundEntryPoint:(NSArray*) arguments {
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupTrailerListings?q=index", [Application host]];
    NSString* indexText = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (indexText == nil) {
        return;
    }

    NSDictionary* index = [self generateIndex:indexText];
    NSArray* indexKeys = index.allKeys;

    for (NSArray* movies in arguments) {
        [self downloadTrailers:movies index:index indexKeys:indexKeys];
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