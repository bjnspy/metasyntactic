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

@interface Field : NSObject {
    NSMutableArray* varint;
    NSMutableArray* fixed32;
    NSMutableArray* fixed64;
    NSMutableArray* lengthDelimited;
    NSMutableArray* group;
}

@property (retain) NSMutableArray* varint;
@property (retain) NSMutableArray* fixed32;
@property (retain) NSMutableArray* fixed64;
@property (retain) NSMutableArray* lengthDelimited;
@property (retain) NSMutableArray* group;

+ (Field*) getDefaultInstance;
+ (Field_Builder*) newBuilder;

- (void) writeTo:(int32_t) fieldNumber
          output:(CodedOutputStream*) output;

@end
