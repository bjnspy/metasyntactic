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

#import "Inserter.h"

#import "Concatenation.h"
#import "Fibonacci.h"

@interface Concatenation()
+ (Rope*) mergeLeft:(id)left right:(id)right;
@end

@interface Inserter()
@property (retain) NSMutableArray* balancedRopes;
@property (retain) Rope* x;
@property NSInteger insertionPoint;
@property (retain) Rope* finalRope;
@end

@implementation Inserter

@synthesize balancedRopes;
@synthesize x;
@synthesize insertionPoint;
@synthesize finalRope;

- (void) dealloc {
  self.balancedRopes = nil;
  self.x = nil;
  self.insertionPoint = 0;
  self.finalRope = nil;
  
  [super dealloc];
}


- (id) initWithBalancedRopes:(NSMutableArray*) balancedRopes_
                        rope:(Rope*) rope_ {
  // It's important that x's length be greater than 0.  Here's why:
  // Because x's length is at least 1, then we know that at the very
  // least 'insertionPoint' will be set to '1' after we call
  // concatenateRopesUpToActualInsertionPoint.  That's because
  // '1' >= nthFibonacciNumber[0].  So we'll increment insertionPoint
  // in the loop to '1'.  That makes it safe to then call:
  // balancedRopes[insertionPoint - 1], as the final line of the
  // insertion
  if ((self = [super init])) {
    self.balancedRopes = balancedRopes_;
    self.x = rope_;
  }
  
  return self;
}


- (void) mergeRopesAndMoveToNextBucket {
  id balancedRope = [balancedRopes objectAtIndex:insertionPoint];
  self.finalRope = [Concatenation mergeLeft:balancedRope right:finalRope];
  [balancedRopes replaceObjectAtIndex:insertionPoint withObject:[NSNull null]];
  
  insertionPoint++;
}


- (void) concatenateExistingRopesUpToExpectedInsertionPoint {
  // Note that for this loop we're comparing x's length to the insertion
  // point.  In the lower loop we'll be comparing the length of
  // 'finalRope'
  while (x.length > [Fibonacci fibonacciArray][insertionPoint + 1]) {
    [self mergeRopesAndMoveToNextBucket];
  }
}


- (void) concatenateRopesUpToActualInsertionPoint {
  // Here we use the length of the finalRope to try to determine where
  // to place it.  This value may change as we merge ropes together,
  // we we must keep calculating this each time through the loop.
  while (finalRope.length >= [Fibonacci fibonacciArray][insertionPoint]) {
    [self mergeRopesAndMoveToNextBucket];
  }
}


- (void) insert {
  // BAP95
  // Assume that x's length is in the interval [Fn, Fn+1), and thus it
  // should be put in slot n (which also corresponds to maximum depth
  // n - 2). If all lower and equal numbered levels are empty, then this
  // can be done directly. If not, then we concatenate ropes in slots
  // 2,...,(n - 1) (concatenating onto the left),
  [self concatenateExistingRopesUpToExpectedInsertionPoint];
  
  // BAP95
  // and concatenate x to the right of the result.
  self.finalRope = [Concatenation mergeLeft:finalRope right:x];
  
  // BAP95
  // We then continue to concatenate ropes from the sequence in increasing
  // order to the left of this result, until the result fits into an empty
  // slot in the sequence.
  [self concatenateRopesUpToActualInsertionPoint];
  
  // Insert the rope into its final location.
  [balancedRopes replaceObjectAtIndex:insertionPoint - 1
                           withObject:finalRope];
}

@end
