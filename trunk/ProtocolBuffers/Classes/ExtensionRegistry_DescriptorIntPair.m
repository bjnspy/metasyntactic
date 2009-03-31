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

#import "ExtensionRegistry_DescriptorIntPair.h"

#import "Descriptor.h"


@interface PBExtensionRegistry_DescriptorIntPair ()
    @property (retain) PBDescriptor* descriptor;
    @property int32_t number;
@end


@implementation PBExtensionRegistry_DescriptorIntPair

@synthesize descriptor;
@synthesize number;


- (void) dealloc {
    self.descriptor = nil;
    self.number = 0;

    [super dealloc];
}


- (id) initWithDescriptor:(PBDescriptor*) descriptor_
                   number:(int32_t) number_ {
    if (self = [super init]) {
        self.descriptor = descriptor_;
        self.number = number_;
    }

    return self;
}


+ (PBExtensionRegistry_DescriptorIntPair*) pairWithDescriptor:(PBDescriptor*) descriptor
                                                       number:(int32_t) number {
    return [[[PBExtensionRegistry_DescriptorIntPair alloc] initWithDescriptor:descriptor
                                                                       number:number] autorelease];
}


- (NSUInteger) hash {
    return descriptor.hash * ((1 << 16) - 1) + number;
}


- (BOOL) isEqual:(id) obj {
    if (![obj isKindOfClass:[PBExtensionRegistry_DescriptorIntPair class]]) {
        return NO;
    }

    PBExtensionRegistry_DescriptorIntPair* other = obj;
    return descriptor == other.descriptor && number == other.number;
}


- (id) copyWithZone:(NSZone*) zone {
    return [self retain];
}

@end