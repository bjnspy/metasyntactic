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

#import "Model.h"
#import "NotificationCenter.h"
#import "SearchEngineDelegate.h"
#import "SearchRequest.h"
#import "SearchResult.h"

@interface AbstractSearchEngine()
@property (assign) id<SearchEngineDelegate> delegate;
@property NSInteger currentRequestId;
@property (retain) SearchRequest* nextSearchRequest;
@property (retain) NSCondition* gate;
@end


@implementation AbstractSearchEngine

@synthesize delegate;
@synthesize currentRequestId;
@synthesize nextSearchRequest;
@synthesize gate;

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

    [gate lock];
    {
        result = currentlyExecutingRequest.requestId != currentRequestId;
    }
    [gate unlock];

    return result;
}


- (void) searchWorker:(SearchRequest*) request {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) search:(SearchRequest*) request {
    NSString* notification = [NSLocalizedString(@"searching", nil) lowercaseString];
    [NotificationCenter addNotification:notification];
    {
        [self searchWorker:request];
    }
    [NotificationCenter removeNotification:notification];
}


- (void) searchLoop {
    while (true) {
        NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
        {
            SearchRequest* currentlyExecutingRequest = nil;
            [gate lock];
            {
                while (nextSearchRequest == nil) {
                    [gate wait];
                }

                currentlyExecutingRequest = [[nextSearchRequest retain] autorelease];
                self.nextSearchRequest = nil;
            }
            [gate unlock];

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
    [gate lock];
    {
        self.currentRequestId++;
        self.nextSearchRequest = [SearchRequest requestWithId:currentRequestId
                                                        value:string
                                                        model:self.model];

        [gate broadcast];
    }
    [gate unlock];
}


- (void) reportResult:(SearchResult*) result {
    NSAssert([NSThread isMainThread], nil);

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
                                               bluray:bluray
                                               people:people];
    [self performSelectorOnMainThread:@selector(reportResult:) withObject:result waitUntilDone:NO];
}


- (void) invalidateExistingRequests {
    [gate lock];
    {
        self.currentRequestId++;
        self.nextSearchRequest = nil;
    }
    [gate unlock];
}

@end