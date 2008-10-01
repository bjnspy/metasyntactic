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

@interface PBDynamicMessage_Builder : AbstractMessage_Builder {
@private
    PBDescriptor* type;
    PBFieldSet* fields;
    PBUnknownFieldSet* unknownFields;
}

@property (retain) PBDescriptor* type;
@property (retain) PBFieldSet* fields;
@property (retain) PBUnknownFieldSet* unknownFields;

+ (PBDynamicMessage_Builder*) builderWithType:(PBDescriptor*) type;

- (PBDynamicMessage_Builder*) mergeFromMessage:(id<Message>) other;

#if 0

- (PBDynamicMessage_Builder*) clear;

- (PBDynamicMessage*) build;
- (PBDynamicMessage*) buildPartial;

- (PBDynamicMessage_Builder*) clone;

- (BOOL) isInitialized;

- (PBDynamicMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (Descriptors_Descriptor*) descriptorForType;
- (PBDynamicMessage*) defaultInstanceForType;
- (NSDictionary*) allFields;
- (PBDynamicMessage_Builder*) builderForField:(PBFieldDescriptor*) field;

- (BOOL) hasField:(PBFieldDescriptor*) field;
- (id) getField:(PBFieldDescriptor*) field;

- (PBDynamicMessage_Builder*) setField:(PBFieldDescriptor*) field value:(id) value;
- (PBDynamicMessage_Builder*) clearField:(PBFieldDescriptor*) field;
- (int32_t) getRepeatedFieldCount:(PBFieldDescriptor*) field;
- (id) getRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index;

- (PBDynamicMessage_Builder*) setRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index value:(id) value;
- (PBDynamicMessage_Builder*) addRepeatedField:(PBFieldDescriptor*) field value:(id) value;

- (PBUnknownFieldSet*) unknownFields;
- (PBDynamicMessage_Builder*) setUnknownFields:(PBUnknownFieldSet*) unknownFields;
- (PBDynamicMessage_Builder*) mergeUnknownFields:(PBUnknownFieldSet*) unknownFields;
#endif

@end
