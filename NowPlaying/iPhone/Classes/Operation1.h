//
//  Operation1.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Operation.h"

@interface Operation1 : Operation {
@protected
    id argument1;
}

+ (Operation1*) operationWithTarget:(id) target selector:(SEL) selector argument:(id) argument1 operationQueue:(OperationQueue*) operationQueue isBounded:(BOOL) isBounded;

/* @protected */
- (id) initWithTarget:(id) target selector:(SEL) selector argument:(id) argument1 operationQueue:(OperationQueue*) operationQueue isBounded:(BOOL) isBounded;

@end