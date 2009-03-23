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

#import "LocalSearchEngine.h"

#import "Location.h"
#import "Model.h"
#import "Movie.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "Theater.h"
#import "Utilities.h"


@implementation LocalSearchEngine

- (void) dealloc {
    [super dealloc];
}

+ (LocalSearchEngine*) engineWithModel:(Model*) model
                         delegate:(id<SearchEngineDelegate>) delegate {
    return [[[LocalSearchEngine alloc] initWithModel:model delegate:delegate] autorelease];
}


- (BOOL) arrayMatches:(NSArray*) array
              request:(SearchRequest*) currentlyExecutingRequest {
    for (NSString* text in array) {
        if ([self abortEarly:currentlyExecutingRequest]) {
            return NO;
        }

        NSString* lowercaseText = [[Utilities asciiString:text] lowercaseString];

        NSRange range = [lowercaseText rangeOfString:currentlyExecutingRequest.lowercaseValue];
        if (range.length > 0) {
            if (range.location > 0) {
                // make sure it's matching the start of a word
                unichar c = [lowercaseText characterAtIndex:range.location - 1];
                if (c >= 'a' && c <= 'z') {
                    continue;
                }
            }

            return YES;
        }
    }

    return NO;
}


- (BOOL) movieMatches:(Movie*) movie
              request:(SearchRequest*) currentlyExecutingRequest {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:movie.canonicalTitle];
    [array addObjectsFromArray:movie.directors];
    [array addObjectsFromArray:[self.model castForMovie:movie]];
    [array addObjectsFromArray:movie.genres];
    return [self arrayMatches:array request:currentlyExecutingRequest];
}


- (BOOL) theaterMatches:(Theater*) theater
                request:(SearchRequest*) currentlyExecutingRequest {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:theater.name];
    [array addObject:theater.location.address];
    return [self arrayMatches:array request:currentlyExecutingRequest];
}


- (NSArray*) findMovies:(SearchRequest*) currentlyExecutingRequest {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.movies) {
        if ([self movieMatches:movie request:currentlyExecutingRequest]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (NSArray*) findTheaters:(SearchRequest*) currentlyExecutingRequest {
    NSMutableArray* result = [NSMutableArray array];
    for (Theater* theater in currentlyExecutingRequest.theaters) {
        if ([self theaterMatches:theater request:currentlyExecutingRequest]) {
            [result addObject:theater];
        }
    }
    [result sortUsingFunction:compareTheatersByName context:nil];
    return result;
}


- (NSArray*) findUpcomingMovies:(SearchRequest*) currentlyExecutingRequest {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.upcomingMovies) {
        if ([self movieMatches:movie request:currentlyExecutingRequest]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (NSArray*) findDVDs:(SearchRequest*) currentlyExecutingRequest {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.dvds) {
        if ([self movieMatches:movie request:currentlyExecutingRequest]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (NSArray*) findBluray:(SearchRequest*) currentlyExecutingRequest {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.bluray) {
        if ([self movieMatches:movie request:currentlyExecutingRequest]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (void) search:(SearchRequest*) currentlyExecutingRequest {
    NSArray* movies = [self findMovies:currentlyExecutingRequest];
    if ([self abortEarly:currentlyExecutingRequest]) { return; }

    NSArray* theaters = [self findTheaters:currentlyExecutingRequest];
    if ([self abortEarly:currentlyExecutingRequest]) { return; }

    NSArray* upcomingMovies = [self findUpcomingMovies:currentlyExecutingRequest];
    if ([self abortEarly:currentlyExecutingRequest]) { return; }

    NSArray* dvds = [self findDVDs:currentlyExecutingRequest];
    if ([self abortEarly:currentlyExecutingRequest]) { return; }

    NSArray* bluray = [self findBluray:currentlyExecutingRequest];
    if ([self abortEarly:currentlyExecutingRequest]) { return; }
    //...

    [self reportResult:currentlyExecutingRequest
                movies:movies
               theaters:theaters
         upcomingMovies:upcomingMovies
                   dvds:dvds
                 bluray:bluray];
}

@end