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


- (void) testClearExtension {
    // clearExtension() is not actually used in TestUtil, so try it manually.
    PBExtendableBuilder* builder1 =
    [[TestAllExtensions builder]
     setExtension:[UnittestProtoRoot optionalInt32Extension] value:[NSNumber numberWithInt:1]];
    
    STAssertTrue([builder1 hasExtension:[UnittestProtoRoot optionalInt32Extension]], @"");
    [builder1 clearExtension:[UnittestProtoRoot optionalInt32Extension]];
    STAssertFalse([builder1 hasExtension:[UnittestProtoRoot optionalInt32Extension]], @"");
    
    PBExtendableBuilder* builder2 =
    [[TestAllExtensions builder]
     addExtension:[UnittestProtoRoot repeatedInt32Extension] value:[NSNumber numberWithInt:1]];
    
    STAssertTrue(1 == [[builder2 getExtension:[UnittestProtoRoot repeatedInt32Extension]] count], @"");
    [builder2 clearExtension:[UnittestProtoRoot repeatedInt32Extension]];
    STAssertTrue(0 == [[builder2 getExtension:[UnittestProtoRoot repeatedInt32Extension]] count], @"");
}


- (void) testExtensionAccessors {
    TestAllExtensions_Builder* builder = [TestAllExtensions builder];
    [TestUtilities setAllExtensions:builder];
    TestAllExtensions* message = [builder build];
    [TestUtilities assertAllExtensionsSet:message];
}


- (void) testExtensionRepeatedSetters {
    TestAllExtensions_Builder* builder = [TestAllExtensions builder];
    [TestUtilities setAllExtensions:builder];
    [TestUtilities modifyRepeatedExtensions:builder];
    TestAllExtensions* message = [builder build];
    [TestUtilities assertRepeatedExtensionsModified:message];
}


- (void) testExtensionDefaults {
    [TestUtilities assertExtensionsClear:[TestAllExtensions defaultInstance]];
    [TestUtilities assertExtensionsClear:[[TestAllExtensions builder] build]];
}

#if 0


[TestUtilities ReflectionTester reflectionTester =
 new [TestUtilities ReflectionTester(TestAllTypes.getDescriptor(), null);
 
 
 
 
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