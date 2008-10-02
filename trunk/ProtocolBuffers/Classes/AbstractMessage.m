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

#import "AbstractMessage.h"

#import "Descriptor.pb.h"
#import "CodedOutputStream.h"
#import "Descriptor.h"
#import "FieldDescriptor.h"
#import "ObjectiveCType.h"

@implementation PBAbstractMessage


- (id) init {
    if (self = [super init]) {
        am_memoizedSize = -1;
    }

    return self;
}


- (BOOL) isInitialized {
    for (PBFieldDescriptor* field in self.descriptorForType.fields) {
        if (field.isRequired) {
            if (![self hasField:field]) {
                return NO;
            }
        }
    }

    NSDictionary* allFields = self.allFields;
    for (PBFieldDescriptor* field in allFields) {
        if (field.objectiveCType == PBObjectiveCTypeMessage) {
            id value = [allFields objectForKey:field];

            if (field.isRepeated) {
                for (id<PBMessage> element in value) {
                    if (![element isInitialized]) {
                        return NO;
                    }
                }
            } else {
                if (![value isInitialized]) {
                    return NO;
                }
            }
        }
    }

    return YES;
}


- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
    NSDictionary* allFields = self.allFields;
    for (PBFieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];
        if (field.isRepeated) {
            for (id element in value) {
                [output writeField:field.type number:field.number value:element];
            }
        } else {
            [output writeField:field.type number:field.number value:value];
        }
    }

    PBUnknownFieldSet* unknownFields = self.getUnknownFields;
    if (self.descriptorForType.options.getMessageSetWireFormat) {
        [unknownFields writeAsMessageSetTo:output];
    } else {
        [unknownFields writeToCodedOutputStream:output];
    }
}


- (NSData*) toData {
    NSMutableData* data = [NSMutableData dataWithLength:self.serializedSize];
    PBCodedOutputStream* stream = [PBCodedOutputStream streamWithData:data];
    [self writeToCodedOutputStream:stream];
    return data;
}


- (void) writeToOutputStream:(NSOutputStream*) output {
    PBCodedOutputStream* codedOutput = [PBCodedOutputStream newInstance:output];
    [self writeToCodedOutputStream:codedOutput];
    [codedOutput flush];
}


- (int32_t) serializedSize {
    int32_t size = am_memoizedSize;
    if (size != -1) {
        return size;
    }

    size = 0;
    NSDictionary* allFields = self.allFields;
    for (PBFieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];

        if (field.isRepeated) {
            for (id element in value) {
                size += computeFieldSize(field.type, field.number, element);
            }
        } else {
            size += computeFieldSize(field.type, field.number, value);
        }
    }

    PBUnknownFieldSet* unknownFields = self.getUnknownFields;
    if (self.descriptorForType.options.getMessageSetWireFormat) {
        size += unknownFields.getSerializedSizeAsMessageSet;
    } else {
        size += unknownFields.serializedSize;
    }

    am_memoizedSize = size;
    return size;
}


- (BOOL) isEqual:(id) other {
    if (other == self) {
        return YES;
    }

    if (![other conformsToProtocol:@protocol(PBMessage)]) {
        return NO;
    }

    if (self.descriptorForType != [other descriptorForType]) {
        return NO;
    }

    return [self.allFields isEqual:[other allFields]];
}


- (NSUInteger) hash {
    NSUInteger hash = 41;
    hash = (19 * hash) + self.descriptorForType.hash;
    hash = (53 * hash) + self.allFields.hash;
    return hash;
}


- (PBDescriptor*) descriptorForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage>) getDefaultInstanceForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSDictionary*) allFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) hasField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) getField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (int32_t) getRepeatedFieldCount:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) getRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (PBUnknownFieldSet*) getUnknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) newBuilderForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


@end
