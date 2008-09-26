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

@protocol Message_Builder
- (id<Message_Builder>) clear;
- (id<Message_Builder>) mergeFrom:(id<Message>) other;
- (id<Message>) build;
- (id<Message>) buildPartial;
- (id<Message_Builder>) clone;
- (BOOL) isInitialized;
- (Descriptors_Descriptor*) descriptorForType;
- (id<Message>) defaultInstanceForType;
- (NSDictionary*) allFields;
- (id<Message_Builder>) newBuilderForField(Descriptors_FieldDescriptor*) field;

- (BOOL) hasField:(Descriptors_FieldDescriptor*) field;
- (id) getField:(Descriptors_FieldDescriptor*) field;
- (id<Message_Builder>) setField:(Descriptors_FieldDescriptor*) field value:(id) value;
- (id<Message_Builder>) clearField:(Descriptors_FieldDescriptor*) field;
- (int32_t) getRepeatedFieldCount:(Descriptors_FieldDescriptor*) field;
- (id) getRepeatedField:(Descriptors_FieldDescriptor*) field index:(int32_t) index;
- (id<Message_Builder>) setRepeatedField:(Descriptors_FieldDescriptor*) field index:(int32_t) index value:(id) value;
- (id<Message_Builder>) addRepeatedField:(Descriptors_FieldDescriptor*) field value:(id) value;

- (UnknownFieldSet*) unknownFields;
- (id<Message_Builder>) setUnknownFields:(UnknownFieldSet*) unknownFields;
- (id<Message_Builder>) mergeUnknownFields:(UnknownFieldSet*) unknownFields; 

- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input;
- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (id<Message_Builder>) mergeFromData:(NSData*) data;
- (id<Message_Builder>) mergeFromData:(NSData*) data extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream) input;
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
    @end
