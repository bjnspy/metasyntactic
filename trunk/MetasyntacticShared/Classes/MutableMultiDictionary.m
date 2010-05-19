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

#import "MutableMultiDictionary.h"

@interface MultiDictionary()
- (id) initWithDictionary:(NSDictionary*) dictionary;
@end

@interface MutableMultiDictionary()
@property (retain) NSMutableDictionary* mutableDictionary;
@end

@implementation MutableMultiDictionary

@synthesize mutableDictionary;

- (void) dealloc {
  self.mutableDictionary = nil;
  [super dealloc];
}


- (id) initWithDictionary:(NSMutableDictionary*) mutableDictionary_ {
  if ((self = [super initWithDictionary:mutableDictionary_])) {
    self.mutableDictionary = mutableDictionary_;
  }

  return self;
}


+ (MutableMultiDictionary*) dictionary {
  return [[[MutableMultiDictionary alloc] initWithDictionary:[NSMutableDictionary dictionary]] autorelease];
}


- (void) addObject:(id) object
            forKey:(id) key {
  NSMutableArray* array = [mutableDictionary objectForKey:key];
  if (array == nil) {
    array = [NSMutableArray array];
    [mutableDictionary setObject:array forKey:key];
  }
  [array addObject:object];
}


- (void) addObjects:(NSArray*) objects
             forKey:(id) key {
  NSMutableArray* array = [mutableDictionary objectForKey:key];
  if (array == nil) {
    array = [NSMutableArray array];
    [mutableDictionary setObject:array forKey:key];
  }
  [array addObjectsFromArray:objects];
}


- (NSMutableArray*) mutableObjectsForKey:(id) key {
  return [mutableDictionary objectForKey:key];
}


- (void) removeObjectsForKey:(id) key {
  [mutableDictionary removeObjectForKey:key];
}

@end
