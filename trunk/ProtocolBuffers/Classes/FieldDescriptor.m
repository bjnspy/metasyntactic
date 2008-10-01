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

#import "FieldDescriptor.h"


@implementation PBFieldDescriptor

- (BOOL) isRequired {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isRepeated {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isExtension {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isOptional {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBObjectiveCType) getObjectiveCType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBDescriptor*) getContainingType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBDescriptor*) getExtensionScope {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBDescriptor*) getMessageType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBEnumDescriptor*) getEnumType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (id) getDefaultValue {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (int32_t) getIndex {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (int32_t) getNumber {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (FieldDescriptorType) getType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (NSString*) getFullName {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

@end
