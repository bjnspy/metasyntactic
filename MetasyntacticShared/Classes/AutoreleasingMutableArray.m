//
//  AutoreleasingMutableArray.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AutoreleasingMutableArray.h"

@interface AutoreleasingMutableArray()
@property (retain) NSMutableArray* underlyingArray;
@end


@implementation AutoreleasingMutableArray

@synthesize underlyingArray;

- (void) dealloc {
  self.underlyingArray = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.underlyingArray = [NSMutableArray array];
  }
  return self;
}


+ (AutoreleasingMutableArray*) array {
  return [[[AutoreleasingMutableArray alloc] init] autorelease];
}


+ (AutoreleasingMutableArray*) arrayWithArray:(NSArray*) values {
  AutoreleasingMutableArray* result = [self array];
  [result addObjectsFromArray:values];
  return result;
}


- (id) objectAtIndex:(NSUInteger)index {
  return [[[underlyingArray objectAtIndex:index] retain] autorelease];
}


- (NSUInteger) count {
  return [underlyingArray count];
}


- (void)addObject:(id)anObject {
  [underlyingArray addObject:anObject];
}


- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
  [underlyingArray insertObject:anObject atIndex:index];
}


- (void)removeLastObject {
  [underlyingArray removeLastObject];
}


- (void)removeObjectAtIndex:(NSUInteger)index {
  [underlyingArray removeObjectAtIndex:index];
}


- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  [underlyingArray replaceObjectAtIndex:index withObject:anObject];
}

@end
