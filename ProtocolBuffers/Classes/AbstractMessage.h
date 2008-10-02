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

#import "Message.h"

@interface PBAbstractMessage : NSObject<PBMessage> {
@private
    int32_t am_memoizedSize;
}

- (PBDescriptor*) descriptorForType;
- (id<PBMessage>) getDefaultInstanceForType;
- (NSDictionary*) allFields;
- (BOOL) hasField:(PBFieldDescriptor*) field;
- (id) getField:(PBFieldDescriptor*) field;
- (int32_t) getRepeatedFieldCount:(PBFieldDescriptor*) field;
- (id) getRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index;
- (PBUnknownFieldSet*) getUnknownFields;
- (BOOL) isInitialized;
- (int32_t) serializedSize;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (void) writeToOutputStream:(NSOutputStream*) output;
- (NSData*) toData;
- (id<PBMessage_Builder>) newBuilderForType;

@end