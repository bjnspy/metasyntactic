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

#import "AbstractMessage.h"

@interface DynamicMessage : AbstractMessage {
    Descriptors_Descriptor* type;
    FieldSet* fields;
    UnknownFieldSet* unknownFields;
}

@property (retain) Descriptors_Descriptor* type;
@property (retain) FieldSet* fields;
@property (retain) UnknownFieldSet* unknownFields;
@property int32_t memoizedSize;

+ (DynamicMessage*) messageWithType:(Descriptors_Descriptor*) type;
+ (DynamicMessage*) messageWithType:(Descriptors_Descriptor*) type fields:(FieldSet*) fields unknownFields:(UnknownFieldSet*) unknownFields;

+ (DynamicMessage*) parseFrom:(Descriptors_Descriptor*) type codedInputStream:(CodedInputStream*) codedInputStream;
+ (DynamicMessage*) parseFrom:(Descriptors_Descriptor*) type codedInputStream:(CodedInputStream*) codedInputStream extensionRegistry:(ExtensionRegistry*) extensionRegistry;
+ (DynamicMessage*) parseFrom:(Descriptors_Descriptor*) type data:(NSData*) data;
+ (DynamicMessage*) parseFrom:(Descriptors_Descriptor*) type data:(NSData*) data extensionRegistry:(ExtensionRegistry*) extensionRegistry;
+ (DynamicMessage*) parseFrom:(Descriptors_Descriptor*) type inputStream:(NSInputStream*) inputStream;
+ (DynamicMessage*) parseFrom:(Descriptors_Descriptor*) type inputStream:(NSInputStream*) inputStream extensionRegistry:(ExtensionRegistry*) extensionRegistry;

+ (DynamicMessage_Builder*) builderWithType:(Descriptors_Descriptor*) type;
+ (DynamicMessage_Builder*) builderWithMessage:(id<Message>) prototype;

- (Descriptors_Descriptor*) descriptorForType;
- (DynamicMessage*) defaultInstanceForType;
- (NSDictionary*) allFields;

- (BOOL) hasField:(FieldDescriptor*) field;
- (id) getField:(FieldDescriptor*) field;

- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field;
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index;

- (UnknownFieldSet*) unknownFields;
- (BOOL) isInitialized;

- (void) writeToCodedOutputStream:(CodedOutputStream*) output;

- (int32_t) serializedSize;
- (DynamicMessage_Builder*) newBuilderForType;

@end