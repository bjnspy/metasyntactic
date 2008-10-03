// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "FieldDescriptorType.h"

#import "ForwardDeclarations.h"

@interface PBCodedInputStream : NSObject {
@private
    NSMutableData* buffer;
    int32_t bufferSize;
    int32_t bufferSizeAfterLimit;
    int32_t bufferPos;
    NSInputStream* input;
    int32_t lastTag;

    /**
     * The total number of bytes read before the current buffer.  The total
     * bytes read up to the current position can be computed as
     * {@code totalBytesRetired + bufferPos}.
     */
    int32_t totalBytesRetired;

    /** The absolute position of the end of the current message. */
    int32_t currentLimit;

    /** See setRecursionLimit() */
    int32_t recursionDepth;
    int32_t recursionLimit;

    /** See setSizeLimit() */
    int32_t sizeLimit;
}

@property (retain, readonly) NSMutableData* buffer;
@property (retain, readonly) NSInputStream* input;

+ (PBCodedInputStream*) streamWithData:(NSData*) data;
+ (PBCodedInputStream*) streamWithInputStream:(NSInputStream*) input;

- (int32_t) readTag;
- (BOOL) refillBuffer:(BOOL) mustSucceed;

- (Float64) readDouble;
- (Float32) readFloat;
- (int64_t) readUInt64;
- (int32_t) readUInt32;
- (int64_t) readInt64;
- (int32_t) readInt32;
- (int64_t) readFixed64;
- (int32_t) readFixed32;
- (int32_t) readEnum;
- (int32_t) readSFixed32;
- (int64_t) readSFixed64;
- (int32_t) readSInt32;
- (int64_t) readSInt64;

- (int8_t) readRawByte;
- (int32_t) readRawVarint32;
- (int64_t) readRawVarint64;
- (int32_t) readRawLittleEndian32;
- (int64_t) readRawLittleEndian64;
- (NSData*) readRawData:(int32_t) size;

- (void) skipRawBytes:(int32_t) size;
- (void) skipMessage;

- (int32_t) pushLimit:(int32_t) byteLimit;
- (void) recomputeBufferSizeAfterLimit;
- (void) popLimit:(int32_t) oldLimit;

int32_t decodeZigZag32(int32_t n);
int64_t decodeZigZag64(int64_t n);

- (void) readMessage:(id<PBMessage_Builder>) builder extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) readBool;
- (NSString*) readString;
- (NSData*) readData;

- (void) readGroup:(int32_t) fieldNumber builder:(id<PBMessage_Builder>) builder extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
- (void) readUnknownGroup:(int32_t) fieldNumber builder:(PBUnknownFieldSet_Builder*) builder;

- (void) checkLastTagWas:(int32_t) value;

- (id) readPrimitiveField:(PBFieldDescriptorType) type;

@end
