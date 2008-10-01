// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AbstractMessage.h"

@interface PBDynamicMessage : PBAbstractMessage {
@private
    PBDescriptor* type;
    PBFieldSet* fields;
    PBUnknownFieldSet* unknownFields;
    int32_t dm_memoizedSize;
}

@property (retain) PBDescriptor* type;
@property (retain) PBFieldSet* fields;
@property (retain) PBUnknownFieldSet* unknownFields;

+ (PBDynamicMessage*) messageWithType:(PBDescriptor*) type fields:(PBFieldSet*) fields unknownFields:(PBUnknownFieldSet*) unknownFields;
+ (PBDynamicMessage*) getDefaultInstance:(PBDescriptor*) type;

+ (PBDynamicMessage_Builder*) builderWithType:(PBDescriptor*) type;


#if 0
+ (PBDynamicMessage*) messageWithType:(Descriptors_Descriptor*) type;


+ (PBDynamicMessage*) parseFrom:(Descriptors_Descriptor*) type codedInputStream:(PBCodedInputStream*) codedInputStream;
+ (PBDynamicMessage*) parseFrom:(Descriptors_Descriptor*) type codedInputStream:(PBCodedInputStream*) codedInputStream extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PBDynamicMessage*) parseFrom:(Descriptors_Descriptor*) type data:(NSData*) data;
+ (PBDynamicMessage*) parseFrom:(Descriptors_Descriptor*) type data:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (PBDynamicMessage*) parseFrom:(Descriptors_Descriptor*) type inputStream:(NSInputStream*) inputStream;
+ (PBDynamicMessage*) parseFrom:(Descriptors_Descriptor*) type inputStream:(NSInputStream*) inputStream extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

+ (PBDynamicMessage_Builder*) builderWithType:(Descriptors_Descriptor*) type;
+ (PBDynamicMessage_Builder*) builderWithMessage:(id<Message>) prototype;

- (Descriptors_Descriptor*) descriptorForType;
- (PBDynamicMessage*) defaultInstanceForType;
- (NSDictionary*) allFields;

- (BOOL) hasField:(PBFieldDescriptor*) field;
- (id) getField:(PBFieldDescriptor*) field;

- (int32_t) getRepeatedFieldCount:(PBFieldDescriptor*) field;
- (id) getRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index;

- (PBUnknownFieldSet*) unknownFields;
- (BOOL) isInitialized;

- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;

- (int32_t) serializedSize;
- (PBDynamicMessage_Builder*) newBuilderForType;
#endif

@end