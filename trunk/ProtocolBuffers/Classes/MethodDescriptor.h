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
 * Describes one method within a service type.
 */
@interface PBMethodDescriptor : NSObject<PBGenericDescriptor> {
  @private
    int32_t index;
    PBMethodDescriptorProto* proto;
    NSString* fullName;
    PBFileDescriptor* file;
    PBServiceDescriptor* service;

    // Initialized during cross-linking.
    PBDescriptor* inputType;
    PBDescriptor* outputType;
}

@property (readonly) int32_t index;
@property (readonly, retain) PBMethodDescriptorProto* proto;
@property (readonly, copy) NSString* fullName;
@property (readonly, retain) PBFileDescriptor* file;
@property (readonly, retain) PBServiceDescriptor* service;
@property (readonly, retain) PBDescriptor* inputType;
@property (readonly, retain) PBDescriptor* outputType;

+ (PBMethodDescriptor*) descriptorWithProto:(PBMethodDescriptorProto*) proto
                                       file:(PBFileDescriptor*) file
                                     parent:(PBServiceDescriptor*) parent
                                      index:(int32_t) index;

// @internal
- (void) crossLink;

@end

#endif