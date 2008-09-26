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

@protocol Message
- (Descriptors_Descriptor*) descriptorForType;
- (id<Message>) defaultInstanceForType;
- (NSDictionary*) allFields;
- (BOOL) hasField:(Descriptors_FieldDescriptor*) field;
- (id) getField:(Descriptors_FieldDescriptor*) field;
- (int) getRepeatedFieldCount:(Descriptors_FieldDescriptor*) field;
- (id) getRepeatedField:(Descriptors_FieldDescriptor*) field index:(int32_t) index;
- (UnknownFieldSet*) unknownFields;
- (BOOL) isInitialized;
- (int32_t) serializedSize;
- (void) writeToCodedOutputStream:(CodedOutputStream*) output;
- (void) writeToOuputStream:(NSOutputStream*) output;
- (NSData*) toData;
- (id<Message_Builder>) newBuilderForType;
@end