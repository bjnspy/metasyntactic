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

#import "IdentitySet.h"


@implementation IdentitySet

static const void *	IdentitySetRetainCallBack(CFAllocatorRef allocator, const void *value) {
  id v = (id)value;
  [v retain];
  return value;
}


static void IdentitySetReleaseCallBack(CFAllocatorRef allocator, const void *value) {
  id v = (id)value;
  [v release];
}


static CFStringRef IdentitySetCopyDescriptionCallBack(const void *value) {
  id v = (id)value;
  return (CFStringRef)[v description];
}


static Boolean IdentitySetEqualCallBack(const void *value1, const void *value2) {
  return value1 == value2;
}


static CFHashCode IdentitySetHashCallBack(const void *value) {
  return (CFHashCode)value;
}


+ (NSMutableSet*) mutableSet {
  CFSetCallBacks callBacks = {
    0,
    IdentitySetRetainCallBack,
    IdentitySetReleaseCallBack,
    IdentitySetCopyDescriptionCallBack,
    IdentitySetEqualCallBack,
    IdentitySetHashCallBack
  };
  NSMutableSet* set = (NSMutableSet*)CFSetCreateMutable(NULL, 0, &callBacks);
  return [set autorelease];
}


+ (NSMutableSet*) mutableSetWithArray:(NSArray*) array {
  NSMutableSet* set = [self mutableSet];
  [set addObjectsFromArray:array];
  return set;
}


+ (NSMutableSet*) mutableSetWithObject:(id) object {
  NSMutableSet* set = [self mutableSet];
  [set addObject:object];
  return set;
}


+ (NSSet*) set {
  return [self mutableSet];
}


+ (NSSet*) setWithObject:(id) object {
  return [self mutableSetWithObject:object];
}


+ (NSSet*) setWithArray:(NSArray*) values {
  return [self mutableSetWithArray:values];
}

@end
