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

#import "WireFormat.h"

#import "Utilities.h"

int32_t PBWireFormatMakeTag(int32_t fieldNumber, int32_t wireType) {
    return (fieldNumber << PBWireFormatTagTypeBits) | wireType;
}


int32_t PBWireFormatGetTagWireType(int32_t tag) {
    return tag & PBWireFormatTagTypeMask;
}


int32_t PBWireFormatGetTagFieldNumber(int32_t tag) {
    return logicalRightShift32(tag, PBWireFormatTagTypeBits);
}


#if 0
int32_t PBWireFormatGetWireFormatForFieldType(PBFieldDescriptorType type) {
    switch (type) {
        case PBFieldDescriptorTypeDouble  : return PBWireFormatFixed64;
        case PBFieldDescriptorTypeFloat   : return PBWireFormatFixed32;
        case PBFieldDescriptorTypeInt64   : return PBWireFormatVarint;
        case PBFieldDescriptorTypeUInt64  : return PBWireFormatVarint;
        case PBFieldDescriptorTypeInt32   : return PBWireFormatVarint;
        case PBFieldDescriptorTypeFixed64 : return PBWireFormatFixed64;
        case PBFieldDescriptorTypeFixed32 : return PBWireFormatFixed32;
        case PBFieldDescriptorTypeBool    : return PBWireFormatVarint;
        case PBFieldDescriptorTypeString  : return PBWireFormatLengthDelimited;
        case PBFieldDescriptorTypeGroup   : return PBWireFormatStartGroup;
        case PBFieldDescriptorTypeMessage : return PBWireFormatLengthDelimited;
        case PBFieldDescriptorTypeData    : return PBWireFormatLengthDelimited;
        case PBFieldDescriptorTypeUInt32  : return PBWireFormatVarint;
        case PBFieldDescriptorTypeEnum    : return PBWireFormatVarint;
        case PBFieldDescriptorTypeSFixed32: return PBWireFormatFixed32;
        case PBFieldDescriptorTypeSFixed64: return PBWireFormatFixed64;
        case PBFieldDescriptorTypeSInt32  : return PBWireFormatVarint;
        case PBFieldDescriptorTypeSInt64  : return PBWireFormatVarint;
    }

    @throw [NSException exceptionWithName:@"Runtime" reason:@"There is no way to get here, but the compiler thinks otherwise." userInfo:nil];
}
#endif