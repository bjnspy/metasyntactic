//
//  Concatenation.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Rope.h"

/**
 * When a {@link Rope} grows too large to be represented by a {@link Leaf},
 * a {@link Concatenation} is used to break the rope up into smaller sections.
 * This has several benefits.  Because the rope is composed of small pieces,
 * destructive operations can happen within the rope without requiring large
 * memory copies (which incur too much overhead).
 *
 * <p>This implementation is tuned to the common operation of adding strings or
 * characters to the end of an existing rope.  Rather than always forming a
 * tree, this implementation will merge children as appropriate to keep most
 * operations running with constant, rather than logarithmic, time.
 *
 * <p>This implementation will also allow the tree to become fairly unbalanced
 * (to a point).  This keeps operations fast on small strings (<16k characters)
 * by not forcing rebalances that wouldn't significantly improve running time.
 */
@interface Concatenation : Rope {
@private
  /** The left child of this concatenation node */
  Rope* left;
  
  /** The right child of this concatenation node */
  Rope* right;
  
  /**
   * The length of this node.  Equivalent to the length of our left and right
   * children combined.
   */
  NSInteger length;
  
  /**
   * BAP95
   * We define the depth ... of a concatenation to be one plus the maximum
   * depth of its children.
   */
  uint8_t depth;

  /**
   * The value of this rope's concatenation once it has been calculated.  The
   * value is zero if we haven't calculated the value yet.
   *
   * <p>Note: this is threadsafe because int reads/writes are always atomic.
   */
  NSUInteger hash;
}

@property (readonly) NSInteger length;
@property (readonly) uint8_t depth;

+ (Rope*) createWithLeft:(Rope*) left right:(Rope*) right;

@end
