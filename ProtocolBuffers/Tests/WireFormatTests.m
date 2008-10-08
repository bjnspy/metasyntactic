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
#import "UnittestMset.pb.h"

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

const int UNKNOWN_TYPE_ID = 1550055; 

- (void) testSerializeMessageSet {
    int32_t TYPE_ID_1 = [[[TestMessageSetExtension1 descriptor].extensions objectAtIndex:0] number];
    int32_t TYPE_ID_2 = [[[TestMessageSetExtension2 descriptor].extensions objectAtIndex:0] number];
    
    // Set up a TestMessageSet with two known messages and an unknown one.
    PBUnknownFieldSet* unknownFields =
    [[[PBUnknownFieldSet newBuilder] addField:[[PBMutableField field] addLengthDelimited:[@"bar" dataUsingEncoding:NSUTF8StringEncoding]]
                                    forNumber:UNKNOWN_TYPE_ID] build];
    
    TestMessageSet* messageSet =
    (id)[[[[[TestMessageSet newBuilder]
        setExtension:[TestMessageSetExtension1 messageSetExtension] value:[[[TestMessageSetExtension1 newBuilder] setI:123] build]]
       setExtension:[TestMessageSetExtension2 messageSetExtension] value:[[[TestMessageSetExtension2 newBuilder] setStr:@"foo"] build]]
      setUnknownFields:unknownFields] build];

    NSData* data = messageSet.toData;
    
    // Parse back using RawMessageSet and check the contents.
    RawMessageSet* raw = [RawMessageSet parseFromData:data];
    
    STAssertTrue(raw.unknownFields.fields.count == 0, @"");
    STAssertTrue(3 == raw.itemList.count, @"");
    STAssertTrue(TYPE_ID_1 == [raw itemAtIndex:0].typeId, @"");
    STAssertTrue(TYPE_ID_2 == [raw itemAtIndex:1].typeId, @"");
    STAssertTrue(UNKNOWN_TYPE_ID == [raw itemAtIndex:2].typeId, @"");
    
    TestMessageSetExtension1* message1 =
    [TestMessageSetExtension1 parseFromData:[raw itemAtIndex:0].message];
    STAssertTrue(123 == message1.i, @"");
    
    TestMessageSetExtension2* message2 =
    [TestMessageSetExtension2 parseFromData:[raw itemAtIndex:1].message];
    STAssertEqualObjects(@"foo", message2.str, @"");
//    STAssertEqualObjects(@"bar", [raw itemAtIndex:2].message. .getItem(2).getMessage().toStringUtf8());
}


- (void) testParseMessageSet {
    int32_t TYPE_ID_1 = [[[TestMessageSetExtension1 descriptor].extensions objectAtIndex:0] number];
    int32_t TYPE_ID_2 = [[[TestMessageSetExtension2 descriptor].extensions objectAtIndex:0] number];
    
    PBExtensionRegistry* extensionRegistry = [PBExtensionRegistry registry];
    [extensionRegistry addExtension:[TestMessageSetExtension1 messageSetExtension]];
    [extensionRegistry addExtension:[TestMessageSetExtension2 messageSetExtension]];
    
    // Set up a RawMessageSet with two known messages and an unknown one.
    RawMessageSet* raw =
    [[[[[RawMessageSet newBuilder]
         addItem:[[[[RawMessageSet_Item newBuilder] setTypeId:TYPE_ID_1] setMessage:[[[[TestMessageSetExtension1 newBuilder] setI:123] build] toData]] build]]
        addItem:[[[[RawMessageSet_Item newBuilder] setTypeId:TYPE_ID_2] setMessage:[[[[TestMessageSetExtension2 newBuilder] setStr:@"foo"] build] toData]] build]]
       addItem:[[[[RawMessageSet_Item newBuilder] setTypeId:UNKNOWN_TYPE_ID] setMessage:[@"bar" dataUsingEncoding:NSUTF8StringEncoding]] build]]
      build];
       
/*    
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
 */
}

@end
