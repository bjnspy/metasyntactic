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
 * A {@link Leaf} is the simplest form of a {@link Rope}.  In essense it is
 * just a {@link String} with a preference to not grow past a certain length.
 * If a {@link Rope} contains a leaf that is larger than that preference, and
 * it needs to perform a destructive operation on that leaf, then the leaf will
 * be split appropriately.  This allows the rope to then operate on smaller
 * chunks of data without needing to copy large contiguous blocks of memory
 * around.
 *
 * <p>Note: this class belongs as a nested class of {@link Rope}.  However, IMO
 * that would cause the filesize to become unweildy.  As such, I've separated
 * this out into a top level class.  However, the package scoping keeps classes
 * besides {@link Rope} from using it.
 */
@interface Leaf : Rope {
@private
  /**
   * The underlying string value that this leaf encapsulates.
   */
  NSString* string;
  NSUInteger hash;
}

+ (Rope*) emptyLeaf;

+ (Rope*) createLeaf:(NSString*) value;

@end
