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

@interface PBFieldSet : NSObject {
    NSMutableDictionary* fields;
}

@property (retain) NSMutableDictionary* fields;

+ (void) mergeFromCodedInputStream:(PBCodedInputStream*) input
                     unknownFields:(PBUnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(PBExtensionRegistry*) extensionRegistry
                           builder:(id<PBMessage_Builder>) builder;
+ (BOOL) mergeFieldFromCodedInputStream:(PBCodedInputStream*) input
                     unknownFields:(PBUnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(PBExtensionRegistry*) extensionRegistry
                           builder:(id<PBMessage_Builder>) builder
                               tag:(int32_t) tag;

+ (PBFieldSet*) set;
+ (PBFieldSet*) emptySet;

- (id) initWithFields:(NSMutableDictionary*) fields;

- (void) clear;
- (NSDictionary*) allFields;

- (BOOL) hasField:(PBFieldDescriptor*) field;
- (id) getField:(PBFieldDescriptor*) field;
- (void) setField:(PBFieldDescriptor*) field value:(id) value;
- (void) clearField:(PBFieldDescriptor*) field;

- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field;
- (void) setRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index value:(id) value;
- (void) addRepeatedField:(PBFieldDescriptor*) field value:(id) value;

- (BOOL) isInitialized;
- (BOOL) isInitialized:(PBDescriptor*) type;

- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;

- (int32_t) serializedSize;

- (void) mergeFromMessage:(id<PBMessage>) other;
- (void) mergeFromFieldSet:(PBFieldSet*) other;

- (void) writeField:(PBFieldDescriptor*) field value:(id) value output:(PBCodedOutputStream*) output;

@end