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

#import "CodedOutputStream.h"

#import "EnumValueDescriptor.h"
#import "FieldDescriptorType.h"
#import "Message.h"
#import "WireFormat.h"

@implementation CodedOutputStream

const int DEFAULT_BUFFER_SIZE = 4096;
const int LITTLE_ENDIAN_32_SIZE = 4;
const int LITTLE_ENDIAN_64_SIZE = 8;

@synthesize output;
@synthesize buffer;
@synthesize position;


- (void) dealloc {
    self.output = nil;
    self.buffer = nil;
    self.position = 0;

    [super dealloc];
}


- (id) initWithOutputStream:(NSOutputStream*) output_
                       data:(NSMutableData*) data_ {
    if (self = [super init]) {
        self.output = output_;
        self.buffer = data_;
        self.position = 0;
    }
    
    return self;
}


+ (CodedOutputStream*) newInstance:(NSOutputStream*) output
                        bufferSize:(int32_t) bufferSize {
    NSMutableData* data = [NSMutableData dataWithLength:bufferSize];
    return [[[CodedOutputStream alloc] initWithOutputStream:output
                                                       data:data] autorelease];
}


+ (CodedOutputStream*) newInstance:(NSOutputStream*) output {    
    return [CodedOutputStream newInstance:output bufferSize:DEFAULT_BUFFER_SIZE];
}


- (void) writeDouble:(int32_t) fieldNumber
               value:(Float64) value {
    [self writeTag:fieldNumber format:WireFormatFixed64];
    [self writeRawLittleEndian64:*(int64_t*)&value];
}


- (void) writeFloat:(int32_t) fieldNumber
              value:(Float32) value {
    [self writeTag:fieldNumber format:WireFormatFixed32];
    [self writeRawLittleEndian32:*(int32_t*)&value];
}


- (void) writeUInt64:(int32_t) fieldNumber
               value:(int64_t) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    [self writeRawVarint64:value];  
}


- (void) writeInt64:(int32_t) fieldNumber
               value:(int64_t) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    [self writeRawVarint64:value];  
}


- (void) writeInt32:(int32_t) fieldNumber
              value:(int32_t) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    if (value >= 0) {
        [self writeRawVarint32:value];
    } else {
        // Must sign-extend
        [self writeRawVarint64:value];
    }
}


- (void) writeFixed64:(int32_t) fieldNumber
                value:(int64_t) value {
    [self writeTag:fieldNumber format:WireFormatFixed64];
    [self writeRawLittleEndian64:value];
}


- (void) writeFixed32:(int32_t) fieldNumber
                value:(int32_t) value {
    [self writeTag:fieldNumber format:WireFormatFixed32];
    [self writeRawLittleEndian32:value];
}


- (void) writeBool:(int32_t) fieldNumber
             value:(BOOL) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    [self writeRawByte:(value ? 1 : 0)];
}


- (void) writeString:(int32_t) fieldNumber
               value:(NSString*) value {
    [self writeTag:fieldNumber format:WireFormatLengthDelimited];
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    [self writeRawVarint32:data.length];
    [self writeRawData:data];
}


- (void) writeGroup:(int32_t) fieldNumber
              value:(id<Message>) value {
    [self writeTag:fieldNumber format:WireFormatStartGroup];
    [value writeToCodedOutputStream:self];
    [self writeTag:fieldNumber format:WireFormatEndGroup];
}


- (void) writeUnknownGroup:(int32_t) fieldNumber
                     value:(UnknownFieldSet*) value {
    [self writeTag:fieldNumber format:WireFormatStartGroup];
    [value writeToCodedOutputStream:self];
    [self writeTag:fieldNumber format:WireFormatEndGroup];
}


- (void) writeMessage:(int32_t) fieldNumber
                value:(id<Message>) value {
    [self writeTag:fieldNumber format:WireFormatLengthDelimited];
    [self writeRawVarint32:[value getSerializedSize]];
    [value writeToCodedOutputStream:self];
}


- (void) writeData:(int32_t) fieldNumber value:(NSData*) value {
    [self writeTag:fieldNumber format:WireFormatLengthDelimited];
    [self writeRawVarint32:value.length];
    [self writeRawData:value];
}


- (void) writeUInt32:(int32_t) fieldNumber
               value:(int32_t) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    [self writeRawVarint32:value];
}


- (void) writeEnum:(int32_t) fieldNumber
             value:(int32_t) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    [self writeRawVarint32:value];
}


- (void) writeSFixed32:(int32_t) fieldNumber
                 value:(int32_t) value {
    [self writeTag:fieldNumber format:WireFormatFixed32];
    [self writeRawLittleEndian32:value];
}


- (void) writeSFixed64:(int32_t) fieldNumber
                 value:(int64_t) value {
    [self writeTag:fieldNumber format:WireFormatFixed64];
    [self writeRawLittleEndian64:value];
}


- (void) writeSInt32:(int32_t) fieldNumber
               value:(int32_t) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    [self writeRawVarint32:encodeZigZag32(value)];
}


- (void) writeSInt64:(int32_t) fieldNumber
               value:(int64_t) value {
    [self writeTag:fieldNumber format:WireFormatVarint];
    [self writeRawVarint64:encodeZigZag64(value)];
}


- (void) writeMessageSetExtension:(int32_t) fieldNumber
                            value:(id<Message>) value {
    [self writeTag:WireFormatMessageSetItem format:WireFormatStartGroup];
    [self writeUInt32:WireFormatMessageSetTypeId value:fieldNumber];
    [self writeMessage:WireFormatMessageSetMessage value:value];
    [self writeTag:WireFormatMessageSetItem format:WireFormatEndGroup];
}


- (void) writeRawMessageSetExtension:(int32_t) fieldNumber
                            value:(NSData*) value {
    [self writeTag:WireFormatMessageSetItem format:WireFormatStartGroup];
    [self writeUInt32:WireFormatMessageSetTypeId value:fieldNumber];
    [self writeData:WireFormatMessageSetMessage value:value];
    [self writeTag:WireFormatMessageSetItem format:WireFormatEndGroup];
}


- (void) writeField:(FieldDescriptorType) type
             number:(int32_t) number
              value:(id) value {
    switch (type) {
        case FieldDescriptorTypeDouble:   [self writeDouble:number value:[value doubleValue]]; break;
        case FieldDescriptorTypeFloat:    [self writeFloat:number value:[value floatValue]]; break;
        case FieldDescriptorTypeInt64:    [self writeInt64:number value:[value longLongValue]]; break;
        case FieldDescriptorTypeUInt64:   [self writeUInt64:number value:[value longLongValue]]; break;
        case FieldDescriptorTypeInt32:    [self writeInt32:number value:[value intValue]]; break;
        case FieldDescriptorTypeFixed64:  [self writeFixed64:number value:[value longLongValue]]; break;
        case FieldDescriptorTypeFixed32:  [self writeFixed32:number value:[value intValue]]; break;
        case FieldDescriptorTypeBool:     [self writeBool:number value:[value boolValue]]; break;
        case FieldDescriptorTypeString:   [self writeString:number value:value]; break;
        case FieldDescriptorTypeGroup:    [self writeGroup:number value:value]; break;
        case FieldDescriptorTypeMessage:  [self writeGroup:number value:value]; break;
        case FieldDescriptorTypeData:     [self writeData:number value:value]; break;
        case FieldDescriptorTypeUInt32:   [self writeUInt32:number value:[value intValue]]; break;
        case FieldDescriptorTypeSFixed32: [self writeSFixed32:number value:[value intValue]]; break;
        case FieldDescriptorTypeSFixed64: [self writeSFixed64:number value:[value longLongValue]]; break;
        case FieldDescriptorTypeSInt32:   [self writeSInt32:number value:[value intValue]]; break;
        case FieldDescriptorTypeSInt64:   [self writeSInt64:number value:[value longLongValue]]; break;
        case FieldDescriptorTypeEnum:     [self writeEnum:number value:[value getNumber]]; break;
        default:
            @throw [NSException exceptionWithName:@"InvalidArgument" reason:@"" userInfo:nil];
    }
}


int32_t computeDoubleSize(int32_t fieldNumber, Float64 value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_64_SIZE;
}


int32_t computeFloatSize(int32_t fieldNumber, Float32 value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_32_SIZE;
}


int32_t computeUInt64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint64Size(value);
}


int32_t computeInt64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint64Size(value);
}


int32_t computeInt32Size(int32_t fieldNumber, int32_t value) {
    if (value >= 0) {
        return computeTagSize(fieldNumber) + computeRawVarint32Size(value);
    } else {
        // Must sign-extend.
        return computeTagSize(fieldNumber) + 10;
    }
}


int32_t computeFixed64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_64_SIZE;
}


int32_t computeFixed32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_32_SIZE;
}


int32_t computeBoolSize(int32_t fieldNumber, BOOL value) {
    return computeTagSize(fieldNumber) + 1;
}


int32_t computeStringSize(int32_t fieldNumber, NSString* value) {
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    return computeTagSize(fieldNumber) + computeRawVarint32Size(data.length) + data.length;
}


int32_t computeGroupSize(int32_t fieldNumber, id<Message> value) {
    return computeTagSize(fieldNumber) * 2 + [value getSerializedSize];
}


int32_t computeUnknownGroupSize(int32_t fieldNumber,
                                UnknownFieldSet* value) {
    return computeTagSize(fieldNumber) * 2 + [value getSerializedSize];
}


int32_t computeMessageSize(int32_t fieldNumber, id<Message> value) {
    int32_t size = [value getSerializedSize];
    return computeTagSize(fieldNumber) + computeRawVarint32Size(size) + size;
}


int32_t computeBytesSize(int32_t fieldNumber, NSData* value) {
    return computeTagSize(fieldNumber) +
    computeRawVarint32Size(value.length) +
    value.length;
}


int32_t computeUInt32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint32Size(value);
}


int32_t computeEnumSize(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint32Size(value);
}


int32_t computeSFixed32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_32_SIZE;
}


int32_t computeSFixed64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_64_SIZE;
}


int32_t computeSInt32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) +
    computeRawVarint32Size(encodeZigZag32(value));
}


int32_t computeSInt64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) +
    computeRawVarint64Size(encodeZigZag64(value));
}


int32_t computeMessageSetExtensionSize(int32_t fieldNumber, id<Message> value) {
    return computeTagSize(WireFormatMessageSetItem) * 2 +
    computeUInt32Size(WireFormatMessageSetTypeId, fieldNumber) +
    computeMessageSize(WireFormatMessageSetMessage, value);
}


int32_t computeRawMessageSetExtensionSize(int32_t fieldNumber, NSData* value) {
    return computeTagSize(WireFormatMessageSetItem) * 2 +
    computeUInt32Size(WireFormatMessageSetTypeId, fieldNumber) +
    computeBytesSize(WireFormatMessageSetMessage, value);
}


int32_t computeFieldSize(FieldDescriptorType type,
                         int32_t number,
                         id value) {
    switch (type) {
        case FieldDescriptorTypeDouble  : return computeDoubleSize  (number, [value doubleValue]);
        case FieldDescriptorTypeFloat   : return computeFloatSize   (number, [value floatValue]);
        case FieldDescriptorTypeInt64   : return computeInt64Size   (number, [value longLongValue]);
        case FieldDescriptorTypeUInt64  : return computeUInt64Size  (number, [value longLongValue]);
        case FieldDescriptorTypeInt32   : return computeInt32Size   (number, [value intValue]);
        case FieldDescriptorTypeFixed64 : return computeFixed64Size (number, [value longLongValue]);
        case FieldDescriptorTypeFixed32 : return computeFixed32Size (number, [value intValue]);
        case FieldDescriptorTypeBool    : return computeBoolSize    (number, [value boolValue]);
        case FieldDescriptorTypeString  : return computeStringSize  (number, value);
        case FieldDescriptorTypeGroup   : return computeGroupSize   (number, value);
        case FieldDescriptorTypeMessage : return computeMessageSize (number, value);
        case FieldDescriptorTypeData    : return computeBytesSize   (number, value);
        case FieldDescriptorTypeUInt32  : return computeUInt32Size  (number, [value intValue]);
        case FieldDescriptorTypeSFixed32: return computeSFixed32Size(number, [value intValue]);
        case FieldDescriptorTypeSFixed64: return computeSFixed64Size(number, [value longLongValue]);
        case FieldDescriptorTypeSInt32  : return computeSInt32Size  (number, [value intValue]);
        case FieldDescriptorTypeSInt64  : return computeSInt64Size  (number, [value longLongValue]);
        case FieldDescriptorTypeEnum:     return computeEnumSize    (number, [value getNumber]);
    }
    
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (void) refreshBuffer {
    if (output == nil) {
        @throw [NSException exceptionWithName:@"OutOfSpace" reason:@"" userInfo:nil];
    }
    
    
    [output write:buffer.bytes maxLength:position];
    position = 0;
}


- (void) flush {
    if (output != nil) {
        [self refreshBuffer];
    }
}


- (int32_t) spaceLeft {
    if (output == nil) {
        return buffer.length - position;
    } else {
        @throw [NSException exceptionWithName:@"UnsupportedOperation" reason:@"" userInfo:nil];
    }
}


- (void) checkNoSpaceLeft {
    if ([self spaceLeft] != 0) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"" userInfo:nil];
    }
}


- (void) writeRawByte:(uint8_t) value {
    if (position == buffer.length) {
        [self refreshBuffer];
    }
    
    ((uint8_t*)buffer.mutableBytes)[position++] = value;
}


- (void) writeRawData:(NSData*) data {
    [self writeRawData:data offset:0 length:data.length];
}


- (void) writeRawData:(NSData*) data offset:(int32_t) offset length:(int32_t) length {
    if (buffer.length - position >= length) {
        // We have room in the current buffer.
        memcpy(((uint8_t*)buffer.mutableBytes) + position, ((uint8_t*)data.bytes) + offset, length);
        position += length;
    } else {
        // Write extends past current buffer.  Fill the rest of this buffer and flush.
        int32_t bytesWritten = buffer.length - position;
        memcpy(((uint8_t*)buffer.mutableBytes) + position, ((uint8_t*)data.bytes) + offset, bytesWritten);
        offset += bytesWritten;
        length -= bytesWritten;
        position = buffer.length;
        [self refreshBuffer];
        
        // Now deal with the rest.
        // Since we have an output stream, this is our buffer
        // and buffer offset == 0
        if (length <= buffer.length) {
            // Fits in new buffer.
            memcpy((uint8_t*)buffer.mutableBytes, ((uint8_t*)data.bytes) + offset, length);
            position = length;
        } else {
            // Write is very big.  Let's do it all at once.
            [output write:((uint8_t*)data.bytes) + offset maxLength:length];
        }
    }
}

/** Encode and write a tag. */
- (void) writeTag:(int32_t) fieldNumber format:(int32_t) format {
    [self writeRawVarint32:WireFormatMakeTag(fieldNumber, format)];
}


int32_t computeTagSize(int32_t fieldNumber) {
    return computeRawVarint32Size(WireFormatMakeTag(fieldNumber, 0));
}


- (void) writeRawVarint32:(int32_t) value {
    while (true) {
        if ((value & ~0x7F) == 0) {
            [self writeRawByte:value];
            return;
        } else {
            [self writeRawByte:((value & 0x7F) | 0x80)];
            uint32_t temp = (*(uint32_t*)&value) >> 7;
            value = *(int32_t*)&temp;
        }
    }
}


int32_t computeRawVarint32Size(int32_t value) {
    if ((value & (0xffffffff <<  7)) == 0) return 1;
    if ((value & (0xffffffff << 14)) == 0) return 2;
    if ((value & (0xffffffff << 21)) == 0) return 3;
    if ((value & (0xffffffff << 28)) == 0) return 4;
    return 5;
}


- (void) writeRawVarint64:(int64_t) value{
    while (true) {
        if ((value & ~0x7FL) == 0) {
            [self writeRawByte:((int32_t)value)];
            return;
        } else {
            [self writeRawByte:(((int32_t)value & 0x7F) | 0x80)];
            uint32_t temp = (*(uint32_t*)&value) >> 7;
            value = *(int32_t*)&temp;
        }
    }
}


int32_t computeRawVarint64Size(int64_t value) {
    if ((value & (0xffffffffffffffffL <<  7)) == 0) return 1;
    if ((value & (0xffffffffffffffffL << 14)) == 0) return 2;
    if ((value & (0xffffffffffffffffL << 21)) == 0) return 3;
    if ((value & (0xffffffffffffffffL << 28)) == 0) return 4;
    if ((value & (0xffffffffffffffffL << 35)) == 0) return 5;
    if ((value & (0xffffffffffffffffL << 42)) == 0) return 6;
    if ((value & (0xffffffffffffffffL << 49)) == 0) return 7;
    if ((value & (0xffffffffffffffffL << 56)) == 0) return 8;
    if ((value & (0xffffffffffffffffL << 63)) == 0) return 9;
    return 10;
}


- (void) writeRawLittleEndian32:(int32_t) value {
    [self writeRawByte:((value      ) & 0xFF)];
    [self writeRawByte:((value >>  8) & 0xFF)];
    [self writeRawByte:((value >> 16) & 0xFF)];
    [self writeRawByte:((value >> 24) & 0xFF)];
}


- (void) writeRawLittleEndian64:(int64_t) value {
    [self writeRawByte:((int32_t)(value      ) & 0xFF)];
    [self writeRawByte:((int32_t)(value >>  8) & 0xFF)];
    [self writeRawByte:((int32_t)(value >> 16) & 0xFF)];
    [self writeRawByte:((int32_t)(value >> 24) & 0xFF)];
    [self writeRawByte:((int32_t)(value >> 32) & 0xFF)];
    [self writeRawByte:((int32_t)(value >> 40) & 0xFF)];
    [self writeRawByte:((int32_t)(value >> 48) & 0xFF)];
    [self writeRawByte:((int32_t)(value >> 56) & 0xFF)];
}



int32_t encodeZigZag32(int32_t n) {
    // Note:  the right-shift must be arithmetic
    return (n << 1) ^ (n >> 31);
}


int64_t encodeZigZag64(int64_t n) {
    // Note:  the right-shift must be arithmetic
    return (n << 1) ^ (n >> 63);
}

@end
