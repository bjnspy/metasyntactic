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

#import "DynamicMessage_Builder.h"

#import "DynamicMessage.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "Message.h"
#import "ObjectiveCType.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"

@implementation DynamicMessage_Builder

@synthesize type;
@synthesize fields;
@synthesize unknownFields;

- (void) dealloc {
    self.type = nil;
    self.fields = nil;
    self.unknownFields = nil;

    [super dealloc];
}


- (id) initWithType:(PBDescriptor*) type_
             fields:(FieldSet*) fields_
      unknownFields:(UnknownFieldSet*) unknownFields_ {
    if (self = [super init]) {
        self.type = type_;
        self.fields = fields_;
        self.unknownFields = unknownFields_;
    }

    return self;
}


+ (DynamicMessage_Builder*) builderWithType:(PBDescriptor*) type {
    return [[[DynamicMessage_Builder alloc] initWithType:type
                                                  fields:[FieldSet set]
                                           unknownFields:[UnknownFieldSet getDefaultInstance]] autorelease];
}


- (DynamicMessage_Builder*) clear {
    [fields clear];
    return self;
}


- (DynamicMessage_Builder*) mergeFromMessage:(id<Message>) other {
    if ([other getDescriptorForType] != type) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"mergeFromMessage can only merge messages of the same type." userInfo:nil];
    }

    [fields mergeFromMessage:other];
    return self;
}


- (id<Message>) build {
    if (![self isInitialized]) {
        @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
    }
    return [self buildPartial];
}


- (DynamicMessage*) buildPartial {
    //[fields makeImmutable];
    DynamicMessage* result = [DynamicMessage messageWithType:type fields:fields unknownFields:unknownFields];
    self.fields = nil;
    self.unknownFields = nil;
    return result;
}


- (DynamicMessage_Builder*) clone {
    DynamicMessage_Builder* result = [DynamicMessage_Builder builderWithType:type];
    [result.fields mergeFromFieldSet:fields];
    return result;
}


- (BOOL) isInitialized {
    return [fields isInitialized:type];
}


- (DynamicMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input
                                    extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    UnknownFieldSet_Builder* unknownFieldsBuilder = [UnknownFieldSet newBuilder:unknownFields];
    [FieldSet mergeFromCodedInputStream:input unknownFields:unknownFieldsBuilder extensionRegistry:extensionRegistry builder:self];
    self.unknownFields = [unknownFieldsBuilder build];
    return self;
}


- (PBDescriptor*) getDescriptorForType {
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


- (DynamicMessage_Builder*) newBuilderForField:(FieldDescriptor*) field {
    [self verifyContainingType:field];

    if (field.getObjectiveCType != ObjectiveCTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"newBuilderForField is only valid for fields with message type."
                                     userInfo:nil];
    }

    return [DynamicMessage_Builder builderWithType:field.getMessageType];
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


- (DynamicMessage_Builder*) setField:(FieldDescriptor*) field value:(id) value {
    [self verifyContainingType:field];
    [fields setField:field value:value];
    return self;
}


- (DynamicMessage_Builder*) clearField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    [fields clearField:field];
    return self;
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields getRepeatedFieldCount:field];
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    [self verifyContainingType:field];
    return [fields getRepeatedField:field index:index];
}


- (DynamicMessage_Builder*) setRepeatedField:(FieldDescriptor*) field
                                       index:(int32_t) index
                                       value:(id) value {
    [self verifyContainingType:field];
    [fields setRepeatedField:field index:index value:value];
    return self;
}


- (DynamicMessage_Builder*) addRepeatedField:(FieldDescriptor*) field
                                       value:(id) value {
    [self verifyContainingType:field];
    [fields addRepeatedField:field value:value];
    return self;
}


- (DynamicMessage_Builder*) mergeUnknownFields:(UnknownFieldSet*) unknownFields_ {
    self.unknownFields = [[[UnknownFieldSet newBuilder:unknownFields] mergeUnknownFields:unknownFields_] build];
    return self;
}


@end
