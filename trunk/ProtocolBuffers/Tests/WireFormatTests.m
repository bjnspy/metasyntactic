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

#import "WireFormatTests.h"

#import "TestUtilities.h"
#import "Unittest.pb.h"
#import "UnittestMset.pb.h"

@implementation WireFormatTests

- (void) testSerialization {
    TestAllTypes* message = [TestUtilities allSet];

    NSData* rawBytes = message.data;
    STAssertTrue(rawBytes.length == message.serializedSize, @"");

    TestAllTypes* message2 = [TestAllTypes parseFromData:rawBytes];

    [TestUtilities assertAllFieldsSet:message2];
}


- (void) testSerializeExtensions {
    // TestAllTypes and TestAllExtensions should have compatible wire formats,
    // so if we serealize a TestAllExtensions then parse it as TestAllTypes
    // it should work.

    TestAllExtensions* message = [TestUtilities allExtensionsSet];
    NSData* rawBytes = message.data;
    STAssertTrue(rawBytes.length == message.serializedSize, @"");

    TestAllTypes* message2 = [TestAllTypes parseFromData:rawBytes];

    [TestUtilities assertAllFieldsSet:message2];
}


- (void) testParseExtensions {
    // TestAllTypes and TestAllExtensions should have compatible wire formats,
    // so if we serealize a TestAllTypes then parse it as TestAllExtensions
    // it should work.

    TestAllTypes* message = [TestUtilities allSet];
    NSData* rawBytes = message.data;

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

    while (YES) {
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
    NSData* data = [[[[[[[[TestFieldOrderings builder]
                          setMyInt:1]
                         setMyString:@"foo"]
                        setMyFloat:1.0]
                       setExtension:[UnittestRoot myExtensionInt] value:[NSNumber numberWithInt:23]]
                      setExtension:[UnittestRoot myExtensionString] value:@"bar"] build] data];
    [self assertFieldsInOrder:data];

    PBDescriptor* descriptor = [TestFieldOrderings descriptor];
    NSData* dynamic_data = [[[[[[[[PBDynamicMessage builderWithType:[TestFieldOrderings descriptor]]
                                  setField:[descriptor findFieldByName:@"my_int"] value:[NSNumber numberWithInt:1L]]
                                 setField:[descriptor findFieldByName:@"my_string"] value:@"foo"]
                                setField:[descriptor findFieldByName:@"my_float"] value:[NSNumber numberWithFloat:1.0]]
                               setField:[UnittestRoot myExtensionInt].descriptor value:[NSNumber numberWithInt:23]]
                              setField:[UnittestRoot myExtensionString].descriptor value:@"bar"] build] data];

    [self assertFieldsInOrder:dynamic_data];
}

const int UNKNOWN_TYPE_ID = 1550055;

- (void) testSerializeMessageSet {
    int32_t TYPE_ID_1 = [[[TestMessageSetExtension1 descriptor].extensions objectAtIndex:0] number];
    int32_t TYPE_ID_2 = [[[TestMessageSetExtension2 descriptor].extensions objectAtIndex:0] number];

    // Set up a TestMessageSet with two known messages and an unknown one.
    PBUnknownFieldSet* unknownFields =
    [[[PBUnknownFieldSet builder] addField:[[PBMutableField field] addLengthDelimited:[@"bar" dataUsingEncoding:NSUTF8StringEncoding]]
                                    forNumber:UNKNOWN_TYPE_ID] build];

    TestMessageSet* messageSet =
    (id)[[[[[TestMessageSet builder]
        setExtension:[TestMessageSetExtension1 messageSetExtension] value:[[[TestMessageSetExtension1 builder] setI:123] build]]
       setExtension:[TestMessageSetExtension2 messageSetExtension] value:[[[TestMessageSetExtension2 builder] setStr:@"foo"] build]]
      setUnknownFields:unknownFields] build];

    NSData* data = messageSet.data;

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
    [[[[[RawMessageSet builder]
         addItem:[[[[RawMessageSet_Item builder] setTypeId:TYPE_ID_1] setMessage:[[[[TestMessageSetExtension1 builder] setI:123] build] data]] build]]
        addItem:[[[[RawMessageSet_Item builder] setTypeId:TYPE_ID_2] setMessage:[[[[TestMessageSetExtension2 builder] setStr:@"foo"] build] data]] build]]
       addItem:[[[[RawMessageSet_Item builder] setTypeId:UNKNOWN_TYPE_ID] setMessage:[@"bar" dataUsingEncoding:NSUTF8StringEncoding]] build]]
      build];


    NSData* data = raw.data;

    // Parse as a TestMessageSet and check the contents.
    TestMessageSet* messageSet =
    [TestMessageSet parseFromData:data extensionRegistry:extensionRegistry];

    STAssertTrue(123 == [[messageSet getExtension:[TestMessageSetExtension1 messageSetExtension]] i], @"");
    STAssertEqualObjects(@"foo", [[messageSet getExtension:[TestMessageSetExtension2 messageSetExtension]] str], @"");

    // Check for unknown field with type LENGTH_DELIMITED,
    //   number UNKNOWN_TYPE_ID, and contents "bar".
    PBUnknownFieldSet* unknownFields = messageSet.unknownFields;
    STAssertTrue(1 == unknownFields.fields.count, @"");
    STAssertTrue([unknownFields hasField:UNKNOWN_TYPE_ID], @"");

    PBField* field = [unknownFields getField:UNKNOWN_TYPE_ID];
    STAssertTrue(1 == field.lengthDelimitedList.count, @"");
//    STAssertEqualObjects(@"bar", field.lengthDelimitedList().get(0).toStringUtf8());
}

@end