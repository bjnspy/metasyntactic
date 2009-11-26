//
//  AutoreleasingMutableSet.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AutoreleasingMutableSet.h"

@interface AutoreleasingMutableSet()
@property (retain) NSMutableSet* underlyingSet;
@end


@implementation AutoreleasingMutableSet

@synthesize underlyingSet;

- (void) dealloc {
  self.underlyingSet = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.underlyingSet = [NSMutableSet set];
  }
  return self;
}


+ (AutoreleasingMutableSet*) set {
  return [[[AutoreleasingMutableSet alloc] init] autorelease];
}


+ (AutoreleasingMutableSet*) setWithArray:(NSArray*) array {
  AutoreleasingMutableSet* result = [self set];
  [result addObjectsFromArray:array];
  return result;
}


+ (AutoreleasingMutableSet*) setWithSet:(NSSet*) set {
  AutoreleasingMutableSet* result = [self set];
  [result unionSet:set];
  return result;
}


- (NSUInteger)count {
  return [underlyingSet count];
}


- (id)member:(id)object {
  return [[[underlyingSet member:object] retain] autorelease];
}


- (NSEnumerator *)objectEnumerator {
  return [underlyingSet objectEnumerator];
}


- (void)addObject:(id)object {
  [underlyingSet addObject:object];
}


- (void)removeObject:(id)object {
  [underlyingSet removeObject:object];
}

@end
