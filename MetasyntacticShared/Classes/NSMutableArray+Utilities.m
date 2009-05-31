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

#import "NSMutableArray+Utilities.h"

#if 0
@implementation NSMutableArray(NSMutableArrayUtilities)

- (void) insertObjects:(NSArray*) array atIndex:(NSInteger) index {
    for (NSInteger i = array.count - 1; i >= 0; i--) {
        [self insertObject:[array objectAtIndex:i] atIndex:index];
    }
}


- (id) removeRandomElement {
    NSInteger index = rand() % self.count;
    id value = [[[self objectAtIndex:index] retain] autorelease];
    [self removeObjectAtIndex:index];

    return value;
}

@end
#else
@implementation NSMutableArrayAdditions

+ (void) insertObjects:(NSArray*) array intoArray:(NSMutableArray*) value atIndex:(NSInteger) index {
  for (NSInteger i = array.count - 1; i >= 0; i--) {
    [value insertObject:[array objectAtIndex:i] atIndex:index];
  }
}


+ (id) removeRandomElement:(NSMutableArray*) array {
  NSInteger index = rand() % array.count;
  id value = [[[array objectAtIndex:index] retain] autorelease];
  [array removeObjectAtIndex:index];

  return value;
}


+ (void) shuffle:(NSMutableArray*) array {
  for (NSInteger i = [array count] - 1; i > 0; --i) {
    NSInteger j = random() % i;
    [array exchangeObjectAtIndex:j withObjectAtIndex:i];
  }
}

@end
#endif