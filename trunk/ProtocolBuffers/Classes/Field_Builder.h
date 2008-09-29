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

@interface Field_Builder : NSObject {
    Field* result;
}

@property (retain) Field* result;

- (Field*) build;

- (Field_Builder*) mergeFromField:(Field*) other;

- (Field_Builder*) clear;
- (Field_Builder*) mergeFromField:(Field*) other;
- (Field_Builder*) addVarint:(int64_t) value;
- (Field_Builder*) addFixed32:(int32_t) value;
- (Field_Builder*) addFixed64:(int64_t) value;
- (Field_Builder*) addLengthDelimited:(NSData*) value;
- (Field_Builder*) addGroup:(UnknownFieldSet*) value;

@end
