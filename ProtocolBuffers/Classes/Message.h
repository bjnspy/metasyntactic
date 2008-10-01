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

@protocol Message
- (PBDescriptor*) getDescriptorForType;
- (id<Message>) getDefaultInstanceForType;
- (NSDictionary*) getAllFields;
- (BOOL) hasField:(FieldDescriptor*) field;
- (id) getField:(FieldDescriptor*) field;
- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field;
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index;
- (UnknownFieldSet*) getUnknownFields;
- (BOOL) isInitialized;
- (int32_t) getSerializedSize;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (void) writeToOutputStream:(NSOutputStream*) output;
- (NSData*) toData;
- (id<Message_Builder>) newBuilderForType;
@end