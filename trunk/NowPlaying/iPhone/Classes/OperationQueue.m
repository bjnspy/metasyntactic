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
@property (retain) NSLock* gate;
@end


@implementation OperationQueue

@synthesize queue;
@synthesize boundedOperations;
@synthesize gate;

- (void) dealloc {
    self.queue = nil;
    self.boundedOperations = nil;
    self.gate = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.queue = [[[NSOperationQueue alloc] init] autorelease];
        self.boundedOperations = [NSMutableArray array];
        self.gate = [[[NSLock alloc] init] autorelease];
    }
    
    return self;
}


+ (OperationQueue*) operationQueue {
    return [[[OperationQueue alloc] init] autorelease];
}


- (void) addOperation:(Operation*) operation priority:(NSOperationQueuePriority) priority {
    operation.queuePriority = priority;
    [queue addOperation:operation];
}


- (void) performSelector:(SEL) selector onTarget:(id) target {
    [self performSelector:selector onTarget:target priority:NSOperationQueuePriorityLow];
}


- (void) performSelector:(SEL) selector onTarget:(id) target priority:(NSOperationQueuePriority) priority {
    Operation* operation = [Operation operationWithTarget:target selector:selector operationQueue:self isBounded:NO];
    [self addOperation:operation priority:priority];
}


- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object {
    [self performSelector:selector onTarget:target withObject:object priority:NSOperationQueuePriorityLow];
}


- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object priority:(NSOperationQueuePriority) priority {
    Operation1* operation = [Operation1 operationWithTarget:target selector:selector argument:object operationQueue:self isBounded:NO];
    [self addOperation:operation priority:priority];
}


- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 {
    [self performSelector:selector onTarget:target withObject:object1 withObject:object2 priority:NSOperationQueuePriorityLow];
}


- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 priority:(NSOperationQueuePriority) priority {
    Operation2* operation = [Operation2 operationWithTarget:target selector:selector argument:object1 argument:object2 operationQueue:self isBounded:NO];
    [self addOperation:operation priority:priority];
}


const NSInteger MAX_BOUNDED_OPERATIONS = 16;
- (void) addBoundedOperation:(Operation*) operation
                    priority:(NSOperationQueuePriority) priority {
    [gate lock];
    {
        [boundedOperations addObject:operation];
        if (boundedOperations.count > MAX_BOUNDED_OPERATIONS) {
            Operation* staleOperation = [boundedOperations objectAtIndex:0];
            [staleOperation cancel];
            
            [boundedOperations removeObjectAtIndex:0];
        }
    }
    [gate unlock];
    
    operation.queuePriority = priority;
    [queue addOperation:operation];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target {
    [self performBoundedSelector:selector onTarget:target priority:NSOperationQueuePriorityLow];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target priority:(NSOperationQueuePriority) priority {
    Operation* operation = [Operation operationWithTarget:target selector:selector operationQueue:self isBounded:YES];
    [self addBoundedOperation:operation priority:priority];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object {
    [self performBoundedSelector:selector onTarget:target withObject:object priority:NSOperationQueuePriorityLow];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object priority:(NSOperationQueuePriority) priority {
    Operation1* operation = [Operation1 operationWithTarget:target selector:selector argument:object operationQueue:self isBounded:YES];
    [self addBoundedOperation:operation priority:priority];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 {
    [self performBoundedSelector:selector onTarget:target withObject:object1 withObject:object2 priority:NSOperationQueuePriorityLow];
}


- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 priority:(NSOperationQueuePriority) priority {
    Operation2* operation = [Operation2 operationWithTarget:target selector:selector argument:object1 argument:object2 operationQueue:self isBounded:YES];
    [self addBoundedOperation:operation priority:priority];
}


- (void) onAfterBoundedOperationCompleted:(Operation*) operation {
    [gate lock];
    {
        [boundedOperations removeObject:operation];
    }
    [gate unlock];
}

@end