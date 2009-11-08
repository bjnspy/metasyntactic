//
//  NSEnumerator+Utilities.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Iterator.h"

@interface Iterator() 
@property (retain) NSEnumerator* enumerator;
@property (retain) id next;
@end


@implementation Iterator

@synthesize enumerator;
@synthesize next;

- (void) dealloc {
  self.enumerator = nil;
  self.next = nil;
  [super dealloc];
}


- (id) initWithEnumerator:(NSEnumerator*) enumerator_ {
  if ((self = [super init])) {
    self.enumerator = enumerator_;
    self.next = enumerator.nextObject;
  }
  
  return self;
}


+ (Iterator*) iteratorWithEnumerator:(NSEnumerator*) enumerator {
  return [[[Iterator alloc] initWithEnumerator:enumerator] autorelease];
}


- (BOOL) hasNext {
  return next != nil;
}


- (id) next {
  id result = [[next retain] autorelease];
  self.next = enumerator.nextObject;
  return result;
}

@end
