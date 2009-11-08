//
//  Rebalancer.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
  if ([rope isKindOfClass:[Concatenation class]]) {
    if (rope.length < [Fibonacci fibonacciArray][rope.depth]) {
      id concat = rope;
      [self add:[concat left]];
      [self add:[concat right]];
      return;
    }
  }
  
  Inserter* inserter = [[[Inserter alloc] initWithBalancedRopes:balancedRopes rope:rope] autorelease];
  [inserter insert];
}


- (Rope*) concatenate {
  Rope* result = nil;
  
  for (Rope* balancedRope in balancedRopes) {
    result = [Concatenation mergeLeft:balancedRope right:result];
  }
  
  return result;
}

@end
