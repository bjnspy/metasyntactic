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

#import "CodedInputStream.h"
#import "Descriptor.pb.h"
#import "ExtensionRegistry.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"



@implementation PBAbstractMessage_Builder


- (id<PBMessage_Builder>) clone {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) clear {
    for (PBFieldDescriptor* key in self.allFields) {
        [self clearField:key];
    }

    return self;
}


- (id<PBMessage_Builder>) mergeFromMessage:(id<PBMessage>) other {
    if ([other descriptor] != self.descriptor) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"mergeFromMessage can only merge messages of the same type."
                                     userInfo:nil];
    }

    // Note:  We don't attempt to verify that other's fields have valid
    //   types.  Doing so would be a losing battle.  We'd have to verify
    //   all sub-messages as well, and we'd have to make copies of all of
    //   them to insure that they don't change after verification (since
    //   the PBMessage interface itself cannot enforce immutability of
    //   implementations).
    NSDictionary* allFields = self.allFields;
    for (PBFieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];

        if (field.isRepeated) {
            for (id element in value) {
                [self addRepeatedField:field value:element];
            }
        } else if (field.objectiveCType == PBObjectiveCTypeMessage) {
            id<PBMessage> existingValue = [self getField:field];

            if (existingValue == [existingValue defaultInstance]) {
                [self setField:field value:value];
            } else {
                id value1 = [[[[existingValue builder] mergeFromMessage:existingValue] mergeFromMessage:value] build];
                [self setField:field value:value1];
            }
        } else {
            [self setField:field value:value];
        }
    }

    return self;
}


- (id<PBMessage_Builder>) mergeFromCodedInputStream:(PBCodedInputStream*) input {
    return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}


- (id<PBMessage_Builder>) mergeFromCodedInputStream:(PBCodedInputStream*) input
                                  extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
    PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
    [PBFieldSet mergeFromCodedInputStream:input unknownFields:unknownFields extensionRegistry:extensionRegistry builder:self];
    [self setUnknownFields:[unknownFields build]];

    return self;
}


- (id<PBMessage_Builder>) mergeUnknownFields:(PBUnknownFieldSet*) unknownFields {
    PBUnknownFieldSet* merged =
    [[[PBUnknownFieldSet builderWithUnknownFields:self.unknownFields]
                               mergeUnknownFields:unknownFields] build];

    [self setUnknownFields:merged];
    return self;
}


- (id<PBMessage_Builder>) mergeFromData:(NSData*) data {
    PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input];
    [input checkLastTagWas:0];
    return self;
}


- (id<PBMessage_Builder>) mergeFromData:(NSData*) data
                      extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
    PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
    [self mergeFromCodedInputStream:input extensionRegistry:extensionRegistry];
    [input checkLastTagWas:0];
    return self;
}


- (id<PBMessage_Builder>) mergeFromInputStream:(NSInputStream*) input {
    PBCodedInputStream* codedInput = [PBCodedInputStream streamWithInputStream:input];
    [self mergeFromCodedInputStream:codedInput];
    [codedInput checkLastTagWas:0];
    return self;
}


- (id<PBMessage_Builder>) mergeFromInputStream:(NSInputStream*) input
                             extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
    PBCodedInputStream* codedInput = [PBCodedInputStream streamWithInputStream:input];
    [self mergeFromCodedInputStream:codedInput extensionRegistry:extensionRegistry];
    [codedInput checkLastTagWas:0];
    return self;
}


- (id<PBMessage>) build {
    if (![self isInitialized]) {
        @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
    }
    return [self buildPartial];
}


- (id<PBMessage>) buildPartial {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) isInitialized {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (PBDescriptor*) descriptor {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage>) defaultInstance {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSDictionary*) allFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) createBuilder:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) hasField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) getField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) setField:(PBFieldDescriptor*) field value:(id) value {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) clearField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) setRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index value:(id) value {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) addRepeatedField:(PBFieldDescriptor*) field value:(id) value {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (PBUnknownFieldSet*) unknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) setUnknownFields:(PBUnknownFieldSet*) unknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


@end