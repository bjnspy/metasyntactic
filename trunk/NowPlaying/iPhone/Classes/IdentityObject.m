//
//  IdentityObject.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IdentityObject.h"

@interface IdentityObject()
@property (retain) id value;
@end


@implementation IdentityObject

@synthesize value;

- (void) dealloc {
    self.value = nil;
    [super dealloc];
}


- (id) initWithValue:(id) value_ {
    if (self = [super init]) {
        self.value = value_;
    }
    
    return self;
}


+ (IdentityObject*) objectWithValue:(id) value {
    return [[[IdentityObject alloc] initWithValue:value] autorelease];
}


- (NSUInteger) hash {
    return (NSUInteger)value;
}


- (BOOL) isEqual:(id) other {
    return value == [other value];
}

@end
