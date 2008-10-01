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

@interface PBUnknownFieldSet_Builder : NSObject {
    NSMutableDictionary* fields;

    // Optimization:  We keep around a builder for the last field that was
    //   modified so that we can efficiently add to it multiple times in a
    //   row (important when parsing an unknown repeated field).
    int32_t lastFieldNumber;

    PBField_Builder* lastField;
}

@property (retain) NSMutableDictionary* fields;
@property int32_t lastFieldNumber;
@property (retain) PBField_Builder* lastField;

+ (PBUnknownFieldSet_Builder*) newBuilder;

- (PBUnknownFieldSet*) build;
- (PBUnknownFieldSet_Builder*) mergeUnknownFields:(PBUnknownFieldSet*) other;

- (PBUnknownFieldSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (PBUnknownFieldSet_Builder*) mergeFromData:(NSData*) data;
- (PBUnknownFieldSet_Builder*) mergeFromInputStream:(NSInputStream*) input;

- (PBUnknownFieldSet_Builder*) mergeVarintField:(int32_t) number value:(int32_t) value;

- (BOOL) mergeFieldFrom:(int32_t) tag input:(PBCodedInputStream*) input;

#if 0
    int32_t lastFieldNumbers;
    UnknownFieldSet_Field_Builder* lastField;
}

@property (retain) NSDictionary* fields;

- (PBUnknownFieldSet_Builder*) clear;
- (PBUnknownFieldSet_Builder*) mergeUnknownFields:(PBUnknownFieldSet*) other;
- (PBUnknownFieldSet_Builder*) mergeField:(int32_t) number field:(UnknownFieldSet_Field*) field;
- (BOOL) hasField:(int32_t) number;
- (PBUnknownFieldSet_Builder*) addField:(int32_t) number field:(UnknownFieldSet_Field*) field;
- (NSDictionary*) dictionary;
#endif


@end
