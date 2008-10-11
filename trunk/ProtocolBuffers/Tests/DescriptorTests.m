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

#import "DescriptorTests.h"

#import "Unittest.pb.h"
#import "UnittestImport.pb.h"

@implementation DescriptorTests

- (void) testFileDescriptor {
    PBFileDescriptor* file = [UnittestRoot descriptor];

    STAssertEqualObjects(@"google/protobuf/unittest.proto", file.name, @"");
    STAssertEqualObjects(@"protobuf_unittest", file.package, @"");

    STAssertEqualObjects(@"UnittestProto", file.options.javaOuterClassname, @"");
    STAssertEqualObjects(@"google/protobuf/unittest.proto", file.proto.name, @"");

    STAssertEqualObjects([NSArray arrayWithObject:[UnittestImportRoot descriptor]],
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
                         [[UnittestImportRoot descriptor] enumTypes], @"");
    for (int i = 0; i < file.enumTypes.count; i++) {
        STAssertTrue(i == [[file.enumTypes objectAtIndex:i] index], @"");
    }

    PBServiceDescriptor* service = [TestService descriptor];
    STAssertEqualObjects(service, [file.services objectAtIndex:0], @"");
    STAssertEqualObjects(service, [file findServiceByName:@"TestService"], @"");
    STAssertNil([file findServiceByName:@"NoSuchType"], @"");
    STAssertNil([file findServiceByName:@"protobuf_unittest.TestService"], @"");
    STAssertEqualObjects([NSArray array],
                 [[UnittestImportRoot descriptor] services], @"");
    for (int i = 0; i < file.services.count; i++) {
        STAssertTrue(i == [[file.services objectAtIndex:i] index], @"");
    }

    PBFieldDescriptor* extension =
    [[UnittestRoot optionalInt32Extension] descriptor];
    STAssertEqualObjects(extension, [file.extensions objectAtIndex:0], @"");
    STAssertEqualObjects(extension,
                         [file findExtensionByName:@"optional_int32_extension"], @"");
    STAssertNil([file findExtensionByName:@"no_such_ext"], @"");
    STAssertNil([file findExtensionByName:@"protobuf_unittest.optional_int32_extension"], @"");
    STAssertEqualObjects([NSArray array],
                         [[UnittestImportRoot descriptor] extensions], @"");
    for (int i = 0; i < file.extensions.count; i++) {
        STAssertTrue(i == [[file.extensions objectAtIndex:i] index], @"");
    }
}


- (void) testDescriptor {
    PBDescriptor* messageType = [TestAllTypes descriptor];
    PBDescriptor* nestedType = [TestAllTypes_NestedMessage descriptor];

    STAssertEqualObjects(@"TestAllTypes", messageType.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes", messageType.fullName, @"");
    STAssertEqualObjects([UnittestRoot descriptor], messageType.file, @"");
    STAssertNil(messageType.containingType, @"");
    STAssertEqualObjects([PBMessageOptions defaultInstance],
                 messageType.options, @"");
    STAssertEqualObjects(@"TestAllTypes", messageType.proto.name, @"");

    STAssertEqualObjects(@"NestedMessage", nestedType.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.NestedMessage",
                 nestedType.fullName, @"");
    STAssertEqualObjects([UnittestRoot descriptor], nestedType.file, @"");
    STAssertEqualObjects(messageType, nestedType.containingType, @"");

    PBFieldDescriptor* field = [messageType.fields objectAtIndex:0];
    STAssertEqualObjects(@"optional_int32", field.name, @"");
    STAssertEqualObjects(field, [messageType findFieldByName:@"optional_int32"], @"");
    STAssertNil([messageType findFieldByName:@"no_such_field"], @"");
    STAssertEqualObjects(field, [messageType findFieldByNumber:1], @"");
    STAssertNil([messageType findFieldByNumber:571283], @"");
    for (int i = 0; i < messageType.fields.count; i++) {
        STAssertTrue(i == [[messageType.fields objectAtIndex:i] index], @"");
    }

    STAssertEqualObjects(nestedType, [messageType.nestedTypes objectAtIndex:0], @"");
    STAssertEqualObjects(nestedType, [messageType findNestedTypeByName:@"NestedMessage"], @"");
    STAssertNil([messageType findNestedTypeByName:@"NoSuchType"], @"");
    for (int i = 0; i < messageType.nestedTypes.count; i++) {
        STAssertTrue(i == [[messageType.nestedTypes objectAtIndex:i] index], @"");
    }

    PBEnumDescriptor* enumType = [TestAllTypes_NestedEnum descriptor];
    STAssertEqualObjects(enumType, [messageType.enumTypes objectAtIndex:0], @"");
    STAssertEqualObjects(enumType, [messageType findEnumTypeByName:@"NestedEnum"], @"");
    STAssertNil([messageType findEnumTypeByName:@"NoSuchType"], @"");
    for (int i = 0; i < messageType.enumTypes.count; i++) {
        STAssertTrue(i == [[messageType.enumTypes objectAtIndex:i] index], @"");
    }
}


- (void) testFieldDescriptor {
    PBDescriptor* messageType = [TestAllTypes descriptor];
    PBFieldDescriptor* primitiveField = [messageType findFieldByName:@"optional_int32"];
    PBFieldDescriptor* enumField = [messageType findFieldByName:@"optional_nested_enum"];
    PBFieldDescriptor* messageField = [messageType findFieldByName:@"optional_foreign_message"];
    PBFieldDescriptor* cordField = [messageType findFieldByName:@"optional_cord"];
    PBFieldDescriptor* extension = [[UnittestRoot optionalInt32Extension] descriptor];
    PBFieldDescriptor* nestedExtension = [[TestRequired single] descriptor];

    STAssertEqualObjects(@"optional_int32", primitiveField.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.optional_int32",
                 primitiveField.fullName, @"");
    STAssertEquals(1, primitiveField.number, @"");
    STAssertEqualObjects(messageType, primitiveField.containingType, @"");
    STAssertEqualObjects([UnittestRoot descriptor], primitiveField.file, @"");
    STAssertEquals(PBFieldDescriptorTypeInt32, primitiveField.type, @"");
    STAssertEquals(PBObjectiveCTypeInt32, primitiveField.objectiveCType, @"");
    STAssertEqualObjects([PBFieldOptions defaultInstance],
                 primitiveField.options, @"");
    STAssertFalse(primitiveField.isExtension, @"");
    STAssertEqualObjects(@"optional_int32", primitiveField.proto.name, @"");

    STAssertEqualObjects(@"optional_nested_enum", enumField.name, @"");
    STAssertEquals(PBFieldDescriptorTypeEnum, enumField.type, @"");
    STAssertEquals(PBObjectiveCTypeEnum, enumField.objectiveCType, @"");
    STAssertEqualObjects([TestAllTypes_NestedEnum descriptor],
                 enumField.enumType, @"");

    STAssertEqualObjects(@"optional_foreign_message", messageField.name, @"");
    STAssertEquals(PBFieldDescriptorTypeMessage, messageField.type, @"");
    STAssertEquals(PBObjectiveCTypeMessage, messageField.objectiveCType, @"");
    STAssertEqualObjects([ForeignMessage descriptor], messageField.messageType, @"");

    STAssertEqualObjects(@"optional_cord", cordField.name, @"");
    STAssertEquals(PBFieldDescriptorTypeString, cordField.type, @"");
    STAssertEquals(PBObjectiveCTypeString, cordField.objectiveCType, @"");
    STAssertEqualObjects([PBFieldOptions_CType CORD],
                 cordField.options.ctype, @"");

    STAssertEqualObjects(@"optional_int32_extension", extension.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.optional_int32_extension",
                 extension.fullName, @"");
    STAssertEquals(1, extension.number, @"");
    STAssertEqualObjects([TestAllExtensions descriptor],
                 extension.containingType, @"");
    STAssertEqualObjects([UnittestRoot descriptor], extension.file, @"");
    STAssertEquals(PBFieldDescriptorTypeInt32, extension.type, @"");
    STAssertEquals(PBObjectiveCTypeInt32, extension.objectiveCType, @"");
    STAssertEqualObjects([PBFieldOptions defaultInstance],
                 extension.options, @"");
    STAssertTrue(extension.isExtension, @"");
    STAssertEqualObjects(nil, extension.extensionScope, @"");
    STAssertEqualObjects(@"optional_int32_extension", extension.proto.name, @"");

    STAssertEqualObjects(@"single", nestedExtension.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.TestRequired.single",
                 nestedExtension.fullName, @"");
    STAssertEqualObjects([TestRequired descriptor],
                 nestedExtension.extensionScope, @"");
}


- (void) testFieldDescriptorLabel {
    PBFieldDescriptor* requiredField =
    [[TestRequired descriptor] findFieldByName:@"a"];
    PBFieldDescriptor* optionalField =
    [[TestAllTypes descriptor] findFieldByName:@"optional_int32"];
    PBFieldDescriptor* repeatedField =
    [[TestAllTypes descriptor] findFieldByName:@"repeated_int32"];

    STAssertTrue(requiredField.isRequired, @"");
    STAssertFalse(requiredField.isRepeated, @"");
    STAssertFalse(optionalField.isRequired, @"");
    STAssertFalse(optionalField.isRepeated, @"");
    STAssertFalse(repeatedField.isRequired, @"");
    STAssertTrue(repeatedField.isRepeated, @"");
}


- (void) testFieldDescriptorDefault {
    PBDescriptor* d = [TestAllTypes descriptor];
    STAssertFalse([[d findFieldByName:@"optional_int32"] hasDefaultValue], @"");
    STAssertTrue(0 == [[[d findFieldByName:@"optional_int32"] defaultValue] intValue], @"");
    STAssertTrue([[d findFieldByName:@"default_int32"] hasDefaultValue], @"");
    STAssertTrue(41 == [[[d findFieldByName:@"default_int32"] defaultValue] intValue], @"");

    d = [TestExtremeDefaultValues descriptor];
    //STAssertEqualObjects(
    //             ByteString.copyFrom(
    //                                 "\0\001\007\b\f\n\r\t\013\\\'\"\u00fe".getBytes(@"ISO-8859-1")),
    //             d.findFieldByName(@"escaped_bytes").getDefaultValue());
    STAssertTrue(-1 == [[[d findFieldByName:@"large_uint32"] defaultValue] longLongValue], @"");
    STAssertTrue(-1L == [[[d findFieldByName:@"large_uint64"] defaultValue] longLongValue], @"");
}


- (void) testEnumDescriptor {
    PBEnumDescriptor* enumType = [ForeignEnum descriptor];
    PBEnumDescriptor* nestedType = [TestAllTypes_NestedEnum descriptor];

    STAssertEqualObjects(@"ForeignEnum", enumType.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.ForeignEnum", enumType.fullName, @"");
    STAssertEqualObjects([UnittestRoot descriptor], enumType.file, @"");
    STAssertNil(enumType.containingType, @"");
    STAssertEqualObjects([PBEnumOptions defaultInstance],
                 enumType.options, @"");

    STAssertEqualObjects(@"NestedEnum", nestedType.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.TestAllTypes.NestedEnum",
                 nestedType.fullName, @"");
    STAssertEqualObjects([UnittestRoot descriptor], nestedType.file, @"");
    STAssertEqualObjects([TestAllTypes descriptor], nestedType.containingType, @"");

    PBEnumValueDescriptor* value = [[ForeignEnum FOREIGN_FOO] valueDescriptor];
    STAssertEqualObjects(value, [enumType.values objectAtIndex:0], @"");
    STAssertEqualObjects(@"FOREIGN_FOO", value.name, @"");
    STAssertEquals(4, value.number, @"");
    STAssertEqualObjects(value, [enumType findValueByName:@"FOREIGN_FOO"], @"");
    STAssertEqualObjects(value, [enumType findValueByNumber:4], @"");
    STAssertNil([enumType findValueByName:@"NO_SUCH_VALUE"], @"");
    for (int i = 0; i < enumType.values.count; i++) {
        STAssertTrue(i == [[enumType.values objectAtIndex:i] index], @"");
    }
}


- (void) testServiceDescriptor {
    PBServiceDescriptor* service = [TestService descriptor];

    STAssertEqualObjects(@"TestService", service.name, @"");
    STAssertEqualObjects(@"protobuf_unittest.TestService", service.fullName, @"");
    STAssertEqualObjects([UnittestRoot descriptor], service.file, @"");

    STAssertTrue(2 == service.methods.count, @"");

    PBMethodDescriptor* fooMethod = [service.methods objectAtIndex:0];
    STAssertEqualObjects(@"Foo", fooMethod.name, @"");
    STAssertEqualObjects([FooRequest descriptor],
                         fooMethod.inputType, @"");
    STAssertEqualObjects([FooResponse descriptor],
                         fooMethod.outputType, @"");
    STAssertEqualObjects(fooMethod, [service findMethodByName:@"Foo"], @"");

    PBMethodDescriptor* barMethod = [service.methods objectAtIndex:1];
    STAssertEqualObjects(@"Bar", barMethod.name, @"");
    STAssertEqualObjects([BarRequest descriptor],
                 barMethod.inputType, @"");
    STAssertEqualObjects([BarResponse descriptor],
                 barMethod.outputType, @"");
    STAssertEqualObjects(barMethod, [service findMethodByName:@"Bar"], @"");

    STAssertNil([service findMethodByName:@"NoSuchMethod"], @"");

    for (int i = 0; i < service.methods.count; i++) {
        STAssertTrue(i == [[service.methods objectAtIndex:i] index], @"");
    }
}

@end