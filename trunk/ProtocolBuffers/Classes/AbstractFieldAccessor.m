//
//  AbstractFieldAccessor.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractFieldAccessor.h"

@interface PBAbstractFieldAccessor()
    @property (retain) PBFieldDescriptor* field;
@end

@implementation PBAbstractFieldAccessor

@synthesize field;

- (void) dealloc {
    self.field = nil;
    [super dealloc];
}


- (id) initWithField:(PBFieldDescriptor*) field_ {
    if (self = [super init]) {
        self.field = field_;
    }
    
    return self;
}


- (NSString*) camelName:(NSString*) name {
    return 
    [NSString stringWithFormat:@"%c%@",
     tolower([name characterAtIndex:0]),
     [name substringFromIndex:1]];
}

@end
