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

#import "GenericDescriptor.h"

@interface PBEnumDescriptor : NSObject<PBGenericDescriptor> {
@private
    int32_t index;
    PBEnumDescriptorProto* proto;
    NSString* fullName;

    // TODO(cyrusn): circularity between us and file
    PBFileDescriptor* file;
    // TODO(cyrusn): circularity between us and containingType
    PBDescriptor* containingType;
    // TODO(cyrusn): circularity between us and enum values
    NSMutableArray* mutableValues;
}

@property (readonly) int32_t index;
@property (readonly, retain) PBEnumDescriptorProto* proto;
@property (readonly, copy) NSString* fullName;
@property (readonly, retain) PBFileDescriptor* file;
@property (readonly, retain) PBDescriptor* containingType;

+ (PBEnumDescriptor*) descriptorWithProto:(PBEnumDescriptorProto*) proto
                                     file:(PBFileDescriptor*) file
                                   parent:(PBDescriptor*) parent
                                    index:(int32_t) index;

- (NSArray*) values;

- (PBEnumValueDescriptor*) findValueByName:(NSString*) name;
- (PBEnumValueDescriptor*) findValueByNumber:(int32_t) number;

@end
