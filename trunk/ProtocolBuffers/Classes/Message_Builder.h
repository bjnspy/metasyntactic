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
- (id<Message>) buildParsed;
- (id<Message_Builder>) clone;
- (BOOL) isInitialized;
- (Descriptor*) getDescriptorForType;
- (id<Message>) getDefaultInstanceForType;
- (NSDictionary*) getAllFields;
- (id<Message_Builder>) newBuilderForField:(FieldDescriptor*) field;

- (BOOL) hasField:(FieldDescriptor*) field;
- (id) getField:(FieldDescriptor*) field;
- (id<Message_Builder>) setField:(FieldDescriptor*) field value:(id) value;
- (id<Message_Builder>) clearField:(FieldDescriptor*) field;
- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field;
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index;
- (id<Message_Builder>) setRepeatedField:(FieldDescriptor*) field index:(int32_t) index value:(id) value;
- (id<Message_Builder>) addRepeatedField:(FieldDescriptor*) field value:(id) value;

- (UnknownFieldSet*) unknownFields;
- (id<Message_Builder>) setUnknownFields:(UnknownFieldSet*) unknownFields;
- (id<Message_Builder>) mergeUnknownFields:(UnknownFieldSet*) unknownFields; 

- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input;
- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (id<Message_Builder>) mergeFromData:(NSData*) data;
- (id<Message_Builder>) mergeFromData:(NSData*) data extensionRegistry:(ExtensionRegistry*) extensionRegistry;
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input;
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry;
@end
