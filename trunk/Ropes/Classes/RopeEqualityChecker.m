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

#import "RopeEqualityChecker.h"

#import "Iterator.h"
#import "Leaf.h"
#import "Rope.h"

@interface Rope()
- (NSArray*) leaves;
@end


@interface RopeEqualityChecker()
@property (retain) Rope* rope1;
@property (retain) Rope* rope2;
@property (retain) Iterator* i1;
@property (retain) Iterator* i2;
@property (retain) Leaf* leaf1;
@property (retain) Leaf* leaf2;
@property NSInteger leaf1Start;
@property NSInteger leaf1End;
@property NSInteger leaf2Start;
@property NSInteger leaf2End;
@end

@implementation RopeEqualityChecker

// As we check each chunk of each rope against the other we'll use the
// following enum to dictate what action to take.  If we've reached the end
// and all chunks were equal, we'll return 'ARE_EQUAL' indicating that we
// should return 'true' to the caller.  If we run into two chunks that are
// not equal we'll return 'NOT_EQUAL' to indicate that we can return 'false'
// immediately.  Otherwise we'll return 'KEEP_GOING' to indicate that we
// need to move to the next chunk.
typedef enum {
  ARE_EQUAL,
  NOT_EQUAL,
  KEEP_GOING,
} Result;

@synthesize rope1;
@synthesize rope2;
@synthesize i1;
@synthesize i2;
@synthesize leaf1;
@synthesize leaf2;
@synthesize leaf1Start;
@synthesize leaf1End;
@synthesize leaf2Start;
@synthesize leaf2End;

- (void) dealloc {
  self.rope1 = nil;
  self.rope2 = nil;
  self.i1 = nil;
  self.i2 = nil;
  self.leaf1 = nil;
  self.leaf2 = nil;
  self.leaf1Start = 0;
  self.leaf1End = 0;
  self.leaf2Start = 0;
  self.leaf2End = 0;
  
  [super dealloc];
}


- (id) initWithRope1:(Rope*) rope1_ rope2:(Rope*) rope2_ {
  if ((self = [super init])) {
    self.rope1 = rope1_;
    self.rope2 = rope2_;
  }
  
  return self;
}


+ (RopeEqualityChecker*) createWithRope1:(Rope*) rope1 rope2:(Rope*) rope2 {
  return [[[RopeEqualityChecker alloc] initWithRope1:rope1 rope2:rope2] autorelease];
}


- (void) shiftRope1Leaf {
  self.leaf1 = i1.next;
  
  self.leaf1Start = 0;
  self.leaf1End = leaf1.length;
}


- (void) shiftRope2Leaf {
  self.leaf2 = i2.next;
  
  self.leaf2Start = 0;
  self.leaf2End = leaf2.length;
}


// This method checks a chunk of each rope against the other and returns
// one of three values.  If the chunks were different, or one rope has
// finished and the other hasn't, it returns 'NotEqual'. If the chunks were
// the same, and there is no more rope to look at, it returns 'AreEqual'.
// Otherwise, it returns 'KeepGoing', signifying that we need to continue
// looping.
- (Result) checkLeafFragments {
  NSInteger leaf1SubstringLength = leaf1End - leaf1Start;
  NSInteger leaf2SubstringLength = leaf2End - leaf2Start;
  
  // Find the smaller of the two leaves.
  NSInteger minLength = MIN(leaf1SubstringLength, leaf2SubstringLength);
  
  // Pull out a chunk of string of that length from both leaves
  // Note: a leaf can't ever be larger than 2^32 - 1 characters (since
  // it encapsulates a string), so it's safe to pull out a substring of it.
  NSString* s1 = [[leaf1 subRope:leaf1Start endIndex:(leaf1Start + minLength)] stringValue];
  NSString* s2 = [[leaf2 subRope:leaf2Start endIndex:(leaf2Start + minLength)] stringValue];
  
  // If the strings don't match, the ropes aren't equal
  if (![s1 isEqual:s2]) {
    return NOT_EQUAL;
  }
  
  // There are now 3 possibilities.  The chunks were the same length, the
  // first was smaller than the second, or the first was larger than the
  // second.
  
  // update the start indices since we consumed a portion of each rope
  leaf1Start += minLength;
  leaf2Start += minLength;

  // Note: Because the lengths of the ropes are
  // the same, we simply need to check if we've reached the end of both
  // sequences.  If we have, then the ropes are equal.  Otherwise we need
  // to keep on going to later chunks.
  
  if (leaf1SubstringLength == leaf2SubstringLength) {
    // The chunks were the same length.  This means that we read to the
    // end of both leaves.  We have to move to the next leaf in both ropes
    
    if (!i1.hasNext) {
      // Neither rope had any more leaves.  These ropes are the same!
      return ARE_EQUAL;
    }
  }
  
  // Move onto the next chunk.
  return KEEP_GOING;
}


- (BOOL) checkLeaves {
  // we're guaranteed to have at least one leaf in both trees at this point
  // Get all the leaves in order
  self.i1 = [Iterator iteratorWithEnumerator:rope1.leaves.objectEnumerator];
  self.i2 = [Iterator iteratorWithEnumerator:rope2.leaves.objectEnumerator];
  
  // Now traverse both sequences of leaves, consuming at least one leaf
  // from either rope each time through the loop.  If we detect a
  // difference, fail immediately.  If we get to the end of both ropes
  // then they were equal.
  while (YES) {
    // Note: the first time through this loop, all the start/end indices
    // will be equal to zero.  So we'll immediately move to the next (i.e.
    // first) leaf in both ropes.
    BOOL moveToNextLeafInRope1 = leaf1Start == leaf1End;
    BOOL moveToNextLeafInRope2 = leaf2Start == leaf2End;
    
    if (moveToNextLeafInRope1) {
      [self shiftRope1Leaf];
    }
    
    if (moveToNextLeafInRope2) {
      [self shiftRope2Leaf];
    }
    
    Result result = [self checkLeafFragments];
    switch (result) {
      case ARE_EQUAL: return YES;
      case NOT_EQUAL: return NO;
      case KEEP_GOING: break;
    }
  }
}


- (BOOL) check {
  if (rope1 == rope2) {
    // simple reference equality check
    return YES;
  }
  
  if (rope1 == nil || rope2 == nil) {
    // if they're not reference equals, and one is null, then they can't
    // ever be equal
    return NO;
  }
  
  if (rope1.length != rope2.length) {
    // if we have different lengths, we can't be the same value
    return NO;
  }
  
  if (rope1.isEmpty) {
    // if i'm empty and we both have the same length, then the other is
    // empty as well and we're the same string.
    return YES;
  }
  
  // The simple checks didn't turn up interesting.  Go onto the complicated
  // checks.
  return [self checkLeaves];
}

@end
