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

#import "NSMutableDictionary+Utilities.h"

@implementation NSMutableDictionary(Utilities)

static void IdentityDictionaryReleaseCallBack(CFAllocatorRef allocator, const void* value) {
  id v = (id)value;
  [v autorelease];
}


static Boolean IdentityDictionaryEqualCallBack(const void* value1, const void* value2) {
  return value1 == value2;
}


static CFHashCode IdentityDictionaryHashCallBack(const void* value) {
  return (CFHashCode)value;
}


+ (NSMutableDictionary*) identityDictionary {
  CFDictionaryKeyCallBacks keyCallBacks = kCFTypeDictionaryKeyCallBacks;
  keyCallBacks.equal = IdentityDictionaryEqualCallBack;
  keyCallBacks.hash = IdentityDictionaryHashCallBack;
  keyCallBacks.release = IdentityDictionaryReleaseCallBack;

  CFDictionaryValueCallBacks valueCallBacks = kCFTypeDictionaryValueCallBacks;

  NSMutableDictionary* result =
  (NSMutableDictionary*) CFDictionaryCreateMutable(NULL,
                                                   0,
                                                   &keyCallBacks,
                                                   &valueCallBacks);
  return [result autorelease];
}

@end
