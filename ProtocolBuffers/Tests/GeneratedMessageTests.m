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

#import "GeneratedMessageTests.h"

#import "Unittest.pb.h"
#import "TestUtilities.h"

@implementation GeneratedMessageTests

- (void) testDefaultInstance {
    STAssertTrue([TestAllTypes defaultInstance] ==
               [[TestAllTypes defaultInstance] defaultInstance], @"");
    STAssertTrue([TestAllTypes defaultInstance] ==
               [[TestAllTypes builder] defaultInstance], @"");
}


- (void) testAccessors {
    TestAllTypes_Builder* builder = [TestAllTypes builder];
    [TestUtilities setAllFields:builder];
    TestAllTypes* message = [builder build];
    [TestUtilities assertAllFieldsSet:message];
}


- (void) testRepeatedSetters {
    TestAllTypes_Builder* builder = [TestAllTypes builder];
    [TestUtilities setAllFields:builder];
    
    [TestUtilities modifyRepeatedFields:builder];
    TestAllTypes* message = [builder build];
    [TestUtilities assertRepeatedFieldsModified:message];
}


- (void) testRepeatedAppend {
    TestAllTypes_Builder* builder = [TestAllTypes builder];
    
    NSArray* array = 
    [NSArray arrayWithObjects:
     [NSNumber numberWithInt:1],
     [NSNumber numberWithInt:2],
     [NSNumber numberWithInt:3],
     [NSNumber numberWithInt:4], nil];
    
    [builder addAllRepeatedInt32:array];
    [builder addAllRepeatedForeignEnum:[NSArray arrayWithObject:[ForeignEnum FOREIGN_BAZ]]];
    
    ForeignMessage* foreignMessage = [[[ForeignMessage builder] setC:12] build];
    [builder addAllRepeatedForeignMessage:[NSArray arrayWithObject:foreignMessage]];
    
    TestAllTypes* message = [builder build];
    STAssertEqualObjects(message.repeatedInt32List, array, @"");
    STAssertEqualObjects(message.repeatedForeignEnumList,
                 [NSArray arrayWithObject:[ForeignEnum FOREIGN_BAZ]], @"");
    STAssertTrue(1 == message.repeatedForeignMessageList.count, @"");
    STAssertTrue(12 == [[message repeatedForeignMessageAtIndex:0] c], @"");
}

#if 0


[TestUtilities ReflectionTester reflectionTester =
new [TestUtilities ReflectionTester(TestAllTypes.getDescriptor(), null);





public void testSettingForeignMessageUsingBuilder() throws Exception {
    TestAllTypes message = [TestAllTypes builder]
    // Pass builder for foreign message instance.
    .setOptionalForeignMessage(ForeignMessage.newBuilder().setC(123))
    .build();
    TestAllTypes expectedMessage = [TestAllTypes builder]
    // Create expected version passing foreign message instance explicitly.
    .setOptionalForeignMessage(
                               ForeignMessage.newBuilder().setC(123).build())
    .build();
    // TODO(ngd): Upgrade to using real #equals method once implemented
    assertEquals(expectedMessage.toString(), message.toString());
}

public void testSettingRepeatedForeignMessageUsingBuilder() throws Exception {
    TestAllTypes message = [TestAllTypes builder]
    // Pass builder for foreign message instance.
    .addRepeatedForeignMessage(ForeignMessage.newBuilder().setC(456))
    .build();
    TestAllTypes expectedMessage = [TestAllTypes builder]
    // Create expected version passing foreign message instance explicitly.
    .addRepeatedForeignMessage(
                               ForeignMessage.newBuilder().setC(456).build())
    .build();
    assertEquals(expectedMessage.toString(), message.toString());
}

public void testDefaults() throws Exception {
    [TestUtilities assertClear([TestAllTypes defaultInstance]);
    [TestUtilities assertClear([TestAllTypes builder].build());
    
    assertEquals("\u1234",
                 TestExtremeDefaultValues.getDefaultInstance().getUtf8String());
}

public void testReflectionGetters() throws Exception {
    TestAllTypes_Builder builder = [TestAllTypes builder];
    [TestUtilities setAllFields(builder);
    TestAllTypes message = builder.build();
    reflectionTester.assertAllFieldsSetViaReflection(message);
}

public void testReflectionSetters() throws Exception {
    TestAllTypes_Builder builder = [TestAllTypes builder];
    reflectionTester.setAllFieldsViaReflection(builder);
    TestAllTypes message = builder.build();
    [TestUtilities assertAllFieldsSet(message);
}

public void testReflectionRepeatedSetters() throws Exception {
    TestAllTypes_Builder builder = [TestAllTypes builder];
    reflectionTester.setAllFieldsViaReflection(builder);
    reflectionTester.modifyRepeatedFieldsViaReflection(builder);
    TestAllTypes message = builder.build();
    [TestUtilities assertRepeatedFieldsModified(message);
}

public void testReflectionDefaults() throws Exception {
    reflectionTester.assertClearViaReflection(
                                              [TestAllTypes defaultInstance]);
    reflectionTester.assertClearViaReflection(
                                              [TestAllTypes builder].build());
}

// =================================================================
// Extensions.

[TestUtilities ReflectionTester extensionsReflectionTester =
new [TestUtilities ReflectionTester(TestAllExtensions.getDescriptor(),
                              [TestUtilities getExtensionRegistry());

public void testExtensionAccessors() throws Exception {
    TestAllExtensions.Builder builder = TestAllExtensions.newBuilder();
    [TestUtilities setAllExtensions(builder);
    TestAllExtensions message = builder.build();
    [TestUtilities assertAllExtensionsSet(message);
}

public void testExtensionRepeatedSetters() throws Exception {
    TestAllExtensions.Builder builder = TestAllExtensions.newBuilder();
    [TestUtilities setAllExtensions(builder);
    [TestUtilities modifyRepeatedExtensions(builder);
    TestAllExtensions message = builder.build();
    [TestUtilities assertRepeatedExtensionsModified(message);
}

public void testExtensionDefaults() throws Exception {
    [TestUtilities assertExtensionsClear(TestAllExtensions.getDefaultInstance());
    [TestUtilities assertExtensionsClear(TestAllExtensions.newBuilder().build());
}

public void testExtensionReflectionGetters() throws Exception {
    TestAllExtensions.Builder builder = TestAllExtensions.newBuilder();
    [TestUtilities setAllExtensions(builder);
    TestAllExtensions message = builder.build();
    extensionsReflectionTester.assertAllFieldsSetViaReflection(message);
}

public void testExtensionReflectionSetters() throws Exception {
    TestAllExtensions.Builder builder = TestAllExtensions.newBuilder();
    extensionsReflectionTester.setAllFieldsViaReflection(builder);
    TestAllExtensions message = builder.build();
    [TestUtilities assertAllExtensionsSet(message);
}

public void testExtensionReflectionRepeatedSetters() throws Exception {
    TestAllExtensions.Builder builder = TestAllExtensions.newBuilder();
    extensionsReflectionTester.setAllFieldsViaReflection(builder);
    extensionsReflectionTester.modifyRepeatedFieldsViaReflection(builder);
    TestAllExtensions message = builder.build();
    [TestUtilities assertRepeatedExtensionsModified(message);
}

public void testExtensionReflectionDefaults() throws Exception {
    extensionsReflectionTester.assertClearViaReflection(
                                                        TestAllExtensions.getDefaultInstance());
    extensionsReflectionTester.assertClearViaReflection(
                                                        TestAllExtensions.newBuilder().build());
}

public void testClearExtension() throws Exception {
    // clearExtension() is not actually used in TestUtil, so try it manually.
    assertFalse(
                TestAllExtensions.newBuilder()
                .setExtension(UnittestProto.optionalInt32Extension, 1)
                .clearExtension(UnittestProto.optionalInt32Extension)
                .hasExtension(UnittestProto.optionalInt32Extension));
    assertEquals(0,
                 TestAllExtensions.newBuilder()
                 .addExtension(UnittestProto.repeatedInt32Extension, 1)
                 .clearExtension(UnittestProto.repeatedInt32Extension)
                 .getExtensionCount(UnittestProto.repeatedInt32Extension));
}

// =================================================================
// multiple_files_test

public void testMultipleFilesOption() throws Exception {
    // We mostly just want to check that things compile.
    MessageWithNoOuter message =
    MessageWithNoOuter.newBuilder()
    .setNested(MessageWithNoOuter.NestedMessage.newBuilder().setI(1))
    .addForeign([TestAllTypes builder].setOptionalInt32(1))
    .setNestedEnum(MessageWithNoOuter.NestedEnum.BAZ)
    .setForeignEnum(EnumWithNoOuter.BAR)
    .build();
    assertEquals(message, MessageWithNoOuter.parseFrom(message.toByteString()));
    
    assertEquals(MultipleFilesTestProto.getDescriptor(),
                 MessageWithNoOuter.getDescriptor().getFile());
    
    Descriptors.FieldDescriptor field =
    MessageWithNoOuter.getDescriptor().findFieldByName("foreign_enum");
    assertEquals(EnumWithNoOuter.BAR.getValueDescriptor(),
                 message.getField(field));
    
    assertEquals(MultipleFilesTestProto.getDescriptor(),
                 ServiceWithNoOuter.getDescriptor().getFile());
    
    assertFalse(
                TestAllExtensions.getDefaultInstance().hasExtension(
                                                                    MultipleFilesTestProto.extensionWithOuter));
}
#endif

@end