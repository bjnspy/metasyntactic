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

#import "AbstractMessage_Builder.h"

@interface DynamicMessage_Builder : AbstractMessage_Builder {
@private
    ProtocolBufferDescriptor* type;
    FieldSet* fields;
    UnknownFieldSet* unknownFields;
}

@property (retain) ProtocolBufferDescriptor* type;
@property (retain) FieldSet* fields;
@property (retain) UnknownFieldSet* unknownFields;

+ (DynamicMessage_Builder*) builderWithType:(ProtocolBufferDescriptor*) type;

- (DynamicMessage_Builder*) mergeFromMessage:(id<Message>) other;

#if 0

- (DynamicMessage_Builder*) clear;

- (DynamicMessage*) build;
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
#endif

@end
