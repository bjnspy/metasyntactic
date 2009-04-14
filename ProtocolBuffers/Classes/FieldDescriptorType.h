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

@class PBFieldDescriptorProto_Type;

typedef enum {
    PBFieldDescriptorTypeDouble,
    PBFieldDescriptorTypeFloat,
    PBFieldDescriptorTypeInt64,
    PBFieldDescriptorTypeUInt64,
    PBFieldDescriptorTypeInt32,
    PBFieldDescriptorTypeFixed64,
    PBFieldDescriptorTypeFixed32,
    PBFieldDescriptorTypeBool,
    PBFieldDescriptorTypeString,
    PBFieldDescriptorTypeGroup,
    PBFieldDescriptorTypeMessage,
    PBFieldDescriptorTypeData,
    PBFieldDescriptorTypeUInt32,
    PBFieldDescriptorTypeEnum,
    PBFieldDescriptorTypeSFixed32,
    PBFieldDescriptorTypeSFixed64,
    PBFieldDescriptorTypeSInt32,
    PBFieldDescriptorTypeSInt64,
} PBFieldDescriptorType;

PBFieldDescriptorType PBFieldDescriptorTypeFrom(PBFieldDescriptorProto_Type* type);
PBFieldDescriptorProto_Type* PBFieldDescriptorTypeTo(PBFieldDescriptorType type);