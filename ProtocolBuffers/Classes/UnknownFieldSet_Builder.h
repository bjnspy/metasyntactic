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

@interface UnknownFieldSet_Builder : NSObject {
    NSMutableDictionary* fields;
    
    // Optimization:  We keep around a builder for the last field that was
    //   modified so that we can efficiently add to it multiple times in a
    //   row (important when parsing an unknown repeated field).
    int32_t lastFieldNumber;
    
    Field_Builder* lastField;
}

@property (retain) NSMutableDictionary* fields;
@property int32_t lastFieldNumber;
@property (retain) Field_Builder* lastField;

+ (UnknownFieldSet_Builder*) newBuilder;

- (UnknownFieldSet*) build;
- (UnknownFieldSet_Builder*) mergeFrom:(UnknownFieldSet*) other;

- (UnknownFieldSet_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input;
- (UnknownFieldSet_Builder*) mergeFromData:(NSData*) data;
- (UnknownFieldSet_Builder*) mergeFromInputStream:(NSInputStream*) input;

#if 0
    int32_t lastFieldNumbers;
    UnknownFieldSet_Field_Builder* lastField;
}

@property (retain) NSDictionary* fields;

- (UnknownFieldSet_Builder*) clear;
- (UnknownFieldSet_Builder*) mergeFrom:(UnknownFieldSet*) other;
- (UnknownFieldSet_Builder*) mergeField:(int32_t) number field:(UnknownFieldSet_Field*) field;
- (UnknownFieldSet_Builder*) mergeVariantField:(int32_t) number value:(int32_t) value;
- (BOOL) hasField:(int32_t) number;
- (UnknownFieldSet_Builder*) addField:(int32_t) number field:(UnknownFieldSet_Field*) field;
- (NSDictionary*) dictionary;
- (BOOL) mergeFieldFrom:(int32_t) tag input:(CodedInputStream*) input;
#endif


@end
