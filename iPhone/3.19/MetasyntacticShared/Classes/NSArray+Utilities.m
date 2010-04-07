// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
