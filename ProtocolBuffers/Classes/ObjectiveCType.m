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

#import "ObjectiveCType.h"

id PBObjectiveCTypeDefault(PBObjectiveCType type) {
    switch (type) {
        case PBObjectiveCTypeInt32:
            return [NSNumber numberWithInt:0];
        case PBObjectiveCTypeInt64:
            return [NSNumber numberWithLongLong:0];
        case PBObjectiveCTypeFloat32:
            return [NSNumber numberWithFloat:0];
        case PBObjectiveCTypeFloat64:
            return [NSNumber numberWithDouble:0];
        case PBObjectiveCTypeBool:
            return [NSNumber numberWithBool:NO];
        case PBObjectiveCTypeString:
            return @"";
        case PBObjectiveCTypeData:
            return [NSData data];
        case PBObjectiveCTypeEnum:
            return nil;
        case PBObjectiveCTypeMessage:
            return nil;
        default:
@throw [NSException exceptionWithName:@"InvalidArgument" reason:@"" userInfo:nil];
    }
}


PBObjectiveCType PBObjectiveCTypeFromFieldDescriptorType(PBFieldDescriptorType type) {
    switch (type) {
        case PBFieldDescriptorTypeDouble:   return PBObjectiveCTypeFloat64;
        case PBFieldDescriptorTypeFloat:    return PBObjectiveCTypeFloat32;
        case PBFieldDescriptorTypeInt64:    return PBObjectiveCTypeInt64;
        case PBFieldDescriptorTypeUInt64:   return PBObjectiveCTypeInt64;
        case PBFieldDescriptorTypeInt32:    return PBObjectiveCTypeInt32;
        case PBFieldDescriptorTypeFixed64:  return PBObjectiveCTypeInt64;
        case PBFieldDescriptorTypeFixed32:  return PBObjectiveCTypeInt32;
        case PBFieldDescriptorTypeBool:     return PBObjectiveCTypeBool;
        case PBFieldDescriptorTypeString:   return PBObjectiveCTypeString;
        case PBFieldDescriptorTypeGroup:    return PBObjectiveCTypeMessage;
        case PBFieldDescriptorTypeMessage:  return PBObjectiveCTypeMessage;
        case PBFieldDescriptorTypeData:     return PBObjectiveCTypeData;
        case PBFieldDescriptorTypeUInt32:   return PBObjectiveCTypeInt32;
        case PBFieldDescriptorTypeSFixed32: return PBObjectiveCTypeInt32;
        case PBFieldDescriptorTypeSFixed64: return PBObjectiveCTypeInt64;
        case PBFieldDescriptorTypeSInt32:   return PBObjectiveCTypeInt32;
        case PBFieldDescriptorTypeSInt64:   return PBObjectiveCTypeInt64;
        case PBFieldDescriptorTypeEnum:     return PBObjectiveCTypeEnum;

        default:
@throw [NSException exceptionWithName:@"InvalidArgument" reason:@"" userInfo:nil];
    }
}