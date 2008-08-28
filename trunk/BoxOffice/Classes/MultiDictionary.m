// Copyright (C) 2008 Cyrus Najmabadi
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

#import "MultiDictionary.h"

@implementation MultiDictionary

@synthesize dictionary;

- (void) dealloc {
    self.dictionary = nil;
    [super dealloc];
}


+ (MultiDictionary*) dictionary {
    return [[[MultiDictionary alloc] init] autorelease];
}


- (id) init {
    if (self = [super init]) {
        self.dictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}


- (void) addObject:(id) object
            forKey:(id) key {
    NSMutableArray* array = [self.dictionary objectForKey:key];
    if (array == nil) {
        array = [NSMutableArray array];
        [self.dictionary setObject:array forKey:key];
    }
    [array addObject:object];
}


- (void) addObjects:(NSArray*) objects
             forKey:(id) key {
    NSMutableArray* array = [self.dictionary objectForKey:key];
    if (array == nil) {
        array = [NSMutableArray array];
        [self.dictionary setObject:array forKey:key];
    }
    [array addObjectsFromArray:objects];
}


- (NSArray*) objectsForKey:(id) key {
    NSArray* array = [self.dictionary objectForKey:key];
    if (array == nil) {
        array = [NSArray array];
    }
    return array;
}


- (NSMutableArray*) mutableObjectsForKey:(id) key {
    return [self.dictionary objectForKey:key];
}


- (NSArray*) allKeys {
    return [self.dictionary allKeys];
}


@end
