// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
