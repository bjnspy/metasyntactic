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

@interface Inserter : NSObject {
@private
  NSMutableArray* balancedRopes;
  /** The original rope to insert.  Named 'x' to match the paper. */
  Rope* x;
  
  /**
   * The location we want to place 'x' into in 'balancedRopes'.
   * Note: this value will change as we're performing the insertion.
   * First, we will start at zero, and traverse 'balancedRopes', until
   * we find the location we want to insert 'x' at.  As we're doing that
   * we'll be concatenating any ropes we find to 'finalBalancedRopes' and
   * replacing them with 'null' inside the array.
   *
   * <p>We'll then concatenate 'x' to 'finalBalancedRope'.  However, this
   * may greatly increase it's size.  As such we will continue incrementing
   * insertion point until we find the final point for 'finalBalancedRope'.
   * Any more ropes we run into will continue to be concatenated to the
   * result.
   *
   * <p>Because this may increase the size of the final rope, we must continue
   * until the final rope's size fits an empty bucket in the array.
   */
  NSInteger insertionPoint;
  
  /**
   * The final rope to place in the array.  Note, it will start as the
   * empty rope.  As we traverse the buckets to find the right location for
   * 'x', we will be concatenating any existing ropes we find to this one.
   * Once we've reached the right point for 'x', we'll concatenate it to
   * this, and then we'll try to find the final bucket location for this
   * rope.
   *
   * <p>Note: as we traverse the buckets, trying to find a final
   * location, we may end up concatenating more ropes to this one.  So we
   * must keep on traversing using the length of *this* rope, and not 'x'
   * to determine the final bucket location.
   */
  Rope* finalRope;
}

- (id) initWithBalancedRopes:(NSMutableArray*) balancedRopes rope:(Rope*) rope;

- (void) insert;

@end
