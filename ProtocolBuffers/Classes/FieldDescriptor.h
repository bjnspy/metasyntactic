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

#import "GenericDescriptor.h"

#import "FieldDescriptorType.h"
#import "ObjectiveCType.h"

@interface FieldDescriptor : NSObject/*<GenericDescriptor>*/ {
}

- (BOOL) isRequired; 
- (BOOL) isRepeated;
- (BOOL) isExtension;      
- (ObjectiveCType) getObjectiveCType;
- (FieldDescriptorType) getType;

- (Descriptor*) getContainingType;
- (Descriptor*) getMessageType;
- (EnumDescriptor*) getEnumType;


- (id) getDefaultValue;
- (int32_t) getNumber;

#if 0
    int32_t index;
    FieldDescriptorProto* proto;
    NSString* fullName;
    FileDescriptor* file;
    Type* type;
    Descriptor* containingType;
}

@property int32_t index;
@property (retain) FieldDescriptorProto* proto;
@property (retain) NSString* fullName;
@property (retain) FileDescriptor* file;
@property (retain) Type* type;
@property (retain) Descriptor* containingType;

- (NSString*) name;
   
- (BOOL) isOptional;
- (BOOL) hasDefaultValue;
- (FieldOptions*) options;  

- (Descriptor*) extensionScope;
- (Descriptor*) messageType;
#endif

@end