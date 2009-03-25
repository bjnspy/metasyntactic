//
//  CacheUpdater.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
@property (retain) NSLock* searchOperationsGate_;
@property (retain) NSArray* searchOperations_;
@end


@implementation CacheUpdater

static CacheUpdater* cacheUpdater = nil;

@synthesize searchOperationsGate_;
@synthesize searchOperations_;

property_wrapper(NSLock*, searchOperationsGate, SearchOperationsGate);
property_wrapper(NSArray*, searchOperations, SearchOperations);

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
    [self.searchOperationsGate lock];
    {
        NSArray* oldOperations = self.searchOperations;
        for (Operation* operation in oldOperations) {
            [operation cancel];
        }

        NSMutableArray* operations = [NSMutableArray array];
        for (Movie* movie in movies) {
            [operations addObject:[self addSearchMovie:movie]];
        }

        self.searchOperations = operations;
    }
    [self.searchOperationsGate unlock];
}


- (void) addMovies:(NSArray*) movies {
    for (Movie* movie in movies) {
        [self addMovie:movie];
    }
}

@end