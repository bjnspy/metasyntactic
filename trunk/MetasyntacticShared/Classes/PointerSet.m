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

#import "PointerSet.h"

@implementation PointerSet

static const void * PointerSetRetainCallBack(CFAllocatorRef allocator, const void* value) {
  return value;
}


static void PointerSetReleaseCallBack(CFAllocatorRef allocator, const void* value) {
}


static CFStringRef PointerSetCopyDescriptionCallBack(const void* value) {
  id v = (id)value;
  return (CFStringRef)[[v description] retain];
}


static Boolean PointerSetEqualCallBack(const void* value1, const void* value2) {
  return value1 == value2;
}


static CFHashCode PointerSetHashCallBack(const void* value) {
  return (CFHashCode)value;
}


+ (NSMutableSet*) mutableSet {
  CFSetCallBacks callBacks = {
    0,
    PointerSetRetainCallBack,
    PointerSetReleaseCallBack,
    PointerSetCopyDescriptionCallBack,
    PointerSetEqualCallBack,
    PointerSetHashCallBack
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
