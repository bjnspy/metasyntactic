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


@interface FieldSet : NSObject {
    // Use a TreeMap because fields need to be in canonical order when
    // serializing.
    NSDictionary* fields;
}

@property (retain) NSDictionary* fields;

+ (FieldSet*) setWithFields:(NSDictionary*) fields;
+ (FieldSet*) set;
+ (FieldSet*) emptySet;

- (void) makeImmutable; 
- (void) clear;

- (NSDictionary*) allFields;
- (BOOL) hasField:(Descriptors_FieldDescriptor*) field;
- (id) getField:(Descriptors_FieldDescriptor*) field;
- (void) setField:(Descriptors_FieldDescriptor*) field value:(id) value;
- (void) clearField:(Descriptors_FieldDescriptor*) field;

- (int32_t) getRepeatedFieldCount:(Descriptors_FieldDescriptor*) field;

- (id) getRepeatedField:(Descriptors_FieldDescriptor*) field index:(int32_t) index;
- (void) setRepeatedField:(Descriptors_FieldDescriptor*) field index:(int32_t) index value:(id) value;
- (void) addRepeatedField:(Descriptors_FieldDescriptor*) field value:(id) value;

- (BOOL) isInitialized;
- (BOOL) isInitialized:(Descriptors_Descriptor*) type;

- (void) mergeFrom:(id<Message>) other;
- (void) mergeFrom:(FieldSet*) other;
- (void) mergeFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder;

- (BOOL) mergeFieldFromCodedInputStream:(CodedInputStream*) input
                          unknownFields:(UnknownFieldSet_Builder*) unknownFields
                      extensionRegistry:(ExtensionRegistry*) extensionRegistry
                                builder:(id<Message_Builder>) builder
                                    tag:(int32_t) tag;

- (void) mergeMessageSetExtensionFromCodedInputStream:(CodedInputStream*) input
                                        unknownFields:(UnknownFieldSet_Builder*) unknownFields
                                    extensionRegistry:(ExtensionRegistry*) extensionRegistry
                                              builder:(id<Message_Builder>) builder;

- (void) writeToCodedOutputStream:(CodedOutputStream*) output;
- (void) writeField:(Descriptors_FieldDescriptor*) field value:(id) value ouput:(CodedInputStream*) output;
- (int32_t) serializedSize;

@end
