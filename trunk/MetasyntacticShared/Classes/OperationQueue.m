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

#import "OperationQueue.h"

#import "NSArray+Utilities.h"
#import "NSMutableArray+Utilities.h"
#import "Operation3.h"

@interface OperationQueue()
@property (retain) NSOperationQueue* queue;
@property (retain) NSMutableArray* boundedOperations;
@property (retain) id<NSLocking> dataGate;
@end


@implementation OperationQueue

static OperationQueue* operationQueue = nil;

+ (void) initialize {
  if (self == [OperationQueue class]) {
    operationQueue = [[OperationQueue alloc] init];
  }
}

@synthesize queue;
@synthesize boundedOperations;
@synthesize dataGate;

- (void) dealloc {
  self.queue = nil;
  self.boundedOperations = nil;
  self.dataGate = nil;

  [super dealloc];
}


- (void) addOperation:(Operation*) operation {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(addOperation:) withObject:operation waitUntilDone:NO];
    return;
  }

  [dataGate lock];
  {
    [queue addOperation:operation];

    if (operation.queuePriority >= Priority) {
      priorityOperationsCount++;
    }
  }
  [dataGate unlock];
}


- (void) restart:(Operation*) operationToKill {
  [dataGate lock];
  {
    self.queue = [[[NSOperationQueue alloc] init] autorelease];
    queue.maxConcurrentOperationCount = 1;

    self.boundedOperations = [NSMutableArray array];
    priorityOperationsCount = 0;
  }
  [dataGate unlock];
}


- (void) restart {
  [self restart:nil];
}


- (id) init {
  if ((self = [super init])) {
    self.dataGate = [[[NSRecursiveLock alloc] init] autorelease];

    // Ugly hack.
    CGSize size = [[UIScreen mainScreen] bounds].size;
    maxBoundedOperations = (MAX(size.width, size.height) / 100);

    [self restart];
  }

  return self;
}


+ (OperationQueue*) operationQueue {
  return operationQueue;
}


- (Operation*) performSelector:(SEL) selector
                      onTarget:(id) target
                          gate:(id<NSLocking>) gate
                      priority:(QueuePriority) priority {
  Operation* operation = [Operation operationWithTarget:target
                                               selector:selector
                                         operationQueue:self
                                              isBounded:NO
                                                   gate:gate
                                               priority:priority];
  [self addOperation:operation];
  return operation;
}


- (Operation1*) performSelector:(SEL) selector
                       onTarget:(id) target
                     withObject:(id) object
                           gate:(id<NSLocking>) gate
                       priority:(QueuePriority) priority {
  Operation1* operation = [Operation1 operationWithTarget:target
                                                 selector:selector
                                                 argument:object
                                           operationQueue:self
                                                isBounded:NO
                                                     gate:gate
                                                 priority:priority];
  [self addOperation:operation];
  return operation;
}


- (Operation2*) performSelector:(SEL) selector
                       onTarget:(id) target
                     withObject:(id) object1
                     withObject:(id) object2
                           gate:(id<NSLocking>) gate
                       priority:(QueuePriority) priority {
  Operation2* operation = [Operation2 operationWithTarget:target
                                                 selector:selector
                                                 argument:object1
                                                 argument:object2
                                           operationQueue:self
                                                isBounded:NO
                                                     gate:gate
                                                 priority:priority];
  [self addOperation:operation];
  return operation;
}


- (Operation3*) performSelector:(SEL) selector
                       onTarget:(id) target
                     withObject:(id) object1
                     withObject:(id) object2
                     withObject:(id) object3
                           gate:(id<NSLocking>) gate
                       priority:(QueuePriority) priority {
  Operation3* operation = [Operation3 operationWithTarget:target
                                                 selector:selector
                                                 argument:object1
                                                 argument:object2
                                                 argument:object3
                                           operationQueue:self
                                                isBounded:NO
                                                     gate:gate
                                                 priority:priority];
  [self addOperation:operation];
  return operation;
}


- (void) addBoundedOperation:(Operation*) operation {
  [dataGate lock];
  {
    if (boundedOperations.count > maxBoundedOperations) {
      // too many operations.  cancel the oldest one.
      Operation* staleOperation = boundedOperations.firstObject;
      [staleOperation cancel];

      [boundedOperations removeFirstObject];
    }

    [boundedOperations addObject:operation];
  }
  [dataGate unlock];

  [self addOperation:operation];
}


- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
  Operation* operation = [Operation operationWithTarget:target
                                               selector:selector
                                         operationQueue:self
                                              isBounded:YES
                                                   gate:gate
                                               priority:priority];
  [self addBoundedOperation:operation];
  return operation;
}


- (Operation1*) performBoundedSelector:(SEL) selector
                              onTarget:(id) target
                            withObject:(id) object
                                  gate:(id<NSLocking>) gate
                              priority:(QueuePriority) priority {
  Operation1* operation = [Operation1 operationWithTarget:target
                                                 selector:selector
                                                 argument:object
                                           operationQueue:self
                                                isBounded:YES
                                                     gate:gate
                                                 priority:priority];
  [self addBoundedOperation:operation];
  return operation;
}


- (Operation2*) performBoundedSelector:(SEL) selector
                              onTarget:(id) target
                            withObject:(id) object1
                            withObject:(id) object2
                                  gate:(id<NSLocking>) gate
                              priority:(QueuePriority) priority {
  Operation2* operation = [Operation2 operationWithTarget:target
                                                 selector:selector
                                                 argument:object1
                                                 argument:object2
                                           operationQueue:self
                                                isBounded:YES
                                                     gate:gate
                                                 priority:priority];
  [self addBoundedOperation:operation];
  return operation;
}


- (void) onAfterBoundedOperationCompleted:(Operation*) operation {
  [dataGate lock];
  {
    [boundedOperations removeObject:operation];
  }
  [dataGate unlock];
}


- (void) temporarilySuspend:(NSTimeInterval) timeInterval {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resume) object:nil];
  [dataGate lock];
  {
    [queue setSuspended:YES];
  }
  [dataGate unlock];
  [self performSelector:@selector(resume) withObject:nil afterDelay:timeInterval];
}


- (void) temporarilySuspend {
  [self temporarilySuspend:1];
}


- (void) resume {
  [dataGate lock];
  {
    [queue setSuspended:NO];
  }
  [dataGate unlock];
}


- (BOOL) hasPriorityOperations {
  BOOL result;
  [dataGate lock];
  {
    result = (priorityOperationsCount > 0);
  }
  [dataGate unlock];
  return result;
}


- (void) notifyOperationDestroyed:(Operation*) operation
                     withPriority:(QueuePriority) priority {
  [dataGate lock];
  {
    if (priority >= Priority) {
      priorityOperationsCount--;
    }
  }
  [dataGate unlock];
}


@end
