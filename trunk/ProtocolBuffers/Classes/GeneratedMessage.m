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

#import "GeneratedMessage.h"

#import "FieldAccessor.h"
#import "FieldAccessorTable.h"
#import "FieldDescriptor.h"
#import "UnknownFieldSet.h"

@interface PBGeneratedMessage ()
@property (retain) PBUnknownFieldSet* unknownFields;
@end


@implementation PBGeneratedMessage

@synthesize unknownFields;

- (void) dealloc {
    self.unknownFields = nil;
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.unknownFields = [PBUnknownFieldSet defaultInstance];
        memoizedSerializedSize = -1;
    }

    return self;
}


- (PBFieldAccessorTable*) fieldAccessorTable {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NSMutableDictionary*) allFieldsMutable {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];

    PBDescriptor* descriptor = [self fieldAccessorTable].descriptor;
    for (PBFieldDescriptor* field in descriptor.fields) {
        if (field.isRepeated) {
            id value = [self getField:field];
            if ([value count] > 0) {
                [result setObject:value forKey:field];
            }
        } else {
            if ([self hasField:field]) {
                id value = [self getField:field];
                if (value != nil) {
                    [result setObject:value forKey:field];
                }
            }
        }
    }
    return result;
}


- (NSDictionary*) allFields {
    return [self allFieldsMutable];
}


- (BOOL) hasField:(PBFieldDescriptor*) field {
    return [[self.fieldAccessorTable getField:field] has:self];
}


- (id) getField:(PBFieldDescriptor*) field {
    return [[self.fieldAccessorTable getField:field] get:self];
}


- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field {
    return [[self.fieldAccessorTable getField:field] getRepeated:self];
}

@end