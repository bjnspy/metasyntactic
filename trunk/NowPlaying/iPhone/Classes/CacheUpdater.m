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
#import "NetflixCache.h"
#import "OperationQueue.h"
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
        [[OperationQueue operationQueue] performSelector:@selector(processMovie:)
                                                onTarget:self
                                              withObject:movie
                                                    gate:nil
                                                priority:Now];
    } else {
        [[OperationQueue operationQueue] performBoundedSelector:@selector(processMovie:)
                                                onTarget:self
                                              withObject:movie
                                                    gate:nil
                                                priority:Priority];
    }
}


- (void) processMovie:(Movie*) movie {
    Model* model = [Model model];
    [model.posterCache       processMovie:movie];
    [model.netflixCache      processMovie:movie];
    [model.upcomingCache     processMovie:movie];
    [model.dvdCache          processMovie:movie];
    [model.blurayCache       processMovie:movie];
    [model.scoreCache        processMovie:movie];
    [model.trailerCache      processMovie:movie];
    [model.imdbCache         processMovie:movie];
    [model.amazonCache       processMovie:movie];
    [model.wikipediaCache    processMovie:movie];
    [model.netflixCache lookupNetflixMovieForLocalMovieBackgroundEntryPoint:movie];
}


- (Operation*) addSearchMovie:(Movie*) movie {
    return [[OperationQueue operationQueue] performSelector:@selector(processMovie:)
                                                onTarget:self
                                              withObject:movie
                                                    gate:nil
                                                priority:Search];
}


- (void) addMovie:(Movie*) movie {
    [[OperationQueue operationQueue] performSelector:@selector(processMovie:)
                                         onTarget:self
                                       withObject:movie
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