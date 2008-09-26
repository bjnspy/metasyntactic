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

@interface UnknownFieldSet_Field_Builder : NSObject {
}
#if 0
    UnknownFieldSet_Field* result;
}

@property (retain) UnknownFieldSet_Field* result;

- (UnknownFieldSet_Field*) build;
- (UnknownFieldSet_Field_Builder*) clear;
- (UnknownFieldSet_Field_Builder*) mergeFrom:(UnknownFieldSet_Field*) other;
- (UnknownFieldSet_Field_Builder*) addVarint:(int64_t) value;
- (UnknownFieldSet_Field_Builder*) addFixed32:(int32_t) value;
- (UnknownFieldSet_Field_Builder*) addFixed64:(int64_t) value;
- (UnknownFieldSet_Field_Builder*) addData:(NSData*) data;
- (UnknownFieldSet_Field_Builder*) addGroup:(UnknownFieldSet*) value;
#endif

@end
