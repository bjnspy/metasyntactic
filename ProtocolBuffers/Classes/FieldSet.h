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

@interface FieldSet : NSObject {
    NSMutableDictionary* fields;
}


@property (retain) NSMutableDictionary* fields;


+ (void) mergeFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder;
+ (BOOL) mergeFieldFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder
                               tag:(int32_t) tag;


+ (FieldSet*) set;
+ (FieldSet*) emptySet;


- (id) initWithFields:(NSMutableDictionary*) fields;

- (void) clear;
- (NSDictionary*) getAllFields;

- (BOOL) hasField:(FieldDescriptor*) field;
- (id) getField:(FieldDescriptor*) field;
- (void) setField:(FieldDescriptor*) field value:(id) value;
- (void) clearField:(FieldDescriptor*) field;

- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field;
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index;
- (void) setRepeatedField:(FieldDescriptor*) field index:(int32_t) index value:(id) value;
- (void) addRepeatedField:(FieldDescriptor*) field value:(id) value;


- (BOOL) isInitialized:(ProtocolBufferDescriptor*) type;

- (void) writeToCodedOutputStream:(CodedOutputStream*) output;

- (int32_t) getSerializedSize;

- (void) mergeFromMessage:(id<Message>) other;
- (void) mergeFromFieldSet:(FieldSet*) other;

- (void) writeField:(FieldDescriptor*) field value:(id) value output:(CodedOutputStream*) output;


#if 0
    // Use a TreeMap because fields need to be in canonical order when
    // serializing.
    NSDictionary* fields;
}

@property (retain) NSDictionary* fields;

+ (FieldSet*) setWithFields:(NSDictionary*) fields;
+ (FieldSet*) set;

- (void) makeImmutable; 

- (BOOL) isInitialized;

- (void) mergeFrom:(id<Message>) other;
- (void) mergeFrom:(FieldSet*) other;
- (void) mergeFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder;

- (BOOL) mergeFieldFromCodedInputStream:(CodedInputStream*) input
                          unknownFields:(UnknownFieldSet_Builder*) unknownFields
                      extensionRegistry:(ExtensionRegistry*) extensionRegistry
                                builder:(id<Message_Builder>) builder
                                    tag:(int32_t) tag;

- (void) mergeMessageSetExtensionFromCodedInputStream:(CodedInputStream*) input
                                        unknownFields:(UnknownFieldSet_Builder*) unknownFields
                                    extensionRegistry:(ExtensionRegistry*) extensionRegistry
                                              builder:(id<Message_Builder>) builder;

- (void) writeField:(Descriptors_FieldDescriptor*) field value:(id) value ouput:(CodedInputStream*) output;
#endif

@end
