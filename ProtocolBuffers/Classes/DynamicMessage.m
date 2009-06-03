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

#if 0
#import "DynamicMessage.h"

#import "Descriptor.h"
#import "Descriptor.pb.h"
#import "DynamicMessage_Builder.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "Message.h"
#import "UnknownFieldSet.h"

@interface PBDynamicMessage ()
@property (retain) PBDescriptor* type;
@property (retain) PBFieldSet* fields;
@property (retain) PBUnknownFieldSet* unknownFields;
@end


@implementation PBDynamicMessage


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
        dm_memoizedSize = -1;
    }

    return self;
}


+ (PBDynamicMessage*) messageWithType:(PBDescriptor*) type
                               fields:(PBFieldSet*) fields
                        unknownFields:(PBUnknownFieldSet*) unknownFields {
    return [[[PBDynamicMessage alloc] initWithType:type fields:fields unknownFields:unknownFields] autorelease];
}


+ (PBDynamicMessage*) defaultInstance:(PBDescriptor*) type {
    return [[[PBDynamicMessage alloc] initWithType:type
                                            fields:[PBFieldSet emptySet]
                                     unknownFields:[PBUnknownFieldSet defaultInstance]] autorelease];
}


+ (id<PBMessage>) parseFrom:(PBDescriptor*) type
           codedInputStream:(PBCodedInputStream*) input {
    return [[[PBDynamicMessage builderWithType:type] mergeFromCodedInputStream:input] build];
}


+ (id<PBMessage>) parseFrom:(PBDescriptor*) type
           codedInputStream:(PBCodedInputStream*) input
          extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
    return [[[PBDynamicMessage builderWithType:type] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}


+ (id<PBMessage>) parseFrom:(PBDescriptor*) type
                       data:(NSData*) data {
    return [[[PBDynamicMessage builderWithType:type] mergeFromData:data] build];
}


+ (id<PBMessage>) parseFrom:(PBDescriptor*) type
                       data:(NSData*) data
          extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
    return [[[PBDynamicMessage builderWithType:type] mergeFromData:data extensionRegistry:extensionRegistry] build];
}


+ (id<PBMessage>) parseFrom:(PBDescriptor*) type
                inputStream:(NSInputStream*) input {
    return [[[PBDynamicMessage builderWithType:type] mergeFromInputStream:input] build];
}


+ (id<PBMessage>) parseFrom:(PBDescriptor*) type
                inputStream:(NSInputStream*) input
          extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
    return [[[PBDynamicMessage builderWithType:type] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}


+ (PBDynamicMessage_Builder*) bulderWithType:(PBDescriptor*) type {
    return [PBDynamicMessage builderWithType:type];
}


+ (PBDynamicMessage_Builder*) builderWithMessage:(id<PBMessage>) prototype {
    return [[PBDynamicMessage builderWithType:[prototype descriptor]] mergeFromMessage:prototype];
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


- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields getRepeatedField:field];
}


- (PBUnknownFieldSet*) unknownFields {
    return unknownFields;
}


- (BOOL) isInitialized {
    return [fields isInitialized:type];
}


- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
    [fields writeToCodedOutputStream:output];

    if (type.options.messageSetWireFormat) {
        [unknownFields writeAsMessageSetTo:output];
    } else {
        [unknownFields writeToCodedOutputStream:output];
    }
}


- (int32_t) serializedSize {
    int32_t size = dm_memoizedSize;
    if (size != -1) {
        return size;
    }

    size = fields.serializedSize;
    if (type.options.messageSetWireFormat) {
        size += unknownFields.serializedSizeAsMessageSet;
    } else {
        size += unknownFields.serializedSize;
    }

    dm_memoizedSize = size;
    return size;
}


- (PBDynamicMessage_Builder*) builder {
    return [PBDynamicMessage builderWithType:type];
}


+ (PBDynamicMessage_Builder*) builderWithType:(PBDescriptor*) type {
    return [PBDynamicMessage_Builder builderWithType:type];
}

@end
#endif