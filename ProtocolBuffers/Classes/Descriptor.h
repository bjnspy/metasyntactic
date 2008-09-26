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

@interface Descriptor : NSObject/*<GenericDescriptor>*/ {
}

- (NSArray*) getFields;

#if 0
NSArray* fields;
    int32_t index;
    DescriptorProto* proto;
    FileDescriptor* file;
    Descriptor* containingType;
    NSArray* nestedTypes;
    NSArray* enumTypes;
    NSArray* extensions;
}

@property int32_t index;
@property (retain) DescriptorProto* proto;
@property (retain) NSString* fullName;
@property (retain) FileDescriptor* file;
@property (retain) Descriptor* containingType;
@property (retain) NSArray* nestedTypes;
@property (retain) NSArray* enumTypes;
@property (retain) NSArray* extensions;
@property (retain) NSArray* fields;

- (NSString*) name;
- (MessageOptions*) options;

- (BOOL) isExtensionNumber:(int32_t) number;    
- (FieldDescriptor*) findFieldByName:(NSString*) name;
- (FieldDescriptor*) findFieldByNumber:(int32_t) number;
- (Descriptor*) findNestedTypeByName:(NSString*) name; 
- (EnumDescriptor*) findEnumTypeByName:(NSString*) name;

+ (Descriptor*) descriptorWithProto:(DescriptorProto*) proto
                               file:(FileDescriptor*) file
                             parent:(Descriptor*) parent
                              index:(int32_t) index;
#endif

@end
