//
//  OperationQueue.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OperationQueue.h"

#import "Operation.h"
#import "Operation1.h"
#import "Operation2.h"

@interface OperationQueue()
@property (retain) NSOperationQueue* queue;
@property (retain) NSMutableArray* boundedOperations;
@property (retain) NSLock* boundedOperationsGate;
@end


@implementation OperationQueue

@synthesize queue;
@synthesize boundedOperations;
@synthesize boundedOperationsGate;

- (void) dealloc {
    self.queue = nil;
    self.boundedOperations = nil;
    self.boundedOperationsGate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
        self.boundedOperations = [NSMutableArray array];
        self.boundedOperationsGate = [[[NSLock alloc] init] autorelease];
    }

    return self;
}


+ (OperationQueue*) operationQueue {
    return [[[OperationQueue alloc] init] autorelease];
}


- (void) addOperation:(Operation*) operation priority:(BOOL) queuePriority {
    NSOperationQueuePriority priority;
    switch (queuePriority) {
        case High:
            priority = NSOperationQueuePriorityNormal;
            break;
        case Normal:
            priority = NSOperationQueuePriorityLow;
            break;
        default:
            priority = NSOperationQueuePriorityVeryLow;
            break;
    }

    operation.queuePriority = priority;
    [queue addOperation:operation];
}


- (void) performSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation* operation = [Operation operationWithTarget:target selector:selector operationQueue:self isBounded:NO gate:gate];
    [self addOperation:operation priority:priority];
}


- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation1* operation = [Operation1 operationWithTarget:target selector:selector argument:object operationQueue:self isBounded:NO gate:gate];
    [self addOperation:operation priority:priority];
}


- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation2* operation = [Operation2 operationWithTarget:target selector:selector argument:object1 argument:object2 operationQueue:self isBounded:NO gate:gate];
    [self addOperation:operation priority:priority];
}


const NSInteger MAX_BOUNDED_OPERATIONS = 16;
- (void) addBoundedOperation:(Operation*) operation
                    priority:(QueuePriority) priority {
    [boundedOperationsGate lock];
    {
        [boundedOperations addObject:operation];
        if (boundedOperations.count > MAX_BOUNDED_OPERATIONS) {
            Operation* staleOperation = [boundedOperations objectAtIndex:0];
            [staleOperation cancel];

            [boundedOperations removeObjectAtIndex:0];
        }
    }
    [boundedOperationsGate unlock];

    [self addOperation:operation priority:priority];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation* operation = [Operation operationWithTarget:target selector:selector operationQueue:self isBounded:YES gate:gate];
    [self addBoundedOperation:operation priority:priority];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation1* operation = [Operation1 operationWithTarget:target selector:selector argument:object operationQueue:self isBounded:YES gate:gate];
    [self addBoundedOperation:operation priority:priority];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate priority:(QueuePriority) priority {
    Operation2* operation = [Operation2 operationWithTarget:target selector:selector argument:object1 argument:object2 operationQueue:self isBounded:YES gate:gate];
    [self addBoundedOperation:operation priority:priority];
}


- (void) onAfterBoundedOperationCompleted:(Operation*) operation {
    [boundedOperationsGate lock];
    {
        [boundedOperations removeObject:operation];
    }
    [boundedOperationsGate unlock];
}

@end