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

#import "ExtensionInfo.h"


@interface PBExtensionInfo ()
@property (retain) PBFieldDescriptor* descriptor;
@property (retain) id<PBMessage> defaultInstance;
@end


@implementation PBExtensionInfo

@synthesize descriptor;
@synthesize defaultInstance;

- (void) dealloc {
    self.descriptor = nil;
    self.defaultInstance = nil;

    [super dealloc];
}


- (id) initWithDescriptor:(PBFieldDescriptor*) descriptor_
          defaultInstance:(id<PBMessage>) defaultInstance_ {
    if (self = [super init]) {
        self.descriptor = descriptor_;
        self.defaultInstance = defaultInstance_;
    }

    return self;
}


+ (PBExtensionInfo*) infoWithDescriptor:(PBFieldDescriptor*) descriptor {
    return [PBExtensionInfo infoWithDescriptor:descriptor defaultInstance:nil];
}


+ (PBExtensionInfo*) infoWithDescriptor:(PBFieldDescriptor*) descriptor
                        defaultInstance:(id<PBMessage>) defaultInstance {
    return [[[PBExtensionInfo alloc] initWithDescriptor:descriptor defaultInstance:defaultInstance] autorelease];
}

@end