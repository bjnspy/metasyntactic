//
//  Rebalancer.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

/**
 * BAP95
 * Rebalancing produces a balanced version of the argument rope. The original
 * is unaffected.
 *
 * <p>Note: You should not access instances of this class from multiple threads.
 * It should only be created on the stack, used by one thread, and then
 * discarded.  See {@link Concatenation#forceBalance} to see the proper usage.
 */
@interface Rebalancer : NSObject {
@private
  /**
   * BAP95
   * The rebalancing operation maintains an ordered sequence of (empty or)
   * balanced ropes, one for each length interval [Fn, Fn+1), for n >= 2
   */
  NSMutableArray* balancedRopes;
}


- (void) add:(Rope *)rope;

- (Rope*) concatenate;

@end
