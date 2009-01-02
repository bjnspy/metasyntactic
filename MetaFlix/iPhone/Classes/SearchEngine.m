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

#import "SearchEngine.h"

#import "Location.h"
#import "Movie.h"
#import "MetaFlixModel.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "Theater.h"
#import "Utilities.h"


@implementation SearchEngine

- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(MetaFlixModel*) model_
            delegate:(id<SearchEngineDelegate>) delegate_ {
    if (self = [super initWithModel:model_ delegate:delegate_]) {
    }

    return self;
}


+ (SearchEngine*) engineWithModel:(MetaFlixModel*) model
                         delegate:(id<SearchEngineDelegate>) delegate {
    return [[[SearchEngine alloc] initWithModel:model delegate:delegate] autorelease];
}


- (BOOL) arrayMatches:(NSArray*) array {
    for (NSString* text in array) {
        if ([self abortEarly]) {
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


- (BOOL) movieMatches:(Movie*) movie {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:movie.canonicalTitle];
    [array addObjectsFromArray:movie.directors];
    [array addObjectsFromArray:[model castForMovie:movie]];
    [array addObjectsFromArray:movie.genres];
    return [self arrayMatches:array];
}


- (BOOL) theaterMatches:(Theater*) theater {
    NSMutableArray* array = [NSMutableArray array];
    [array addObject:theater.name];
    [array addObject:theater.location.address];
    return [self arrayMatches:array];
}


- (NSArray*) findMovies {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.movies) {
        if ([self movieMatches:movie]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (NSArray*) findTheaters {
    NSMutableArray* result = [NSMutableArray array];
    for (Theater* theater in currentlyExecutingRequest.theaters) {
        if ([self theaterMatches:theater]) {
            [result addObject:theater];
        }
    }
    [result sortUsingFunction:compareTheatersByName context:nil];
    return result;
}


- (NSArray*) findUpcomingMovies {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.upcomingMovies) {
        if ([self movieMatches:movie]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (NSArray*) findDVDs {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.dvds) {
        if ([self movieMatches:movie]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (NSArray*) findBluray {
    NSMutableArray* result = [NSMutableArray array];
    for (Movie* movie in currentlyExecutingRequest.bluray) {
        if ([self movieMatches:movie]) {
            [result addObject:movie];
        }
    }
    [result sortUsingFunction:compareMoviesByTitle context:nil];
    return result;
}


- (void) search {
    NSArray* movies = [self findMovies];
    if ([self abortEarly]) { return; }

    NSArray* theaters = [self findTheaters];
    if ([self abortEarly]) { return; }

    NSArray* upcomingMovies = [self findUpcomingMovies];
    if ([self abortEarly]) { return; }

    NSArray* dvds = [self findDVDs];
    if ([self abortEarly]) { return; }

    NSArray* bluray = [self findBluray];
    if ([self abortEarly]) { return; }
    //...

    [self reportResult:movies
               theaters:theaters
         upcomingMovies:upcomingMovies
                   dvds:dvds
                 bluray:bluray];
}

@end