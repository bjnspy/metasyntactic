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

#import "GeneratedMessage.h"

#import "FieldDescriptor.h"
#import "UnknownFieldSet.h"

@implementation PBGeneratedMessage

@synthesize unknownFields;

- (void) dealloc {
    self.unknownFields = nil;
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.unknownFields = [PBUnknownFieldSet defaultInstance];
    }

    return self;
}


- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (PBUnknownFieldSet*) getUnknownFields {
    return unknownFields;
}


- (NSMutableDictionary*) getAllFieldsMutable {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    
    PBDescriptor* descriptor = [self internalGetFieldAccessorTable].descriptor;
    for (PBFieldDescriptor* field in descriptor.getFields) {
        if (field.isRepeated) {
            id value = [self getField:field];
            if ([value count] > 0) {
                [result setObject:value forKey:field];
            }
        } else {
            if ([self hasField:field]) {
                [result setObject:[self getField:field] forKey:field];
            }
        }
    }
    return result;
}


- (NSDictionary*) getAllFields {
    return [self getAllFieldsMutable];
}

@end
