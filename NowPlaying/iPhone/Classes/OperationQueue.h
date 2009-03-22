//
//  OperationQueue.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface OperationQueue : NSObject {
@private
    NSOperationQueue* queue;
    NSMutableArray* boundedOperations;
    NSLock* gate;
}

+ (OperationQueue*) operationQueue;

- (void) performSelector:(SEL) selector onTarget:(id) target;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2;

- (void) performSelector:(SEL) selector onTarget:(id) target priority:(NSOperationQueuePriority) priority;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object priority:(NSOperationQueuePriority) priority;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 priority:(NSOperationQueuePriority) priority;

- (void) performBoundedSelector:(SEL) selector onTarget:(id) target;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2;

- (void) performBoundedSelector:(SEL) selector onTarget:(id) target priority:(NSOperationQueuePriority) priority;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object priority:(NSOperationQueuePriority) priority;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 priority:(NSOperationQueuePriority) priority;

/* @package */
- (void) onAfterBoundedOperationCompleted:(Operation*) operation;

@end
