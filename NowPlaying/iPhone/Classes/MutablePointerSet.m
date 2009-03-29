//
//  MutablePointerSet.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MutablePointerSet.h"

@interface MutablePointerSet()
@property (retain) NSMutableSet* mutableSet;
@end


@implementation MutablePointerSet

@synthesize mutableSet;

- (void) dealloc {
    self.mutableSet = nil;
    [super dealloc];
}


- (id) initWithSet:(NSMutableSet*) set_ {
    if (self = [super initWithSet:set_]) {
        self.mutableSet = set_;
    }
    
    return self;
}


+ (MutablePointerSet*) set {
    return [[[MutablePointerSet alloc] initWithSet:[NSMutableSet set]] autorelease];
}


- (void) addObject:(id) value {
    [mutableSet addObject:[NSValue valueWithPointer:value]];
}


- (void) removeObject:(id) value {
    [mutableSet removeObject:[NSValue valueWithPointer:value]];
}

@end
