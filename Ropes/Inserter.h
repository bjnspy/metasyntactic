//
//  Inserter.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Inserter : NSObject {
@private
  NSMutableArray* balancedRopes;
  Rope* x;
  NSInteger insertionPoint;
  Rope* finalRope;
}

- (id) initWithBalancedRopes:(NSMutableArray*) balancedRopes rope:(Rope*) rope;

- (void) insert;

@end
