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

const int32_t WIRETYPE_VARINT = 0;
const int32_t WIRETYPE_FIXED64 = 1;
const int32_t WIRETYPE_LENGTH_DELIMITED = 2;
const int32_t WIRETYPE_START_GROUP = 3;
const int32_t WIRETYPE_END_GROUP = 4;
const int32_t WIRETYPE_FIXED32 = 5;

const int32_t TAG_TYPE_BITS = 3;
const int32_t TAG_TYPE_MASK = 7 /* = (1 << TAG_TYPE_BITS) - 1*/;

@interface WireFormat : NSObject {
}

@end