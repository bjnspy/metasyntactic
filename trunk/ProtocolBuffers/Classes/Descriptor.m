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

#import "Descriptor.h"


@interface PBDescriptor ()
@property (retain) NSArray* nestedTypes;
@end


@implementation PBDescriptor

@synthesize nestedTypes;

- (void) dealloc {
    self.nestedTypes = nil;
    [super dealloc];
}


+ (PBDescriptor*) descriptorWithProto:(PBDescriptorProto*) proto
                                 file:(PBFileDescriptor*) file
                               parent:(PBDescriptor*) parent
                                index:(int32_t) index {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (NSArray*) fields {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBMessageOptions*) options {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (NSString*) fullName {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (NSArray*) enumTypes {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (NSArray*) extensions {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (BOOL) isExtensionNumber:(int32_t) number {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBFieldDescriptor*) findFieldByNumber:(int32_t) number {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBFieldDescriptor*) findFieldByName:(NSString*) name {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}

@end
