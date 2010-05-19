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
