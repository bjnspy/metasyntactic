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

#import "DynamicMessage_Builder.h"

#import "DynamicMessage.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "Message.h"
#import "ObjectiveCType.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"

@interface PBDynamicMessage_Builder ()
@property (retain) PBDescriptor* type;
@property (retain) PBFieldSet* fields;
@property (retain) PBUnknownFieldSet* unknownFields;
@end


@implementation PBDynamicMessage_Builder

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
             fields:(PBFieldSet*) fields_
      unknownFields:(PBUnknownFieldSet*) unknownFields_ {
    if (self = [super init]) {
        self.type = type_;
        self.fields = fields_;
        self.unknownFields = unknownFields_;
    }

    return self;
}


+ (PBDynamicMessage_Builder*) builderWithType:(PBDescriptor*) type {
    return [[[PBDynamicMessage_Builder alloc] initWithType:type
                                                  fields:[PBFieldSet set]
                                           unknownFields:[PBUnknownFieldSet defaultInstance]] autorelease];
}


- (PBDynamicMessage_Builder*) clear {
    [fields clear];
    return self;
}


- (PBDynamicMessage_Builder*) mergeFromMessage:(id<PBMessage>) other {
    if ([other descriptor] != type) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"mergeFromMessage can only merge messages of the same type." userInfo:nil];
    }

    [fields mergeFromMessage:other];
    return self;
}


- (PBDynamicMessage*) buildPartial {
    //[fields makeImmutable];
    PBDynamicMessage* result = [PBDynamicMessage messageWithType:type fields:fields unknownFields:unknownFields];
    self.fields = nil;
    self.unknownFields = nil;
    return result;
}


- (PBDynamicMessage*) build {
    if (![self isInitialized]) {
        @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
    }
    return [self buildPartial];
}


- (PBDynamicMessage_Builder*) clone {
    PBDynamicMessage_Builder* result = [PBDynamicMessage builderWithType:type];
    [result.fields mergeFromFieldSet:fields];
    return result;
}


- (BOOL) isInitialized {
    return [fields isInitialized:type];
}


- (PBDynamicMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input
                                    extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
    PBUnknownFieldSet_Builder* unknownFieldsBuilder = [PBUnknownFieldSet builderWithUnknownFields:unknownFields];
    [PBFieldSet mergeFromCodedInputStream:input unknownFields:unknownFieldsBuilder extensionRegistry:extensionRegistry builder:self];
    self.unknownFields = [unknownFieldsBuilder build];
    return self;
}


- (PBDescriptor*) descriptor {
    return type;
}


- (PBDynamicMessage*) defaultInstance {
    return [PBDynamicMessage defaultInstance:type];
}


- (NSDictionary*) allFields {
    return fields.allFields;
}


- (void) verifyContainingType:(PBFieldDescriptor*) field {
    if (field.containingType != type) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"PBFieldDescriptor does not match message type." userInfo:nil];
    }
}


- (PBDynamicMessage_Builder*) createBuilder:(PBFieldDescriptor*) field {
    [self verifyContainingType:field];

    if (field.objectiveCType != PBObjectiveCTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"createBuilder is only valid for fields with message type."
                                     userInfo:nil];
    }

    return [PBDynamicMessage builderWithType:field.messageType];
}


- (BOOL) hasField:(PBFieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields hasField:field];
}


- (id) getField:(PBFieldDescriptor*) field {
    [self verifyContainingType:field];
    id result = [fields getField:field];
    if (result == nil) {
        result = [PBDynamicMessage defaultInstance:field.messageType];
    }
    return result;
}


- (PBDynamicMessage_Builder*) setField:(PBFieldDescriptor*) field value:(id) value {
    [self verifyContainingType:field];
    [fields setField:field value:value];
    return self;
}


- (PBDynamicMessage_Builder*) clearField:(PBFieldDescriptor*) field {
    [self verifyContainingType:field];
    [fields clearField:field];
    return self;
}


- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields getRepeatedField:field];
}


- (PBDynamicMessage_Builder*) setRepeatedField:(PBFieldDescriptor*) field
                                       index:(int32_t) index
                                       value:(id) value {
    [self verifyContainingType:field];
    [fields setRepeatedField:field index:index value:value];
    return self;
}


- (PBDynamicMessage_Builder*) addRepeatedField:(PBFieldDescriptor*) field
                                       value:(id) value {
    [self verifyContainingType:field];
    [fields addRepeatedField:field value:value];
    return self;
}


- (PBDynamicMessage_Builder*) mergeUnknownFields:(PBUnknownFieldSet*) unknownFields_ {
    self.unknownFields = [[[PBUnknownFieldSet builderWithUnknownFields:unknownFields] mergeUnknownFields:unknownFields_] build];
    return self;
}


@end