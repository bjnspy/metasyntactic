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

- (PBMethodDescriptor*) findMethodByName:(NSString*) name;

// @internal
- (void) crossLink;

@end
