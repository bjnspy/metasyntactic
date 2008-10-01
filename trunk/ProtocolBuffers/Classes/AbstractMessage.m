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
    for (FieldDescriptor* field in self.getDescriptorForType.getFields) {
        if (field.isRequired) {
            if (![self hasField:field]) {
                return NO;
            }
        }
    }

    NSDictionary* allFields = self.getAllFields;
    for (FieldDescriptor* field in allFields) {
        if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            id value = [allFields objectForKey:field];

            if (field.isRepeated) {
                for (id<Message> element in value) {
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
    NSDictionary* allFields = self.getAllFields;
    for (FieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];
        if (field.isRepeated) {
            for (id element in value) {
                [output writeField:field.getType number:field.getNumber value:element];
            }
        } else {
            [output writeField:field.getType number:field.getNumber value:value];
        }
    }

    UnknownFieldSet* unknownFields = self.getUnknownFields;
    if (self.getDescriptorForType.getOptions.getMessageSetWireFormat) {
        [unknownFields writeAsMessageSetTo:output];
    } else {
        [unknownFields writeToCodedOutputStream:output];
    }
}


- (NSData*) toData {
    NSMutableData* data = [NSMutableData dataWithLength:self.getSerializedSize];
    PBCodedOutputStream* stream = [PBCodedOutputStream streamWithData:data];
    [self writeToCodedOutputStream:stream];
    return data;
}


- (void) writeToOutputStream:(NSOutputStream*) output {
    PBCodedOutputStream* codedOutput = [PBCodedOutputStream newInstance:output];
    [self writeToCodedOutputStream:codedOutput];
    [codedOutput flush];
}


- (int32_t) getSerializedSize {
    int32_t size = am_memoizedSize;
    if (size != -1) {
        return size;
    }

    size = 0;
    NSDictionary* allFields = self.getAllFields;
    for (FieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];

        if (field.isRepeated) {
            for (id element in value) {
                size += computeFieldSize(field.getType, field.getNumber, element);
            }
        } else {
            size += computeFieldSize(field.getType, field.getNumber, value);
        }
    }

    UnknownFieldSet* unknownFields = self.getUnknownFields;
    if (self.getDescriptorForType.getOptions.getMessageSetWireFormat) {
        size += unknownFields.getSerializedSizeAsMessageSet;
    } else {
        size += unknownFields.getSerializedSize;
    }

    am_memoizedSize = size;
    return size;
}


- (BOOL) isEqual:(id) other {
    if (other == self) {
        return YES;
    }

    if (![other conformsToProtocol:@protocol(Message)]) {
        return NO;
    }

    if (self.getDescriptorForType != [other getDescriptorForType]) {
        return NO;
    }

    return [self.getAllFields isEqual:[other getAllFields]];
}


- (NSUInteger) hash {
    NSUInteger hash = 41;
    hash = (19 * hash) + self.getDescriptorForType.hash;
    hash = (53 * hash) + self.getAllFields.hash;
    return hash;
}


- (PBDescriptor*) getDescriptorForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message>) getDefaultInstanceForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSDictionary*) getAllFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) hasField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) getField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (UnknownFieldSet*) getUnknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) newBuilderForType {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


@end
