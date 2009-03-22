//
//  Operation.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Operation.h"

#import "OperationQueue.h"


@interface Operation()
@property (assign) OperationQueue* operationQueue;
@property (retain) id target;
@property SEL selector;
@property BOOL isBounded;
@end


@implementation Operation

@synthesize operationQueue;
@synthesize target;
@synthesize selector;
@synthesize isBounded;

- (void) dealloc {
    self.operationQueue = nil;
    self.target = nil;
    self.selector = nil;
    self.isBounded = NO;

    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
       operationQueue:(OperationQueue*) operationQueue_
            isBounded:(BOOL) isBounded_ {
    if (self = [super init]) {
        self.target = target_;
        self.selector = selector_;
        self.operationQueue = operationQueue_;
        self.isBounded = isBounded_;
    }
    
    return self;
}


+ (Operation*) operationWithTarget:(id) target
                          selector:(SEL) selector
                    operationQueue:(OperationQueue*) operationQueue
                         isBounded:(BOOL) isBounded {
    return [[[Operation alloc] initWithTarget:target
                                     selector:selector
                               operationQueue:operationQueue
                                    isBounded:isBounded] autorelease];
}

/*
- (BOOL)isEqual:(id)anObject {
    if (![anObject isKindOfClass:[Operation class]]) {
        return NO;
    }
    
    Operation* other = anObject;
    return target == other.target && selector == other.selector;
}
 */


- (void) mainWorker {
    [target performSelector:selector];
}


- (void) main {
    [self mainWorker];
    if (isBounded) {
        [operationQueue onAfterBoundedOperationCompleted:self];
    }
}

@end
