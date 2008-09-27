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
    NSMutableDictionary* fields;
}


@property (retain) NSMutableDictionary* fields;


+ (void) mergeFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder;
+ (BOOL) mergeFieldFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder
                               tag:(int32_t) tag;


+ (FieldSet*) set;
+ (FieldSet*) emptySet;


- (id) initWithFields:(NSMutableDictionary*) fields;

- (void) clear;
- (NSDictionary*) getAllFields;

- (BOOL) hasField:(FieldDescriptor*) field;
- (id) getField:(FieldDescriptor*) field;
- (void) setField:(FieldDescriptor*) field value:(id) value;
- (void) clearField:(FieldDescriptor*) field;

- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field;
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index;
- (void) setRepeatedField:(FieldDescriptor*) field index:(int32_t) index value:(id) value;
- (void) addRepeatedField:(FieldDescriptor*) field value:(id) value;


- (BOOL) isInitialized:(Descriptor*) type;

- (void) writeToCodedOutputStream:(CodedOutputStream*) output;

- (int32_t) getSerializedSize;

- (void) mergeFromMessage:(id<Message>) other;
- (void) mergeFromFieldSet:(FieldSet*) other;

- (void) writeField:(FieldDescriptor*) field value:(id) value output:(CodedOutputStream*) output;


#if 0
    // Use a TreeMap because fields need to be in canonical order when
    // serializing.
    NSDictionary* fields;
}

@property (retain) NSDictionary* fields;

+ (FieldSet*) setWithFields:(NSDictionary*) fields;
+ (FieldSet*) set;

- (void) makeImmutable; 

- (BOOL) isInitialized;

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

- (void) writeField:(Descriptors_FieldDescriptor*) field value:(id) value ouput:(CodedInputStream*) output;
#endif

@end
