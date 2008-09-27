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

#import "FieldDescriptorType.h"

@interface CodedOutputStream : NSObject {
    NSMutableData* buffer;
    int32_t position;
    NSOutputStream* output;
}

@property (retain) NSMutableData* buffer;
@property int32_t position;
@property (retain) NSOutputStream* output;

+ (CodedOutputStream*) newInstance:(NSOutputStream*) output;

int32_t encodeZigZag32(int32_t n);
int64_t encodeZigZag64(int64_t n);

int32_t computeDoubleSize(int32_t fieldNumber, Float64 value);
int32_t computeFloatSize(int32_t fieldNumber, Float32 value);
int32_t computeUInt64Size(int32_t fieldNumber, int64_t value);
int32_t computeInt64Size(int32_t fieldNumber, int64_t value);
int32_t computeInt32Size(int32_t fieldNumber, int32_t value);
int32_t computeFixed64Size(int32_t fieldNumber, int64_t value);
int32_t computeFixed32Size(int32_t fieldNumber, int32_t value);
int32_t computeBoolSize(int32_t fieldNumber, BOOL value);
int32_t computeStringSize(int32_t fieldNumber, NSString* value);
int32_t computeGroupSize(int32_t fieldNumber, id<Message> value);
int32_t computeUnknownGroupSize(int32_t fieldNumber, UnknownFieldSet* value);
int32_t computeMessageSize(int32_t fieldNumber, id<Message> value);
int32_t computeBytesSize(int32_t fieldNumber, NSData* value);
int32_t computeUInt32Size(int32_t fieldNumber, int32_t value);
int32_t computeEnumSize(int32_t fieldNumber, int32_t value);
int32_t computeSFixed32Size(int32_t fieldNumber, int32_t value);
int32_t computeSFixed64Size(int32_t fieldNumber, int64_t value);
int32_t computeSInt32Size(int32_t fieldNumber, int32_t value);
int32_t computeSInt64Size(int32_t fieldNumber, int64_t value);
int32_t computeMessageSetExtensionSize(int32_t fieldNumber, id<Message> value);
int32_t computeRawMessageSetExtensionSize(int32_t fieldNumber, NSData* value);
int32_t computeFieldSize(FieldDescriptorType type, int32_t number, id value);
int32_t computeTagSize(int32_t fieldNumber);
int32_t computeRawVarint32Size(int32_t value);
int32_t computeRawVarint64Size(int64_t value);


- (void) flush;

- (void) writeRawByte:(uint8_t) value;

- (void) writeTag:(int32_t) fieldNumber format:(int32_t) format;

- (void) writeRawLittleEndian32:(int32_t) value;
- (void) writeRawLittleEndian64:(int64_t) value;

- (void) writeRawVarint32:(int32_t) value;
- (void) writeRawVarint64:(int64_t) value;

- (void) writeRawLittleEndian32:(int32_t) value;
- (void) writeRawLittleEndian64:(int64_t) value;

- (void) writeRawData:(NSData*) data;
- (void) writeRawData:(NSData*) data offset:(int32_t) offset length:(int32_t) length;

- (void) writeData:(int32_t) fieldNumber value:(NSData*) value;


- (void) writeUInt64:(int32_t) fieldNumber value:(int64_t) value;
- (void) writeInt64:(int32_t) fieldNumber value:(int64_t) value;
- (void) writeInt32:(int32_t) fieldNumber value:(int32_t) value;
- (void) writeFixed64:(int32_t) fieldNumber value:(int64_t) value;
- (void) writeFixed32:(int32_t) fieldNumber value:(int32_t) value;
- (void) writeBool:(int32_t) fieldNumber value:(BOOL) value;
- (void) writeString:(int32_t) fieldNumber value:(NSString*) value;
- (void) writeGroup:(int32_t) fieldNumber value:(id<Message>) value;
- (void) writeUnknownGroup:(int32_t) fieldNumber value:(UnknownFieldSet*) value;
- (void) writeMessage:(int32_t) fieldNumber value:(id<Message>) value;
- (void) writeUInt32:(int32_t) fieldNumber value:(int32_t) value;
- (void) writeEnum:(int32_t) fieldNumber value:(int32_t) value;
- (void) writeSFixed32:(int32_t) fieldNumber value:(int32_t) value;
- (void) writeSFixed64:(int32_t) fieldNumber value:(int64_t) value;
- (void) writeSInt32:(int32_t) fieldNumber value:(int32_t) value;
- (void) writeSInt64:(int32_t) fieldNumber value:(int64_t) value;
- (void) writeMessageSetExtension:(int32_t) fieldNumber value:(id<Message>) value;
- (void) writeRawMessageSetExtension:(int32_t) fieldNumber value:(NSData*) value;

@end
