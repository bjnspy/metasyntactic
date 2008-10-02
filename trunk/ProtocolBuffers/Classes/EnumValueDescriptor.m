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

#import "EnumValueDescriptor.h"

@interface PBEnumValueDescriptor ()
@property (assign) PBFileDescriptor* file;
@property (assign) PBEnumDescriptor* type;

@property int32_t index;
@property (copy) NSString* fullName;
@end


@implementation PBEnumValueDescriptor

@synthesize index;
@synthesize fullName;
@synthesize file;
@synthesize type;

- (void) dealloc {
    self.index = 0;
    self.fullName = nil;
    self.file = nil;
    self.type = nil;

    [super dealloc];
}


- (int32_t) number {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBEnumDescriptor*) type {
    return type;
}


@end
