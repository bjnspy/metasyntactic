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

#if 0
#import "GenericDescriptor.h"

/**
 * Describes one value within an enum type.  Note that multiple defined
 * values may have the same number.  In generated Java code, all values
 * with the same number after the first become aliases of the first.
 * However, they still have independent EnumValueDescriptors.
 */
@interface PBEnumValueDescriptor : NSObject<PBGenericDescriptor> {
  @private
    PBFileDescriptor* file;
    PBEnumDescriptor* type;

    int32_t index;
    PBEnumValueDescriptorProto* proto;
    NSString* fullName;
}

// don't retain our backreferences.
@property (readonly, assign) PBFileDescriptor* file;
@property (readonly, assign) PBEnumDescriptor* type;

@property (readonly) int32_t index;
@property (readonly, retain) PBEnumValueDescriptorProto* proto;
@property (readonly, copy) NSString* fullName;

+ (PBEnumValueDescriptor*) descriptorWithProto:(PBEnumValueDescriptorProto*) proto
                                          file:(PBFileDescriptor*) file
                                        parent:(PBEnumDescriptor*) parent
                                         index:(int32_t) index;

- (int32_t) number;

@end
#endif