//
//  Operation.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Operation : NSOperation {
@protected
    OperationQueue* operationQueue;
    BOOL isBounded;
    id target;
    SEL selector;
    id<NSLocking> gate;
}

+ (Operation*) operationWithTarget:(id) target selector:(SEL) selector operationQueue:(OperationQueue*) operationQueue isBounded:(BOOL) isBounded gate:(id<NSLocking>) gate;

/* @protected */
- (id) initWithTarget:(id) target selector:(SEL) selector operationQueue:(OperationQueue*) operationQueue isBounded:(BOOL) isBounded gate:(id<NSLocking>) gate;

@end