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

#import "MutableField.h"

#import "Field.h"

@interface PBField ()
@property (retain) NSArray* varint;
@property (retain) NSArray* fixed32;
@property (retain) NSArray* fixed64;
@property (retain) NSArray* lengthDelimited;
@property (retain) NSArray* group;
@end

@implementation PBMutableField

@synthesize mutableVarint;
@synthesize mutableFixed32;
@synthesize mutableFixed64;
@synthesize mutableLengthDelimited;
@synthesize mutableGroup;

- (void) dealloc {
    self.mutableVarint = nil;
    self.mutableFixed32 = nil;
    self.mutableFixed64 = nil;
    self.mutableLengthDelimited = nil;
    self.mutableGroup = nil;

    [super dealloc];
}


+ (PBMutableField*) field {
    return [[[PBMutableField alloc] init] autorelease];
}


- (id) init {
    if (self = [super init]) {
    }

    return self;
}


- (void) setMutableVarint:(NSMutableArray*) array {
    self.mutableVarint = array;
    self.varint = array;
}


- (void) setMutableFixed32:(NSMutableArray*) array {
    self.mutableFixed32 = array;
    self.fixed32 = array;
}


- (void) setMutableFixed64:(NSMutableArray*) array {
    self.mutableFixed64 = array;
    self.fixed64 = array;
}


- (void) setMutableLengthDelimited:(NSMutableArray*) array {
    self.mutableLengthDelimited = array;
    self.lengthDelimited = array;
}


- (void) setMutableGroup:(NSMutableArray*) array {
    self.mutableGroup = array;
    self.group = array;
}


- (PBMutableField*) clear {
    self.mutableVarint = nil;
    self.mutableFixed32 = nil;
    self.mutableFixed64 = nil;
    self.mutableLengthDelimited = nil;
    self.mutableGroup = nil;
    return self;
}


- (PBMutableField*) mergeFromField:(PBField*) other {
    if (other.varint.count > 0) {
        if (mutableVarint == nil) {
            self.mutableVarint = [NSMutableArray array];
        }
        [mutableVarint addObjectsFromArray:other.varint];
    }

    if (other.fixed32.count > 0) {
        if (mutableFixed32 == nil) {
            self.mutableFixed32 = [NSMutableArray array];
        }
        [mutableFixed32 addObjectsFromArray:other.fixed32];
    }

    if (other.fixed64.count > 0) {
        if (mutableFixed64 == nil) {
            self.mutableFixed64 = [NSMutableArray array];
        }
        [mutableFixed64 addObjectsFromArray:other.fixed64];
    }

    if (other.lengthDelimited.count > 0) {
        if (mutableLengthDelimited == nil) {
            self.mutableLengthDelimited = [NSMutableArray array];
        }
        [mutableLengthDelimited addObjectsFromArray:other.lengthDelimited];
    }

    if (other.group.count > 0) {
        if (mutableGroup == nil) {
            self.mutableGroup = [NSMutableArray array];
        }
        [mutableGroup addObjectsFromArray:other.group];
    }

    return self;
}


- (PBMutableField*) addVarint:(int64_t) value {
    if (mutableVarint == nil) {
        self.mutableVarint = [NSMutableArray array];
    }
    [mutableVarint addObject:[NSNumber numberWithLongLong:value]];
    return self;
}


- (PBMutableField*) addFixed32:(int32_t) value {
    if (mutableFixed32 == nil) {
        self.mutableFixed32 = [NSMutableArray array];
    }
    [mutableFixed32 addObject:[NSNumber numberWithInt:value]];
    return self;
}


- (PBMutableField*) addFixed64:(int64_t) value {
    if (mutableFixed64 == nil) {
        self.mutableFixed64 = [NSMutableArray array];
    }
    [mutableFixed64 addObject:[NSNumber numberWithLongLong:value]];
    return self;
}


- (PBMutableField*) addLengthDelimited:(NSData*) value {
    if (mutableLengthDelimited == nil) {
        self.mutableLengthDelimited = [NSMutableArray array];
    }
    [mutableLengthDelimited addObject:value];
    return self;
}


- (PBMutableField*) addGroup:(PBUnknownFieldSet*) value {
    if (mutableGroup == nil) {
        self.mutableGroup = [NSMutableArray array];
    }
    [mutableGroup addObject:value];
    return self;
}

@end
