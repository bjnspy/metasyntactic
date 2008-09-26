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


@interface UnknownFieldSet_Field : NSObject {
}
#if 0
    NSArray* varint;
    NSArray* fixed32;
    NSArray* fixed64;
    NSArray* lengthDelimited;
    NSArray* group;
}

@property (retain) NSArray* varint;
@property (retain) NSArray* fixed32;
@property (retain) NSArray* fixed64;
@property (retain) NSArray* lengthDelimited;
@property (retain) NSArray* group;


+ (UnknownFieldSet_Builder*) builder;
+ (UnknownFieldSet_Builder*) builderFromField:(UnknownFieldSet_Field*) copyFrom;
+ (UnknownFieldSet_Field*) defaultInstance;

- (NSArray*) varintList;
- (NSArray*) fixed32List;
- (NSArray*) fixed64List;
- (NSArray*) lengthDelimitedList;
- (NSArray*) groupList;

- (void) writeTo:(int32_t) fieldNumber ouput:(CodedOutputStream*) output;
- (int32_t) serializedSize:(int32_t) fieldNumber;

- (void) writeAsMessageSetExtensionTo:(int32_t) fieldNumber output:(CodedOutputStream*) output;
- (int32_t) serializedSizeAsMessageSetExtension:(int32_t) fieldNumber;
#endif


@end
