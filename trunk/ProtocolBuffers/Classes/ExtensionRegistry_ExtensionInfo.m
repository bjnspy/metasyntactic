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

#import "ExtensionRegistry_ExtensionInfo.h"


@implementation ExtensionRegistry_ExtensionInfo

@synthesize descriptor;
@synthesize defaultInstance;

- (void) dealloc {
    self.descriptor = nil;
    self.defaultInstance = nil;

    [super dealloc];
}


- (id) initWithDescriptor:(FieldDescriptor*) descriptor_
          defaultInstance:(id<Message>) defaultInstance_ {
    if (self = [super init]) {
        self.descriptor = descriptor_;
        self.defaultInstance = defaultInstance_;
    }
    
    return self;
}


+ (ExtensionRegistry_ExtensionInfo*) infoWithDescriptor:(FieldDescriptor*) descriptor {
    return [ExtensionRegistry_ExtensionInfo infoWithDescriptor:descriptor defaultInstance:nil];
}


+ (ExtensionRegistry_ExtensionInfo*) infoWithDescriptor:(FieldDescriptor*) descriptor
                                        defaultInstance:(id<Message>) defaultInstance {
    return [[[ExtensionRegistry_ExtensionInfo alloc] initWithDescriptor:descriptor defaultInstance:defaultInstance] autorelease];
}

@end
