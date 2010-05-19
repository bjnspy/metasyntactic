// Copyright 2010 Cyrus Najmabadi
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
