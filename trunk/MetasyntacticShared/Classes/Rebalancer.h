//
//  Rebalancer.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Rebalancer : NSObject {
@private
  NSMutableArray* balancedRopes;
}


- (void) add:(Rope *)rope;

- (Rope*) concatenate;

@end
