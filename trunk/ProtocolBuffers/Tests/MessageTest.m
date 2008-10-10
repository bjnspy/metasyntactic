//
//  MessageTest.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MessageTest.h"

#import "Unittest.pb.h"

@implementation MessageTest

- (TestAllTypes*) mergeSource {
    return [[[[[[TestAllTypes newBuilder]
                setOptionalInt32:1]
               setOptionalString:@"foo"]
              setOptionalForeignMessage:[ForeignMessage defaultInstance]]
             addRepeatedString:@"bar"]
            build];
}


- (TestAllTypes*) mergeDestination {
    return [[[[[[TestAllTypes newBuilder]
               setOptionalInt64:2]
              setOptionalString:@"baz"]
             setOptionalForeignMessage:[[[ForeignMessage newBuilder] setC:3] build]]
            addRepeatedString:@"qux"]
            build];
}


- (TestAllTypes*) mergeResult {
    return [[[[[[[[TestAllTypes newBuilder]
                  setOptionalInt32:1]
                 setOptionalInt64:2]
                setOptionalString:@"foo"]
               setOptionalForeignMessage:[[[ForeignMessage newBuilder] setC:3] build]]
              addRepeatedString:@"qux"]
             addRepeatedString:@"bar"]
            build];
}


- (void) testMergeFrom {
    TestAllTypes* result =
    [[[TestAllTypes newBuilderWithPrototype:self.mergeDestination]
      mergeFromTestAllTypes:self.mergeSource] build];

    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}


/**
 * Test merging a DynamicMessage into a GeneratedMessage.  As long as they
 * have the same descriptor, this should work, but it is an entirely different
 * code path.
 */
- (void) testMergeFromDynamic {
    TestAllTypes* result = [[[TestAllTypes newBuilderWithPrototype:self.mergeDestination]
                             mergeFromMessage:[[PBDynamicMessage builderWithMessage:self.mergeSource] build]]
                            build];

    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}

#if 0
/** Test merging two DynamicMessages. */
public void testDynamicMergeFrom() throws Exception {
    DynamicMessage result =
    DynamicMessage.newBuilder(MERGE_DEST)
    .mergeFrom(DynamicMessage.newBuilder(MERGE_SOURCE).build())
    .build();
    
    assertEquals(MERGE_RESULT_TEXT, result.toString());
}

// =================================================================
// Required-field-related tests.

private static final TestRequired TEST_REQUIRED_UNINITIALIZED =
TestRequired.getDefaultInstance();
private static final TestRequired TEST_REQUIRED_INITIALIZED =
TestRequired.newBuilder().setA(1).setB(2).setC(3).build();

public void testRequired() throws Exception {
    TestRequired.Builder builder = TestRequired.newBuilder();
    
    assertFalse(builder.isInitialized());
    builder.setA(1);
    assertFalse(builder.isInitialized());
    builder.setB(1);
    assertFalse(builder.isInitialized());
    builder.setC(1);
    assertTrue(builder.isInitialized());
}

public void testRequiredForeign() throws Exception {
    TestRequiredForeign.Builder builder = TestRequiredForeign.newBuilder();
    
    assertTrue(builder.isInitialized());
    
    builder.setOptionalMessage(TEST_REQUIRED_UNINITIALIZED);
    assertFalse(builder.isInitialized());
    
    builder.setOptionalMessage(TEST_REQUIRED_INITIALIZED);
    assertTrue(builder.isInitialized());
    
    builder.addRepeatedMessage(TEST_REQUIRED_UNINITIALIZED);
    assertFalse(builder.isInitialized());
    
    builder.setRepeatedMessage(0, TEST_REQUIRED_INITIALIZED);
    assertTrue(builder.isInitialized());
}

public void testRequiredExtension() throws Exception {
    TestAllExtensions.Builder builder = TestAllExtensions.newBuilder();
    
    assertTrue(builder.isInitialized());
    
    builder.setExtension(TestRequired.single, TEST_REQUIRED_UNINITIALIZED);
    assertFalse(builder.isInitialized());
    
    builder.setExtension(TestRequired.single, TEST_REQUIRED_INITIALIZED);
    assertTrue(builder.isInitialized());
    
    builder.addExtension(TestRequired.multi, TEST_REQUIRED_UNINITIALIZED);
    assertFalse(builder.isInitialized());
    
    builder.setExtension(TestRequired.multi, 0, TEST_REQUIRED_INITIALIZED);
    assertTrue(builder.isInitialized());
}

public void testRequiredDynamic() throws Exception {
    Descriptors.Descriptor descriptor = TestRequired.getDescriptor();
    DynamicMessage.Builder builder = DynamicMessage.newBuilder(descriptor);
    
    assertFalse(builder.isInitialized());
    builder.setField(descriptor.findFieldByName("a"), 1);
    assertFalse(builder.isInitialized());
    builder.setField(descriptor.findFieldByName("b"), 1);
    assertFalse(builder.isInitialized());
    builder.setField(descriptor.findFieldByName("c"), 1);
    assertTrue(builder.isInitialized());
}

public void testRequiredDynamicForeign() throws Exception {
    Descriptors.Descriptor descriptor = TestRequiredForeign.getDescriptor();
    DynamicMessage.Builder builder = DynamicMessage.newBuilder(descriptor);
    
    assertTrue(builder.isInitialized());
    
    builder.setField(descriptor.findFieldByName("optional_message"),
                     TEST_REQUIRED_UNINITIALIZED);
    assertFalse(builder.isInitialized());
    
    builder.setField(descriptor.findFieldByName("optional_message"),
                     TEST_REQUIRED_INITIALIZED);
    assertTrue(builder.isInitialized());
    
    builder.addRepeatedField(descriptor.findFieldByName("repeated_message"),
                             TEST_REQUIRED_UNINITIALIZED);
    assertFalse(builder.isInitialized());
    
    builder.setRepeatedField(descriptor.findFieldByName("repeated_message"), 0,
                             TEST_REQUIRED_INITIALIZED);
    assertTrue(builder.isInitialized());
}

public void testUninitializedException() throws Exception {
    try {
        TestRequired.newBuilder().build();
        fail("Should have thrown an exception.");
    } catch (UninitializedMessageException e) {
        assertEquals("Message missing required fields: a, b, c", e.getMessage());
    }
}

public void testBuildPartial() throws Exception {
    // We're mostly testing that no exception is thrown.
    TestRequired message = TestRequired.newBuilder().buildPartial();
    assertFalse(message.isInitialized());
}

public void testNestedUninitializedException() throws Exception {
    try {
        TestRequiredForeign.newBuilder()
        .setOptionalMessage(TEST_REQUIRED_UNINITIALIZED)
        .addRepeatedMessage(TEST_REQUIRED_UNINITIALIZED)
        .addRepeatedMessage(TEST_REQUIRED_UNINITIALIZED)
        .build();
        fail("Should have thrown an exception.");
    } catch (UninitializedMessageException e) {
        assertEquals(
                     "Message missing required fields: " +
                     "optional_message.a, " +
                     "optional_message.b, " +
                     "optional_message.c, " +
                     "repeated_message[0].a, " +
                     "repeated_message[0].b, " +
                     "repeated_message[0].c, " +
                     "repeated_message[1].a, " +
                     "repeated_message[1].b, " +
                     "repeated_message[1].c",
                     e.getMessage());
    }
}

public void testBuildNestedPartial() throws Exception {
    // We're mostly testing that no exception is thrown.
    TestRequiredForeign message =
    TestRequiredForeign.newBuilder()
    .setOptionalMessage(TEST_REQUIRED_UNINITIALIZED)
    .addRepeatedMessage(TEST_REQUIRED_UNINITIALIZED)
    .addRepeatedMessage(TEST_REQUIRED_UNINITIALIZED)
    .buildPartial();
    assertFalse(message.isInitialized());
}

public void testParseUnititialized() throws Exception {
    try {
        TestRequired.parseFrom(ByteString.EMPTY);
        fail("Should have thrown an exception.");
    } catch (InvalidProtocolBufferException e) {
        assertEquals("Message missing required fields: a, b, c", e.getMessage());
    }
}

public void testParseNestedUnititialized() throws Exception {
    ByteString data =
    TestRequiredForeign.newBuilder()
    .setOptionalMessage(TEST_REQUIRED_UNINITIALIZED)
    .addRepeatedMessage(TEST_REQUIRED_UNINITIALIZED)
    .addRepeatedMessage(TEST_REQUIRED_UNINITIALIZED)
    .buildPartial().toByteString();
    
    try {
        TestRequiredForeign.parseFrom(data);
        fail("Should have thrown an exception.");
    } catch (InvalidProtocolBufferException e) {
        assertEquals(
                     "Message missing required fields: " +
                     "optional_message.a, " +
                     "optional_message.b, " +
                     "optional_message.c, " +
                     "repeated_message[0].a, " +
                     "repeated_message[0].b, " +
                     "repeated_message[0].c, " +
                     "repeated_message[1].a, " +
                     "repeated_message[1].b, " +
                     "repeated_message[1].c",
                     e.getMessage());
    }
}

public void testDynamicUninitializedException() throws Exception {
    try {
        DynamicMessage.newBuilder(TestRequired.getDescriptor()).build();
        fail("Should have thrown an exception.");
    } catch (UninitializedMessageException e) {
        assertEquals("Message missing required fields: a, b, c", e.getMessage());
    }
}

public void testDynamicBuildPartial() throws Exception {
    // We're mostly testing that no exception is thrown.
    DynamicMessage message =
    DynamicMessage.newBuilder(TestRequired.getDescriptor())
    .buildPartial();
    assertFalse(message.isInitialized());
}

public void testDynamicParseUnititialized() throws Exception {
    try {
        Descriptors.Descriptor descriptor = TestRequired.getDescriptor();
        DynamicMessage.parseFrom(descriptor, ByteString.EMPTY);
        fail("Should have thrown an exception.");
    } catch (InvalidProtocolBufferException e) {
        assertEquals("Message missing required fields: a, b, c", e.getMessage());
    }
}
#endif

@end
