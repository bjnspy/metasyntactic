//
//  RopeTests.m
//  Ropes
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RopeTests.h"

#import "Rope.h"

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))

@implementation RopeTests

static NSString* largeString;
static Rope* largeRope;
static NSString* mediumString;
static Rope* mediumRope;

+ (NSString*) createTestString:(NSInteger) size {
  NSMutableString* result = [NSMutableString string];
  for (NSInteger i = 0; i < size; i++) {
    unichar c = (unichar)('a' + (i % 26));
    [result appendString:[NSString stringWithCharacters:&c length:1]];
  }
  
  return result;
}


+ (Rope*) createChunkedRope:(NSString*) string {
  Rope* result = [Rope emptyRope];
  
  for (NSInteger i = 0; i < string.length; i += [Rope coalesceLeafLength]) {
    NSInteger endIndex = MIN(string.length, i + [Rope coalesceLeafLength]);
    result = [result appendString:[string substringWithRange:NSMakeRange(i, endIndex - i)]];
  }
  
  return result;
}


+ (void) initialize {
  if (self == [RopeTests class]) {
    mediumString = [[self createTestString:(1 << 16)] retain];
    mediumRope = [[self createChunkedRope:mediumString] retain];
    
    largeString = [[self createTestString:(1 << 20)] retain];
    largeRope = [[self createChunkedRope:largeString] retain];
  }
}


- (void) testMath {
  STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );    
}


- (void) testStringValue {
  STAssertTrue([largeString isEqual:largeRope.stringValue], @"");
}


- (void) testLength {
  STAssertTrue(largeString.length == largeRope.length, @"");
}


- (void) testSimpleSubRope1 {
  NSString* s1 = [largeString substringWithRange:NSMakeRange(0, 26)];
  NSString* s2 = [largeRope subRope:0 endIndex:26].stringValue;
  
  STAssertTrue([s1 isEqual:s2], @"");
}


- (void) testSimpleSubRope2 {
  NSInteger start = largeString.length - 26;
  NSInteger end = largeString.length;
  
  NSString* s1 = [largeString substringWithRange:NSMakeRange(start, end - start)];
  NSString* s2 = [[largeRope subRope:start endIndex:end] stringValue];
  
  STAssertTrue([s1 isEqual:s2], @"");
}


- (void) testSimpleSubRope3 {
  NSInteger start = largeString.length / 2;
  NSString* s1 = [largeString substringWithRange:NSMakeRange(start, 26)];
  NSString* s2 = [[largeRope subRope:start endIndex:start + 26] stringValue];
  
  STAssertTrue([s1 isEqual:s2], @"");
}


- (void) testComplexSubRope1 {
  // pick a range that will cross a node split
  
  NSString* s1 = [largeString substringWithRange:NSMakeRange(1000, 50)];
  NSString* s2 = [[largeRope subRope:1000 endIndex:1050] stringValue];
  
  STAssertTrue([s1 isEqual:s2], @"");
}


NSString* repeat(NSInteger count, unichar c) {
  NSMutableString* buffer = [NSMutableString string];
  for (NSInteger i = 0; i < count; i++) {
    [buffer appendString:[NSString stringWithCharacters:&c length:1]];
  }
  return buffer;
}


NSString* append(NSString* s1, NSString* s2) {
  return [NSString stringWithFormat:@"%@%@", s1, s2];
}


// The following subrope tests test all the corner cases of subRope.
// Consider the following concatenation:
//
// ------------------------------------------------------------------
// |                               |                                |
// ------------------------------------------------------------------
// 0, 1                  (m - 1),  m,  (m + 1)            (e - 1),  e
//
// We want to test every permutation of subRopes between those points.
- (void) testComplexSubRope2 {
  NSString* string = append(repeat(1024, 'a'), repeat(1024, 'b'));
  Rope* rope = [RopeTests createChunkedRope:string];
  NSInteger indices[] = {
    0, 1, 2, 1022, 1023, 1024, 1025, 1026, 2046, 2047, 2048
  };
  
  for (NSInteger i = 0; i < ArrayLength(indices); i++) {
    for (NSInteger j = i; j < ArrayLength(indices); j++) {
      Rope* subRope = [rope subRope:i endIndex:j];
      NSString* substring = [string substringWithRange:NSMakeRange(i, j - i)];
      
      STAssertTrue([substring isEqual:subRope.stringValue], @"");
    }
  }
}


- (void) testComplexSubstring2 {
// pick a range that will cross two node splits

  NSString* s1 = [largeString substringWithRange:NSMakeRange(1000, 1060)];
  NSString* s2 = [[largeRope subRope:1000 endIndex:2060] stringValue];
  
  STAssertTrue([s1 isEqual:s2], @"");
}


- (void) testComplexSubstring3 {
  NSString* s1 = [largeString substringWithRange:NSMakeRange(200000, 600000)];
  NSString* s2 = [[largeRope subRope:200000 endIndex:800000] stringValue];
  
  STAssertTrue([s1 isEqual:s2], @"");
}


- (void) testLargeConcatenation {
  NSString* reallyLargeString = append(largeString, largeString);
  Rope* reallyLargeRope = [largeRope appendRope:largeRope];
  STAssertTrue([reallyLargeString isEqual:reallyLargeRope.stringValue], @"");
}


- (void) testCharacterAt {
  for (NSInteger i = 0; i < 10000; i++) {
    STAssertTrue([largeString characterAtIndex:i] == [largeRope characterAtIndex:i], @"");
  }
}


- (void) testConcatenate1 {
  Rope* rope = [Rope createRope:@""];
  
  NSInteger size = 1 << 16;
  for (NSInteger i = 0; i < size; i++) {
    rope = [rope appendChar:(unichar)('a' + (i % 26))];
  }
  
  [mediumRope.stringValue isEqual:rope.stringValue];
}


- (void) testSubRope1 {
  //STAssertTrue(1 == 2, @"");
  
  NSInteger oneThird = mediumRope.length / 3;
  NSInteger twoThirds = mediumRope.length * 2 / 3;
  
  Rope* start = [mediumRope subRope:0 endIndex:oneThird];
  Rope* middle = [mediumRope subRope:oneThird endIndex:twoThirds];
  Rope* end = [mediumRope subRope:twoThirds];
  
  STAssertTrue([mediumRope isEqual:[[start appendRope:middle] appendRope:end]], @"");
}


- (void) testEquals1 {
  STAssertTrue([[Rope createRope:@""] isEqual:[Rope createRope:@""]], @"");
}


- (void) testEquals2 {
  STAssertTrue([[Rope createRope:@"a"] isEqual:[Rope createRope:@"a"]], @"");
}


- (void) testEquals3 {
  STAssertTrue(![[Rope createRope:@"a"] isEqual:[Rope createRope:@"b"]], @"");
}


- (void) testEquals4 {
  STAssertTrue(![[Rope createRope:@""] isEqual:[Rope createRope:@"b"]], @"");
}


- (void) testEquals5 {
  STAssertTrue(![[Rope createRope:@"a"] isEqual:[Rope createRope:@""]], @"");
}


- (void) testEquals6 {
  STAssertTrue(![[Rope createRope:@"a"] isEqual:[Rope createRope:@"aa"]], @"");
}


- (void) testEquals7 {
  STAssertTrue(![[Rope createRope:@"aa"] isEqual:[Rope createRope:@"a"]], @"");
}


- (void) testEquals8 {
  STAssertTrue(![[RopeTests createChunkedRope:repeat(2048, 'a')] isEqual:
                 [Rope createRope:repeat(2049, 'a')]], @"");
}


- (void) testEquals9 {
  STAssertTrue(![[RopeTests createChunkedRope:repeat(2048, 'a')] isEqual:
                 [Rope createRope:repeat(3072, 'a')]], @"");
}


/**
 * This test checks that we chunk properly the following ropes
 *
 * ------------------------------------------------------------------
 * |                       |      |      |                          |
 * ------------------------------------------------------------------
 *
 * ------------------------------------------------------------------
 * |                 |                         |                    |
 * ------------------------------------------------------------------
 */
- (void) testEqualsLarge {
  Rope* rope1 =
  [[[[Rope createRope:append(repeat(1536, 'a'), repeat(512, 'b'))]
     appendString:repeat(1024, 'c')]
    appendString:repeat(1024, 'd')]
   appendString:append(repeat(512, 'e'), repeat(1536, 'f'))];
  
  Rope* rope2 =
  [[[Rope createRope:repeat(1536, 'a')]
    appendString:append(append(append(repeat(512, 'b'), repeat(1024, 'c')),
                             repeat(1024, 'd')), repeat(512, 'e'))]
   appendString:repeat(1536, 'f')];
  
  STAssertTrue([rope1 isEqual:rope2], @"");
}


- (void) testHashCode1 {
  STAssertEquals([Rope hashString:mediumString], [mediumRope hash], @"");
}


- (void) testHashCode2 {
  Rope* rope1 =
  [[[[Rope createRope:append(repeat(1536, 'a'), repeat(512, 'b'))]
     appendString:repeat(1024, 'c')]
    appendString:repeat(1024, 'd')]
   appendString:append(repeat(512, 'e'), repeat(1536, 'f'))];
  
  Rope* rope2 =
  [[[Rope createRope:repeat(1536, 'a')]
    appendString:append(append(append(repeat(512, 'b'), repeat(1024, 'c')),
                               repeat(1024, 'd')), repeat(512, 'e'))]
   appendString:repeat(1536, 'f')];
  
  STAssertTrue(rope1.hash == rope2.hash, @"");
}

@end
