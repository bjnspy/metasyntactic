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

#import "AbstractMessage.h"

#import "CodedOutputStream.h"
#import "Descriptor.h"
#import "Descriptor.pb.h"
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
    // Check that all required fields are present.
    for (PBFieldDescriptor* field in self.descriptor.fields) {
        if (field.isRequired) {
            if (![self hasField:field]) {
                return NO;
            }
        }
    }

    // Check that embedded messages are initialized.
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
    NSArray* sortedFields = [allFields.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (PBFieldDescriptor* field in sortedFields) {
        id value = [allFields objectForKey:field];
        if (field.isRepeated) {
            for (id element in value) {
                [output writeField:field.type number:field.number value:element];
            }
        } else {
            [output writeField:field.type number:field.number value:value];
        }
    }

    PBUnknownFieldSet* unknownFields = self.unknownFields;
    if (self.descriptor.options.messageSetWireFormat) {
        [unknownFields writeAsMessageSetTo:output];
    } else {
        [unknownFields writeToCodedOutputStream:output];
    }
}


- (NSData*) data {
    NSMutableData* data = [NSMutableData dataWithLength:self.serializedSize];
    PBCodedOutputStream* stream = [PBCodedOutputStream streamWithData:data];
    [self writeToCodedOutputStream:stream];
    return data;
}


- (void) writeToOutputStream:(NSOutputStream*) output {
    PBCodedOutputStream* codedOutput = [PBCodedOutputStream streamWithOutputStream:output];
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

    PBUnknownFieldSet* unknownFields = self.unknownFields;
    if (self.descriptor.options.messageSetWireFormat) {
        size += unknownFields.serializedSizeAsMessageSet;
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

    id<PBMessage> otherMessage = other;
    if (self.descriptor != [otherMessage descriptor]) {
        return NO;
    }

    return [self.allFields isEqual:[other allFields]];
}


- (NSUInteger) hash {
    NSUInteger hash = 41;
    hash = (19 * hash) + self.descriptor.hash;
    hash = (53 * hash) + self.allFields.hash;
    return hash;
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


- (BOOL) hasField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id) getField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (PBUnknownFieldSet*) unknownFields {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (id<PBMessage_Builder>) builder {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


@end