//
//  DescriptorPool_DescriptorIntPair.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DescriptorPool_DescriptorIntPair.h"

@interface PBDescriptorPool_DescriptorIntPair ()
    @property (retain) id<PBGenericDescriptor> descriptor;
    @property int32_t number;
@end


@implementation PBDescriptorPool_DescriptorIntPair

@synthesize descriptor;
@synthesize number;

- (void) dealloc {
    self.descriptor = nil;
    self.number = 0;
    
    [super dealloc];
}


- (id) initWithDescriptor:(id<PBGenericDescriptor>) descriptor_
                   number:(int32_t) number_ {
    if (self = [super init]) {
        self.descriptor = descriptor_;
        self.number = number_;
    }
    
    return self;
}


+ (PBDescriptorPool_DescriptorIntPair*) pairWithDescriptor:(id<PBGenericDescriptor>) descriptor
                                                    number:(int32_t) number {
    return [[[PBDescriptorPool_DescriptorIntPair alloc] initWithDescriptor:descriptor 
                                                                    number:number] autorelease];
}


- (NSUInteger) hash {
    return [(id)descriptor hash] * ((1 << 16) - 1) + number;
}


- (BOOL) isEqual:(id) obj {
    if (![obj isKindOfClass:[PBDescriptorPool_DescriptorIntPair class]]) {
        return false;
    }
    
    PBDescriptorPool_DescriptorIntPair* other = obj;
    return descriptor == other.descriptor && number == other.number;
}

@end