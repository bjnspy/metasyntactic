//
//  untitled.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSSet+Utilities.h"


@implementation NSSet(NSSetUtilities)

- (NSSet*) filteredSetUsingFunction:(BOOL(*)(id)) predicate {
  NSMutableSet* result = [NSMutableSet set];
  for (id value in self) {
    if (predicate(value)) {
      [result addObject:value];
    }
  }
  return result;
}

@end
