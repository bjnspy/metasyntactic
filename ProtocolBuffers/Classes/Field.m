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

#import "Field.h"

#import "CodedOutputStream.h"
#import "Field_Builder.h"

@implementation PBField

static PBField* defaultInstance = nil;

+ (void) initialize {
    if (self == [PBField class]) {
        defaultInstance = [[PBField newBuilder] build];
    }
}


@synthesize varint;
@synthesize fixed32;
@synthesize fixed64;
@synthesize lengthDelimited;
@synthesize group;


- (void) dealloc {
    self.varint = nil;
    self.fixed32 = nil;
    self.fixed64 = nil;
    self.lengthDelimited = nil;
    self.group = nil;

    [super dealloc];
}


+ (PBField_Builder*) newBuilder {
    return [[[PBField_Builder alloc] init] autorelease];
}


+ (PBField_Builder*) newBuilder:(PBField*) copyFrom {
    return [[PBField newBuilder] mergeFromField:copyFrom];
}


+ (PBField*) getDefaultInstance {
    return defaultInstance;
}


- (void) writeTo:(int32_t) fieldNumber
          output:(PBCodedOutputStream*) output {
    for (NSNumber* value in varint) {
        [output writeUInt64:fieldNumber value:value.longLongValue];
    }
    for (NSNumber* value in fixed32) {
        [output writeFixed32:fieldNumber value:value.intValue];
    }
    for (NSNumber* value in fixed64) {
        [output writeFixed64:fieldNumber value:value.longLongValue];
    }
    for (NSData* value in lengthDelimited) {
        [output writeData:fieldNumber value:value];
    }
    for (PBUnknownFieldSet* value in group) {
        [output writeUnknownGroup:fieldNumber value:value];
    }
}


- (int32_t) getSerializedSize:(int32_t) fieldNumber {
    int32_t result = 0;
    for (NSNumber* value in varint) {
        result += computeUInt64Size(fieldNumber, value.longLongValue);
    }
    for (NSNumber* value in fixed32) {
        result += computeFixed32Size(fieldNumber, value.intValue);
    }
    for (NSNumber* value in fixed64) {
        result += computeFixed64Size(fieldNumber, value.longLongValue);
    }
    for (NSData* value in lengthDelimited) {
        result += computeDataSize(fieldNumber, value);
    }
    for (PBUnknownFieldSet* value in group) {
        result += computeUnknownGroupSize(fieldNumber, value);
    }
    return result;
}


- (void) writeAsMessageSetExtensionTo:(int32_t) fieldNumber
                               output:(PBCodedOutputStream*) output {
    for (NSData* value in lengthDelimited) {
        [output writeRawMessageSetExtension:fieldNumber value:value];
    }
}


- (int32_t) getSerializedSizeAsMessageSetExtension:(int32_t) fieldNumber {
    int32_t result = 0;
    for (NSData* value in lengthDelimited) {
        result += computeRawMessageSetExtensionSize(fieldNumber, value);
    }
    return result;
}


@end
