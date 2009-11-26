//
//  AutoreleasingMutableDictionary.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AutoreleasingMutableDictionary.h"

@interface AutoreleasingMutableDictionary()
@property (retain) NSMutableDictionary* underlyingDictionary;
@end


@implementation AutoreleasingMutableDictionary

@synthesize underlyingDictionary;

- (void) dealloc {
  self.underlyingDictionary = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.underlyingDictionary = [NSMutableDictionary dictionary];
  }
  return self;
}


+ (AutoreleasingMutableDictionary*) dictionary {
  return [[[AutoreleasingMutableDictionary alloc] init] autorelease];
}


+ (AutoreleasingMutableDictionary*) dictionaryWithDictionary:(NSDictionary*) dictionary {
  AutoreleasingMutableDictionary* result = [self dictionary];
  [result setDictionary:dictionary];
  return result;
}


- (NSUInteger)count {
  return [underlyingDictionary count];
}


- (id)objectForKey:(id)aKey {
  return [[[underlyingDictionary objectForKey:aKey] retain] autorelease];
}


- (NSEnumerator *)keyEnumerator {
  return [underlyingDictionary keyEnumerator];
}


- (void)removeObjectForKey:(id)aKey {
  [underlyingDictionary removeObjectForKey:aKey];
}


- (void)setObject:(id)anObject forKey:(id)aKey {
  [underlyingDictionary setObject:anObject forKey:aKey];
}

@end
