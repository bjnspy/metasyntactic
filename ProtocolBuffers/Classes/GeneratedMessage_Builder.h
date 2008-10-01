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

@interface GeneratedMessage_Builder : AbstractMessage_Builder {

}


- (FieldAccessorTable*) internalGetFieldAccessorTable;
- (id<Message_Builder>) mergeFromMessage:(id<Message>) other;
- (Descriptor*) getDescriptorForType;
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
- (UnknownFieldSet*) getUnknownFields;
- (id<Message_Builder>) setUnknownFields:(UnknownFieldSet*) unknownFields;
- (id<Message_Builder>) mergeUnknownFields:(UnknownFieldSet*) unknownFields;
- (BOOL) isInitialized;

- (BOOL) parseUnknownField:(CodedInputStream*) input
             unknownFields:(UnknownFieldSet_Builder*) unknownFields
         extensionRegistry:(ExtensionRegistry*) extensionRegistry
                       tag:(int32_t) tag;
@end
