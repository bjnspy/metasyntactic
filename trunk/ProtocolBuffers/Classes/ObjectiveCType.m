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

#import "ObjectiveCType.h"

id ObjectiveCTypeDefault(PBObjectiveCType type) {
    switch (type) {
        case ObjectiveCTypeInt32:
            return [NSNumber numberWithInt:0];
        case ObjectiveCTypeInt64:
            return [NSNumber numberWithLongLong:0];
        case ObjectiveCTypeFloat32:
            return [NSNumber numberWithFloat:0];
        case ObjectiveCTypeFloat64:
            return [NSNumber numberWithDouble:0];
        case ObjectiveCTypeBool:
            return [NSNumber numberWithBool:NO];
        case ObjectiveCTypeString:
            return @"";
        case ObjectiveCTypeData:
            return [NSData data];
        case ObjectiveCTypeEnum:
            return nil;
        case ObjectiveCTypeMessage:
            return nil;
        default:
            @throw [NSException exceptionWithName:@"InvalidArgument" reason:@"" userInfo:nil];
    }
}
