// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
