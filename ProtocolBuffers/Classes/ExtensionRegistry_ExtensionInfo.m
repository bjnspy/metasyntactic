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

#import "ExtensionRegistry_ExtensionInfo.h"


@implementation ExtensionRegistry_ExtensionInfo

@synthesize descriptor;
@synthesize defaultInstance;

- (void) dealloc {
    self.descriptor = nil;
    self.defaultInstance = nil;

    [super dealloc];
}


- (id) initWithDescriptor:(FieldDescriptor*) descriptor_
          defaultInstance:(id<Message>) defaultInstance_ {
    if (self = [super init]) {
        self.descriptor = descriptor_;
        self.defaultInstance = defaultInstance_;
    }
    
    return self;
}


+ (ExtensionRegistry_ExtensionInfo*) infoWithDescriptor:(FieldDescriptor*) descriptor {
    return [ExtensionRegistry_ExtensionInfo infoWithDescriptor:descriptor defaultInstance:nil];
}


+ (ExtensionRegistry_ExtensionInfo*) infoWithDescriptor:(FieldDescriptor*) descriptor
                                        defaultInstance:(id<Message>) defaultInstance {
    return [[[ExtensionRegistry_ExtensionInfo alloc] initWithDescriptor:descriptor defaultInstance:defaultInstance] autorelease];
}

@end
