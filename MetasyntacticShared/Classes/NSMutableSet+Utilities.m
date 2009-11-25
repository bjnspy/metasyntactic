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

#import "NSMutableSet+Utilities.h"


@implementation NSMutableSet(Utilities)

static void	AutoreleasingSetReleaseCallBack(CFAllocatorRef allocator, const void *value) {
  [(id)value autorelease];
}

+ (NSMutableSet*) autoreleasingSet {
  CFSetCallBacks callBacks = kCFTypeSetCallBacks;
  callBacks.release = AutoreleasingSetReleaseCallBack;

  NSMutableSet* set = (NSMutableSet*)CFSetCreateMutable(NULL, 0, &callBacks);
  return [set autorelease];
}


+ (NSMutableSet*) autoreleasingSetWithArray:(NSArray*) array {
  NSMutableSet* result = [self autoreleasingSet];
  [result addObjectsFromArray:array];
  return result;
}


+ (NSMutableSet*) autoreleasingSetWithSet:(NSSet*) set {
  NSMutableSet* result = [self autoreleasingSet];
  [result unionSet:set];
  return result;
}

static void IdentitySetReleaseCallBack(CFAllocatorRef allocator, const void* value) {
  id v = (id)value;
  [v autorelease];
}


static Boolean IdentitySetEqualCallBack(const void* value1, const void* value2) {
  return value1 == value2;
}


static CFHashCode IdentitySetHashCallBack(const void* value) {
  return (CFHashCode)value;
}


+ (NSMutableSet*) identitySet {
  CFSetCallBacks callBacks = kCFTypeSetCallBacks;
  callBacks.equal = IdentitySetEqualCallBack;
  callBacks.hash = IdentitySetHashCallBack;
  callBacks.release = IdentitySetReleaseCallBack;

  NSMutableSet* set = (NSMutableSet*)CFSetCreateMutable(NULL, 0, &callBacks);
  return [set autorelease];
}


+ (NSMutableSet*) identitySetWithArray:(NSArray*) array {
  NSMutableSet* set = [self identitySet];
  [set addObjectsFromArray:array];
  return set;
}


+ (NSMutableSet*) identitySetWithObject:(id) object {
  NSMutableSet* set = [self identitySet];
  [set addObject:object];
  return set;
}

@end
