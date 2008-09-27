//
//  EnumValueDescriptor.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 9/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EnumValueDescriptor.h"


@implementation EnumValueDescriptor

@synthesize index;
@synthesize fullName;
@synthesize file;
@synthesize type;

- (void) dealloc {
    self.index = 0;
    self.fullName = nil;
    self.file = nil;
    self.type = nil;

    [super dealloc];
}


- (int32_t) getNumber {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (EnumDescriptor*) getType {
    return type;
}


@end
