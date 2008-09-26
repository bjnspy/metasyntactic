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

#import "AbstractMessage_Builder.h"

@interface DynamicMessage_Builder : AbstractMessage_Builder {
    Descriptors_Descriptor* type;
    FieldSet* fields;
    UnknownFieldSet* unknownFields;
}

@property (retain) Descriptors_Descriptor* type;
@property (retain) FieldSet* fields;
@property (retain) UnknownFieldSet* unknownFields;

+ (DynamicMessage_Builder*) builderWithType:(Descriptors_Descriptor*) type;

- (DynamicMessage_Builder*) clear;
- (DynamicMessage_Builder*) mergeFrom:(id<Message>) other;

- (DynamicMessage*) build; 
- (DynamicMessage*) buildParsed;
- (DynamicMessage*) buildPartial; 

- (DynamicMessage_Builder*) clone;
    
- (BOOL) isInitialized;

- (DynamicMessage_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
    
- (Descriptors_Descriptor*) descriptorForType;
- (DynamicMessage*) defaultInstanceForType;
- (NSDictionary*) allFields;
- (DynamicMessage_Builder*) builderForField:(FieldDescriptor*) field;

- (BOOL) hasField:(FieldDescriptor*) field;
- (id) getField:(FieldDescriptor*) field;

- (DynamicMessage_Builder*) setField:(FieldDescriptor*) field value:(id) value;
- (DynamicMessage_Builder*) clearField:(FieldDescriptor*) field;
- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field;
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index;

- (DynamicMessage_Builder*) setRepeatedField:(FieldDescriptor*) field index:(int32_t) index value:(id) value;
- (DynamicMessage_Builder*) addRepeatedField:(FieldDescriptor*) field value:(id) value; 

- (UnknownFieldSet*) unknownFields;
- (DynamicMessage_Builder*) setUnknownFields:(UnknownFieldSet*) unknownFields;
- (DynamicMessage_Builder*) mergeUnknownFields:(UnknownFieldSet*) unknownFields;

@end
