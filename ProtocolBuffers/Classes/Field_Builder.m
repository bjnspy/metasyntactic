// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Field_Builder.h"

#import "Field.h"

@implementation Field_Builder

@synthesize result;

- (void) dealloc {
    self.result = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.result = [[[Field alloc] init] autorelease];
    }
    
    return self;
}


- (Field*) build {
    if (result.varint == nil) {
        result.varint = [NSMutableArray array];
    }
    if (result.fixed32 == nil) {
        result.fixed32 = [NSMutableArray array];
    }
    if (result.fixed64 == nil) {
        result.fixed64 = [NSMutableArray array];
    }
    if (result.lengthDelimited == nil) {
        result.lengthDelimited = [NSMutableArray array];
    }
    if (result.group == nil) {
        result.group = [NSMutableArray array];
    }
    
    Field* temp = [[result retain] autorelease];
    self.result = nil;
    return temp;
}


- (Field_Builder*) clear {
    self.result = [[[Field alloc] init] autorelease];
    return self;
}


- (Field_Builder*) mergeFrom:(Field*) other {
    if (other.varint.count > 0) {
        if (result.varint == nil) {
            result.varint = [NSMutableArray array];
        }
        [result.varint addObjectsFromArray:other.varint];
    }
    
    if (other.fixed32.count > 0) {
        if (result.fixed32 == nil) {
            result.fixed32 = [NSMutableArray array];
        }
        [result.fixed32 addObjectsFromArray:other.fixed32];
    }
    
    if (other.fixed64.count > 0) {
        if (result.fixed64 == nil) {
            result.fixed64 = [NSMutableArray array];
        }
        [result.fixed64 addObjectsFromArray:other.fixed64];
    }
    
    if (other.lengthDelimited.count > 0) {
        if (result.lengthDelimited == nil) {
            result.lengthDelimited = [NSMutableArray array];
        }
        [result.lengthDelimited addObjectsFromArray:other.lengthDelimited];
    }
    
    if (other.group.count > 0) {
        if (result.group == nil) {
            result.group = [NSMutableArray array];
        }
        [result.group addObjectsFromArray:other.group];
    }
    
    return self;
}


- (Field_Builder*) addVarint:(int64_t) value {
    if (result.varint == nil) {
        result.varint = [NSMutableArray array];
    }
    [result.varint addObject:[NSNumber numberWithLongLong:value]];
    return self;
}


- (Field_Builder*) addFixed32:(int32_t) value {
    if (result.fixed32 == nil) {
        result.fixed32 = [NSMutableArray array];
    }
    [result.fixed32 addObject:[NSNumber numberWithInt:value]];
    return self;
}


- (Field_Builder*) addFixed64:(int64_t) value {
    if (result.fixed64 == nil) {
        result.fixed64 = [NSMutableArray array];
    }
    [result.fixed64 addObject:[NSNumber numberWithLongLong:value]];
    return self;
}


- (Field_Builder*) addLengthDelimited:(NSData*) value {
    if (result.lengthDelimited == nil) {
        result.lengthDelimited = [NSMutableArray array];
    }
    [result.lengthDelimited addObject:value];
    return self;
}


- (Field_Builder*) addGroup:(UnknownFieldSet*) value {
    if (result.group == nil) {
        result.group = [NSMutableArray array];
    }
    [result.group addObject:value];
    return self;
}

@end
