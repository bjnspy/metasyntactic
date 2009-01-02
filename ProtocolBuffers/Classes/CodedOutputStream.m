// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "CodedOutputStream.h"

#import "EnumValueDescriptor.h"
#import "FieldDescriptorType.h"
#import "Message.h"
#import "Utilities.h"
#import "WireFormat.h"

@interface PBCodedOutputStream ()
@property (retain) NSMutableData* buffer;
@property int32_t position;
@property (retain) NSOutputStream* output;
@end


@implementation PBCodedOutputStream

const int32_t DEFAULT_BUFFER_SIZE = 4096;
const int32_t LITTLE_ENDIAN_32_SIZE = 4;
const int32_t LITTLE_ENDIAN_64_SIZE = 8;

@synthesize output;
@synthesize buffer;
@synthesize position;

- (void) dealloc {
    [output close];
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

        [output open];
    }

    return self;
}


+ (PBCodedOutputStream*) streamWithOutputStream:(NSOutputStream*) output
                                     bufferSize:(int32_t) bufferSize {
    NSMutableData* data = [NSMutableData dataWithLength:bufferSize];
    return [[[PBCodedOutputStream alloc] initWithOutputStream:output
                                                       data:data] autorelease];
}


+ (PBCodedOutputStream*) streamWithOutputStream:(NSOutputStream*) output {
    return [PBCodedOutputStream streamWithOutputStream:output bufferSize:DEFAULT_BUFFER_SIZE];
}


+ (PBCodedOutputStream*) streamWithData:(NSMutableData*) data {
    return [[[PBCodedOutputStream alloc] initWithOutputStream:nil data:data] autorelease];
}


/** Write a {@code double} field, including tag, to the stream. */
- (void) writeDouble:(int32_t) fieldNumber
               value:(Float64) value {
    [self writeTag:fieldNumber format:PBWireFormatFixed64];
    [self writeRawLittleEndian64:convertFloat64ToInt64(value)];
}


/** Write a {@code float} field, including tag, to the stream. */
- (void) writeFloat:(int32_t) fieldNumber
              value:(Float32) value {
    [self writeTag:fieldNumber format:PBWireFormatFixed32];
    [self writeRawLittleEndian32:convertFloat32ToInt32(value)];
}


/** Write a {@code uint64} field, including tag, to the stream. */
- (void) writeUInt64:(int32_t) fieldNumber
               value:(int64_t) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    [self writeRawVarint64:value];
}


/** Write an {@code int64} field, including tag, to the stream. */
- (void) writeInt64:(int32_t) fieldNumber
               value:(int64_t) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    [self writeRawVarint64:value];
}


/** Write an {@code int32} field, including tag, to the stream. */
- (void) writeInt32:(int32_t) fieldNumber
              value:(int32_t) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    if (value >= 0) {
        [self writeRawVarint32:value];
    } else {
        // Must sign-extend
        [self writeRawVarint64:value];
    }
}


/** Write a {@code fixed64} field, including tag, to the stream. */
- (void) writeFixed64:(int32_t) fieldNumber
                value:(int64_t) value {
    [self writeTag:fieldNumber format:PBWireFormatFixed64];
    [self writeRawLittleEndian64:value];
}


/** Write a {@code fixed32} field, including tag, to the stream. */
- (void) writeFixed32:(int32_t) fieldNumber
                value:(int32_t) value {
    [self writeTag:fieldNumber format:PBWireFormatFixed32];
    [self writeRawLittleEndian32:value];
}


/** Write a {@code bool} field, including tag, to the stream. */
- (void) writeBool:(int32_t) fieldNumber
             value:(BOOL) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    [self writeRawByte:(value ? 1 : 0)];
}


/** Write a {@code string} field, including tag, to the stream. */
- (void) writeString:(int32_t) fieldNumber
               value:(NSString*) value {
    // TODO(cyrusn): we could probably use:
    // NSString:getBytes:maxLength:usedLength:encoding:options:range:remainingRange:
    // to write directly into our buffer.
    [self writeTag:fieldNumber format:PBWireFormatLengthDelimited];
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    [self writeRawVarint32:data.length];
    [self writeRawData:data];
}


/** Write a {@code group} field, including tag, to the stream. */
- (void) writeGroup:(int32_t) fieldNumber
              value:(id<PBMessage>) value {
    [self writeTag:fieldNumber format:PBWireFormatStartGroup];
    [value writeToCodedOutputStream:self];
    [self writeTag:fieldNumber format:PBWireFormatEndGroup];
}


/** Write a group represented by an {@link PBUnknownFieldSet}. */
- (void) writeUnknownGroup:(int32_t) fieldNumber
                     value:(PBUnknownFieldSet*) value {
    [self writeTag:fieldNumber format:PBWireFormatStartGroup];
    [value writeToCodedOutputStream:self];
    [self writeTag:fieldNumber format:PBWireFormatEndGroup];
}


/** Write an embedded message field, including tag, to the stream. */
- (void) writeMessage:(int32_t) fieldNumber
                value:(id<PBMessage>) value {
    [self writeTag:fieldNumber format:PBWireFormatLengthDelimited];
    [self writeRawVarint32:[value serializedSize]];
    [value writeToCodedOutputStream:self];
}


/** Write a {@code bytes} field, including tag, to the stream. */
- (void) writeData:(int32_t) fieldNumber value:(NSData*) value {
    [self writeTag:fieldNumber format:PBWireFormatLengthDelimited];
    [self writeRawVarint32:value.length];
    [self writeRawData:value];
}


/** Write a {@code uint32} field, including tag, to the stream. */
- (void) writeUInt32:(int32_t) fieldNumber
               value:(int32_t) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    [self writeRawVarint32:value];
}


/**
 * Write an enum field, including tag, to the stream.  Caller is responsible
 * for converting the enum value to its numeric value.
 */
- (void) writeEnum:(int32_t) fieldNumber
             value:(int32_t) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    [self writeRawVarint32:value];
}


/** Write an {@code sfixed32} field, including tag, to the stream. */
- (void) writeSFixed32:(int32_t) fieldNumber
                 value:(int32_t) value {
    [self writeTag:fieldNumber format:PBWireFormatFixed32];
    [self writeRawLittleEndian32:value];
}


/** Write an {@code sfixed64} field, including tag, to the stream. */
- (void) writeSFixed64:(int32_t) fieldNumber
                 value:(int64_t) value {
    [self writeTag:fieldNumber format:PBWireFormatFixed64];
    [self writeRawLittleEndian64:value];
}


/** Write an {@code sint32} field, including tag, to the stream. */
- (void) writeSInt32:(int32_t) fieldNumber
               value:(int32_t) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    [self writeRawVarint32:encodeZigZag32(value)];
}


/** Write an {@code sint64} field, including tag, to the stream. */
- (void) writeSInt64:(int32_t) fieldNumber
               value:(int64_t) value {
    [self writeTag:fieldNumber format:PBWireFormatVarint];
    [self writeRawVarint64:encodeZigZag64(value)];
}


/**
 * Write a MessageSet extension field to the stream.  For historical reasons,
 * the wire format differs from normal fields.
 */
- (void) writeMessageSetExtension:(int32_t) fieldNumber
                            value:(id<PBMessage>) value {
    [self writeTag:PBWireFormatMessageSetItem format:PBWireFormatStartGroup];
    [self writeUInt32:PBWireFormatMessageSetTypeId value:fieldNumber];
    [self writeMessage:PBWireFormatMessageSetMessage value:value];
    [self writeTag:PBWireFormatMessageSetItem format:PBWireFormatEndGroup];
}


/**
 * Write an unparsed MessageSet extension field to the stream.  For
 * historical reasons, the wire format differs from normal fields.
 */
- (void) writeRawMessageSetExtension:(int32_t) fieldNumber
                               value:(NSData*) value {
    [self writeTag:PBWireFormatMessageSetItem format:PBWireFormatStartGroup];
    [self writeUInt32:PBWireFormatMessageSetTypeId value:fieldNumber];
    [self writeData:PBWireFormatMessageSetMessage value:value];
    [self writeTag:PBWireFormatMessageSetItem format:PBWireFormatEndGroup];
}


/**
 * Write a field of arbitrary type, including tag, to the stream.
 *
 * @param type   The field's type.
 * @param number The field's number.
 * @param value  Object representing the field's value.  Must be of the exact
 *               type which would be returned by
 *               {@link PBMessage#getField(Descriptors.PBFieldDescriptor)} for
 *               this field.
 */
- (void) writeField:(PBFieldDescriptorType) type
             number:(int32_t) number
              value:(id) value {
    switch (type) {
        case PBFieldDescriptorTypeDouble:   [self writeDouble:number      value:[value doubleValue]]; break;
        case PBFieldDescriptorTypeFloat:    [self writeFloat:number       value:[value floatValue]]; break;
        case PBFieldDescriptorTypeInt64:    [self writeInt64:number       value:[value longLongValue]]; break;
        case PBFieldDescriptorTypeUInt64:   [self writeUInt64:number      value:[value longLongValue]]; break;
        case PBFieldDescriptorTypeInt32:    [self writeInt32:number       value:[value intValue]]; break;
        case PBFieldDescriptorTypeFixed64:  [self writeFixed64:number     value:[value longLongValue]]; break;
        case PBFieldDescriptorTypeFixed32:  [self writeFixed32:number     value:[value intValue]]; break;
        case PBFieldDescriptorTypeBool:     [self writeBool:number        value:[value boolValue]]; break;
        case PBFieldDescriptorTypeString:   [self writeString:number      value:value]; break;
        case PBFieldDescriptorTypeGroup:    [self writeGroup:number       value:value]; break;
        case PBFieldDescriptorTypeMessage:  [self writeMessage:number     value:value]; break;
        case PBFieldDescriptorTypeData:     [self writeData:number        value:value]; break;
        case PBFieldDescriptorTypeUInt32:   [self writeUInt32:number      value:[value intValue]]; break;
        case PBFieldDescriptorTypeSFixed32: [self writeSFixed32:number    value:[value intValue]]; break;
        case PBFieldDescriptorTypeSFixed64: [self writeSFixed64:number    value:[value longLongValue]]; break;
        case PBFieldDescriptorTypeSInt32:   [self writeSInt32:number      value:[value intValue]]; break;
        case PBFieldDescriptorTypeSInt64:   [self writeSInt64:number      value:[value longLongValue]]; break;
        case PBFieldDescriptorTypeEnum:     [self writeEnum:number        value:[value number]]; break;
        default:
            @throw [NSException exceptionWithName:@"InvalidArgument" reason:@"" userInfo:nil];
    }
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code double} field, including tag.
 */
int32_t computeDoubleSize(int32_t fieldNumber, Float64 value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_64_SIZE;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code float} field, including tag.
 */
int32_t computeFloatSize(int32_t fieldNumber, Float32 value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_32_SIZE;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code uint64} field, including tag.
 */
int32_t computeUInt64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint64Size(value);
}


/**
 * Compute the number of bytes that would be needed to encode an
 * {@code int64} field, including tag.
 */
int32_t computeInt64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint64Size(value);
}


/**
 * Compute the number of bytes that would be needed to encode an
 * {@code int32} field, including tag.
 */
int32_t computeInt32Size(int32_t fieldNumber, int32_t value) {
    if (value >= 0) {
        return computeTagSize(fieldNumber) + computeRawVarint32Size(value);
    } else {
        // Must sign-extend.
        return computeTagSize(fieldNumber) + 10;
    }
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code fixed64} field, including tag.
 */
int32_t computeFixed64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_64_SIZE;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code fixed32} field, including tag.
 */
int32_t computeFixed32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_32_SIZE;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code bool} field, including tag.
 */
int32_t computeBoolSize(int32_t fieldNumber, BOOL value) {
    return computeTagSize(fieldNumber) + 1;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code string} field, including tag.
 */
int32_t computeStringSize(int32_t fieldNumber, NSString* value) {
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    return computeTagSize(fieldNumber) + computeRawVarint32Size(data.length) + data.length;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code group} field, including tag.
 */
int32_t computeGroupSize(int32_t fieldNumber, id<PBMessage> value) {
    return computeTagSize(fieldNumber) * 2 + [value serializedSize];
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code group} field represented by an {@code PBUnknownFieldSet}, including
 * tag.
 */
int32_t computeUnknownGroupSize(int32_t fieldNumber,
                                PBUnknownFieldSet* value) {
    return computeTagSize(fieldNumber) * 2 + value.serializedSize;
}


/**
 * Compute the number of bytes that would be needed to encode an
 * embedded message field, including tag.
 */
int32_t computeMessageSize(int32_t fieldNumber, id<PBMessage> value) {
    int32_t size = [value serializedSize];
    return computeTagSize(fieldNumber) + computeRawVarint32Size(size) + size;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code bytes} field, including tag.
 */
int32_t computeDataSize(int32_t fieldNumber, NSData* value) {
    return computeTagSize(fieldNumber) +
    computeRawVarint32Size(value.length) +
    value.length;
}


/**
 * Compute the number of bytes that would be needed to encode a
 * {@code uint32} field, including tag.
 */
int32_t computeUInt32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint32Size(value);
}


/**
 * Compute the number of bytes that would be needed to encode an
 * enum field, including tag.  Caller is responsible for converting the
 * enum value to its numeric value.
 */
int32_t computeEnumSize(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + computeRawVarint32Size(value);
}


/**
 * Compute the number of bytes that would be needed to encode an
 * {@code sfixed32} field, including tag.
 */
int32_t computeSFixed32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_32_SIZE;
}


/**
 * Compute the number of bytes that would be needed to encode an
 * {@code sfixed64} field, including tag.
 */
int32_t computeSFixed64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) + LITTLE_ENDIAN_64_SIZE;
}


/**
 * Compute the number of bytes that would be needed to encode an
 * {@code sint32} field, including tag.
 */
int32_t computeSInt32Size(int32_t fieldNumber, int32_t value) {
    return computeTagSize(fieldNumber) +
    computeRawVarint32Size(encodeZigZag32(value));
}


/**
 * Compute the number of bytes that would be needed to encode an
 * {@code sint64} field, including tag.
 */
int32_t computeSInt64Size(int32_t fieldNumber, int64_t value) {
    return computeTagSize(fieldNumber) +
    computeRawVarint64Size(encodeZigZag64(value));
}


/**
 * Compute the number of bytes that would be needed to encode a
 * MessageSet extension to the stream.  For historical reasons,
 * the wire format differs from normal fields.
 */
int32_t computeMessageSetExtensionSize(int32_t fieldNumber, id<PBMessage> value) {
    return computeTagSize(PBWireFormatMessageSetItem) * 2 +
    computeUInt32Size(PBWireFormatMessageSetTypeId, fieldNumber) +
    computeMessageSize(PBWireFormatMessageSetMessage, value);
}


/**
 * Compute the number of bytes that would be needed to encode an
 * unparsed MessageSet extension field to the stream.  For
 * historical reasons, the wire format differs from normal fields.
 */
int32_t computeRawMessageSetExtensionSize(int32_t fieldNumber, NSData* value) {
    return computeTagSize(PBWireFormatMessageSetItem) * 2 +
    computeUInt32Size(PBWireFormatMessageSetTypeId, fieldNumber) +
    computeDataSize(PBWireFormatMessageSetMessage, value);
}


/**
 * Compute the number of bytes that would be needed to encode a
 * field of arbitrary type, including tag, to the stream.
 *
 * @param type   The field's type.
 * @param number The field's number.
 * @param value  Object representing the field's value.  Must be of the exact
 *               type which would be returned by
 *               {@link PBMessage#getField(Descriptors.PBFieldDescriptor)} for
 *               this field.
 */
int32_t computeFieldSize(PBFieldDescriptorType type,
                         int32_t number,
                         id value) {
    switch (type) {
        case PBFieldDescriptorTypeDouble  : return computeDoubleSize  (number, [value doubleValue]);
        case PBFieldDescriptorTypeFloat   : return computeFloatSize   (number, [value floatValue]);
        case PBFieldDescriptorTypeInt64   : return computeInt64Size   (number, [value longLongValue]);
        case PBFieldDescriptorTypeUInt64  : return computeUInt64Size  (number, [value longLongValue]);
        case PBFieldDescriptorTypeInt32   : return computeInt32Size   (number, [value intValue]);
        case PBFieldDescriptorTypeFixed64 : return computeFixed64Size (number, [value longLongValue]);
        case PBFieldDescriptorTypeFixed32 : return computeFixed32Size (number, [value intValue]);
        case PBFieldDescriptorTypeBool    : return computeBoolSize    (number, [value boolValue]);
        case PBFieldDescriptorTypeString  : return computeStringSize  (number, value);
        case PBFieldDescriptorTypeGroup   : return computeGroupSize   (number, value);
        case PBFieldDescriptorTypeMessage : return computeMessageSize (number, value);
        case PBFieldDescriptorTypeData    : return computeDataSize    (number, value);
        case PBFieldDescriptorTypeUInt32  : return computeUInt32Size  (number, [value intValue]);
        case PBFieldDescriptorTypeSFixed32: return computeSFixed32Size(number, [value intValue]);
        case PBFieldDescriptorTypeSFixed64: return computeSFixed64Size(number, [value longLongValue]);
        case PBFieldDescriptorTypeSInt32  : return computeSInt32Size  (number, [value intValue]);
        case PBFieldDescriptorTypeSInt64  : return computeSInt64Size  (number, [value longLongValue]);
        case PBFieldDescriptorTypeEnum:     return computeEnumSize    (number, [value number]);
    }

    @throw [NSException exceptionWithName:@"Runtime" reason:@"There is no way to get here, but the compiler thinks otherwise." userInfo:nil];
}


/**
 * Internal helper that writes the current buffer to the output. The
 * buffer position is reset to its initial value when this returns.
 */
- (void) refreshBuffer {
    if (output == nil) {
        // We're writing to a single buffer.
        @throw [NSException exceptionWithName:@"OutOfSpace" reason:@"" userInfo:nil];
    }


    [output write:buffer.bytes maxLength:position];
    position = 0;
}


/**
 * Flushes the stream and forces any buffered bytes to be written.  This
 * does not flush the underlying OutputStream.
 */
- (void) flush {
    if (output != nil) {
        [self refreshBuffer];
    }
}


/**
 * If writing to a flat array, return the space left in the array.
 * Otherwise, throws {@code UnsupportedOperationException}.
 */
- (int32_t) spaceLeft {
    if (output == nil) {
        return buffer.length - position;
    } else {
        @throw [NSException exceptionWithName:@"UnsupportedOperation"
                                       reason:@"spaceLeft() can only be called on CodedOutputStreams that are writing to a flat array."
                                     userInfo:nil];
    }
}


/**
 * Verifies that {@link #spaceLeft()} returns zero.  It's common to create
 * a byte array that is exactly big enough to hold a message, then write to
 * it with a {@code PBCodedOutputStream}.  Calling {@code checkNoSpaceLeft()}
 * after writing verifies that the message was actually as big as expected,
 * which can help catch bugs.
 */
- (void) checkNoSpaceLeft {
    if (self.spaceLeft != 0) {
        @throw [NSException exceptionWithName:@"IllegalState" reason:@"Did not write as much data as expected." userInfo:nil];
    }
}


/** Write a single byte. */
- (void) writeRawByte:(uint8_t) value {
    if (position == buffer.length) {
        [self refreshBuffer];
    }

    ((uint8_t*)buffer.mutableBytes)[position++] = value;
}


/** Write an array of bytes. */
- (void) writeRawData:(NSData*) data {
    [self writeRawData:data offset:0 length:data.length];
}


- (void) writeRawData:(NSData*) value offset:(int32_t) offset length:(int32_t) length {
    if (buffer.length - position >= length) {
        // We have room in the current buffer.
        memcpy(((uint8_t*)buffer.mutableBytes) + position, ((uint8_t*)value.bytes) + offset, length);
        position += length;
    } else {
        // Write extends past current buffer.  Fill the rest of this buffer and flush.
        int32_t bytesWritten = buffer.length - position;
        memcpy(((uint8_t*)buffer.mutableBytes) + position, ((uint8_t*)value.bytes) + offset, bytesWritten);
        offset += bytesWritten;
        length -= bytesWritten;
        position = buffer.length;
        [self refreshBuffer];

        // Now deal with the rest.
        // Since we have an output stream, this is our buffer
        // and buffer offset == 0
        if (length <= buffer.length) {
            // Fits in new buffer.
            memcpy((uint8_t*)buffer.mutableBytes, ((uint8_t*)value.bytes) + offset, length);
            position = length;
        } else {
            // Write is very big.  Let's do it all at once.
            [output write:((uint8_t*) value.bytes) + offset maxLength:length];
        }
    }
}


/** Encode and write a tag. */
- (void) writeTag:(int32_t) fieldNumber
           format:(int32_t) format {
    [self writeRawVarint32:PBWireFormatMakeTag(fieldNumber, format)];
}


/** Compute the number of bytes that would be needed to encode a tag. */
int32_t computeTagSize(int32_t fieldNumber) {
    return computeRawVarint32Size(PBWireFormatMakeTag(fieldNumber, 0));
}


/**
 * Encode and write a varint.  {@code value} is treated as
 * unsigned, so it won't be sign-extended if negative.
 */
- (void) writeRawVarint32:(int32_t) value {
    while (YES) {
        if ((value & ~0x7F) == 0) {
            [self writeRawByte:value];
            return;
        } else {
            [self writeRawByte:((value & 0x7F) | 0x80)];
            value = logicalRightShift32(value, 7);
        }
    }
}


/**
 * Compute the number of bytes that would be needed to encode a varint.
 * {@code value} is treated as unsigned, so it won't be sign-extended if
 * negative.
 */
int32_t computeRawVarint32Size(int32_t value) {
    if ((value & (0xffffffff <<  7)) == 0) return 1;
    if ((value & (0xffffffff << 14)) == 0) return 2;
    if ((value & (0xffffffff << 21)) == 0) return 3;
    if ((value & (0xffffffff << 28)) == 0) return 4;
    return 5;
}


/** Encode and write a varint. */
- (void) writeRawVarint64:(int64_t) value{
    while (YES) {
        if ((value & ~0x7FL) == 0) {
            [self writeRawByte:((int32_t) value)];
            return;
        } else {
            [self writeRawByte:(((int32_t) value & 0x7F) | 0x80)];
            value = logicalRightShift64(value, 7);
        }
    }
}


/** Compute the number of bytes that would be needed to encode a varint. */
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


/** Write a little-endian 32-bit integer. */
- (void) writeRawLittleEndian32:(int32_t) value {
    [self writeRawByte:((value      ) & 0xFF)];
    [self writeRawByte:((value >>  8) & 0xFF)];
    [self writeRawByte:((value >> 16) & 0xFF)];
    [self writeRawByte:((value >> 24) & 0xFF)];
}


/** Write a little-endian 64-bit integer. */
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


/**
 * Encode a ZigZag-encoded 32-bit value.  ZigZag encodes signed integers
 * into values that can be efficiently encoded with varint.  (Otherwise,
 * negative values must be sign-extended to 64 bits to be varint encoded,
 * thus always taking 10 bytes on the wire.)
 *
 * @param n A signed 32-bit integer.
 * @return An unsigned 32-bit integer, stored in a signed int
 */
int32_t encodeZigZag32(int32_t n) {
    // Note:  the right-shift must be arithmetic
    return (n << 1) ^ (n >> 31);
}


/**
 * Encode a ZigZag-encoded 64-bit value.  ZigZag encodes signed integers
 * into values that can be efficiently encoded with varint.  (Otherwise,
 * negative values must be sign-extended to 64 bits to be varint encoded,
 * thus always taking 10 bytes on the wire.)
 *
 * @param n A signed 64-bit integer.
 * @return An unsigned 64-bit integer, stored in a signed int
 */
int64_t encodeZigZag64(int64_t n) {
    // Note:  the right-shift must be arithmetic
    return (n << 1) ^ (n >> 63);
}

@end