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

#import "Rebalancer.h"

#import "Concatenation.h"
#import "Fibonacci.h"
#import "Inserter.h"

@interface Rope()
- (uint8_t) depth;
@end

@interface Concatenation()
+ (Rope*) mergeLeft:(id) left right:(id) right;
- (Rope*) left;
- (Rope*) right;
@end

@interface Rebalancer()
@property (retain) NSMutableArray* balancedRopes;
@end


@implementation Rebalancer

@synthesize balancedRopes;

- (void) dealloc {
  self.balancedRopes = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.balancedRopes = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [Fibonacci fibonacciArrayLength]; i++) {
      [balancedRopes addObject:[NSNull null]];
    }
  }
  
  return self;
}


- (void) add:(Rope*) rope {
  // BAP95
  // traverse the rope from left to right, inserting each node into the
  // appropriate sequence position, depending on its length.
  //
  // cyrusn:
  // We do a depth first traversal of the tree, adding any leaves we run
  // into.  Note: as an optimization we do not descend into any balanced
  // nodes as we would just end up ripping them apart and putting them
  // right back together again.
  if ([rope isKindOfClass:[Concatenation class]]) {
    if (rope.length < [Fibonacci fibonacciArray][rope.depth]) {
      id concat = rope;
      [self add:[concat left]];
      [self add:[concat right]];
      return;
    }
  }
  
  // Inserting a rope is actually rather complicated.  So we create a
  // specialized class to handle it for us.
  Inserter* inserter = [[[Inserter alloc] initWithBalancedRopes:balancedRopes rope:rope] autorelease];
  [inserter insert];
}


/**
 * BAP95
 * The final step in balancing a rope is to concatenate the sequence of
 * ropes in order of increasing size. The resulting rope will not be
 * balanced in the above sense, but its depth will exceed the desired value
 * by at most 2. One additional root node may be introduced by the final
 * concatenation. (Indeed, this is necessary. Consider concatenating a
 * small leaf to a large balanced tree to another small leaf. We must add
 * 2 to the depth of the resulting tree unless we re-examine the balanced
 * tree.
 */
- (Rope*) concatenate {
  Rope* result = nil;
  
  for (Rope* balancedRope in balancedRopes) {
    result = [Concatenation mergeLeft:balancedRope right:result];
  }
  
  return result;
}

@end
