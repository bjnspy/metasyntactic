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

#import "AutoreleasingMutableArray.h"

@interface AutoreleasingMutableArray()
@property (retain) NSMutableArray* underlyingArray;
@end


@implementation AutoreleasingMutableArray

@synthesize underlyingArray;

- (void) dealloc {
  self.underlyingArray = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.underlyingArray = [NSMutableArray array];
  }
  return self;
}


+ (AutoreleasingMutableArray*) array {
  return [[[AutoreleasingMutableArray alloc] init] autorelease];
}


+ (AutoreleasingMutableArray*) arrayWithArray:(NSArray*) values {
  AutoreleasingMutableArray* result = [self array];
  [result addObjectsFromArray:values];
  return result;
}


- (id) objectAtIndex:(NSUInteger)index {
  return [[[underlyingArray objectAtIndex:index] retain] autorelease];
}


- (NSUInteger) count {
  return [underlyingArray count];
}


- (void)addObject:(id)anObject {
  [underlyingArray addObject:anObject];
}


- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
  [underlyingArray insertObject:anObject atIndex:index];
}


- (void)removeLastObject {
  [underlyingArray removeLastObject];
}


- (void)removeObjectAtIndex:(NSUInteger)index {
  [underlyingArray removeObjectAtIndex:index];
}


- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  [underlyingArray replaceObjectAtIndex:index withObject:anObject];
}

@end
