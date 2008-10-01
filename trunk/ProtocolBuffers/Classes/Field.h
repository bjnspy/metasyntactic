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

@interface PBField : NSObject {
    NSMutableArray* varint;
    NSMutableArray* fixed32;
    NSMutableArray* fixed64;
    NSMutableArray* lengthDelimited;
    NSMutableArray* group;
}

@property (retain) NSMutableArray* varint;
@property (retain) NSMutableArray* fixed32;
@property (retain) NSMutableArray* fixed64;
@property (retain) NSMutableArray* lengthDelimited;
@property (retain) NSMutableArray* group;

+ (PBField*) getDefaultInstance;
+ (PBField_Builder*) newBuilder;

- (void) writeTo:(int32_t) fieldNumber
          output:(PBCodedOutputStream*) output;

- (int32_t) getSerializedSize:(int32_t) fieldNumber;
- (void) writeAsMessageSetExtensionTo:(int32_t) fieldNumber
                               output:(PBCodedOutputStream*) output;
- (int32_t) getSerializedSizeAsMessageSetExtension:(int32_t) fieldNumber;

@end
