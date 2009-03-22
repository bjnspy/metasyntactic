//
//  Operation1.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Operation1.h"

@interface Operation1()
@property (retain) id argument1;
@end


@implementation Operation1

@synthesize argument1;

- (void) dealloc {
    self.argument1 = nil;
    [super dealloc];
}


- (id) initWithTarget:(id) target_
             selector:(SEL) selector_
             argument:(id)argument1_
       operationQueue:(OperationQueue*) operationQueue_
            isBounded:(BOOL) isBounded_ {
    if (self = [super initWithTarget:target_
                            selector:selector_
                      operationQueue:operationQueue_
                           isBounded:isBounded_]) {
        self.argument1 = argument1_;
    }
    
    return self;
}


+ (Operation1*) operationWithTarget:(id) target
                           selector:(SEL) selector
                           argument:(id) argument1
                     operationQueue:(OperationQueue*) operationQueue 
                          isBounded:(BOOL) isBounded {
    return [[[Operation1 alloc] initWithTarget:target
                                      selector:selector
                                      argument:argument1
                                operationQueue:operationQueue
                                     isBounded:isBounded] autorelease];
}


- (void) mainWorker {
    [target performSelector:selector withObject:argument1];
}


@end
