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

#import "OperationQueue.h"

#import "Operation.h"
#import "Operation1.h"
#import "Operation2.h"

@interface OperationQueue()
@property (retain) NSOperationQueue* queue_;
@property (retain) NSMutableArray* boundedOperations_;
@property (retain) NSLock* boundedOperationsGate_;
@end


@implementation OperationQueue

@synthesize queue_;
@synthesize boundedOperations_;
@synthesize boundedOperationsGate_;

property_wrapper(NSOperationQueue*, queue, Queue);
property_wrapper(NSMutableArray*, boundedOperations, BoundedOperations);
property_wrapper(NSLock*, boundedOperationsGate, BoundedOperationsGate);

- (void) dealloc {
    self.queue = nil;
    self.boundedOperations = nil;
    self.boundedOperationsGate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        self.queue.maxConcurrentOperationCount = 2;
        self.boundedOperations = [NSMutableArray array];
        self.boundedOperationsGate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (OperationQueue*) operationQueue {
    return [[[OperationQueue alloc] init] autorelease];
}


- (void) addOperation:(Operation*) operation priority:(BOOL) queuePriority {
    operation.queuePriority = queuePriority;
    [self.queue addOperation:operation];
}


- (Operation*) performSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation* operation = [Operation operationWithTarget:target selector:selector operationQueue:self isBounded:NO gate:gate];
    [self addOperation:operation priority:priority];
    return operation;
}


- (Operation*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation1* operation = [Operation1 operationWithTarget:target selector:selector argument:object operationQueue:self isBounded:NO gate:gate];
    [self addOperation:operation priority:priority];
    return operation;
}


- (Operation*) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation2* operation = [Operation2 operationWithTarget:target selector:selector argument:object1 argument:object2 operationQueue:self isBounded:NO gate:gate];
    [self addOperation:operation priority:priority];
    return operation;
}


const NSInteger MAX_BOUNDED_OPERATIONS = 9;
- (void) addBoundedOperation:(Operation*) operation
                    priority:(QueuePriority) priority {
    [self.boundedOperationsGate lock];
    {
        [self.boundedOperations addObject:operation];
        if (self.boundedOperations.count > MAX_BOUNDED_OPERATIONS) {
            Operation* staleOperation = [self.boundedOperations objectAtIndex:0];
            [staleOperation cancel];

            [self.boundedOperations removeObjectAtIndex:0];
        }
    }
    [self.boundedOperationsGate unlock];

    [self addOperation:operation priority:priority];
}


- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation* operation = [Operation operationWithTarget:target selector:selector operationQueue:self isBounded:YES gate:gate];
    [self addBoundedOperation:operation priority:priority];
    return operation;
}


- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation1* operation = [Operation1 operationWithTarget:target selector:selector argument:object operationQueue:self isBounded:YES gate:gate];
    [self addBoundedOperation:operation priority:priority];
    return operation;
}


- (Operation*) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation2* operation = [Operation2 operationWithTarget:target selector:selector argument:object1 argument:object2 operationQueue:self isBounded:YES gate:gate];
    [self addBoundedOperation:operation priority:priority];
    return operation;
}


- (void) onAfterBoundedOperationCompleted:(Operation*) operation {
    [self.boundedOperationsGate lock];
    {
        [self.boundedOperations removeObject:operation];
    }
    [self.boundedOperationsGate unlock];
}

@end