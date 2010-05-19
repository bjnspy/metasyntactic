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

#import "Iterator.h"

@interface Iterator()
@property (retain) NSEnumerator* enumerator;
@property (retain) id next;
@end


@implementation Iterator

@synthesize enumerator;
@synthesize next;

- (void) dealloc {
  self.enumerator = nil;
  self.next = nil;
  [super dealloc];
}


- (id) initWithEnumerator:(NSEnumerator*) enumerator_ {
  if ((self = [super init])) {
    self.enumerator = enumerator_;
    self.next = enumerator.nextObject;
  }

  return self;
}


+ (Iterator*) iteratorWithEnumerator:(NSEnumerator*) enumerator {
  return [[[Iterator alloc] initWithEnumerator:enumerator] autorelease];
}


- (BOOL) hasNext {
  return next != nil;
}


- (id) next {
  id result = [[next retain] autorelease];
  self.next = enumerator.nextObject;
  return result;
}

@end
