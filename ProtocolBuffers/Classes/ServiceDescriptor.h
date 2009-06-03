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

/** Describes a service type. */
@interface PBServiceDescriptor : NSObject<PBGenericDescriptor> {
  @private
    int32_t index;
    PBServiceDescriptorProto* proto;
    NSString* fullName;
    PBFileDescriptor* file;
    NSMutableArray* mutableMethods;
}

@property (readonly) int32_t index;
@property (readonly, retain) PBServiceDescriptorProto* proto;
@property (readonly, copy) NSString* fullName;
@property (readonly, retain) PBFileDescriptor* file;

+ (PBServiceDescriptor*) descriptorWithProto:(PBServiceDescriptorProto*) proto
                                        file:(PBFileDescriptor*) file
                                       index:(int32_t) index;

- (NSArray*) methods;

/**
 * Find a method by name.
 * @param name The unqualified name of the method (e.g. "Foo").
 * @return the method's decsriptor, or {@code nil} if not found.
 */
- (PBMethodDescriptor*) findMethodByName:(NSString*) name;

// @internal
- (void) crossLink;

@end
#endif