//
//  Operation2.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Operation1.h"

@interface Operation2 : Operation1 {
@protected
    id argument2;
}

+ (Operation2*) operationWithTarget:(id) target selector:(SEL) selector argument:(id) argument1 argument:(id) argument2 operationQueue:(OperationQueue*) operationQueue  isBounded:(BOOL) isBounded;

/* @protected */
- (id) initWithTarget:(id) target selector:(SEL) selector argument:(id) argument1 argument:(id) argument2 operationQueue:(OperationQueue*) operationQueue isBounded:(BOOL) isBounded;

@end