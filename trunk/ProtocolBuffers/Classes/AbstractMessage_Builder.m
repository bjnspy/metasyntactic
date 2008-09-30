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

#import "Descriptor.pb.h"

#import "CodedInputStream.h"
#import "ExtensionRegistry.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"


@implementation AbstractMessage_Builder


- (id<Message_Builder>) clone {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) clear {
    for (FieldDescriptor* key in self.getAllFields) {
        [self clearField:key];
    }
    
    return self;
}


- (id<Message_Builder>) mergeFromMessage:(id<Message>) other {
    if ([other getDescriptorForType] != self.getDescriptorForType) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"mergeFromMessage:(id<Message>) can only merge messages of the same type." userInfo:nil];
    }
    
    // Note:  We don't attempt to verify that other's fields have valid
    //   types.  Doing so would be a losing battle.  We'd have to verify
    //   all sub-messages as well, and we'd have to make copies of all of
    //   them to insure that they don't change after verification (since
    //   the Message interface itself cannot enforce immutability of
    //   implementations).
    // TODO(kenton):  Provide a function somewhere called makeDeepCopy()
    //   which allows people to make secure deep copies of messages.
    NSDictionary* allFields = self.getAllFields;
    for (FieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];
        
        if (field.isRepeated) {
            for (id element in value) {
                [self addRepeatedField:field value:element];
            }
        } else if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            id<Message> existingValue = [self getField:field];
            
            if (existingValue == [existingValue getDefaultInstanceForType]) {
                [self setField:field value:value];
            } else {
                id value1 = [[[[existingValue newBuilderForType] mergeFromMessage:existingValue] mergeFromMessage:value] build];
                [self setField:field value:value1];
            }
        } else {
            [self setField:field value:value];
        }
    }
    
    return self;
}


- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input {
    return [self mergeFromCodedInputStream:input extensionRegistry:[ExtensionRegistry getEmptyRegistry]];
}


- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input
                                extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    UnknownFieldSet_Builder* unknownFields = [UnknownFieldSet newBuilder:self.getUnknownFields];
    [FieldSet mergeFromCodedInputStream:input unknownFields:unknownFields extensionRegistry:extensionRegistry builder:self];
    [self setUnknownFields:[unknownFields build]];
    
    return self;
}


- (id<Message_Builder>) mergeUnknownFields:(UnknownFieldSet*) unknownFields {
    UnknownFieldSet* merged = [[[UnknownFieldSet newBuilder:self.getUnknownFields] mergeUnknownFields:unknownFields] build];
    [self setUnknownFields:merged];
    
    return self;
}


- (id<Message_Builder>) mergeFromData:(NSData*) data {
    CodedInputStream* input = [CodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input];
    [input checkLastTagWas:0];
    return self;
}


- (id<Message_Builder>) mergeFromData:(NSData*) data
                    extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    CodedInputStream* input = [CodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input extensionRegistry:extensionRegistry];
    [input checkLastTagWas:0];
    return self;
}


- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input {
    CodedInputStream* codedInput = [CodedInputStream streamWithInputStream:input];
    [self mergeFromCodedInputStream:codedInput];
    [codedInput checkLastTagWas:0];
    return self;
}


- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input
                           extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    CodedInputStream* codedInput = [CodedInputStream streamWithInputStream:input];
    [self mergeFromCodedInputStream:codedInput extensionRegistry:extensionRegistry];
    [codedInput checkLastTagWas:0];
    return self;
}


- (id<Message>) buildParsed {
    if (![self isInitialized]) {
        @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
    }
    return [self buildPartial];
}


- (id<Message>) build {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message>) buildPartial {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) isInitialized {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (ProtocolBufferDescriptor*) getDescriptorForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message>) getDefaultInstanceForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSDictionary*) getAllFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) newBuilderForField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) hasField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) getField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) setField:(FieldDescriptor*) field value:(id) value {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) clearField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) setRepeatedField:(FieldDescriptor*) field index:(int32_t) index value:(id) value {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) addRepeatedField:(FieldDescriptor*) field value:(id) value {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (UnknownFieldSet*) unknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) setUnknownFields:(UnknownFieldSet*) unknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (UnknownFieldSet*) getUnknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


@end
