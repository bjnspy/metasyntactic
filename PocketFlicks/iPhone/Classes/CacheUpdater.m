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

#import "CacheUpdater.h"

#import "AmazonCache.h"
#import "BlurayCache.h"
#import "DVDCache.h"
#import "IMDbCache.h"
#import "Model.h"
#import "Movie.h"
#import "MutableNetflixCache.h"
#import "PosterCache.h"
#import "ScoreCache.h"
#import "TrailerCache.h"
#import "UpcomingCache.h"
#import "WikipediaCache.h"

@interface CacheUpdater()
@property (retain) NSLock* searchOperationsGate;
@property (retain) NSArray* searchOperations;
@end


@implementation CacheUpdater

static CacheUpdater* cacheUpdater = nil;

@synthesize searchOperationsGate;
@synthesize searchOperations;

- (void) dealloc {
    self.searchOperationsGate = nil;
    self.searchOperations = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.searchOperationsGate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (CacheUpdater*) cacheUpdater {
    if (cacheUpdater == nil) {
        cacheUpdater = [[CacheUpdater alloc] init];
    }

    return cacheUpdater;
}


- (void) prioritizeMovie:(Movie*) movie now:(BOOL) now {
    if (now) {
        [ThreadingUtilities backgroundSelector:@selector(processMovie:force:)
                                      onTarget:self
                                    withObject:movie
                                    withObject:[NSNumber numberWithBool:YES]
                                          gate:nil
                                       visible:YES];
    } else {
        [[OperationQueue operationQueue] performBoundedSelector:@selector(processMovie:force:)
                                                       onTarget:self
                                                     withObject:movie
                                                     withObject:[NSNumber numberWithBool:NO]
                                                           gate:nil
                                                       priority:Priority];
    }
}


- (void) processMovie:(Movie*) movie
                force:(NSNumber*) forceNumber {
    NSLog(@"CacheUpdater:processMovie - %@", movie.canonicalTitle);

    BOOL force = forceNumber.boolValue;
    if (force) {
        [NotificationCenter addNotification:movie.canonicalTitle];
    }

    Model* model = [Model model];
    [model.posterCache       processMovie:movie force:force];
    [model.netflixCache      processMovie:movie force:force];
    [model.upcomingCache     processMovie:movie force:force];
    [model.dvdCache          processMovie:movie force:force];
    [model.blurayCache       processMovie:movie force:force];
    [model.scoreCache        processMovie:movie force:force];
    [model.trailerCache      processMovie:movie force:force];
    [model.imdbCache         processMovie:movie force:force];
    [model.amazonCache       processMovie:movie force:force];
    [model.wikipediaCache    processMovie:movie force:force];
    [model.netflixCache lookupNetflixMovieForLocalMovieBackgroundEntryPoint:movie];

    if (force) {
        [NotificationCenter removeNotification:movie.canonicalTitle];
    }
}


- (Operation2*) addSearchMovie:(Movie*) movie {
    return [[OperationQueue operationQueue] performSelector:@selector(processMovie:force:)
                                                   onTarget:self
                                                 withObject:movie
                                                 withObject:[NSNumber numberWithBool:NO]
                                                       gate:nil
                                                   priority:Search];
}


- (void) addMovie:(Movie*) movie {
    if (movie == nil) {
        return;
    }

    [[OperationQueue operationQueue] performSelector:@selector(processMovie:force:)
                                            onTarget:self
                                          withObject:movie
                                          withObject:[NSNumber numberWithBool:NO]
                                                gate:nil
                                            priority:Low];
}


- (void) addSearchMovies:(NSArray*) movies {
    [searchOperationsGate lock];
    {
        for (Operation* operation in searchOperations) {
            [operation cancel];
        }

        NSMutableArray* operations = [NSMutableArray array];
        for (Movie* movie in movies) {
            [operations addObject:[self addSearchMovie:movie]];
        }

        self.searchOperations = operations;
    }
    [searchOperationsGate unlock];
}


- (void) addMovies:(NSArray*) movies {
    for (Movie* movie in movies) {
        [self addMovie:movie];
    }
}

@end