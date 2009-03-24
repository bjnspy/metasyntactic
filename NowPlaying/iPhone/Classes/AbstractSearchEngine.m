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

#import "AbstractSearchEngine.h"

#import "Location.h"
#import "Model.h"
#import "Movie.h"
#import "SearchEngineDelegate.h"
#import "SearchRequest.h"
#import "SearchResult.h"
#import "Theater.h"
#import "Utilities.h"

@interface AbstractSearchEngine()
@property (assign) id<SearchEngineDelegate> delegate_;
@property NSInteger currentRequestId_;
@property (retain) SearchRequest* nextSearchRequest_;
@property (retain) NSCondition* gate_;
@end


@implementation AbstractSearchEngine

@synthesize delegate_;
@synthesize currentRequestId_;
@synthesize nextSearchRequest_;
@synthesize gate_;

property_wrapper(id<SearchEngineDelegate>, delegate, Delegate);
property_wrapper(NSInteger, currentRequestId, CurrentRequestId);
property_wrapper(SearchRequest*, nextSearchRequest, NextSearchRequest);
property_wrapper(NSCondition*, gate, Gate);

- (void) dealloc {
    self.delegate = nil;
    self.currentRequestId = 0;
    self.nextSearchRequest = nil;
    self.gate = nil;

    [super dealloc];
}


- (id) initWithDelegate:(id<SearchEngineDelegate>) delegate__ {
    if (self = [super init]) {
        self.currentRequestId = 0;
        self.delegate = delegate__;
        self.gate = [[[NSCondition alloc] init] autorelease];

        [self performSelectorInBackground:@selector(searchThreadEntryPoint) withObject:nil];
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (BOOL) abortEarly:(SearchRequest*) currentlyExecutingRequest {
    BOOL result;

    [self.gate lock];
    {
        result = currentlyExecutingRequest.requestId != self.currentRequestId;
    }
    [self.gate unlock];

    return result;
}


- (void) search:(SearchRequest*) request {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) searchLoop {
    while (true) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            SearchRequest* currentlyExecutingRequest = nil;
            [self.gate lock];
            {
                while (self.nextSearchRequest == nil) {
                    [self.gate wait];
                }

                currentlyExecutingRequest = [[self.nextSearchRequest retain] autorelease];
                self.nextSearchRequest = nil;
            }
            [self.gate unlock];

            [self search:currentlyExecutingRequest];
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
    [self.gate lock];
    {
        self.currentRequestId++;
        self.nextSearchRequest = [SearchRequest requestWithId:self.currentRequestId
                                                        value:string
                                                        model:self.model];

        [self.gate broadcast];
    }
    [self.gate unlock];
}


- (void) reportResult:(SearchResult*) result {
    NSAssert([NSThread isMainThread], nil);

    BOOL abort = NO;
    [self.gate lock];
    {
        if (result.requestId != self.currentRequestId) {
            abort = YES;
        }
    }
    [self.gate unlock];

    if (abort) {
        return;
    }

    [self.delegate reportResult:result];
}


- (void) reportResult:(SearchRequest*) request
               movies:(NSArray*) movies
             theaters:(NSArray*) theaters
       upcomingMovies:(NSArray*) upcomingMovies
                 dvds:(NSArray*) dvds
               bluray:(NSArray*) bluray {
    [self reportResult:request
                movies:movies
              theaters:theaters
        upcomingMovies:upcomingMovies
                  dvds:dvds
                bluray:bluray
                people:[NSArray array]];
}


- (void) reportResult:(SearchRequest*) request
               movies:(NSArray*) movies
             theaters:(NSArray*) theaters
       upcomingMovies:(NSArray*) upcomingMovies
                 dvds:(NSArray*) dvds
               bluray:(NSArray*) bluray
               people:(NSArray*) people {
    SearchResult* result = [SearchResult resultWithId:request.requestId
                                                value:request.value
                                               movies:movies
                                             theaters:theaters
                                       upcomingMovies:upcomingMovies
                                                 dvds:dvds
                                               bluray:bluray];
    [self performSelectorOnMainThread:@selector(reportResult:) withObject:result waitUntilDone:NO];
}


- (void) invalidateExistingRequests {
    [self.gate lock];
    {
        self.currentRequestId++;
        self.nextSearchRequest = nil;
    }
    [self.gate unlock];
}

@end