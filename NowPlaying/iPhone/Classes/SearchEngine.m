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

#import "SearchEngine.h"

#import "Location.h"
#import "Movie.h"
#import "NowPlayingModel.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "Theater.h"
#import "Utilities.h"

@implementation SearchEngine

@synthesize delegate;
@synthesize currentRequestId;
@synthesize model;
@synthesize currentlyExecutingRequest;
@synthesize nextSearchRequest;
@synthesize gate;


- (void) dealloc {
    self.delegate = nil;
    self.currentRequestId = 0;
    self.model = nil;
    self.currentlyExecutingRequest = nil;
    self.nextSearchRequest = nil;
    self.gate = nil;

    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_
            delegate:(id<SearchEngineDelegate>) delegate_ {
    if (self = [super init]) {
        self.model = model_;
        self.currentRequestId = 0;
        self.delegate = delegate_;
        self.gate = [[[NSCondition alloc] init] autorelease];

        [self performSelectorInBackground:@selector(searchThreadEntryPoint) withObject:nil];
    }

    return self;
}


+ (SearchEngine*) engineWithModel:(NowPlayingModel*) model
                         delegate:(id<SearchEngineDelegate>) delegate {
    return [[[SearchEngine alloc] initWithModel:model delegate:delegate] autorelease];
}


- (BOOL) arrayMatches:(NSArray*) array {
    for (NSString* text in array) {
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
    [array addObjectsFromArray:movie.cast];
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


- (BOOL) abortEarly {
    BOOL result;

    [gate lock];
    {
        result = currentlyExecutingRequest.requestId != currentRequestId;
    }
    [gate unlock];

    return result;
}


- (void) search {
    NSArray* movies = [self findMovies];
    if ([self abortEarly]) { return; }

    NSArray* theaters = [self findTheaters];
    if ([self abortEarly]) { return; }

    NSArray* upcomingMovies = [self findUpcomingMovies];
    if ([self abortEarly]) { return; }
    //...

    SearchResult* result = [SearchResult resultWithId:currentlyExecutingRequest.requestId
                                                value:currentlyExecutingRequest.value
                                               movies:movies
                                             theaters:theaters
                                       upcomingMovies:upcomingMovies];
    [self performSelectorOnMainThread:@selector(reportResult:) withObject:result waitUntilDone:NO];
}


- (void) searchLoop {
    while (true) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            [gate lock];
            {
                while (nextSearchRequest == nil) {
                    [gate wait];
                }

                self.currentlyExecutingRequest = nextSearchRequest;
                self.nextSearchRequest = nil;
            }
            [gate unlock];

            [self search];

            self.currentlyExecutingRequest = nil;
        }
        [autoreleasePool release];
    }
}


- (void) searchThreadEntryPoint {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    {
        [NSThread setThreadPriority:0.0];

        [self searchLoop];
    }
    [autoreleasePool release];
}


- (void) submitRequest:(NSString*) string {
    [gate lock];
    {
        currentRequestId++;
        self.nextSearchRequest = [SearchRequest requestWithId:currentRequestId value:string model:model];

        [gate broadcast];
    }
    [gate unlock];
}


- (void) reportResult:(SearchResult*) result {
    BOOL abort = NO;
    [gate lock];
    {
        if (result.requestId != currentRequestId) {
            abort = YES;
        }
    }
    [gate unlock];

    if (abort) {
        return;
    }

    [delegate reportResult:result];
}


- (void) invalidateExistingRequests {
    [gate lock];
    {
        currentRequestId++;
        self.nextSearchRequest = nil;
    }
    [gate unlock];
}



@end