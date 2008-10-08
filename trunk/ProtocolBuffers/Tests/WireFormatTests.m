//
//  WireFormatTests.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WireFormatTests.h"

//#import "CodedInputStream.h"
#import "TestUtilities.h"
#import "Unittest.pb.h"

@implementation WireFormatTests

- (void) testSerialization {
    TestAllTypes* message = [TestUtilities allSet];
    
    NSData* rawBytes = message.toData;
    STAssertTrue(rawBytes.length == message.serializedSize, @"");
    
    TestAllTypes* message2 = [TestAllTypes parseFromData:rawBytes];
    
    [TestUtilities assertAllFieldsSet:message2];
}


- (void) testSerializeExtensions {
    // TestAllTypes and TestAllExtensions should have compatible wire formats,
    // so if we serealize a TestAllExtensions then parse it as TestAllTypes
    // it should work.
    
    TestAllExtensions* message = [TestUtilities allExtensionsSet];
    NSData* rawBytes = message.toData;
    STAssertTrue(rawBytes.length == message.serializedSize, @"");
    
    TestAllTypes* message2 = [TestAllTypes parseFromData:rawBytes];
    
    [TestUtilities assertAllFieldsSet:message2];
}


- (void) testParseExtensions {
    // TestAllTypes and TestAllExtensions should have compatible wire formats,
    // so if we serealize a TestAllTypes then parse it as TestAllExtensions
    // it should work.
    
    TestAllTypes* message = [TestUtilities allSet];
    NSData* rawBytes = message.toData;
    
    PBExtensionRegistry* registry = [PBExtensionRegistry registry];
    [TestUtilities registerAllExtensions:registry];
    
    TestAllExtensions* message2 =
    [TestAllExtensions parseFromData:rawBytes extensionRegistry:registry];
    
    [TestUtilities assertAllExtensionsSet:message2];
}


- (void) testExtensionsSerializedSize {
    STAssertTrue([TestUtilities allSet].serializedSize == [TestUtilities allExtensionsSet].serializedSize, @"");
}


- (void) assertFieldsInOrder:(NSData*) data {
    PBCodedInputStream* input = [PBCodedInputStream streamWithData:data];
    int32_t previousTag = 0;
    
    while (true) {
        int32_t tag = [input readTag];
        if (tag == 0) {
            break;
        }
        
        STAssertTrue(tag > previousTag, @"");
        [input skipField:tag];
    }
}


- (void) testInterleavedFieldsAndExtensions {
    // Tests that fields are written in order even when extension ranges
    // are interleaved with field numbers.
    NSData* data = [[[[[[[[TestFieldOrderings newBuilder]
                          setMyInt:1]
                         setMyString:@"foo"]
                        setMyFloat:1.0]
                       setExtension:[UnittestProtoRoot myExtensionInt] value:[NSNumber numberWithInt:23]] 
                      setExtension:[UnittestProtoRoot myExtensionString] value:@"bar"] build] toData];
    [self assertFieldsInOrder:data];
    
    PBDescriptor* descriptor = [TestFieldOrderings descriptor];
    NSData* dynamic_data = [[[[[[[[PBDynamicMessage builderWithType:[TestFieldOrderings descriptor]]
                                  setField:[descriptor findFieldByName:@"my_int"] value:[NSNumber numberWithInt:1L]]
                                 setField:[descriptor findFieldByName:@"my_string"] value:@"foo"]
                                setField:[descriptor findFieldByName:@"my_float"] value:[NSNumber numberWithFloat:1.0]]
                               setField:[UnittestProtoRoot myExtensionInt].descriptor value:[NSNumber numberWithInt:23]]
                              setField:[UnittestProtoRoot myExtensionString].descriptor value:@"bar"] build] toData];
    
    [self assertFieldsInOrder:dynamic_data];
}

#if 0




private static final int UNKNOWN_TYPE_ID = 1550055;
private static final int TYPE_ID_1 =
TestMessageSetExtension1.getDescriptor().getExtensions().get(0).getNumber();
private static final int TYPE_ID_2 =
TestMessageSetExtension2.getDescriptor().getExtensions().get(0).getNumber();

public void testSerializeMessageSet() throws Exception {
    // Set up a TestMessageSet with two known messages and an unknown one.
    TestMessageSet messageSet =
    TestMessageSet.newBuilder()
    .setExtension(
                  TestMessageSetExtension1.messageSetExtension,
                  TestMessageSetExtension1.newBuilder().setI(123).build())
    .setExtension(
                  TestMessageSetExtension2.messageSetExtension,
                  TestMessageSetExtension2.newBuilder().setStr("foo").build())
    .setUnknownFields(
                      UnknownFieldSet.newBuilder()
                      .addField(UNKNOWN_TYPE_ID,
                                UnknownFieldSet.Field.newBuilder()
                                .addLengthDelimited(ByteString.copyFromUtf8("bar"))
                                .build())
                      .build())
    .build();
    
    ByteString data = messageSet.toByteString();
    
    // Parse back using RawMessageSet and check the contents.
    RawMessageSet raw = RawMessageSet.parseFrom(data);
    
    assertTrue(raw.getUnknownFields().asMap().isEmpty());
    
    assertEquals(3, raw.getItemCount());
    assertEquals(TYPE_ID_1, raw.getItem(0).getTypeId());
    assertEquals(TYPE_ID_2, raw.getItem(1).getTypeId());
    assertEquals(UNKNOWN_TYPE_ID, raw.getItem(2).getTypeId());
    
    TestMessageSetExtension1 message1 =
    TestMessageSetExtension1.parseFrom(
                                       raw.getItem(0).getMessage().toByteArray());
    assertEquals(123, message1.getI());
    
    TestMessageSetExtension2 message2 =
    TestMessageSetExtension2.parseFrom(
                                       raw.getItem(1).getMessage().toByteArray());
    assertEquals("foo", message2.getStr());
    
    assertEquals("bar", raw.getItem(2).getMessage().toStringUtf8());
}

public void testParseMessageSet() throws Exception {
    ExtensionRegistry extensionRegistry = ExtensionRegistry.newInstance();
    extensionRegistry.add(TestMessageSetExtension1.messageSetExtension);
    extensionRegistry.add(TestMessageSetExtension2.messageSetExtension);
    
    // Set up a RawMessageSet with two known messages and an unknown one.
    RawMessageSet raw =
    RawMessageSet.newBuilder()
    .addItem(
             RawMessageSet.Item.newBuilder()
             .setTypeId(TYPE_ID_1)
             .setMessage(
                         TestMessageSetExtension1.newBuilder()
                         .setI(123)
                         .build().toByteString())
             .build())
    .addItem(
             RawMessageSet.Item.newBuilder()
             .setTypeId(TYPE_ID_2)
             .setMessage(
                         TestMessageSetExtension2.newBuilder()
                         .setStr("foo")
                         .build().toByteString())
             .build())
    .addItem(
             RawMessageSet.Item.newBuilder()
             .setTypeId(UNKNOWN_TYPE_ID)
             .setMessage(ByteString.copyFromUtf8("bar"))
             .build())
    .build();
    
    ByteString data = raw.toByteString();
    
    // Parse as a TestMessageSet and check the contents.
    TestMessageSet messageSet =
    TestMessageSet.parseFrom(data, extensionRegistry);
    
    assertEquals(123, messageSet.getExtension(
                                              TestMessageSetExtension1.messageSetExtension).getI());
    assertEquals("foo", messageSet.getExtension(
                                                TestMessageSetExtension2.messageSetExtension).getStr());
    
    // Check for unknown field with type LENGTH_DELIMITED,
    //   number UNKNOWN_TYPE_ID, and contents "bar".
    UnknownFieldSet unknownFields = messageSet.getUnknownFields();
    assertEquals(1, unknownFields.asMap().size());
    assertTrue(unknownFields.hasField(UNKNOWN_TYPE_ID));
    
    UnknownFieldSet.Field field = unknownFields.getField(UNKNOWN_TYPE_ID);
    assertEquals(1, field.getLengthDelimitedList().size());
    assertEquals("bar", field.getLengthDelimitedList().get(0).toStringUtf8());
}
#endif

@end
