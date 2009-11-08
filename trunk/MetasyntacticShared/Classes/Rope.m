//
//  Rope.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.


#import "Rope.h"

#import "Leaf.h"
#import "RopeEqualityChecker.h"

@implementation Rope

static const NSInteger COALESCE_LEAF_LENGTH = 1 << 10;

+ (Rope*) createRope:(NSString*) value {
  return [Leaf createLeaf:value];
}


- (unichar) characterAt:(NSInteger) index AbstractMethod;


- (NSInteger) length AbstractMethod;


- (NSInteger) indexOf:(unichar) c AbstractMethod;


- (Rope*) subRopeWorker:(NSInteger) beginIndex endIndex:(NSInteger) endIndex AbstractMethod;


- (uint8_t) depth AbstractMethod;


- (void) addToMutableString:(NSMutableString*) builder AbstractMethod;


- (Rope*) appendRopeWorker:(Rope*) other AbstractMethod;


- (void) addLeaves:(NSMutableArray*) leaves AbstractMethod;


- (NSString*) stringValue AbstractMethod;


- (Rope*) ropeByReplacingOccurrencesOfChar:(unichar)oldChar withChar:(unichar)newChar AbstractMethod;


- (BOOL) isEmpty {
  return self.length == 0;
}


- (Rope*) subRope:(NSInteger) beginIndex {
  return [self subRope:beginIndex endIndex:self.length];
}


- (Rope*) subRope:(NSInteger) beginIndex endIndex:(NSInteger) endIndex {
  if (beginIndex < 0 || endIndex > self.length || beginIndex > endIndex) {
    @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:@"" userInfo:nil];
  }
  
  return [self subRopeWorker:beginIndex endIndex:endIndex];
}


- (Rope*) appendChar:(unichar) c {
  return [self appendString:[NSString stringWithCharacters:&c length:1]];
}


- (Rope*) appendString:(NSString*) string {
  return [self appendRope:[Rope createRope:string]];
}


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


- (Rope*) prependChar:(unichar) c {
  return [self prependString:[NSString stringWithCharacters:&c length:1]];  
}


- (Rope*) prependString:(NSString*) string {
  return [self prependRope:[Rope createRope:string]];
}


- (Rope*) prependRope:(Rope*) rope {
  if (rope == nil) {
    return self;
  }
  
  return [rope appendRope:self];
}


- (Rope*) insertChar:(unichar) c index:(NSInteger) index {
  return [self insertString:[NSString stringWithCharacters:&c length:1] index:index];
}


- (Rope*) insertString:(NSString*) string index:(NSInteger) index {
  return [self insertRope:[Rope createRope:string] index:index];
}


- (Rope*) insertRope:(Rope*) rope index:(NSInteger) index {
  return [self replace:index endIndex:index withRope:rope];
}


- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withChar:(unichar) c {
  return [self replace:beginIndex endIndex:endIndex withString:[NSString stringWithCharacters:&c length:1]];  
}


- (Rope*) replace:(NSInteger) beginIndex endIndex:(NSInteger) endIndex withString:(NSString*) string {
  return [self replace:beginIndex endIndex:endIndex withRope:[Rope createRope:string]];
}


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


- (BOOL) isEqualToRope:(Rope*) other {
  return [[RopeEqualityChecker createWithRope1:self rope2:other] check];
}


- (NSArray*) leaves {
  NSMutableArray* leaves = [NSMutableArray array];
  [self addLeaves:leaves];
  return leaves;
}



@end
