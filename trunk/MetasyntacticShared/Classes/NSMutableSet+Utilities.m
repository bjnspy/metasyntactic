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

#import "NSMutableSet+Utilities.h"

@implementation NSMutableSet(Utilities)

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
