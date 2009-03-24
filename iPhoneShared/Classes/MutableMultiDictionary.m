// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MutableMultiDictionary.h"

@interface MutableMultiDictionary()
@property (retain) NSMutableDictionary* mutableDictionary_;
@end

@implementation MutableMultiDictionary

@synthesize mutableDictionary_;

property_wrapper(NSMutableDictionary*, mutableDictionary, MutableDictionary);

- (void) dealloc {
    self.mutableDictionary = nil;
    [super dealloc];
}


- (id) initWithDictionary:(NSMutableDictionary*) mutableDictionary__ {
    if (self = [super initWithDictionary:mutableDictionary__]) {
        self.mutableDictionary = mutableDictionary__;
    }
    
    return self;
}


+ (MutableMultiDictionary*) dictionary {
    return [[[MutableMultiDictionary alloc] initWithDictionary:[NSMutableDictionary dictionary]] autorelease];
}


- (void) addObject:(id) object
            forKey:(id) key {
    NSMutableArray* array = [self.mutableDictionary objectForKey:key];
    if (array == nil) {
        array = [NSMutableArray array];
        [self.mutableDictionary setObject:array forKey:key];
    }
    [array addObject:object];
}


- (void) addObjects:(NSArray*) objects
             forKey:(id) key {
    NSMutableArray* array = [self.mutableDictionary objectForKey:key];
    if (array == nil) {
        array = [NSMutableArray array];
        [self.mutableDictionary setObject:array forKey:key];
    }
    [array addObjectsFromArray:objects];
}


- (NSMutableArray*) mutableObjectsForKey:(id) key {
    return [self.mutableDictionary objectForKey:key];
}


- (void) removeObjectsForKey:(id) key {
    [self.mutableDictionary removeObjectForKey:key];
}

@end