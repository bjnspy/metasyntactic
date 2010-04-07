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
