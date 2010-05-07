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

#import "AbstractSearchRequest.h"
#import "AbstractSearchResult.h"
#import "MetasyntacticSharedApplication.h"
#import "NotificationCenter.h"
#import "ThreadingUtilities.h"

@interface AbstractSearchEngine()
@property (assign) id<SearchEngineDelegate> delegate;
@property NSInteger currentRequestId;
@property (retain) AbstractSearchRequest* nextSearchRequest;
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


- (id) initWithDelegate:(id<SearchEngineDelegate>) delegate_ {
  if ((self = [super init])) {
    self.currentRequestId = 0;
    self.delegate = delegate_;
    self.gate = [[[NSCondition alloc] init] autorelease];

    [ThreadingUtilities backgroundSelector:@selector(searchThreadEntryPoint)
                                  onTarget:self
                                      gate:nil
                                    daemon:YES];
  }

  return self;
}


- (void) searchWorker:(AbstractSearchRequest*) request AbstractMethod;


- (AbstractSearchRequest*) createSearchRequest:(NSInteger) requestId
                                         value:(NSString*) value AbstractMethod;


- (BOOL) abortEarly:(AbstractSearchRequest*) currentlyExecutingRequest {
  BOOL result;

  [gate lock];
  {
    result = currentlyExecutingRequest.requestId != currentRequestId;
  }
  [gate unlock];

  return result;
}


- (void) search:(AbstractSearchRequest*) request {
  NSString* notification = [LocalizedString(@"Searching", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self searchWorker:request];
  }
  [NotificationCenter removeNotification:notification];
}


- (void) searchLoopWorker {
  AbstractSearchRequest* currentlyExecutingRequest = nil;
  [gate lock];
  {
    while (nextSearchRequest == nil) {
      [gate wait];
    }

    currentlyExecutingRequest = [[nextSearchRequest retain] autorelease];
    self.nextSearchRequest = nil;
  }
  [gate unlock];

  if (lastSearchTime == 0) {
    // if it's the first search, then wait a second to start searching.
    [NSThread sleepForTimeInterval:1];
  } else {
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = ABS(lastSearchTime - currentTime);
    if (elapsedTime < 1) {
      // don't search that often.  If we're searching again and a second
      // hasn't even passed, then wait until a second has passed since
      // the last search and then proceed.
      [NSThread sleepForTimeInterval:1 - elapsedTime];
    }
  }

  [self search:currentlyExecutingRequest];

  // Keep track of when we stopped searching.  Don't start again until
  // we get a bit more input.
  lastSearchTime = [NSDate timeIntervalSinceReferenceDate];
}


- (void) searchThreadEntryPoint {
  while (true) {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    {
      [self searchLoopWorker];
    }
    [autoreleasePool release];
  }
}


- (void) submitRequest:(NSString*) string {
  [gate lock];
  {
    self.currentRequestId++;
    self.nextSearchRequest = [self createSearchRequest:currentRequestId
                                                 value:string];

    [gate broadcast];
  }
  [gate unlock];
}


- (void) reportResult:(AbstractSearchResult*) result {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(reportResult:) withObject:result waitUntilDone:NO];
    return;
  }

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


- (void) invalidateExistingRequests {
  [gate lock];
  {
    self.currentRequestId++;
    self.nextSearchRequest = nil;
  }
  [gate unlock];
}

@end
