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
    
#if 0
    Descriptor messageType = TestAllTypes.getDescriptor();
    STAssertEqualObjects(messageType, file.getMessageTypes().get(0));
    STAssertEqualObjects(messageType, file.findMessageTypeByName(@"TestAllTypes"));
    assertNull(file.findMessageTypeByName(@"NoSuchType"));
    assertNull(file.findMessageTypeByName(@"protobuf_unittest.TestAllTypes"));
    for (int i = 0; i < file.getMessageTypes().size(); i++) {
        STAssertEqualObjects(i, file.getMessageTypes().get(i).getIndex());
    }
    
    EnumDescriptor enumType = ForeignEnum.getDescriptor();
    STAssertEqualObjects(enumType, file.getEnumTypes().get(0));
    STAssertEqualObjects(enumType, file.findEnumTypeByName(@"ForeignEnum"));
    assertNull(file.findEnumTypeByName(@"NoSuchType"));
    assertNull(file.findEnumTypeByName(@"protobuf_unittest.ForeignEnum"));
    STAssertEqualObjects(Arrays.asList(ImportEnum.getDescriptor()),
                 UnittestImport.getDescriptor().getEnumTypes());
    for (int i = 0; i < file.getEnumTypes().size(); i++) {
        STAssertEqualObjects(i, file.getEnumTypes().get(i).getIndex());
    }
    
    ServiceDescriptor service = TestService.getDescriptor();
    STAssertEqualObjects(service, file.getServices().get(0));
    STAssertEqualObjects(service, file.findServiceByName(@"TestService"));
    assertNull(file.findServiceByName(@"NoSuchType"));
    assertNull(file.findServiceByName(@"protobuf_unittest.TestService"));
    STAssertEqualObjects(Collections.emptyList(),
                 UnittestImport.getDescriptor().getServices());
    for (int i = 0; i < file.getServices().size(); i++) {
        STAssertEqualObjects(i, file.getServices().get(i).getIndex());
    }
    
    FieldDescriptor extension =
    UnittestProto.optionalInt32Extension.getDescriptor();
    STAssertEqualObjects(extension, file.getExtensions().get(0));
    STAssertEqualObjects(extension,
                 file.findExtensionByName(@"optional_int32_extension"));
    assertNull(file.findExtensionByName(@"no_such_ext"));
    assertNull(file.findExtensionByName(
                                        "protobuf_unittest.optional_int32_extension"));
    STAssertEqualObjects(Collections.emptyList(),
                 UnittestImport.getDescriptor().getExtensions());
    for (int i = 0; i < file.getExtensions().size(); i++) {
        STAssertEqualObjects(i, file.getExtensions().get(i).getIndex());
    }
#endif
}

#if 0
public void testDescriptor() throws Exception {
    Descriptor messageType = TestAllTypes.getDescriptor();
    Descriptor nestedType = TestAllTypes.NestedMessage.getDescriptor();
    
    STAssertEqualObjects(@"TestAllTypes", messageType.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes", messageType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), messageType.getFile());
    assertNull(messageType.getContainingType());
    STAssertEqualObjects(DescriptorProtos.MessageOptions.getDefaultInstance(),
                 messageType.getOptions());
    STAssertEqualObjects(@"TestAllTypes", messageType.toProto().getName());
    
    STAssertEqualObjects(@"NestedMessage", nestedType.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.NestedMessage",
                 nestedType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), nestedType.getFile());
    STAssertEqualObjects(messageType, nestedType.getContainingType());
    
    FieldDescriptor field = messageType.getFields().get(0);
    STAssertEqualObjects(@"optional_int32", field.getName());
    STAssertEqualObjects(field, messageType.findFieldByName(@"optional_int32"));
    assertNull(messageType.findFieldByName(@"no_such_field"));
    STAssertEqualObjects(field, messageType.findFieldByNumber(1));
    assertNull(messageType.findFieldByNumber(571283));
    for (int i = 0; i < messageType.getFields().size(); i++) {
        STAssertEqualObjects(i, messageType.getFields().get(i).getIndex());
    }
    
    STAssertEqualObjects(nestedType, messageType.getNestedTypes().get(0));
    STAssertEqualObjects(nestedType, messageType.findNestedTypeByName(@"NestedMessage"));
    assertNull(messageType.findNestedTypeByName(@"NoSuchType"));
    for (int i = 0; i < messageType.getNestedTypes().size(); i++) {
        STAssertEqualObjects(i, messageType.getNestedTypes().get(i).getIndex());
    }
    
    EnumDescriptor enumType = TestAllTypes.NestedEnum.getDescriptor();
    STAssertEqualObjects(enumType, messageType.getEnumTypes().get(0));
    STAssertEqualObjects(enumType, messageType.findEnumTypeByName(@"NestedEnum"));
    assertNull(messageType.findEnumTypeByName(@"NoSuchType"));
    for (int i = 0; i < messageType.getEnumTypes().size(); i++) {
        STAssertEqualObjects(i, messageType.getEnumTypes().get(i).getIndex());
    }
}

public void testFieldDescriptor() throws Exception {
    Descriptor messageType = TestAllTypes.getDescriptor();
    FieldDescriptor primitiveField =
    messageType.findFieldByName(@"optional_int32");
    FieldDescriptor enumField =
    messageType.findFieldByName(@"optional_nested_enum");
    FieldDescriptor messageField =
    messageType.findFieldByName(@"optional_foreign_message");
    FieldDescriptor cordField =
    messageType.findFieldByName(@"optional_cord");
    FieldDescriptor extension =
    UnittestProto.optionalInt32Extension.getDescriptor();
    FieldDescriptor nestedExtension = TestRequired.single.getDescriptor();
    
    STAssertEqualObjects(@"optional_int32", primitiveField.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.optional_int32",
                 primitiveField.getFullName());
    STAssertEqualObjects(1, primitiveField.getNumber());
    STAssertEqualObjects(messageType, primitiveField.getContainingType());
    STAssertEqualObjects(UnittestProto.getDescriptor(), primitiveField.getFile());
    STAssertEqualObjects(FieldDescriptor.Type.INT32, primitiveField.getType());
    STAssertEqualObjects(FieldDescriptor.JavaType.INT, primitiveField.getJavaType());
    STAssertEqualObjects(DescriptorProtos.FieldOptions.getDefaultInstance(),
                 primitiveField.getOptions());
    assertFalse(primitiveField.isExtension());
    STAssertEqualObjects(@"optional_int32", primitiveField.toProto().getName());
    
    STAssertEqualObjects(@"optional_nested_enum", enumField.getName());
    STAssertEqualObjects(FieldDescriptor.Type.ENUM, enumField.getType());
    STAssertEqualObjects(FieldDescriptor.JavaType.ENUM, enumField.getJavaType());
    STAssertEqualObjects(TestAllTypes.NestedEnum.getDescriptor(),
                 enumField.getEnumType());
    
    STAssertEqualObjects(@"optional_foreign_message", messageField.getName());
    STAssertEqualObjects(FieldDescriptor.Type.MESSAGE, messageField.getType());
    STAssertEqualObjects(FieldDescriptor.JavaType.MESSAGE, messageField.getJavaType());
    STAssertEqualObjects(ForeignMessage.getDescriptor(), messageField.getMessageType());
    
    STAssertEqualObjects(@"optional_cord", cordField.getName());
    STAssertEqualObjects(FieldDescriptor.Type.STRING, cordField.getType());
    STAssertEqualObjects(FieldDescriptor.JavaType.STRING, cordField.getJavaType());
    STAssertEqualObjects(DescriptorProtos.FieldOptions.CType.CORD,
                 cordField.getOptions().getCtype());
    
    STAssertEqualObjects(@"optional_int32_extension", extension.getName());
    STAssertEqualObjects(@"protobuf_unittest.optional_int32_extension",
                 extension.getFullName());
    STAssertEqualObjects(1, extension.getNumber());
    STAssertEqualObjects(TestAllExtensions.getDescriptor(),
                 extension.getContainingType());
    STAssertEqualObjects(UnittestProto.getDescriptor(), extension.getFile());
    STAssertEqualObjects(FieldDescriptor.Type.INT32, extension.getType());
    STAssertEqualObjects(FieldDescriptor.JavaType.INT, extension.getJavaType());
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
    FieldDescriptor requiredField =
    TestRequired.getDescriptor().findFieldByName(@"a");
    FieldDescriptor optionalField =
    TestAllTypes.getDescriptor().findFieldByName(@"optional_int32");
    FieldDescriptor repeatedField =
    TestAllTypes.getDescriptor().findFieldByName(@"repeated_int32");
    
    assertTrue(requiredField.isRequired());
    assertFalse(requiredField.isRepeated());
    assertFalse(optionalField.isRequired());
    assertFalse(optionalField.isRepeated());
    assertFalse(repeatedField.isRequired());
    assertTrue(repeatedField.isRepeated());
}

public void testFieldDescriptorDefault() throws Exception {
    Descriptor d = TestAllTypes.getDescriptor();
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
    EnumDescriptor enumType = ForeignEnum.getDescriptor();
    EnumDescriptor nestedType = TestAllTypes.NestedEnum.getDescriptor();
    
    STAssertEqualObjects(@"ForeignEnum", enumType.getName());
    STAssertEqualObjects(@"protobuf_unittest.ForeignEnum", enumType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), enumType.getFile());
    assertNull(enumType.getContainingType());
    STAssertEqualObjects(DescriptorProtos.EnumOptions.getDefaultInstance(),
                 enumType.getOptions());
    
    STAssertEqualObjects(@"NestedEnum", nestedType.getName());
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.NestedEnum",
                 nestedType.getFullName());
    STAssertEqualObjects(UnittestProto.getDescriptor(), nestedType.getFile());
    STAssertEqualObjects(TestAllTypes.getDescriptor(), nestedType.getContainingType());
    
    EnumValueDescriptor value = ForeignEnum.FOREIGN_FOO.getValueDescriptor();
    STAssertEqualObjects(value, enumType.getValues().get(0));
    STAssertEqualObjects(@"FOREIGN_FOO", value.getName());
    STAssertEqualObjects(4, value.getNumber());
    STAssertEqualObjects(value, enumType.findValueByName(@"FOREIGN_FOO"));
    STAssertEqualObjects(value, enumType.findValueByNumber(4));
    assertNull(enumType.findValueByName(@"NO_SUCH_VALUE"));
    for (int i = 0; i < enumType.getValues().size(); i++) {
        STAssertEqualObjects(i, enumType.getValues().get(i).getIndex());
    }
}

public void testServiceDescriptor() throws Exception {
    ServiceDescriptor service = TestService.getDescriptor();
    
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
    
    assertNull(service.findMethodByName(@"NoSuchMethod"));
    
    for (int i = 0; i < service.getMethods().size(); i++) {
        STAssertEqualObjects(i, service.getMethods().get(i).getIndex());
    }
}


#endif

@end
