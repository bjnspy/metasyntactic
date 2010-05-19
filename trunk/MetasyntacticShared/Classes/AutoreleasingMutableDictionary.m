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

#import "AutoreleasingMutableDictionary.h"

@interface AutoreleasingMutableDictionary()
@property (retain) NSMutableDictionary* underlyingDictionary;
@end


@implementation AutoreleasingMutableDictionary

@synthesize underlyingDictionary;

- (void) dealloc {
  self.underlyingDictionary = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.underlyingDictionary = [NSMutableDictionary dictionary];
  }
  return self;
}


+ (AutoreleasingMutableDictionary*) dictionary {
  return [[[AutoreleasingMutableDictionary alloc] init] autorelease];
}


+ (AutoreleasingMutableDictionary*) dictionaryWithDictionary:(NSDictionary*) dictionary {
  AutoreleasingMutableDictionary* result = [self dictionary];
  [result setDictionary:dictionary];
  return result;
}


- (NSUInteger)count {
  return [underlyingDictionary count];
}


- (id)objectForKey:(id)aKey {
  return [[[underlyingDictionary objectForKey:aKey] retain] autorelease];
}


- (NSEnumerator *)keyEnumerator {
  return [underlyingDictionary keyEnumerator];
}


- (void)removeObjectForKey:(id)aKey {
  [underlyingDictionary removeObjectForKey:aKey];
}


- (void)setObject:(id)anObject forKey:(id)aKey {
  [underlyingDictionary setObject:anObject forKey:aKey];
}

@end
