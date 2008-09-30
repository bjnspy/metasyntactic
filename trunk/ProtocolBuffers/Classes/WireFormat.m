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

#import "WireFormat.h"

#import "Utilities.h"

int32_t WireFormatMakeTag(int32_t fieldNumber, int32_t wireType) {
    return (fieldNumber << TAG_TYPE_BITS) | wireType;
}


int32_t WireFormatGetTagWireType(int32_t tag) {
    return tag & TAG_TYPE_MASK;
}


int32_t WireFormatGetTagFieldNumber(int32_t tag) {
    return logicalRightShift32(tag, TAG_TYPE_BITS);
}


int32_t WireFormatGetWireFormatForFieldType(FieldDescriptorType type) {
    switch (type) {
        case FieldDescriptorTypeDouble  : return WireFormatFixed64;
        case FieldDescriptorTypeFloat   : return WireFormatFixed32;
        case FieldDescriptorTypeInt64   : return WireFormatVarint;
        case FieldDescriptorTypeUInt64  : return WireFormatVarint;
        case FieldDescriptorTypeInt32   : return WireFormatVarint;
        case FieldDescriptorTypeFixed64 : return WireFormatFixed64;
        case FieldDescriptorTypeFixed32 : return WireFormatFixed32;
        case FieldDescriptorTypeBool    : return WireFormatVarint;
        case FieldDescriptorTypeString  : return WireFormatLengthDelimited;
        case FieldDescriptorTypeGroup   : return WireFormatStartGroup;
        case FieldDescriptorTypeMessage : return WireFormatLengthDelimited;
        case FieldDescriptorTypeData    : return WireFormatLengthDelimited;
        case FieldDescriptorTypeUInt32  : return WireFormatVarint;
        case FieldDescriptorTypeEnum    : return WireFormatVarint;
        case FieldDescriptorTypeSFixed32: return WireFormatFixed32;
        case FieldDescriptorTypeSFixed64: return WireFormatFixed64;
        case FieldDescriptorTypeSInt32  : return WireFormatVarint;
        case FieldDescriptorTypeSInt64  : return WireFormatVarint;
    }
    
    @throw [NSException exceptionWithName:@"Runtime" reason:@"There is no way to get here, but the compiler thinks otherwise." userInfo:nil];
}