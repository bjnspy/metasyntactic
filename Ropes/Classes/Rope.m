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

#import "Leaf.h"
#import "RopeEqualityChecker.h"

@implementation Rope

/**
 * Creates a new rope consisting of the provided string.
 *
 * @param value The value to make the rope out of.
 * @return the new rope.
 */
+ (Rope*) createRope:(NSString*) value {
  return [Leaf createLeaf:value];
}


+ (Rope*) emptyRope {
  return [Leaf emptyLeaf];
}


/**
 * Leafs up to this length will be merged when ropes are concatenated.  This
 * helps prevent the rope from consisting of too many leaves (which would
 * slow down common operations on small strings.
 * Because ropes that are smaller than 1k characters will only contain one
 * node, they can be used interchangeably with strings with very little
 * overhead.
 */
+ (NSInteger) coalesceLeafLength {
  return 1 << 10;
}


/**
 * Returns the character in this rope at the provided index.
 *
 * @return the character.
 * @see {@link String#charAt(int)}
 */
- (unichar) characterAtIndex:(NSInteger) index AbstractMethod;


/**
 * @return the number of characters in this rope.
 */
- (NSInteger) length AbstractMethod;


/**
 * Returns the index within this rope of the first occurrence of the
 * specified character.
 *
 * <p>Note: this method accepts an integer in case you are looking for a 32 bit
 * unicode codepoint.
 *
 * @param c a character
 * @return the index of the first occurrence of the character in this rope,
 * or {@code -1} if the character does not occur.
 *
 * @see {@link String#indexOf(int)}
 */
- (NSInteger) indexOf:(unichar) c AbstractMethod;


/**
 * Subclasses should implement this method to extract and return the
 * requested subrope.
 *
 * @see {@link #subRope(long, long)}
 */
- (Rope*) subRopeWorker:(NSInteger) beginIndex endIndex:(NSInteger) endIndex AbstractMethod;


/**
 * @return The depth of the rope.  See BAP95.
 */
- (uint8_t) depth AbstractMethod;


/**
 * Helper method for {@link #stringValue}.  Allows us to concatenate all the
 * leaves using a single NSMutableString.
 */
- (void) addToMutableString:(NSMutableString*) builder AbstractMethod;


/**
 * Subclasses should implement this method to return the rope that is
 * equivalent to {@code other} appended to themself.
 *
 * @see {@link #append(Rope)}
 */
- (Rope*) appendRopeWorker:(Rope*) other AbstractMethod;


/**
 * Subclasses should implement this method to return all the leaves contained
 * within themselves in left to right order.  This is used by methods in this
 * class to traverse the entire rope from left to right one leaf at a time
 *
 * @param leaves The list to add the leaves to
 */
- (void) addLeaves:(NSMutableArray*) leaves AbstractMethod;


/**
 * A string with the same characters as this rope.  Note: a rope is only
 * convertible to a string if it has less than 2^31 characters.  Note:
 * it is possible for the conversion of a large rope to a string to fail
 * if the JVM cannot allocate a contiguous sequence of memory long enough
 * to fit all the characters in this rope.
 *
 * @return a string with the same characters as this rope.
 */
- (NSString*) stringValue AbstractMethod;


/**
 * Returns a new string resulting from replacing all occurrences of
 * {@code oldChar} in this string with {@code newChar}.  If no characters are
 * replaced, then this rope will be returned
 *
 * @param oldChar the old character
 * @param newChar the new character
 * @return a rope derived from this rope by replacing every occurrance of
 * oldChar with newChar
 */
- (Rope*) ropeByReplacingOccurrencesOfChar:(unichar)oldChar withChar:(unichar)newChar AbstractMethod;


/**
 * @return {@code true} if this rope is empty, {@code false} otherwise.
 */
- (BOOL) isEmpty {
  return self.length == 0;
}


/**
 * @param beginIndex the beginning index, inclusive.
 *
 * @return a new rope that is a portion of this rope. The substring begins
 * with the character at the specified index and extends to the end of this
 * rope.
 */
- (Rope*) subRope:(NSInteger) beginIndex {
  return [self subRope:beginIndex endIndex:self.length];
}


/**
 * @param beginIndex the beginning index, inclusive.
 * @param endIndex the end index, exclusive.
 *
 * @return a new rope that is a portion of this rope. The portion begins at
 * the specified {@code beginIndex} and extends to the character at index
 * {@code endIndex - 1}. Thus the length of the substring is
 * {@code endIndex-beginIndex}.
 */
- (Rope*) subRope:(NSInteger) beginIndex endIndex:(NSInteger) endIndex {
  if (beginIndex < 0 || endIndex > self.length || beginIndex > endIndex) {
    @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:@"" userInfo:nil];
  }
  
  return [self subRopeWorker:beginIndex endIndex:endIndex];
}


/**
 * Appends the specified character to the end of this rope, producing a new
 * rope as the result.
 *
 * @see {@link #append(Rope)}
 */
- (Rope*) appendChar:(unichar) c {
  return [self appendString:[NSString stringWithCharacters:&c length:1]];
}


/**
 * Appends the specified string to the end of this rope, producing a new
 * rope as the result.
 *
 * @see {@link #append(Rope)}
 */
- (Rope*) appendString:(NSString*) string {
  return [self appendRope:[Rope createRope:string]];
}


/**
 * Appends the specified rope to the end of this rope, producing a new
 * rope as the result.
 *
 * @param rope the rope to append.
 * @return a rope that represents the concatenation of this rope's characters
 * followed by the argument.
 */
- (Rope*) appendRope:(Rope*) rope {
  if (rope == nil) {
    rope = [Leaf emptyLeaf];
  }
  
  if (self.isEmpty) {
    return rope;
  }
  
  if (rope.isEmpty) {
    return self;
  }
  
  return [self appendRopeWorker:rope];
}


/**
 * Prepends the specified character to the beginning of this rope, producing
 * a new rope as the result.
 *
 * @see {@link #prepend(Rope)}
 */
- (Rope*) prependChar:(unichar) c {
  return [self prependString:[NSString stringWithCharacters:&c length:1]];  
}


/**
 * Prepends the specified string to the beginning of this rope, producing
 * a new rope as the result.
 *
 * @see {@link #prepend(Rope)}
 */
- (Rope*) prependString:(NSString*) string {
  return [self prependRope:[Rope createRope:string]];
}


/**
 * Prepends the specified rope to the beginning of this rope, producing
 * a new rope as the result.
 *
 * @param rope the character to prepend.
 * @return a rope that represents the concatenation of the argument and this
 * rope's characters.
 */
- (Rope*) prependRope:(Rope*) rope {
  if (rope == nil) {
    return self;
  }
  
  return [rope appendRope:self];
}


/**
 * Inserts the char argument into this rope at the position specified by
 * {@code index}.
 *
 * @see {@link #insert(long, Rope)}
 */
- (Rope*) insertChar:(unichar) c index:(NSInteger) index {
  return [self insertString:[NSString stringWithCharacters:&c length:1] index:index];
}


/**
 * Inserts the string argument into this rope at the position specified by
 * {@code index}.
 *
 * @see {@link #insert(long, Rope)}
 */
- (Rope*) insertString:(NSString*) string index:(NSInteger) index {
  return [self insertRope:[Rope createRope:string] index:index];
}


/**
 * Inserts the rope argument into this rope at the position specified by
 * {@code index}.
 *
 * @param index the index to insert the rope.
 * @param rope the rope to insert.
 * @return a rope that represents the insertion of the rope argument
 * in the specified index in this rope's characters.
 */
- (Rope*) insertRope:(Rope*) rope index:(NSInteger) index {
  return [self replace:index endIndex:index withRope:rope];
}

/**
 * Removes the characters in a substring of this rope. The substring begins
 * at the specified {@code beginIndex} and extends to the character at index
 * {@code endIndex - 1} or to the end of the sequence if no such character
 * exists. If {@code beginIndex} is equal to {@code endIndex}, no changes are
 * made.
 *
 * @param beginIndex The beginning index, inclusive.
 * @param endIndex The ending index, exclusive.
 * @return a rope that represents the deletion of the specified range from
 * this rope.
 */
- (Rope*) delete:(NSInteger) beginIndex endIndex:(NSInteger) endIndex {
  return [self replace:beginIndex endIndex:endIndex withRope:[Rope emptyRope]];
}


/**
 * Removes the characters in a substring of this rope, and replaces them with
 * the specified character.
 *
 * @see {@link #replace(long, long, Rope)}
 */
- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withChar:(unichar) c {
  return [self replace:beginIndex endIndex:endIndex withString:[NSString stringWithCharacters:&c length:1]];  
}


/**
 * Removes the characters in a substring of this rope, and replaces them with
 * the specified string.
 *
 * @see {@link #replace(long, long, Rope)}
 */
- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withString:(NSString*) string {
  return [self replace:beginIndex endIndex:endIndex withRope:[Rope createRope:string]];
}


/**
 * Removes the characters in a substring of this rope, and replaces them with
 * the specified rope.
 *
 * @param beginIndex The beginning index, inclusive.
 * @param endIndex The ending index, exclusive.
 * @param rope the characters to replace the removed range with
 * @return a rope that represented the deletion of the specified range,
 * along with the insertion of the specified rope to this rope.
 */
- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withRope:(Rope*) rope {
  if (rope == nil) {
    rope = [Leaf emptyLeaf];
  }
  
  Rope* start = [self subRope:0 endIndex:beginIndex];
  Rope* middle = rope;
  Rope* end = [self subRope:endIndex];
  
  return [start appendRope:[middle appendRope:end]];
}


- (BOOL) isEqual:(id)object {
  if (![object isKindOfClass:[Rope class]]) {
    return NO;
  }
  
  return [self isEqualToRope:object];
}


/**
 * Checks if this rope contains the same sequence of characeters as
 * {@code other}.
 *
 * <p>Note: this method can be very expensive if called on a large rope (and
 * will currently fail if there are more than 2^32 leaves in the rope).
 * Clients are recommended to only use this method if their ropes are small.
 *
 * @param other the rope to compare against.
 * @return {@code true} if these ropes contain the same sequence of
 * characters. {@code false} otherwise.
 */
- (BOOL) isEqualToRope:(Rope*) other {
  // The implementation of 'equals' is sufficiently complex that it warrents
  // extraction into it's own class below.
  return [[RopeEqualityChecker createWithRope1:self rope2:other] check];
}


/**
 * Helper method for {@link #equals}.
 *
 * @return all the leaves in left to right order.
 */
- (NSArray*) leaves {
  NSMutableArray* leaves = [NSMutableArray array];
  [self addLeaves:leaves];
  return leaves;
}


+ (NSUInteger) hashString:(NSString*) string {
  NSUInteger hash = 0;  
  NSInteger length = string.length;  
  for (NSInteger i = 0; i < length; i++) {
    hash = 31 * hash + [string characterAtIndex:i];
  }
  return hash;  
}

@end
