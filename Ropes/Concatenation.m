//
//  Concatenation.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.


#import "Concatenation.h"

#import "Fibonacci.h"
#import "Leaf.h"
#import "Rebalancer.h"

@interface Rope()
- (uint8_t) depth;
- (void) addLeaves:(NSMutableArray *)leaves;
- (void) addToMutableString:(NSMutableString*) string;
@end

@interface Concatenation()
@property (retain) Rope* left;
@property (retain) Rope* right;
@property NSInteger length;
@property uint8_t depth;
@property NSUInteger hash;
@end


@implementation Concatenation

static const NSInteger COALESCE_LEAF_LENGTH = 1 << 10;
static const NSInteger MAX_TREE_IMBALANCE = 16;

@synthesize left;
@synthesize right;
@synthesize length;
@synthesize depth;
@synthesize hash;

- (void) dealloc {
  self.left = nil;
  self.right = nil;
  self.length = 0;
  self.depth = 0;
  self.hash = 0;
  
  [super dealloc];
}


- (id) initWithLeft:(Rope*) left_ right:(Rope*) right_ {
  if ((self = [super init])) {
    self.left = left_;
    self.right = right_;
    self.length = left.length + right.length;
    self.depth = 1 + MAX(left.depth, right.depth);
  }
  
  return self;
}


- (BOOL) isBalanced {
  if (self.depth < MAX_TREE_IMBALANCE) {
    return YES;
  }
  
  if (self.depth >= [Fibonacci fibonacciArrayLength] - 1) {
    return NO;
  }
  
  return self.length >= [Fibonacci fibonacciArray][self.depth];
}


- (Rope*) forceBalance {
  Rebalancer* rebalancer = [[[Rebalancer alloc] init] autorelease];
  [rebalancer add:self];
  return [rebalancer concatenate];
}


- (Rope*) balance {
  if (self.isBalanced) {
    return self;
  }
  
  return [self forceBalance];
}


+ (Rope*) createWithLeft:(Rope*) left right:(Rope*) right {
  Concatenation* concatenation = [[[Concatenation alloc] initWithLeft:left right:right] autorelease];
  return [concatenation balance];
}


+ (Rope*) mergeLeft:(id) left right:(id) right {
  if (left == nil || left == [NSNull null]) {
    return right;
  } else if (right == nil || right == [NSNull null]) {
    return left;
  } else {
    return [[[Concatenation alloc] initWithLeft:left right:right] autorelease];
  }
}


NSUInteger power(NSUInteger base, NSUInteger exponent) {
  if (exponent == 0) {
    return 1;
  } else if ((exponent %2) == 1) {
    return base * power(base * base, exponent / 2);
  } else {
    return power(base * base, exponent / 2);
  }
}


- (NSUInteger) hash {
  if (hash == 0) {
    self.hash = left.hash * power(31, right.length) + right.hash;
  }
  
  return hash;
}


- (void) addLeaves:(NSMutableArray *)leaves {
  [left addLeaves:leaves];
  [right addLeaves:leaves];
}


- (NSString*) stringValue {
  NSMutableString* builder = [NSMutableString string];
  [self addToMutableString:builder];
  return builder;
}


- (void) addToMutableString:(NSMutableString*) string {
  [left addToMutableString:string];
  [right addToMutableString:string];
}


- (Rope*) appendRopeWorker:(Rope *)other {
  if ([right isKindOfClass:[Leaf class]] && [other isKindOfClass:[Leaf class]]) {
    NSInteger finalLength = right.length + other.length;
    if (finalLength <= COALESCE_LEAF_LENGTH) {
      return [left appendRope:[right appendRope:other]];
    }
  }
  
  return [Concatenation createWithLeft:self right:other];
}


- (Rope*) subRopeWorker:(NSInteger)beginIndex endIndex:(NSInteger)endIndex {
  NSInteger substringLength = endIndex - beginIndex;
  if (substringLength == 0) {
    return [Leaf emptyLeaf];
  }
  
  Rope* newLeft;
  if (beginIndex == 0 && substringLength >= left.length) {
    newLeft = left;
  } else {
    NSInteger start = MIN(left.length, beginIndex);
    NSInteger end = MIN(left.length, start + substringLength);
    
    newLeft = [left subRope:start endIndex:end];
  }
  
  Rope* newRight;
  if (beginIndex <= left.length && endIndex == self.length) {
    newRight = right;
  } else {
    NSInteger start = MAX(0, beginIndex - left.length);
    NSInteger remaining = substringLength - newLeft.length;
    NSInteger end = start + remaining;
    
    newRight = [right subRope:start endIndex:end];
  }
  
  return [newLeft appendRope:newRight];
}


- (unichar) characterAt:(NSInteger)index {
  if (index < 0 || index >= self.length) {
    @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:@"" userInfo:nil];
  }
  
  if (index < self.length) {
    return [left characterAt:index];
  } else {
    return [right characterAt:(index - left.length)];
  }
}


- (NSInteger) indexOf:(unichar)c {
  NSInteger val = [left indexOf:c];
  if (val != NSNotFound) {
    return val;
  }
  
  //  if (Character.charCount(codePoint) == 2) {
  //    // scary special case.  If it's a 32bit unicode character that crosses the
  //    // boundary between the left and right node, then we want to find it.
  //    char lastCharInLeft = left.charAt(left.length() - 1);
  //    char firstCharInRight = right.charAt(0);
  //    
  //    int synthesizedCodePoint =
  //    Character.toCodePoint(lastCharInLeft, firstCharInRight);
  //    
  //    if (synthesizedCodePoint == codePoint) {
  //      return left.length() - 1;
  //    }
  //  }
  
  val = [right indexOf:c];
  if (val != NSNotFound) {
    return left.length + val;
  }
  
  return NSNotFound;
}


- (Rope*) ropeByReplacingOccurrencesOfChar:(unichar) oldChar withChar:(unichar) newChar {
  Rope* newLeft = [left ropeByReplacingOccurrencesOfChar:oldChar withChar:newChar];
  Rope* newRight = [right ropeByReplacingOccurrencesOfChar:oldChar withChar:newChar];
  
  if (newLeft == left && newRight == right) {
    return self;
  }
  
  return [newLeft appendRope:newRight];
}


@end
