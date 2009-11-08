//
//  Leaf.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.


#import "Leaf.h"

#import "Concatenation.h"

@interface Leaf()
@property (copy) NSString* string;
@property NSUInteger hash;
@end


@implementation Leaf

static const NSInteger COALESCE_LEAF_LENGTH = 1 << 10;

static Leaf* emptyLeaf;

+ (void) initialize {
  if (self == [Leaf class]) {
    emptyLeaf = [[Leaf alloc] initWithString:@""];
  }
}

@synthesize string;
@synthesize hash;

- (void) dealloc {
  self.string = nil;
  self.hash = 0;
  
  [super dealloc];
}


- (id) initWithString:(NSString*) string_ {
  if ((self = [super init])) {
    self.string = string_;
  }
  
  return self;
}


+ (Rope*) emptyLeaf {
  return emptyLeaf;
}


+ (Rope*) createLeaf:(NSString*) value {
  if (value.length == 0) {
    return emptyLeaf;
  }
  
  return [[[Leaf alloc] initWithString:value] autorelease];
}


+ (NSUInteger) hashString:(NSString*) string {
  if (string.length == 0) {
    return 0;
  }
  
  unichar result = [string characterAtIndex:0];
  for (NSInteger i = 1; i < string.length; i++) {
    result = 31 * result + [string characterAtIndex:i];
  }
  
  return result;
}


- (NSUInteger) hash {
  if (hash == 0) {
    hash = [Leaf hashString:string];
  }
  
  return hash;
}


- (void) addLeaves:(NSMutableArray *)leaves {
  [leaves addObject:self];
}


- (NSString*) stringValue {
  return string;
}


- (NSInteger) length {
  return string.length;
}


- (void) addToMutableString:(NSMutableString *)builder {
  [builder appendString:string];
}


- (Rope*) appendRopeWorker:(Rope *)other {
  if ([other isKindOfClass:[Leaf class]]) {
    NSInteger finalLength = self.length + other.length;
    if (finalLength <= COALESCE_LEAF_LENGTH) {
      return [Leaf createLeaf:[NSString stringWithFormat:@"%@%@", string, [(id)other string]]];
    }
  }
  
  return [Concatenation createWithLeft:self right:other];
}


- (uint8_t) depth {
  return 0;
}


- (Rope*) subRopeWorker:(NSInteger)beginIndex endIndex:(NSInteger)endIndex {
  return [Leaf createLeaf:[string substringWithRange:NSMakeRange(beginIndex, endIndex - beginIndex)]];
}


- (unichar) characterAt:(NSInteger)index {
  return [string characterAtIndex:index];
}


- (NSInteger) indexOf:(unichar)c {
  NSRange range = [string rangeOfString:[NSString stringWithCharacters:&c length:1]];
  if (range.length > 0) {
    return NSNotFound;
  }
  
  return range.location;
}


- (Rope*) ropeByReplacingOccurrencesOfChar:(unichar)oldChar withChar:(unichar)newChar {
  NSString* result = [string stringByReplacingOccurrencesOfString:[NSString stringWithCharacters:&oldChar length:1]
                                                       withString:[NSString stringWithCharacters:&newChar length:1]];
  
  if (result == string) {
    return self;
  }
  
  return [Leaf createLeaf:result];
}

@end
