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

#import "AbstractMovieCache.h"

#import "LinkedSet.h"
#import "ThreadingUtilities.h"

@interface AbstractMovieCache()
@property (retain) LinkedSet* prioritizedMovies;
@property (retain) LinkedSet* primaryMovies;
@property (retain) LinkedSet* secondaryMovies;
@property (retain) NSMutableSet* updatedMovies;
@end


@implementation AbstractMovieCache

@synthesize prioritizedMovies;
@synthesize primaryMovies;
@synthesize secondaryMovies;
@synthesize updatedMovies;

- (void) dealloc {
    self.prioritizedMovies = nil;
    self.primaryMovies = nil;
    self.secondaryMovies = nil;
    self.updatedMovies = nil;

    [super dealloc];
}


- (id) initWithModel:(Model*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
        self.primaryMovies = [LinkedSet set];
        self.secondaryMovies = [LinkedSet set];
        self.updatedMovies = [NSMutableSet set];

        [ThreadingUtilities backgroundSelector:@selector(updateDetailsBackgroundEntryPoint)
                                      onTarget:self
                                          gate:nil
                                       visible:NO];
    }

    return self;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self clearUpdatedMovies];
}


- (void) updateMovieDetails:(Movie*) movie {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) updatedMoviesContainsNoLock:(Movie*) movie {
    return [updatedMovies containsObject:movie];
}


- (BOOL) updatedMoviesContains:(Movie*) movie {
    BOOL value;
    [gate lock];
    {
        value = [self updatedMoviesContainsNoLock:movie];
    }
    [gate unlock];
    return value;
}


- (void) addUpdatedMovie:(Movie*) movie {
    [gate lock];
    {
        [updatedMovies addObject:movie];
    }
    [gate unlock];
}


- (void) clearUpdatedMovies {
    [gate lock];
    {
        [updatedMovies removeAllObjects];
    }
    [gate unlock];
}


- (void) updateDetailsBackgroundEntryPoint {
    while (YES) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            Movie* movie = nil;
            [gate lock];
            {
                while ((movie = [prioritizedMovies removeLastObjectAdded]) == nil &&
                       (movie = [primaryMovies removeLastObjectAdded]) == nil &&
                       (movie = [secondaryMovies removeLastObjectAdded]) == nil) {
                    [gate wait];
                }
            }
            [gate unlock];

            if (movie != nil) {
                if (![self updatedMoviesContains:movie]) {
                    [self addUpdatedMovie:movie];
                    [self updateMovieDetails:movie];
                }
            }

            [NSThread sleepForTimeInterval:1];
        }
        [pool release];
    }
}


- (void) addMovie:(Movie*) movie
              set:(LinkedSet*) set {
    [gate lock];
    {
        if (![self updatedMoviesContainsNoLock:movie]) {
            [set addObject:movie];
            [gate broadcast];
        }
    }
    [gate unlock];
}


- (void) addMovies:(NSArray*) movies
               set:(LinkedSet*) set {
    [gate lock];
    {
        [set addObjectsFromArray:movies];
        [gate broadcast];
    }
    [gate unlock];
}


- (void) prioritizeMovie:(Movie*) movie {
    [self addMovie:movie set:prioritizedMovies];
}


- (void) addPrimaryMovie:(Movie*) movie {
    [self addMovie:movie set:primaryMovies];
}


- (void) addSecondaryMovie:(Movie*) movie {
    [self addMovie:movie set:secondaryMovies];
}


- (void) addPrimaryMovies:(NSArray*) movies {
    [self addMovies:movies set:primaryMovies];
}


- (void) addSecondaryMovies:(NSArray*) movies {
    [self addMovies:movies set:secondaryMovies];
}

@end