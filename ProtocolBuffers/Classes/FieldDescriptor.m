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

#import "FieldDescriptor.h"


@implementation FieldDescriptor

- (BOOL) isRequired {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isRepeated {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isExtension {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isOptional {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (ObjectiveCType) getObjectiveCType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (Descriptor*) getContainingType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (Descriptor*) getExtensionScope {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (Descriptor*) getMessageType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (EnumDescriptor*) getEnumType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (id) getDefaultValue {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (int32_t) getNumber {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (FieldDescriptorType) getType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

- (NSString*) getFullName {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

@end
