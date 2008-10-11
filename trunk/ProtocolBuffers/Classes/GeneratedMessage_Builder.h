// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AbstractMessage_Builder.h"

@interface PBGeneratedMessage_Builder : PBAbstractMessage_Builder {
}

- (id<PBMessage_Builder>) mergeFromMessage:(id<PBMessage>) other;
- (PBDescriptor*) descriptor;
- (NSDictionary*) allFields;
- (id<PBMessage_Builder>) createBuilder:(PBFieldDescriptor*) field;

- (BOOL) hasField:(PBFieldDescriptor*) field;
- (id) getField:(PBFieldDescriptor*) field;
- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field;

- (id<PBMessage_Builder>) setField:(PBFieldDescriptor*) field value:(id) value;
- (id<PBMessage_Builder>) clearField:(PBFieldDescriptor*) field;
- (id<PBMessage_Builder>) setRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index value:(id) value;
- (id<PBMessage_Builder>) addRepeatedField:(PBFieldDescriptor*) field value:(id) value;
- (id<PBMessage_Builder>) setUnknownFields:(PBUnknownFieldSet*) unknownFields;
- (id<PBMessage_Builder>) mergeUnknownFields:(PBUnknownFieldSet*) unknownFields;

- (PBUnknownFieldSet*) unknownFields;
- (BOOL) isInitialized;

- (BOOL) parseUnknownField:(PBCodedInputStream*) input
             unknownFields:(PBUnknownFieldSet_Builder*) unknownFields
         extensionRegistry:(PBExtensionRegistry*) extensionRegistry
                       tag:(int32_t) tag;
@end