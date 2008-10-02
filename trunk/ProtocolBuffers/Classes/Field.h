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
@protected
    NSArray* varint;
    NSArray* fixed32;
    NSArray* fixed64;
    NSArray* lengthDelimited;
    NSArray* group;
}

@property (retain, readonly) NSArray* varint;
@property (retain, readonly) NSArray* fixed32;
@property (retain, readonly) NSArray* fixed64;
@property (retain, readonly) NSArray* lengthDelimited;
@property (retain, readonly) NSArray* group;

+ (PBField*) defaultInstance;

- (void) writeTo:(int32_t) fieldNumber
          output:(PBCodedOutputStream*) output;

- (int32_t) getSerializedSize:(int32_t) fieldNumber;
- (void) writeAsMessageSetExtensionTo:(int32_t) fieldNumber
                               output:(PBCodedOutputStream*) output;
- (int32_t) getSerializedSizeAsMessageSetExtension:(int32_t) fieldNumber;

@end
