//
//  RopeEqualityChecker.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.


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


- (Result) checkLeafFragments {
  NSInteger leaf1SubstringLength = leaf1End - leaf1Start;
  NSInteger leaf2SubstringLength = leaf2End - leaf2Start;
  
  NSInteger minLength = MIN(leaf1SubstringLength, leaf2SubstringLength);
  
  NSString* s1 = [[leaf1 subRope:leaf1Start endIndex:(leaf1Start + minLength)] stringValue];
  NSString* s2 = [[leaf2 subRope:leaf2Start endIndex:(leaf2Start + minLength)] stringValue];
  
  if (![s1 isEqual:s2]) {
    return NOT_EQUAL;
  }
  
  leaf1Start += minLength;
  leaf2Start += minLength;
  
  if (leaf1SubstringLength == leaf2SubstringLength) {
    if (!i1.hasNext) {
      return ARE_EQUAL;
    }
  }
  
  return KEEP_GOING;
}


- (BOOL) checkLeaves {
  self.i1 = [Iterator iteratorWithEnumerator:rope1.leaves.objectEnumerator];
  self.i2 = [Iterator iteratorWithEnumerator:rope2.leaves.objectEnumerator];
  
  while (YES) {
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
    return YES;
  }
  
  if (rope1 == nil || rope2 == nil) {
    return NO;
  }
  
  if (rope1.length != rope2.length) {
    return NO;
  }
  
  if (rope1.isEmpty) {
    return YES;
  }
  
  return [self checkLeaves];
}

@end
