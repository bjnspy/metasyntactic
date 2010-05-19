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

#import "NSMutableArray+Utilities.h"

@implementation NSMutableArray(Utilities)

- (void) insertObjects:(NSArray*) array atIndex:(NSInteger) index {
  for (NSInteger i = array.count - 1; i >= 0; i--) {
    [self insertObject:[array objectAtIndex:i] atIndex:index];
  }
}


- (id) removeRandomElement {
  NSInteger index = rand() % self.count;
  id value = [[[self objectAtIndex:index] retain] autorelease];
  [self removeObjectAtIndex:index];

  return value;
}


- (void) shuffle {
  for (NSInteger i = self.count - 1; i > 0; --i) {
    NSInteger j = random() % i;
    [self exchangeObjectAtIndex:j withObjectAtIndex:i];
  }
}


- (void) transformUsingFunction:(id(*)(id)) transformer {
  for (NSInteger i = 0; i < self.count; i++) {
    [self replaceObjectAtIndex:i withObject:transformer([self objectAtIndex:i])];
  }
}


- (void) removeFirstObject {
  [self removeObjectAtIndex:0];
}

@end
