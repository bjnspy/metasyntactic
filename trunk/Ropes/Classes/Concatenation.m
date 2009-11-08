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


// Note: all reference to BAP95 refer to the paper by Boehm, Atkinson and
// Plass which is linked to in Rope.java
@implementation Concatenation

/**
 * To prevent rebalancing too often, we let trees get to the point where
 * there are 16 levels of difference between the left and right child.  This
 * allows many operations too happen in constant time, while still maintaining
 * amortized logarithmic time overall.
 */
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


/**
 * Constructor for a RopeConcatenation.  This constructor will not produce a
 * balanced concatenation.  As such it should only be called by
 * {@link #newConcatenation} and {@link #mergeRopes}.
 *
 * @param left the left child.
 * @param right the right child.
 */
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
    // we haven't even hit our max imbalance.  Don't even bother rebalancing.
    return YES;
  }
  
  if (self.depth >= [Fibonacci fibonacciArrayLength] - 1) {
    // We've gone *way* deep at this point.  Our rebalancing algorithm won't
    // even work if we get any deeper, so force a rebalance.
    return NO;
  }

  // Check if our length is too short for our depth.  If so, rebalance.
  return self.length >= [Fibonacci fibonacciArray][self.depth];
}


- (Rope*) forceBalance {
  // Rebalancing is a complex enough operation that it warrants its own class.
  Rebalancer* rebalancer = [[[Rebalancer alloc] init] autorelease];
  [rebalancer add:self];
  return [rebalancer concatenate];
}


- (Rope*) balance {
  // BAP95
  // Since the length of ropes is, in practice, bounded by the word size of
  // the machine, we can place a bound on the depth of balanced ropes. The
  // concatenation operation checks whether the resulting tree significantly
  // exceeds this bound. If so, the rope is explicitly rebalanced.  
  if (self.isBalanced) {
    return self;
  }
  
  return [self forceBalance];
}


/**
 * Returns a new rope that is equivalent to the concatenation of hte two
 * ropes passed in.  The rope will be appropriately balanced.
 *
 * @param rope1 the first rope
 * @param rope2 the second rope
 * @return the balanced concatenation of the two ropes
 */
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
    // So, let's pretend that you wanted to emulate the Java String hash
    // function, or something similar.
    //
    // Since I'm an old Lisper, let's define it recursively:
    //     "".hashCode(); = 0;
    //     (A + someChar).hashCode() = A.hashCode() * 31 + someChar.
    //
    // where all arithmetic is mod 2^32.  This has all sorts of useful
    // properties:
    //   You know A.hashCode() and B.hashCode()
    //   (A + B).hashCode() = A.hashCode() * 31 ^ B.length + B.hashCode();
    //
    // Threadsafety note.  It's possible for two threads to try to calculate
    // the hash code at the same time.  That's alright.  Both will return the
    // the same result.  However, once one has successfully computed the hash
    // and stored it, it will be usable by another thread.
    // Java guarantees atomic reads/writes of ints, so this is safe.
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
  // BAP95
  // If the left argument (this) is a concatenation node whose right son is
  // a short leaf, and the right argument is also a short leaf, then we
  // concatenate the two leaves, and then concatenate the result to the left
  // son of the left argument (this).  
  if ([right isKindOfClass:[Leaf class]] && [other isKindOfClass:[Leaf class]]) {
    NSInteger finalLength = right.length + other.length;
    if (finalLength <= [Rope coalesceLeafLength]) {
      return [left appendRope:[right appendRope:other]];
    }
  }
  
  // BAP95
  // In the general case, concatenation involves simply allocating a
  // concatenation node containing two pointers to the two arguments.
  return [Concatenation createWithLeft:self right:other];
}


- (Rope*) subRopeWorker:(NSInteger)beginIndex endIndex:(NSInteger)endIndex {
  NSInteger substringLength = endIndex - beginIndex;
  if (substringLength == 0) {
    return [Leaf emptyLeaf];
  }
  
  Rope* newLeft;
  if (beginIndex == 0 && substringLength >= left.length) {
    // If the span totally consumes our left child, then just use that node.
    // This helps keep memory usage down by sharing nodes between ropes.
    newLeft = left;
  } else {
    // the span consumes either some of the left child, or none of the left
    // child.  Recurse into that node.  Ensure that the indices we pass into
    // that node are capped at the start/end of the node itself.
    // Note: if the span does not consume any part of the node, then we will
    // pass an empty span.  That will then immediately terminate with the
    // check at the top of the method
    NSInteger start = MIN(left.length, beginIndex);
    NSInteger end = MIN(left.length, start + substringLength);
    
    newLeft = [left subRope:start endIndex:end];
  }
  
  Rope* newRight;
  if (beginIndex <= left.length && endIndex == self.length) {
    newRight = right;
  } else {
    // The start index needs to be adjusted for our right child node. i.e. if
    // you have two nodes that are ten characters long, and the client asks
    // for a subrope starting at position 15, then we'll need to recurse into
    // the right child passing in index '5'.
    NSInteger start = MAX(0, beginIndex - left.length);
    
    // We may have consumed some of the span in our left child.  So update
    // how much we have remaining.
    NSInteger remaining = substringLength - newLeft.length;
    NSInteger end = start + remaining;
    
    newRight = [right subRope:start endIndex:end];
  }
  
  return [newLeft appendRope:newRight];
}


- (unichar) characterAtIndex:(NSInteger)index {
  if (index < 0 || index >= self.length) {
    @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:@"" userInfo:nil];
  }
  
  if (index < left.length) {
    return [left characterAtIndex:index];
  } else {
    return [right characterAtIndex:(index - left.length)];
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
    // If neither our right child or left child changed, then we can just
    // return ourself.
    return self;
  }
  
  return [newLeft appendRope:newRight];
}


@end
