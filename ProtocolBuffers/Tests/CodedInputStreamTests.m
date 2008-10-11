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

#import "CodedInputStreamTests.h"

#import "ProtocolBuffers.h"
#import "SmallBlockInputStream.h"

@implementation CodedInputStreamTests

- (void) testDecodeZigZag {
    STAssertEquals( 0, decodeZigZag32(0), nil);
    STAssertEquals(-1, decodeZigZag32(1), nil);
    STAssertEquals( 1, decodeZigZag32(2), nil);
    STAssertEquals(-2, decodeZigZag32(3), nil);
    STAssertEquals((int32_t)0x3FFFFFFF, decodeZigZag32(0x7FFFFFFE), nil);
    STAssertEquals((int32_t)0xC0000000, decodeZigZag32(0x7FFFFFFF), nil);
    STAssertEquals((int32_t)0x7FFFFFFF, decodeZigZag32(0xFFFFFFFE), nil);
    STAssertEquals((int32_t)0x80000000, decodeZigZag32(0xFFFFFFFF), nil);
    
    STAssertEquals((int64_t) 0, decodeZigZag64(0), nil);
    STAssertEquals((int64_t)-1, decodeZigZag64(1), nil);
    STAssertEquals((int64_t) 1, decodeZigZag64(2), nil);
    STAssertEquals((int64_t)-2, decodeZigZag64(3), nil);
    STAssertEquals((int64_t)0x000000003FFFFFFFL, decodeZigZag64(0x000000007FFFFFFEL), nil);
    STAssertEquals((int64_t)0xFFFFFFFFC0000000L, decodeZigZag64(0x000000007FFFFFFFL), nil);
    STAssertEquals((int64_t)0x000000007FFFFFFFL, decodeZigZag64(0x00000000FFFFFFFEL), nil);
    STAssertEquals((int64_t)0xFFFFFFFF80000000L, decodeZigZag64(0x00000000FFFFFFFFL), nil);
    STAssertEquals((int64_t)0x7FFFFFFFFFFFFFFFL, decodeZigZag64(0xFFFFFFFFFFFFFFFEL), nil);
    STAssertEquals((int64_t)0x8000000000000000L, decodeZigZag64(0xFFFFFFFFFFFFFFFFL), nil);
}




/**
 * Parses the given bytes using readRawVarint32() and readRawVarint64() and
 * checks that the result matches the given value.
 */
- (void) assertReadVarint:(NSData*) data value:(int64_t) value {
    {
        PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
        STAssertTrue((int32_t)value == [input readRawVarint32], @"");
    }
    {
        PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
        STAssertTrue(value == [input readRawVarint64], @"");
    }
    
    {
        PBCodedInputStream* input = [PBCodedInputStream streamWithInputStream:[NSInputStream inputStreamWithData:data]];
        STAssertTrue((int32_t)value == [input readRawVarint32], @"");
    }
    {
        PBCodedInputStream* input = [PBCodedInputStream streamWithInputStream:[NSInputStream inputStreamWithData:data]];
        STAssertTrue(value == [input readRawVarint64], @"");
    }
    
    // Try different block sizes.
    for (int32_t blockSize = 1; blockSize <= 16; blockSize *= 2) {
        {
            PBCodedInputStream* input = [PBCodedInputStream streamWithInputStream:[SmallBlockInputStream streamWithData:data blockSize:blockSize]];
            STAssertTrue((int32_t)value == [input readRawVarint32], @"");
        }
        {
            PBCodedInputStream* input = [PBCodedInputStream streamWithInputStream:[SmallBlockInputStream streamWithData:data blockSize:blockSize]];
            STAssertTrue(value == [input readRawVarint64], @"");
        }
    }
}


/**
 * Parses the given bytes using readRawVarint32() and readRawVarint64() and
 * expects them to fail with an InvalidProtocolBufferException whose
 * description matches the given one.
 */
- (void) assertReadVarintFailure:(NSData*) data {
    {
        PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
        STAssertThrows([input readRawVarint32], @"");
    }
    {
        PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
        STAssertThrows([input readRawVarint64], @"");
    }
}

- (NSData*) bytes_with_sentinel:(int32_t) unused, ... {
    va_list list;
    va_start(list, unused);
    
    NSMutableData* values = [NSMutableData dataWithCapacity:0];
    int32_t i;
    
    while ((i = va_arg(list, int32_t)) != 256) {
        NSAssert(i >= 0 && i < 256, @"");
        uint8_t u = (uint8_t)i;
        [values appendBytes:&u length:1];
    }
    
    va_end(list);
    
    return values;
}

#define bytes(...) [self bytes_with_sentinel:0, __VA_ARGS__, 256]


- (void) testBytes {
    NSData* data = bytes(0xa2, 0x74);
    STAssertTrue(data.length == 2, @"");
    STAssertTrue(((uint8_t*)data.bytes)[0] == 0xa2, @"");
    STAssertTrue(((uint8_t*)data.bytes)[1] == 0x74, @"");
}

/** Tests readRawVarint32() and readRawVarint64(). */
- (void) testReadVarint {
    [self assertReadVarint:bytes(0x00) value:0];
    [self assertReadVarint:bytes(0x01) value:1];
    [self assertReadVarint:bytes(0x7f) value:127];
    // 14882
    [self assertReadVarint:bytes(0xa2, 0x74) value:(0x22 << 0) | (0x74 << 7)];
    // 2961488830
    [self assertReadVarint:bytes(0xbe, 0xf7, 0x92, 0x84, 0x0b) value:
     (0x3e << 0) | (0x77 << 7) | (0x12 << 14) | (0x04 << 21) |
     (0x0bLL << 28)];
    
    // 64-bit
    // 7256456126
    [self assertReadVarint:bytes(0xbe, 0xf7, 0x92, 0x84, 0x1b) value:
     (0x3e << 0) | (0x77 << 7) | (0x12 << 14) | (0x04 << 21) |
     (0x1bLL << 28)];
    // 41256202580718336
    [self assertReadVarint:
     bytes(0x80, 0xe6, 0xeb, 0x9c, 0xc3, 0xc9, 0xa4, 0x49) value:
     (0x00 << 0) | (0x66 << 7) | (0x6b << 14) | (0x1c << 21) |
     (0x43LL << 28) | (0x49LL << 35) | (0x24LL << 42) | (0x49LL << 49)];
    // 11964378330978735131
    [self assertReadVarint:
     bytes(0x9b, 0xa8, 0xf9, 0xc2, 0xbb, 0xd6, 0x80, 0x85, 0xa6, 0x01) value:
     (0x1b << 0) | (0x28 << 7) | (0x79 << 14) | (0x42 << 21) |
     (0x3bLL << 28) | (0x56LL << 35) | (0x00LL << 42) |
     (0x05LL << 49) | (0x26LL << 56) | (0x01LL << 63)];
    
    // Failures
    [self assertReadVarintFailure:bytes(0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x00)];
    [self assertReadVarintFailure:bytes(0x80)];
}

#if 0




#endif

#if 0
/**
 * Parses the given bytes using readRawLittleEndian32() and checks
 * that the result matches the given value.
 */
private void assertReadLittleEndian32(byte[] data, int value)
throws Exception {
    CodedInputStream input = CodedInputStream.newInstance(data);
    assertEquals(value, input.readRawLittleEndian32());
    
    // Try different block sizes.
    for (int blockSize = 1; blockSize <= 16; blockSize *= 2) {
        input = CodedInputStream.newInstance(
                                             new SmallBlockInputStream(data, blockSize));
        assertEquals(value, input.readRawLittleEndian32());
    }
}

/**
 * Parses the given bytes using readRawLittleEndian64() and checks
 * that the result matches the given value.
 */
private void assertReadLittleEndian64(byte[] data, long value)
throws Exception {
    CodedInputStream input = CodedInputStream.newInstance(data);
    assertEquals(value, input.readRawLittleEndian64());
    
    // Try different block sizes.
    for (int blockSize = 1; blockSize <= 16; blockSize *= 2) {
        input = CodedInputStream.newInstance(
                                             new SmallBlockInputStream(data, blockSize));
        assertEquals(value, input.readRawLittleEndian64());
    }
}

/** Tests readRawLittleEndian32() and readRawLittleEndian64(). */
public void testReadLittleEndian() throws Exception {
    assertReadLittleEndian32(bytes(0x78, 0x56, 0x34, 0x12), 0x12345678);
    assertReadLittleEndian32(bytes(0xf0, 0xde, 0xbc, 0x9a), 0x9abcdef0);
    
    assertReadLittleEndian64(
                             bytes(0xf0, 0xde, 0xbc, 0x9a, 0x78, 0x56, 0x34, 0x12),
                             0x123456789abcdef0L);
    assertReadLittleEndian64(
                             bytes(0x78, 0x56, 0x34, 0x12, 0xf0, 0xde, 0xbc, 0x9a),
                             0x9abcdef012345678L);
}

/** Test decodeZigZag32() and decodeZigZag64(). */
public void testDecodeZigZag() throws Exception {
    assertEquals( 0, CodedInputStream.decodeZigZag32(0));
    assertEquals(-1, CodedInputStream.decodeZigZag32(1));
    assertEquals( 1, CodedInputStream.decodeZigZag32(2));
    assertEquals(-2, CodedInputStream.decodeZigZag32(3));
    assertEquals(0x3FFFFFFF, CodedInputStream.decodeZigZag32(0x7FFFFFFE));
    assertEquals(0xC0000000, CodedInputStream.decodeZigZag32(0x7FFFFFFF));
    assertEquals(0x7FFFFFFF, CodedInputStream.decodeZigZag32(0xFFFFFFFE));
    assertEquals(0x80000000, CodedInputStream.decodeZigZag32(0xFFFFFFFF));
    
    assertEquals( 0, CodedInputStream.decodeZigZag64(0));
    assertEquals(-1, CodedInputStream.decodeZigZag64(1));
    assertEquals( 1, CodedInputStream.decodeZigZag64(2));
    assertEquals(-2, CodedInputStream.decodeZigZag64(3));
    assertEquals(0x000000003FFFFFFFL,
                 CodedInputStream.decodeZigZag64(0x000000007FFFFFFEL));
    assertEquals(0xFFFFFFFFC0000000L,
                 CodedInputStream.decodeZigZag64(0x000000007FFFFFFFL));
    assertEquals(0x000000007FFFFFFFL,
                 CodedInputStream.decodeZigZag64(0x00000000FFFFFFFEL));
    assertEquals(0xFFFFFFFF80000000L,
                 CodedInputStream.decodeZigZag64(0x00000000FFFFFFFFL));
    assertEquals(0x7FFFFFFFFFFFFFFFL,
                 CodedInputStream.decodeZigZag64(0xFFFFFFFFFFFFFFFEL));
    assertEquals(0x8000000000000000L,
                 CodedInputStream.decodeZigZag64(0xFFFFFFFFFFFFFFFFL));
}

/** Tests reading and parsing a whole message with every field type. */
public void testReadWholeMessage() throws Exception {
    TestAllTypes message = TestUtil.getAllSet();
    
    byte[] rawBytes = message.toByteArray();
    assertEquals(rawBytes.length, message.getSerializedSize());
    
    TestAllTypes message2 = TestAllTypes.parseFrom(rawBytes);
    TestUtil.assertAllFieldsSet(message2);
    
    // Try different block sizes.
    for (int blockSize = 1; blockSize < 256; blockSize *= 2) {
        message2 = TestAllTypes.parseFrom(
                                          new SmallBlockInputStream(rawBytes, blockSize));
        TestUtil.assertAllFieldsSet(message2);
    }
}

/** Tests skipField(). */
public void testSkipWholeMessage() throws Exception {
    TestAllTypes message = TestUtil.getAllSet();
    byte[] rawBytes = message.toByteArray();
    
    // Create two parallel inputs.  Parse one as unknown fields while using
    // skipField() to skip each field on the other.  Expect the same tags.
    CodedInputStream input1 = CodedInputStream.newInstance(rawBytes);
    CodedInputStream input2 = CodedInputStream.newInstance(rawBytes);
    UnknownFieldSet.Builder unknownFields = UnknownFieldSet.newBuilder();
    
    while (true) {
        int tag = input1.readTag();
        assertEquals(tag, input2.readTag());
        if (tag == 0) {
            break;
        }
        unknownFields.mergeFieldFrom(tag, input1);
        input2.skipField(tag);
    }
}

public void testReadHugeBlob() throws Exception {
    // Allocate and initialize a 1MB blob.
    byte[] blob = new byte[1 << 20];
    for (int i = 0; i < blob.length; i++) {
        blob[i] = (byte)i;
    }
    
    // Make a message containing it.
    TestAllTypes.Builder builder = TestAllTypes.newBuilder();
    TestUtil.setAllFields(builder);
    builder.setOptionalBytes(ByteString.copyFrom(blob));
    TestAllTypes message = builder.build();
    
    // Serialize and parse it.  Make sure to parse from an InputStream, not
    // directly from a ByteString, so that CodedInputStream uses buffered
    // reading.
    TestAllTypes message2 =
    TestAllTypes.parseFrom(message.toByteString().newInput());
    
    assertEquals(message.getOptionalBytes(), message2.getOptionalBytes());
    
    // Make sure all the other fields were parsed correctly.
    TestAllTypes message3 = TestAllTypes.newBuilder(message2)
    .setOptionalBytes(TestUtil.getAllSet().getOptionalBytes())
    .build();
    TestUtil.assertAllFieldsSet(message3);
}

public void testReadMaliciouslyLargeBlob() throws Exception {
    ByteString.Output rawOutput = ByteString.newOutput();
    CodedOutputStream output = CodedOutputStream.newInstance(rawOutput);
    
    int tag = WireFormat.makeTag(1, WireFormat.WIRETYPE_LENGTH_DELIMITED);
    output.writeRawVarint32(tag);
    output.writeRawVarint32(0x7FFFFFFF);
    output.writeRawBytes(new byte[32]);  // Pad with a few random bytes.
    output.flush();
    
    CodedInputStream input = rawOutput.toByteString().newCodedInput();
    assertEquals(tag, input.readTag());
    
    try {
        input.readBytes();
        fail("Should have thrown an exception!");
    } catch (InvalidProtocolBufferException e) {
        // success.
    }
}

private TestRecursiveMessage makeRecursiveMessage(int depth) {
    if (depth == 0) {
        return TestRecursiveMessage.newBuilder().setI(5).build();
    } else {
        return TestRecursiveMessage.newBuilder()
        .setA(makeRecursiveMessage(depth - 1)).build();
    }
}

private void assertMessageDepth(TestRecursiveMessage message, int depth) {
    if (depth == 0) {
        assertFalse(message.hasA());
        assertEquals(5, message.getI());
    } else {
        assertTrue(message.hasA());
        assertMessageDepth(message.getA(), depth - 1);
    }
}

public void testMaliciousRecursion() throws Exception {
    ByteString data64 = makeRecursiveMessage(64).toByteString();
    ByteString data65 = makeRecursiveMessage(65).toByteString();
    
    assertMessageDepth(TestRecursiveMessage.parseFrom(data64), 64);
    
    try {
        TestRecursiveMessage.parseFrom(data65);
        fail("Should have thrown an exception!");
    } catch (InvalidProtocolBufferException e) {
        // success.
    }
    
    CodedInputStream input = data64.newCodedInput();
    input.setRecursionLimit(8);
    try {
        TestRecursiveMessage.parseFrom(input);
        fail("Should have thrown an exception!");
    } catch (InvalidProtocolBufferException e) {
        // success.
    }
}

public void testSizeLimit() throws Exception {
    CodedInputStream input = CodedInputStream.newInstance(
                                                          TestUtil.getAllSet().toByteString().newInput());
    input.setSizeLimit(16);
    
    try {
        TestAllTypes.parseFrom(input);
        fail("Should have thrown an exception!");
    } catch (InvalidProtocolBufferException e) {
        // success.
    }
}

/**
 * Tests that if we read an string that contains invalid UTF-8, no exception
 * is thrown.  Instead, the invalid bytes are replaced with the Unicode
 * "replacement character" U+FFFD.
 */
public void testReadInvalidUtf8() throws Exception {
    ByteString.Output rawOutput = ByteString.newOutput();
    CodedOutputStream output = CodedOutputStream.newInstance(rawOutput);
    
    int tag = WireFormat.makeTag(1, WireFormat.WIRETYPE_LENGTH_DELIMITED);
    output.writeRawVarint32(tag);
    output.writeRawVarint32(1);
    output.writeRawBytes(new byte[] { (byte)0x80 });
    output.flush();
    
    CodedInputStream input = rawOutput.toByteString().newCodedInput();
    assertEquals(tag, input.readTag());
    String text = input.readString();
    assertEquals(0xfffd, text.charAt(0));
}
#endif

@end