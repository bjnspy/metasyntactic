//
//  MessageTest.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MessageTests.h"

#import "Unittest.pb.h"

@implementation MessageTests

- (TestAllTypes*) mergeSource {
    return [[[[[[TestAllTypes_Builder builder]
                setOptionalInt32:1]
               setOptionalString:@"foo"]
              setOptionalForeignMessage:[ForeignMessage defaultInstance]]
             addRepeatedString:@"bar"]
            build];
}


- (TestAllTypes*) mergeDestination {
    return [[[[[[TestAllTypes_Builder builder]
                setOptionalInt64:2]
               setOptionalString:@"baz"]
              setOptionalForeignMessage:[[[ForeignMessage_Builder builder] setC:3] build]]
             addRepeatedString:@"qux"]
            build];
}


- (TestAllTypes*) mergeResult {
    return [[[[[[[[TestAllTypes_Builder builder]
                  setOptionalInt32:1]
                 setOptionalInt64:2]
                setOptionalString:@"foo"]
               setOptionalForeignMessage:[[[ForeignMessage_Builder builder] setC:3] build]]
              addRepeatedString:@"qux"]
             addRepeatedString:@"bar"]
            build];
}


- (void) testMergeFrom {
    TestAllTypes* result =
    [[[TestAllTypes_Builder builderWithPrototype:self.mergeDestination]
      mergeFromTestAllTypes:self.mergeSource] build];
    
    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}


/**
 * Test merging a DynamicMessage into a GeneratedMessage.  As long as they
 * have the same descriptor, this should work, but it is an entirely different
 * code path.
 */
- (void) testMergeFromDynamic {
    TestAllTypes* result = [[[TestAllTypes_Builder builderWithPrototype:self.mergeDestination]
                             mergeFromMessage:[[PBDynamicMessage builderWithMessage:self.mergeSource] build]]
                            build];
    
    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}


/** Test merging two DynamicMessages. */
- (void) testDynamicMergeFrom {
    PBDynamicMessage* result =
    [[[PBDynamicMessage builderWithMessage:self.mergeDestination]
      mergeFromMessage:[[PBDynamicMessage builderWithMessage:self.mergeSource] build]]
     build];
    
    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}

// =================================================================
// Required-field-related tests.

- (TestRequired*) testRequiredUninitialized {
    return [TestRequired defaultInstance];
}


- (TestRequired*) testRequiredInitialized {
    return [[[[[TestRequired_Builder builder] setA:1] setB:2] setC:3] build];
}


- (void) testRequired {
    TestRequired_Builder* builder = [TestRequired_Builder builder];
    
    STAssertFalse(builder.isInitialized, @"");
    [builder setA:1];
    STAssertFalse(builder.isInitialized, @"");
    [builder setB:1];
    STAssertFalse(builder.isInitialized, @"");
    [builder setC:1];
    STAssertTrue(builder.isInitialized, @"");
}


- (void) testRequiredForeign {
    TestRequiredForeign_Builder* builder = [TestRequiredForeign_Builder builder];
    
    STAssertTrue(builder.isInitialized, @"");
    
    [builder setOptionalMessage:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setOptionalMessage:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
    
    [builder addRepeatedMessage:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder replaceRepeatedMessageAtIndex:0 withRepeatedMessage:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
}


- (void) testRequiredExtension {
    TestAllExtensions_Builder* builder = [TestAllExtensions_Builder builder];
    
    STAssertTrue(builder.isInitialized, @"");
    
    [builder setExtension:[TestRequired single] value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setExtension:[TestRequired single] value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
    
    [builder addExtension:[TestRequired multi] value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setExtension:[TestRequired multi] index:0 value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
}
     

- (void) testRequiredDynamic {
    PBDescriptor* descriptor = [TestRequired descriptor];
    PBDynamicMessage_Builder* builder = [PBDynamicMessage_Builder builderWithType:descriptor];
    
    STAssertFalse(builder.isInitialized, @"");
    [builder setField:[descriptor findFieldByName:@"a"] value:[NSNumber numberWithInt:1]];
    STAssertFalse(builder.isInitialized, @"");
    [builder setField:[descriptor findFieldByName:@"b"] value:[NSNumber numberWithInt:1]];
    STAssertFalse(builder.isInitialized, @"");
    [builder setField:[descriptor findFieldByName:@"c"] value:[NSNumber numberWithInt:1]];
    STAssertTrue(builder.isInitialized, @"");
}
     

- (void) testRequiredDynamicForeign {
    PBDescriptor* descriptor = [TestRequiredForeign descriptor];
    PBDynamicMessage_Builder* builder = [PBDynamicMessage_Builder builderWithType:descriptor];
    
    STAssertTrue(builder.isInitialized, @"");
    
    [builder setField:[descriptor findFieldByName:@"optional_message"]
                value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setField:[descriptor findFieldByName:@"optional_message"]
                value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
    
    [builder addRepeatedField:[descriptor findFieldByName:@"repeated_message"]
                        value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setRepeatedField:[descriptor findFieldByName:@"repeated_message"]
                        index:0
                        value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
}

     
     #if 0
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
        .setOptionalMessageself.testRequiredUninitialized
        .addRepeatedMessageself.testRequiredUninitialized
        .addRepeatedMessageself.testRequiredUninitialized
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
    .setOptionalMessageself.testRequiredUninitialized
    .addRepeatedMessageself.testRequiredUninitialized
    .addRepeatedMessageself.testRequiredUninitialized
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
    .setOptionalMessageself.testRequiredUninitialized
    .addRepeatedMessageself.testRequiredUninitialized
    .addRepeatedMessageself.testRequiredUninitialized
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
