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

#import "NSSet+Utilities.h"


@implementation NSSet(NSSetUtilities)

+ (NSSet*) autoreleasingSet {
  return [NSMutableSet autoreleasingSet];
}


+ (NSSet*) autoreleasingSetWithArray:(NSArray*) array {
  return [NSMutableSet autoreleasingSetWithArray:array];
}


+ (NSSet*) autoreleasingSetWithSet:(NSSet*) set {
  return [NSMutableSet autoreleasingSetWithSet:set];
}


+ (NSSet*) identitySet {
  return [NSMutableSet identitySet];
}


+ (NSSet*) identitySetWithObject:(id) object {
  return [NSMutableSet identitySetWithObject:object];
}


+ (NSSet*) identitySetWithArray:(NSArray*) values {
  return [NSMutableSet identitySetWithArray:values];
}


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
