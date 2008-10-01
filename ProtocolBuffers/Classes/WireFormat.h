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

typedef enum {
    WireFormatVarint = 0,
    WireFormatFixed64 = 1,
    WireFormatLengthDelimited = 2,
    WireFormatStartGroup = 3,
    WireFormatEndGroup = 4,
    WireFormatFixed32 = 5,

    TAG_TYPE_BITS = 3,
    TAG_TYPE_MASK = 7 /* = (1 << TAG_TYPE_BITS) - 1*/,

    WireFormatMessageSetItem = 1,
    WireFormatMessageSetTypeId = 2,
    WireFormatMessageSetMessage = 3
} PBWireFormat;

int32_t WireFormatMakeTag(int32_t fieldNumber, int32_t wireType);
int32_t WireFormatGetTagWireType(int32_t tag);
int32_t WireFormatGetTagFieldNumber(int32_t tag);

int32_t WireFormatGetWireFormatForFieldType(PBFieldDescriptorType type);

#define WireFormatMessageSetItemTag (WireFormatMakeTag(WireFormatMessageSetItem, WireFormatStartGroup))
#define WireFormatMessageSetItemEndTag (WireFormatMakeTag(WireFormatMessageSetItem, WireFormatEndGroup))
#define WireFormatMessageSetTypeIdTag (WireFormatMakeTag(WireFormatMessageSetTypeId, WireFormatVarint))
#define WireFormatMessageSetMessageTag (WireFormatMakeTag(WireFormatMessageSetMessage, WireFormatLengthDelimited))