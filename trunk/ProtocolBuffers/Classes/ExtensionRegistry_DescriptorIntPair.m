// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ExtensionRegistry_DescriptorIntPair.h"

#import "Descriptor.h"

@implementation ExtensionRegistry_DescriptorIntPair

@synthesize descriptor;
@synthesize number;


- (void) dealloc {
    self.descriptor = nil;
    self.number = 0;

    [super dealloc];
}


- (id) initWithDescriptor:(Descriptor*) descriptor_
                   number:(int32_t) number_ {
    if (self = [super init]) {
        self.descriptor = descriptor_;
        self.number = number_;
    }
    
    return self;
}


+ (ExtensionRegistry_DescriptorIntPair*) pairWithDescriptor:(Descriptor*) descriptor
                                                     number:(int32_t) number {
    return [[[ExtensionRegistry_DescriptorIntPair alloc] initWithDescriptor:descriptor number:number] autorelease];
}


- (NSUInteger) hash {
    return descriptor.hash * ((1 << 16) - 1) + number;
}


- (BOOL) isEqual:(id) obj {
    if (![obj isKindOfClass:[ExtensionRegistry_DescriptorIntPair class]]) {
        return false;
    }
    
    ExtensionRegistry_DescriptorIntPair* other = obj;
    return descriptor == other.descriptor && number == other.number;
}

@end
