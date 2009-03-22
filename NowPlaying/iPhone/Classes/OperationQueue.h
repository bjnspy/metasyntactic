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
    NSLock* boundedOperationsGate;
}

+ (OperationQueue*) operationQueue;

- (void) performSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate;

- (void) performSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate visible:(BOOL) visible;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate visible:(BOOL) visible;
- (void) performSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate visible:(BOOL) visible;

- (void) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate;

- (void) performBoundedSelector:(SEL) selector onTarget:(id) target gate:(id<NSLocking>) gate visible:(BOOL) visible;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object gate:(id<NSLocking>) gate visible:(BOOL) visible;
- (void) performBoundedSelector:(SEL) selector onTarget:(id) target withObject:(id) object1 withObject:(id) object2 gate:(id<NSLocking>) gate visible:(BOOL) visible;

/* @package */
- (void) onAfterBoundedOperationCompleted:(Operation*) operation;

@end
