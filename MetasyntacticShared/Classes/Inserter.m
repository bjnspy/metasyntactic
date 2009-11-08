//
//  Inserter.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
  while (x.length > [Fibonacci fibonacciArray][insertionPoint + 1]) {
    [self mergeRopesAndMoveToNextBucket];
  }
}


- (void) concatenateRopesUpToActualInsertionPoint {
  while (finalRope.length >= [Fibonacci fibonacciArray][insertionPoint]) {
    [self mergeRopesAndMoveToNextBucket];
  }
}


- (void) insert {
  [self concatenateExistingRopesUpToExpectedInsertionPoint];
  self.finalRope = [Concatenation mergeLeft:finalRope right:x];
  [self concatenateRopesUpToActualInsertionPoint];
  
  [balancedRopes replaceObjectAtIndex:insertionPoint - 1
                           withObject:finalRope];
}

@end
