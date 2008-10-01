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

@interface PBField_Builder : NSObject {
    PBField* result;
}

@property (retain) PBField* result;

- (PBField*) build;

- (PBField_Builder*) mergeFromField:(PBField*) other;

- (PBField_Builder*) clear;
- (PBField_Builder*) mergeFromField:(PBField*) other;
- (PBField_Builder*) addVarint:(int64_t) value;
- (PBField_Builder*) addFixed32:(int32_t) value;
- (PBField_Builder*) addFixed64:(int64_t) value;
- (PBField_Builder*) addLengthDelimited:(NSData*) value;
- (PBField_Builder*) addGroup:(UnknownFieldSet*) value;

@end
