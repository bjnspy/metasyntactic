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

@interface PBEnumValueDescriptor : NSObject/*<PBGenericDescriptor>*/ {
    PBFileDescriptor* file;
    PBEnumDescriptor* type;

    int32_t index;
    //EnumValueDescriptorProto proto;
    NSString* fullName;
}

// don't retain our backreferences.
@property (assign) PBFileDescriptor* file;
@property (assign) PBEnumDescriptor* type;

@property int32_t index;
@property (retain) NSString* fullName;

- (PBEnumDescriptor*) getType;
- (int32_t) number;
- (int32_t) getIndex;

@end
