//
//  AbstractSearchEngine.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractSearchEngine.h"

#import "Location.h"
#import "Movie.h"
#import "NowPlayingModel.h"
#import "SearchEngineDelegate.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "Theater.h"
#import "Utilities.h"

@interface AbstractSearchEngine()
@property (assign) id<SearchEngineDelegate> delegate;
@property NSInteger currentRequestId;
@property (retain) NowPlayingModel* model;
@property (retain) SearchRequest* currentlyExecutingRequest;
@property (retain) SearchRequest* nextSearchRequest;
@property (retain) NSCondition* gate;
@end


@implementation AbstractSearchEngine

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
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
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


- (void) reportResult:(NSArray*) movies
             theaters:(NSArray*) theaters
       upcomingMovies:(NSArray*) upcomingMovies
                 dvds:(NSArray*) dvds
               bluray:(NSArray*) bluray {
    SearchResult* result = [SearchResult resultWithId:currentlyExecutingRequest.requestId
                                                value:currentlyExecutingRequest.value
                                               movies:movies
                                             theaters:theaters
                                       upcomingMovies:upcomingMovies
                                                 dvds:dvds
                                               bluray:bluray];
    [self performSelectorOnMainThread:@selector(reportResult:) withObject:result waitUntilDone:NO];
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