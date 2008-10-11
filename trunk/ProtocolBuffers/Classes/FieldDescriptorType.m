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

#import "FieldDescriptorType.h"

#import "Descriptor.pb.h"

PBFieldDescriptorType PBFieldDescriptorTypeFrom(PBFieldDescriptorProto_Type* type) {
    PBFieldDescriptorType result = (PBFieldDescriptorType)(type.number - 1);
    if (PBFieldDescriptorTypeTo(result) != type) {
        @throw [NSException exceptionWithName:@"InconsistancyError" reason:@"" userInfo:nil];
    }
    return result;
}


PBFieldDescriptorProto_Type* PBFieldDescriptorTypeTo(PBFieldDescriptorType type) {
    switch (type) {
        case PBFieldDescriptorTypeDouble:   return [PBFieldDescriptorProto_Type TYPE_DOUBLE];
        case PBFieldDescriptorTypeFloat:    return [PBFieldDescriptorProto_Type TYPE_FLOAT];
        case PBFieldDescriptorTypeInt64:    return [PBFieldDescriptorProto_Type TYPE_INT64];
        case PBFieldDescriptorTypeUInt64:   return [PBFieldDescriptorProto_Type TYPE_UINT64];
        case PBFieldDescriptorTypeInt32:    return [PBFieldDescriptorProto_Type TYPE_INT32];
        case PBFieldDescriptorTypeFixed64:  return [PBFieldDescriptorProto_Type TYPE_FIXED64];
        case PBFieldDescriptorTypeFixed32:  return [PBFieldDescriptorProto_Type TYPE_FIXED32];
        case PBFieldDescriptorTypeBool:     return [PBFieldDescriptorProto_Type TYPE_BOOL_];
        case PBFieldDescriptorTypeString:   return [PBFieldDescriptorProto_Type TYPE_STRING];
        case PBFieldDescriptorTypeGroup:    return [PBFieldDescriptorProto_Type TYPE_GROUP];
        case PBFieldDescriptorTypeMessage:  return [PBFieldDescriptorProto_Type TYPE_MESSAGE];
        case PBFieldDescriptorTypeData:     return [PBFieldDescriptorProto_Type TYPE_BYTES];
        case PBFieldDescriptorTypeUInt32:   return [PBFieldDescriptorProto_Type TYPE_UINT32];
        case PBFieldDescriptorTypeEnum:     return [PBFieldDescriptorProto_Type TYPE_ENUM];
        case PBFieldDescriptorTypeSFixed32: return [PBFieldDescriptorProto_Type TYPE_SFIXED32];
        case PBFieldDescriptorTypeSFixed64: return [PBFieldDescriptorProto_Type TYPE_SFIXED64];
        case PBFieldDescriptorTypeSInt32:   return [PBFieldDescriptorProto_Type TYPE_SINT32];
        case PBFieldDescriptorTypeSInt64:   return [PBFieldDescriptorProto_Type TYPE_SINT64];
        default:
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
}