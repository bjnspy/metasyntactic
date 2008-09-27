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

#import "Field.h"

#import "CodedOutputStream.h"
#import "Field_Builder.h"

@implementation Field

static Field* defaultInstance = nil;

+ (void) initialize {
    if (self == [Field class]) {
        defaultInstance = [[Field newBuilder] build];
    }
}


@synthesize varint;
@synthesize fixed32;
@synthesize fixed64;
@synthesize lengthDelimited;
@synthesize group;


- (void) dealloc {
    self.varint = nil;
    self.fixed32 = nil;
    self.fixed64 = nil;
    self.lengthDelimited = nil;
    self.group = nil;
    
    [super dealloc];
}


+ (Field_Builder*) newBuilder { 
    return [[[Field_Builder alloc] init] autorelease];
}


+ (Field_Builder*) newBuilder:(Field*) copyFrom {
    return [[Field newBuilder] mergeFrom:copyFrom];
}


+ (Field*) getDefaultInstance {
    return defaultInstance;
}

    
- (void) writeTo:(int32_t) fieldNumber
          output:(CodedOutputStream*) output {
    for (NSNumber* value in varint) {
        [output writeUInt64:fieldNumber value:value.longLongValue];
    }
    for (NSNumber* value in fixed32) {
        [output writeFixed32:fieldNumber value:value.intValue];
    }
    for (NSNumber* value in fixed64) {
        [output writeFixed64:fieldNumber value:value.longLongValue];
    }
    for (NSData* value in lengthDelimited) {
        [output writeData:fieldNumber value:value];
    }
    for (UnknownFieldSet* value in group) {
        [output writeUnknownGroup:fieldNumber value:value];
    }
}


- (int32_t) getSerializedSize:(int32_t) fieldNumber {
    int32_t result = 0;
    for (NSNumber* value in varint) {
        result += computeUInt64Size(fieldNumber, value.longLongValue);
    }
    for (NSNumber* value in fixed32) {
        result += computeFixed32Size(fieldNumber, value.intValue);
    }
    for (NSNumber* value in fixed64) {
        result += computeFixed64Size(fieldNumber, value.longLongValue);
    }
    for (NSData* value in lengthDelimited) {
        result += computeBytesSize(fieldNumber, value);
    }
    for (UnknownFieldSet* value in group) {
        result += computeUnknownGroupSize(fieldNumber, value);
    }
    return result; 
}


- (void) writeAsMessageSetExtensionTo:(int32_t) fieldNumber
                               output:(CodedOutputStream*) output {
    for (NSData* value in lengthDelimited) {
        [output writeRawMessageSetExtension:fieldNumber value:value];
    }
}


- (int32_t) getSerializedSizeAsMessageSetExtension:(int32_t) fieldNumber {
    int32_t result = 0;
    for (NSData* value in lengthDelimited) {
        result += computeRawMessageSetExtensionSize(fieldNumber, value);
    }
    return result;
}
    

@end
