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

#import "DynamicMessage.h"

#import "Descriptor.pb.h"
#import "Descriptor.h"
#import "DynamicMessage_Builder.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "Message.h"
#import "UnknownFieldSet.h"

@implementation DynamicMessage


@synthesize type;
@synthesize fields;
@synthesize unknownFields;

- (void) dealloc {
    self.type = nil;
    self.fields = nil;
    self.unknownFields = nil;

    [super dealloc];
}



- (id) initWithType:(ProtocolBufferDescriptor*) type_
             fields:(FieldSet*) fields_
      unknownFields:(UnknownFieldSet*) unknownFields_ {
    if (self = [super init]) {
        self.type = type_;
        self.fields = fields_;
        self.unknownFields = unknownFields_;
        dm_memoizedSize = -1;
    }

    return self;
}


+ (DynamicMessage*) messageWithType:(ProtocolBufferDescriptor*) type
                             fields:(FieldSet*) fields
                      unknownFields:(UnknownFieldSet*) unknownFields {
    return [[[DynamicMessage alloc] initWithType:type fields:fields unknownFields:unknownFields] autorelease];
}


+ (DynamicMessage*) getDefaultInstance:(ProtocolBufferDescriptor*) type {
    return [[[DynamicMessage alloc] initWithType:type
                                          fields:[FieldSet emptySet]
                                   unknownFields:[UnknownFieldSet getDefaultInstance]] autorelease];
}


+ (id<Message>) parseFrom:(ProtocolBufferDescriptor*) type
         codedInputStream:(CodedInputStream*) input {
    return [[[DynamicMessage builderWithType:type] mergeFromCodedInputStream:input] buildParsed];
}


+ (id<Message>) parseFrom:(ProtocolBufferDescriptor*) type
         codedInputStream:(CodedInputStream*) input
        extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    return [[[DynamicMessage builderWithType:type] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] buildParsed];
}


+ (id<Message>) parseFrom:(ProtocolBufferDescriptor*) type
                     data:(NSData*) data {
    return [[[DynamicMessage builderWithType:type] mergeFromData:data] buildParsed];
}


+ (id<Message>) parseFrom:(ProtocolBufferDescriptor*) type
                     data:(NSData*) data
        extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    return [[[DynamicMessage builderWithType:type] mergeFromData:data extensionRegistry:extensionRegistry] buildParsed];
}


+ (id<Message>) parseFrom:(ProtocolBufferDescriptor*) type
              inputStream:(NSInputStream*) input {
    return [[[DynamicMessage builderWithType:type] mergeFromInputStream:input] buildParsed];
}


+ (id<Message>) parseFrom:(ProtocolBufferDescriptor*) type
              inputStream:(NSInputStream*) input
        extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    return [[[DynamicMessage builderWithType:type] mergeFromInputStream:input extensionRegistry:extensionRegistry] buildParsed];
}


+ (DynamicMessage_Builder*) bulderWithType:(ProtocolBufferDescriptor*) type {
    return [DynamicMessage_Builder builderWithType:type];
}


+ (DynamicMessage_Builder*) builderWithMessage:(id<Message>) prototype {
    return [[DynamicMessage_Builder builderWithType:[prototype getDescriptorForType]] mergeFromMessage:prototype];
}


- (ProtocolBufferDescriptor*) getDescriptorForType {
    return type;
}


- (DynamicMessage*) getDefaultInstanceForType {
    return [DynamicMessage getDefaultInstance:type];
}


- (NSDictionary*) getAllFields {
    return fields.getAllFields;
}


- (void) verifyContainingType:(FieldDescriptor*) field {
    if (field.getContainingType != type) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"FieldDescriptor does not match message type." userInfo:nil];
    }
}


- (BOOL) hasField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields hasField:field];
}


- (id) getField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    id result = [fields getField:field];
    if (result == nil) {
        result = [DynamicMessage getDefaultInstance:field.getMessageType];
    }
    return result;
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields getRepeatedFieldCount:field];
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    [self verifyContainingType:field];
    return [fields getRepeatedField:field index:index];
}


- (UnknownFieldSet*) getUnknownFields {
    return unknownFields;
}


- (BOOL) isInitialized {
    return [fields isInitialized:type];
}


- (void) writeToCodedOutputStream:(CodedOutputStream*) output {
    [fields writeToCodedOutputStream:output];

    if (type.getOptions.getMessageSetWireFormat) {
        [unknownFields writeAsMessageSetTo:output];
    } else {
        [unknownFields writeToCodedOutputStream:output];
    }
}


- (int32_t) getSerializedSize {
    int size = dm_memoizedSize;
    if (size != -1) {
        return size;
    }

    size = fields.getSerializedSize;
    if (type.getOptions.getMessageSetWireFormat) {
        size += unknownFields.getSerializedSizeAsMessageSet;
    } else {
        size += unknownFields.getSerializedSize;
    }

    dm_memoizedSize = size;
    return size;
}


- (DynamicMessage_Builder*) newBuilderForType {
    return [DynamicMessage_Builder builderWithType:type];
}


+ (DynamicMessage_Builder*) builderWithType:(ProtocolBufferDescriptor*) type {
    return [DynamicMessage_Builder builderWithType:type];
}


@end
