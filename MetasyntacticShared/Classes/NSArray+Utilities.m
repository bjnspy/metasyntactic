// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "NSArray+Utilities.h"

#import "NSMutableArray+Utilities.h"

@implementation NSArray(Utilities)

- (id) findSmallestElementUsingFunction:(NSInteger(*)(id, id, void*)) comparator
                                context:(void*) context {
  if (self.count == 0) {
    return nil;
  }

  id value = self.firstObject;

  for (NSInteger i = 1; i < self.count; i++) {
    id current = [self objectAtIndex:i];

    NSComparisonResult result = comparator(value, current, context);
    if (result == NSOrderedDescending) {
      value = current;
    }
  }

  return value;
}


- (id) findSmallestElementUsingFunction:(NSInteger(*)(id, id, void*, void*)) comparator
                               context1:(void*) context1
                               context2:(void*) context2 {
  if (self.count == 0) {
    return nil;
  }

  id value = self.firstObject;

  for (NSInteger i = 1; i < self.count; i++) {
    id current = [self objectAtIndex:i];

    NSComparisonResult result = comparator(value, current, context1, context2);
    if (result == NSOrderedDescending) {
      value = current;
    }
  }

  return value;
}


- (NSArray*) shuffledArray {
  NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:self];
  [mutableArray shuffle];
  return mutableArray;
}


- (NSArray*) filteredArrayUsingFunction:(BOOL(*)(id)) predicate {
  NSMutableArray* result = [NSMutableArray array];
  for (id value in self) {
    if (predicate(value)) {
      [result addObject:value];
    }
  }
  return result;
}


- (NSArray*) transformedArrayUsingFunction:(id(*)(id)) tranformer {
  NSMutableArray* result = [NSMutableArray arrayWithArray:self];
  [result transformUsingFunction:tranformer];
  return result;
}


- (id) firstObject {
  if (self.count == 0) {
    return nil;
  }

  return [self objectAtIndex:0];
}

@end
