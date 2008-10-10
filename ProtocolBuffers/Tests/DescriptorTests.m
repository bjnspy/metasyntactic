//
//  DescriptorTests.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DescriptorTests.h"

#import "Unittest.pb.h"
#import "UnittestImport.pb.h"

@implementation DescriptorTests

- (void) testFileDescriptor {
    PBFileDescriptor* file = [UnittestProtoRoot descriptor];
    
    STAssertEqualObjects(@"google/protobuf/unittest.proto", file.name, @"");
    STAssertEqualObjects(@"protobuf_unittest", file.package, @"");
    
    STAssertEqualObjects(@"UnittestProto", file.options.javaOuterClassname, @"");
    STAssertEqualObjects(@"google/protobuf/unittest.proto", file.proto.name, @"");
    
    STAssertEqualObjects([NSArray arrayWithObject:[UnittestImportProtoRoot descriptor]],
                         file.dependencies, @"");
    
    PBDescriptor* messageType = [TestAllTypes descriptor];
    STAssertEqualObjects(messageType, [file.messageTypes objectAtIndex:0], @"");
    STAssertEqualObjects(messageType, [file findMessageTypeByName:@"TestAllTypes"], @"");
    STAssertNil([file findMessageTypeByName:@"NoSuchType"], @"");
    STAssertNil([file findMessageTypeByName:@"protobuf_unittest.TestAllTypes"], @"");
    for (int i = 0; i < file.messageTypes.count; i++) {
        STAssertTrue(i == [[file.messageTypes objectAtIndex:i] index], @"");
    }
    
    PBEnumDescriptor* enumType = [ForeignEnum descriptor];
    STAssertEqualObjects(enumType, [file.enumTypes objectAtIndex:0], @"");
    STAssertEqualObjects(enumType, [file findEnumTypeByName:@"ForeignEnum"], @"");
    STAssertNil([file findEnumTypeByName:@"NoSuchType"], @"");
    STAssertNil([file findEnumTypeByName:@"protobuf_unittest.ForeignEnum"], @"");
    STAssertEqualObjects([NSArray arrayWithObject:[ImportEnum descriptor]],
                         [[UnittestImportProtoRoot descriptor] enumTypes], @"");
    for (int i = 0; i < file.enumTypes.count; i++) {
        STAssertTrue(i == [[file.enumTypes objectAtIndex:i] index], @"");
    }
    
    PBServiceDescriptor* service = [TestService descriptor];
    STAssertEqualObjects(service, [file.services objectAtIndex:0], @"");
    STAssertEqualObjects(service, [file findServiceByName:@"TestService"], @"");
    STAssertNil([file findServiceByName:@"NoSuchType"], @"");
    STAssertNil([file findServiceByName:@"protobuf_unittest.TestService"], @"");
    STAssertEqualObjects([NSArray array],
                 [[UnittestImportProtoRoot descriptor] services], @"");
    for (int i = 0; i < file.services.count; i++) {
        STAssertTrue(i == [[file.services objectAtIndex:i] index], @"");
    }
    
    PBFieldDescriptor* extension =
    [[UnittestProtoRoot optionalInt32Extension] descriptor];
    STAssertEqualObjects(extension, [file.extensions objectAtIndex:0], @"");
    STAssertEqualObjects(extension,
                         [file findExtensionByName:@"optional_int32_extension"], @"");
    STAssertNil([file findExtensionByName:@"no_such_ext"], @"");
    STAssertNil([file findExtensionByName:@"protobuf_unittest.optional_int32_extension"], @"");
    STAssertEqualObjects([NSArray array],
                         [[UnittestImportProtoRoot descriptor] extensions], @"");
    for (int i = 0; i < file.extensions.count; i++) {
        STAssertTrue(i == [[file.extensions objectAtIndex:i] index], @"");
    }
}

#if 0
public void testDescriptor() throws Exception {
    PBDescriptor* messageType = [TestAllTypes descriptor];
    PBDescriptor* nestedType = TestAllTypes.NestedMessage.getDescriptor();
    
    STAssertEqualObjects(@"TestAllTypes", messageType.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes", messageType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), messageType.getFile());
    STAssertNil(messageType.getContainingType());
    STAssertEqualObjects(DescriptorProtos.MessageOptions.getDefaultInstance(),
                 messageType.getOptions());
    STAssertEqualObjects(@"TestAllTypes", messageType.toProto().getName());
    
    STAssertEqualObjects(@"NestedMessage", nestedType.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.NestedMessage",
                 nestedType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), nestedType.getFile());
    STAssertEqualObjects(messageType, nestedType.getContainingType());
    
    PBFieldDescriptor* field = messageType.getFields().get(0);
    STAssertEqualObjects(@"optional_int32", field.getName());
    STAssertEqualObjects(field, messageType.findFieldByName(@"optional_int32"));
    STAssertNil(messageType.findFieldByName(@"no_such_field"));
    STAssertEqualObjects(field, messageType.findFieldByNumber(1));
    STAssertNil(messageType.findFieldByNumber(571283));
    for (int i = 0; i < messageType.getFields().size(); i++) {
        STAssertEqualObjects(i, messageType.getFields().get(i).getIndex());
    }
    
    STAssertEqualObjects(nestedType, messageType.getNestedTypes().get(0));
    STAssertEqualObjects(nestedType, messageType.findNestedTypeByName(@"NestedMessage"));
    STAssertNil(messageType.findNestedTypeByName(@"NoSuchType"));
    for (int i = 0; i < messageType.getNestedTypes().size(); i++) {
        STAssertEqualObjects(i, messageType.getNestedTypes().get(i).getIndex());
    }
    
    PBEnumDescriptor* enumType = TestAllTypes.NestedEnum.getDescriptor();
    STAssertEqualObjects(enumType, messageType.enumTypes.get(0));
    STAssertEqualObjects(enumType, messageType.findEnumTypeByName(@"NestedEnum"));
    STAssertNil(messageType.findEnumTypeByName(@"NoSuchType"));
    for (int i = 0; i < messageType.enumTypes.size(); i++) {
        STAssertEqualObjects(i, messageType.enumTypes.get(i).getIndex());
    }
}

public void testFieldDescriptor() throws Exception {
    PBDescriptor* messageType = [TestAllTypes descriptor];
    PBFieldDescriptor* primitiveField =
    messageType.findFieldByName(@"optional_int32");
    PBFieldDescriptor* enumField =
    messageType.findFieldByName(@"optional_nested_enum");
    PBFieldDescriptor* messageField =
    messageType.findFieldByName(@"optional_foreign_message");
    PBFieldDescriptor* cordField =
    messageType.findFieldByName(@"optional_cord");
    PBFieldDescriptor* extension =
    UnittestProto.optionalInt32Extension.getDescriptor();
    PBFieldDescriptor* nestedExtension = TestRequired.single.getDescriptor();
    
    STAssertEqualObjects(@"optional_int32", primitiveField.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.optional_int32",
                 primitiveField.getFullName());
    STAssertEqualObjects(1, primitiveField.getNumber());
    STAssertEqualObjects(messageType, primitiveField.getContainingType());
    STAssertEqualObjects(UnittestProto.getDescriptor(), primitiveField.getFile());
    STAssertEqualObjects(PBFieldDescriptor*.Type.INT32, primitiveField.getType());
    STAssertEqualObjects(PBFieldDescriptor*.JavaType.INT, primitiveField.getJavaType());
    STAssertEqualObjects(DescriptorProtos.FieldOptions.getDefaultInstance(),
                 primitiveField.getOptions());
    assertFalse(primitiveField.isExtension());
    STAssertEqualObjects(@"optional_int32", primitiveField.toProto().getName());
    
    STAssertEqualObjects(@"optional_nested_enum", enumField.getName());
    STAssertEqualObjects(PBFieldDescriptor*.Type.ENUM, enumField.getType());
    STAssertEqualObjects(PBFieldDescriptor*.JavaType.ENUM, enumField.getJavaType());
    STAssertEqualObjects(TestAllTypes.NestedEnum.getDescriptor(),
                 enumField.getEnumType());
    
    STAssertEqualObjects(@"optional_foreign_message", messageField.getName());
    STAssertEqualObjects(PBFieldDescriptor*.Type.MESSAGE, messageField.getType());
    STAssertEqualObjects(PBFieldDescriptor*.JavaType.MESSAGE, messageField.getJavaType());
    STAssertEqualObjects(ForeignMessage.getDescriptor(), messageField.getMessageType());
    
    STAssertEqualObjects(@"optional_cord", cordField.getName());
    STAssertEqualObjects(PBFieldDescriptor*.Type.STRING, cordField.getType());
    STAssertEqualObjects(PBFieldDescriptor*.JavaType.STRING, cordField.getJavaType());
    STAssertEqualObjects(DescriptorProtos.FieldOptions.CType.CORD,
                 cordField.getOptions().getCtype());
    
    STAssertEqualObjects(@"optional_int32_extension", extension.getName());
    STAssertEqualObjects(@"protobuf_unittest.optional_int32_extension",
                 extension.getFullName());
    STAssertEqualObjects(1, extension.getNumber());
    STAssertEqualObjects(TestAllExtensions.getDescriptor(),
                 extension.getContainingType());
    STAssertEqualObjects(UnittestProto.getDescriptor(), extension.getFile());
    STAssertEqualObjects(PBFieldDescriptor*.Type.INT32, extension.getType());
    STAssertEqualObjects(PBFieldDescriptor*.JavaType.INT, extension.getJavaType());
    STAssertEqualObjects(DescriptorProtos.FieldOptions.getDefaultInstance(),
                 extension.getOptions());
    assertTrue(extension.isExtension());
    STAssertEqualObjects(null, extension.getExtensionScope());
    STAssertEqualObjects(@"optional_int32_extension", extension.toProto().getName());
    
    STAssertEqualObjects(@"single", nestedExtension.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestRequired.single",
                 nestedExtension.getFullName());
    STAssertEqualObjects(TestRequired.getDescriptor(),
                 nestedExtension.getExtensionScope());
}

public void testFieldDescriptorLabel() throws Exception {
    PBFieldDescriptor* requiredField =
    TestRequired.getDescriptor().findFieldByName(@"a");
    PBFieldDescriptor* optionalField =
    [TestAllTypes descriptor].findFieldByName(@"optional_int32");
    PBFieldDescriptor* repeatedField =
    [TestAllTypes descriptor].findFieldByName(@"repeated_int32");
    
    assertTrue(requiredField.isRequired());
    assertFalse(requiredField.isRepeated());
    assertFalse(optionalField.isRequired());
    assertFalse(optionalField.isRepeated());
    assertFalse(repeatedField.isRequired());
    assertTrue(repeatedField.isRepeated());
}

public void testFieldDescriptorDefault() throws Exception {
    PBDescriptor* d = [TestAllTypes descriptor];
    assertFalse(d.findFieldByName(@"optional_int32").hasDefaultValue());
    STAssertEqualObjects(0, d.findFieldByName(@"optional_int32").getDefaultValue());
    assertTrue(d.findFieldByName(@"default_int32").hasDefaultValue());
    STAssertEqualObjects(41, d.findFieldByName(@"default_int32").getDefaultValue());
    
    d = TestExtremeDefaultValues.getDescriptor();
    STAssertEqualObjects(
                 ByteString.copyFrom(
                                     "\0\001\007\b\f\n\r\t\013\\\'\"\u00fe".getBytes(@"ISO-8859-1")),
                 d.findFieldByName(@"escaped_bytes").getDefaultValue());
    STAssertEqualObjects(-1, d.findFieldByName(@"large_uint32").getDefaultValue());
    STAssertEqualObjects(-1L, d.findFieldByName(@"large_uint64").getDefaultValue());
}

public void testEnumDescriptor() throws Exception {
    PBEnumDescriptor* enumType = ForeignEnum.getDescriptor();
    PBEnumDescriptor* nestedType = TestAllTypes.NestedEnum.getDescriptor();
    
    STAssertEqualObjects(@"ForeignEnum", enumType.getName());
    STAssertEqualObjects(@"protobuf_unittest.ForeignEnum", enumType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), enumType.getFile());
    STAssertNil(enumType.getContainingType());
    STAssertEqualObjects(DescriptorProtos.EnumOptions.getDefaultInstance(),
                 enumType.getOptions());
    
    STAssertEqualObjects(@"NestedEnum", nestedType.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.NestedEnum",
                 nestedType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), nestedType.getFile());
    STAssertEqualObjects([TestAllTypes descriptor], nestedType.getContainingType());
    
    EnumValueDescriptor value = ForeignEnum.FOREIGN_FOO.getValueDescriptor();
    STAssertEqualObjects(value, enumType.getValues().get(0));
    STAssertEqualObjects(@"FOREIGN_FOO", value.getName());
    STAssertEqualObjects(4, value.getNumber());
    STAssertEqualObjects(value, enumType.findValueByName(@"FOREIGN_FOO"));
    STAssertEqualObjects(value, enumType.findValueByNumber(4));
    STAssertNil(enumType.findValueByName(@"NO_SUCH_VALUE"));
    for (int i = 0; i < enumType.getValues().size(); i++) {
        STAssertEqualObjects(i, enumType.getValues().get(i).getIndex());
    }
}

public void testServiceDescriptor() throws Exception {
    PBServiceDescriptor* service = TestService.getDescriptor();
    
    STAssertEqualObjects(@"TestService", service.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestService", service.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), service.getFile());
    
    STAssertEqualObjects(2, service.getMethods().size());
    
    MethodDescriptor fooMethod = service.getMethods().get(0);
    STAssertEqualObjects(@"Foo", fooMethod.getName());
    STAssertEqualObjects(UnittestProto.FooRequest.getDescriptor(),
                 fooMethod.getInputType());
    STAssertEqualObjects(UnittestProto.FooResponse.getDescriptor(),
                 fooMethod.getOutputType());
    STAssertEqualObjects(fooMethod, service.findMethodByName(@"Foo"));
    
    MethodDescriptor barMethod = service.getMethods().get(1);
    STAssertEqualObjects(@"Bar", barMethod.getName());
    STAssertEqualObjects(UnittestProto.BarRequest.getDescriptor(),
                 barMethod.getInputType());
    STAssertEqualObjects(UnittestProto.BarResponse.getDescriptor(),
                 barMethod.getOutputType());
    STAssertEqualObjects(barMethod, service.findMethodByName(@"Bar"));
    
    STAssertNil(service.findMethodByName(@"NoSuchMethod"));
    
    for (int i = 0; i < service.getMethods().size(); i++) {
        STAssertEqualObjects(i, service.getMethods().get(i).getIndex());
    }
}


#endif

@end
