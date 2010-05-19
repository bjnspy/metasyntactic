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
