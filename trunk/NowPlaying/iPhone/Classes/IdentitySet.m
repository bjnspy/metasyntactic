//
//  IdentitySet.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IdentitySet.h"

#import "IdentityObject.h"

@interface IdentitySet()
@property (retain) NSMutableSet* set;
@end


@implementation IdentitySet

@synthesize set;

- (void) dealloc {
    self.set = nil;
    
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.set = [NSMutableSet set];
    }
    
    return self;
}


+ (IdentitySet*) set {
    return [[[IdentitySet alloc] init] autorelease];
}


+ (IdentitySet*) setWithArray:(NSArray*) array {
    IdentitySet* set = [[[IdentitySet alloc] init] autorelease];
    [set addObjectsFromArray:array];
    return set;
}


- (void) addObject:(id) value {
    [set addObject:[IdentityObject objectWithValue:value]];
}


- (void) removeObject:(id) value {
    [set removeObject:[IdentityObject objectWithValue:value]];
}


- (void) addObjectsFromArray:(NSArray*) values {
    for (id value in values) {
        [self addObject:value];
    }
}


- (BOOL) containsObject:(id) value {
    return [set containsObject:[IdentityObject objectWithValue:value]];
}


- (NSInteger) count {
    return set.count;
}


- (NSArray*) allObjects {
    NSMutableArray* array = [NSMutableArray array];
    
    for (IdentityObject* object in set) {
        [array addObject:object.value];
    }
    
    return array;
}

@end