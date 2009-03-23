//
//  Operation2.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Operation2.h"


@interface Operation2()
@property (retain) id argument2;
@end


@implementation Operation2

@synthesize argument2;

- (void) dealloc {
    self.argument2 = nil;
    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id) argument1_
             argument:(id) argument2_
       operationQueue:(OperationQueue*) operationQueue_
            isBounded:(BOOL) isBounded_
                 gate:(id<NSLocking>) gate_ {
    if (self = [super initWithTarget:target_
                            selector:selector_
                            argument:argument1_
                      operationQueue:operationQueue_
                           isBounded:isBounded_
                                gate:gate_]) {
        self.argument2 = argument2_;
    }

    return self;
}


+ (Operation2*) operationWithTarget:(id) target
                           selector:(SEL) selector
                           argument:(id) argument1
                           argument:(id) argument2
                     operationQueue:(OperationQueue*) operationQueue
                          isBounded:(BOOL) isBounded
                               gate:(id<NSLocking>) gate {
    return [[[Operation2 alloc] initWithTarget:target
                                      selector:selector
                                      argument:argument1
                                      argument:argument2
                                operationQueue:operationQueue
                                     isBounded:isBounded
                                          gate:gate] autorelease];
}


- (void) mainWorker {
    [target performSelector:selector withObject:argument1 withObject:argument2];
}

@end