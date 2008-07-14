//
//  MultiDictionary.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

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