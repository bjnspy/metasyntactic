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

#import "Unittest.pb.h"

@implementation UnittestProtoRoot
static PBFileDescriptor* descriptor = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalInt32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalInt64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalUint32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalUint64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalSint32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalSint64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalFixed32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalFixed64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalSfixed32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalSfixed64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalFloatExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalDoubleExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalBoolExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalStringExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalBytesExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalGroupExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalNestedMessageExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalForeignMessageExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalImportMessageExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalNestedEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalForeignEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalImportEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalStringPieceExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_optionalCordExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedInt32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedInt64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedUint32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedUint64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedSint32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedSint64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedFixed32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedFixed64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedSfixed32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedSfixed64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedFloatExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedDoubleExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedBoolExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedStringExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedBytesExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedGroupExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedNestedMessageExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedForeignMessageExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedImportMessageExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedNestedEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedForeignEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedImportEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedStringPieceExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_repeatedCordExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultInt32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultInt64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultUint32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultUint64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultSint32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultSint64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultFixed32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultFixed64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultSfixed32Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultSfixed64Extension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultFloatExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultDoubleExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultBoolExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultStringExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultBytesExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultNestedEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultForeignEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultImportEnumExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultStringPieceExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_defaultCordExtension = nil;
static PBGeneratedExtension* UnittestProtoRoot_myExtensionString = nil;
static PBGeneratedExtension* UnittestProtoRoot_myExtensionInt = nil;
static PBDescriptor* internal_static_protobuf_unittest_TestAllTypes_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestAllTypes_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestAllTypes_descriptor {
  return internal_static_protobuf_unittest_TestAllTypes_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestAllTypes_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestAllTypes_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestAllTypes_NestedMessage_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestAllTypes_NestedMessage_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestAllTypes_NestedMessage_descriptor {
  return internal_static_protobuf_unittest_TestAllTypes_NestedMessage_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestAllTypes_NestedMessage_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestAllTypes_NestedMessage_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_descriptor {
  return internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_descriptor {
  return internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_ForeignMessage_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_ForeignMessage_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_ForeignMessage_descriptor {
  return internal_static_protobuf_unittest_ForeignMessage_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_ForeignMessage_fieldAccessorTable {
  return internal_static_protobuf_unittest_ForeignMessage_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestAllExtensions_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestAllExtensions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestAllExtensions_descriptor {
  return internal_static_protobuf_unittest_TestAllExtensions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestAllExtensions_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestAllExtensions_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_OptionalGroup_extension_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_OptionalGroup_extension_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_OptionalGroup_extension_descriptor {
  return internal_static_protobuf_unittest_OptionalGroup_extension_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_OptionalGroup_extension_fieldAccessorTable {
  return internal_static_protobuf_unittest_OptionalGroup_extension_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_RepeatedGroup_extension_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_RepeatedGroup_extension_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_RepeatedGroup_extension_descriptor {
  return internal_static_protobuf_unittest_RepeatedGroup_extension_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_RepeatedGroup_extension_fieldAccessorTable {
  return internal_static_protobuf_unittest_RepeatedGroup_extension_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestRequired_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestRequired_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestRequired_descriptor {
  return internal_static_protobuf_unittest_TestRequired_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestRequired_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestRequired_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestRequiredForeign_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestRequiredForeign_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestRequiredForeign_descriptor {
  return internal_static_protobuf_unittest_TestRequiredForeign_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestRequiredForeign_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestRequiredForeign_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestForeignNested_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestForeignNested_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestForeignNested_descriptor {
  return internal_static_protobuf_unittest_TestForeignNested_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestForeignNested_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestForeignNested_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestEmptyMessage_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestEmptyMessage_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestEmptyMessage_descriptor {
  return internal_static_protobuf_unittest_TestEmptyMessage_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestEmptyMessage_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestEmptyMessage_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_descriptor {
  return internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestReallyLargeTagNumber_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestReallyLargeTagNumber_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestReallyLargeTagNumber_descriptor {
  return internal_static_protobuf_unittest_TestReallyLargeTagNumber_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestReallyLargeTagNumber_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestReallyLargeTagNumber_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestRecursiveMessage_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestRecursiveMessage_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestRecursiveMessage_descriptor {
  return internal_static_protobuf_unittest_TestRecursiveMessage_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestRecursiveMessage_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestRecursiveMessage_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestMutualRecursionA_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestMutualRecursionA_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestMutualRecursionA_descriptor {
  return internal_static_protobuf_unittest_TestMutualRecursionA_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestMutualRecursionA_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestMutualRecursionA_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestMutualRecursionB_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestMutualRecursionB_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestMutualRecursionB_descriptor {
  return internal_static_protobuf_unittest_TestMutualRecursionB_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestMutualRecursionB_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestMutualRecursionB_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestDupFieldNumber_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestDupFieldNumber_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestDupFieldNumber_descriptor {
  return internal_static_protobuf_unittest_TestDupFieldNumber_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestDupFieldNumber_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestDupFieldNumber_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestDupFieldNumber_Foo_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestDupFieldNumber_Foo_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestDupFieldNumber_Foo_descriptor {
  return internal_static_protobuf_unittest_TestDupFieldNumber_Foo_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestDupFieldNumber_Foo_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestDupFieldNumber_Foo_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestDupFieldNumber_Bar_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestDupFieldNumber_Bar_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestDupFieldNumber_Bar_descriptor {
  return internal_static_protobuf_unittest_TestDupFieldNumber_Bar_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestDupFieldNumber_Bar_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestDupFieldNumber_Bar_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestNestedMessageHasBits_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestNestedMessageHasBits_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestNestedMessageHasBits_descriptor {
  return internal_static_protobuf_unittest_TestNestedMessageHasBits_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestNestedMessageHasBits_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestNestedMessageHasBits_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_descriptor {
  return internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestCamelCaseFieldNames_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestCamelCaseFieldNames_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestCamelCaseFieldNames_descriptor {
  return internal_static_protobuf_unittest_TestCamelCaseFieldNames_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestCamelCaseFieldNames_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestCamelCaseFieldNames_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestFieldOrderings_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestFieldOrderings_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestFieldOrderings_descriptor {
  return internal_static_protobuf_unittest_TestFieldOrderings_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestFieldOrderings_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestFieldOrderings_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_TestExtremeDefaultValues_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_TestExtremeDefaultValues_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_TestExtremeDefaultValues_descriptor {
  return internal_static_protobuf_unittest_TestExtremeDefaultValues_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_TestExtremeDefaultValues_fieldAccessorTable {
  return internal_static_protobuf_unittest_TestExtremeDefaultValues_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_FooRequest_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_FooRequest_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_FooRequest_descriptor {
  return internal_static_protobuf_unittest_FooRequest_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_FooRequest_fieldAccessorTable {
  return internal_static_protobuf_unittest_FooRequest_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_FooResponse_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_FooResponse_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_FooResponse_descriptor {
  return internal_static_protobuf_unittest_FooResponse_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_FooResponse_fieldAccessorTable {
  return internal_static_protobuf_unittest_FooResponse_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_BarRequest_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_BarRequest_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_BarRequest_descriptor {
  return internal_static_protobuf_unittest_BarRequest_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_BarRequest_fieldAccessorTable {
  return internal_static_protobuf_unittest_BarRequest_fieldAccessorTable;
}
static PBDescriptor* internal_static_protobuf_unittest_BarResponse_descriptor = nil;
static PBFieldAccessorTable* internal_static_protobuf_unittest_BarResponse_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_protobuf_unittest_BarResponse_descriptor {
  return internal_static_protobuf_unittest_BarResponse_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_protobuf_unittest_BarResponse_fieldAccessorTable {
  return internal_static_protobuf_unittest_BarResponse_fieldAccessorTable;
}
+ (void) initialize {
  if (self == [UnittestProtoRoot class]) {
    descriptor = [[UnittestProtoRoot buildDescriptor] retain];
         UnittestProtoRoot_optionalInt32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:0]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalInt64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:1]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalUint32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:2]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalUint64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:3]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalSint32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:4]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalSint64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:5]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalFixed32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:6]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalFixed64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:7]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalSfixed32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:8]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalSfixed64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:9]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalFloatExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:10]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalDoubleExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:11]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalBoolExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:12]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_optionalStringExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:13]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_optionalBytesExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:14]
                                                           type:[NSData class]] retain];
         UnittestProtoRoot_optionalGroupExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:15]
                                                           type:[OptionalGroup_extension class]] retain];
         UnittestProtoRoot_optionalNestedMessageExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:16]
                                                           type:[TestAllTypes_NestedMessage class]] retain];
         UnittestProtoRoot_optionalForeignMessageExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:17]
                                                           type:[ForeignMessage class]] retain];
         UnittestProtoRoot_optionalImportMessageExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:18]
                                                           type:[ImportMessage class]] retain];
         UnittestProtoRoot_optionalNestedEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:19]
                                                           type:[TestAllTypes_NestedEnum class]] retain];
         UnittestProtoRoot_optionalForeignEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:20]
                                                           type:[ForeignEnum class]] retain];
         UnittestProtoRoot_optionalImportEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:21]
                                                           type:[ImportEnum class]] retain];
         UnittestProtoRoot_optionalStringPieceExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:22]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_optionalCordExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:23]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_repeatedInt32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:24]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedInt64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:25]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedUint32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:26]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedUint64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:27]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedSint32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:28]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedSint64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:29]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedFixed32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:30]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedFixed64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:31]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedSfixed32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:32]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedSfixed64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:33]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedFloatExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:34]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedDoubleExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:35]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedBoolExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:36]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_repeatedStringExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:37]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_repeatedBytesExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:38]
                                                           type:[NSData class]] retain];
         UnittestProtoRoot_repeatedGroupExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:39]
                                                           type:[RepeatedGroup_extension class]] retain];
         UnittestProtoRoot_repeatedNestedMessageExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:40]
                                                           type:[TestAllTypes_NestedMessage class]] retain];
         UnittestProtoRoot_repeatedForeignMessageExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:41]
                                                           type:[ForeignMessage class]] retain];
         UnittestProtoRoot_repeatedImportMessageExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:42]
                                                           type:[ImportMessage class]] retain];
         UnittestProtoRoot_repeatedNestedEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:43]
                                                           type:[TestAllTypes_NestedEnum class]] retain];
         UnittestProtoRoot_repeatedForeignEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:44]
                                                           type:[ForeignEnum class]] retain];
         UnittestProtoRoot_repeatedImportEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:45]
                                                           type:[ImportEnum class]] retain];
         UnittestProtoRoot_repeatedStringPieceExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:46]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_repeatedCordExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:47]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_defaultInt32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:48]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultInt64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:49]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultUint32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:50]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultUint64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:51]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultSint32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:52]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultSint64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:53]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultFixed32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:54]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultFixed64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:55]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultSfixed32Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:56]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultSfixed64Extension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:57]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultFloatExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:58]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultDoubleExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:59]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultBoolExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:60]
                                                           type:[NSNumber class]] retain];
         UnittestProtoRoot_defaultStringExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:61]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_defaultBytesExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:62]
                                                           type:[NSData class]] retain];
         UnittestProtoRoot_defaultNestedEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:63]
                                                           type:[TestAllTypes_NestedEnum class]] retain];
         UnittestProtoRoot_defaultForeignEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:64]
                                                           type:[ForeignEnum class]] retain];
         UnittestProtoRoot_defaultImportEnumExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:65]
                                                           type:[ImportEnum class]] retain];
         UnittestProtoRoot_defaultStringPieceExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:66]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_defaultCordExtension = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:67]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_myExtensionString = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:68]
                                                           type:[NSString class]] retain];
         UnittestProtoRoot_myExtensionInt = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:69]
                                                           type:[NSNumber class]] retain];
    internal_static_protobuf_unittest_TestAllTypes_descriptor = [[[self descriptor].messageTypes objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"OptionalInt32", @"OptionalInt64", @"OptionalUint32", @"OptionalUint64", @"OptionalSint32", @"OptionalSint64", @"OptionalFixed32", @"OptionalFixed64", @"OptionalSfixed32", @"OptionalSfixed64", @"OptionalFloat", @"OptionalDouble", @"OptionalBool", @"OptionalString", @"OptionalBytes", @"OptionalGroup", @"OptionalNestedMessage", @"OptionalForeignMessage", @"OptionalImportMessage", @"OptionalNestedEnum", @"OptionalForeignEnum", @"OptionalImportEnum", @"OptionalStringPiece", @"OptionalCord", @"RepeatedInt32", @"RepeatedInt64", @"RepeatedUint32", @"RepeatedUint64", @"RepeatedSint32", @"RepeatedSint64", @"RepeatedFixed32", @"RepeatedFixed64", @"RepeatedSfixed32", @"RepeatedSfixed64", @"RepeatedFloat", @"RepeatedDouble", @"RepeatedBool", @"RepeatedString", @"RepeatedBytes", @"RepeatedGroup", @"RepeatedNestedMessage", @"RepeatedForeignMessage", @"RepeatedImportMessage", @"RepeatedNestedEnum", @"RepeatedForeignEnum", @"RepeatedImportEnum", @"RepeatedStringPiece", @"RepeatedCord", @"DefaultInt32", @"DefaultInt64", @"DefaultUint32", @"DefaultUint64", @"DefaultSint32", @"DefaultSint64", @"DefaultFixed32", @"DefaultFixed64", @"DefaultSfixed32", @"DefaultSfixed64", @"DefaultFloat", @"DefaultDouble", @"DefaultBool", @"DefaultString", @"DefaultBytes", @"DefaultNestedEnum", @"DefaultForeignEnum", @"DefaultImportEnum", @"DefaultStringPiece", @"DefaultCord", nil];
      internal_static_protobuf_unittest_TestAllTypes_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestAllTypes_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestAllTypes class]
                                      builderClass:[TestAllTypes_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestAllTypes_NestedMessage_descriptor = [[[internal_static_protobuf_unittest_TestAllTypes_descriptor nestedTypes] objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Bb", nil];
      internal_static_protobuf_unittest_TestAllTypes_NestedMessage_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestAllTypes_NestedMessage_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestAllTypes_NestedMessage class]
                                      builderClass:[TestAllTypes_NestedMessage_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_descriptor = [[[internal_static_protobuf_unittest_TestAllTypes_descriptor nestedTypes] objectAtIndex:1] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", nil];
      internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestAllTypes_OptionalGroup class]
                                      builderClass:[TestAllTypes_OptionalGroup_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_descriptor = [[[internal_static_protobuf_unittest_TestAllTypes_descriptor nestedTypes] objectAtIndex:2] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", nil];
      internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestAllTypes_RepeatedGroup class]
                                      builderClass:[TestAllTypes_RepeatedGroup_Builder class]] retain];
    }
    internal_static_protobuf_unittest_ForeignMessage_descriptor = [[[self descriptor].messageTypes objectAtIndex:1] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"C", nil];
      internal_static_protobuf_unittest_ForeignMessage_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_ForeignMessage_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[ForeignMessage class]
                                      builderClass:[ForeignMessage_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestAllExtensions_descriptor = [[[self descriptor].messageTypes objectAtIndex:2] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_protobuf_unittest_TestAllExtensions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestAllExtensions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestAllExtensions class]
                                      builderClass:[TestAllExtensions_Builder class]] retain];
    }
    internal_static_protobuf_unittest_OptionalGroup_extension_descriptor = [[[self descriptor].messageTypes objectAtIndex:3] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", nil];
      internal_static_protobuf_unittest_OptionalGroup_extension_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_OptionalGroup_extension_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[OptionalGroup_extension class]
                                      builderClass:[OptionalGroup_extension_Builder class]] retain];
    }
    internal_static_protobuf_unittest_RepeatedGroup_extension_descriptor = [[[self descriptor].messageTypes objectAtIndex:4] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", nil];
      internal_static_protobuf_unittest_RepeatedGroup_extension_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_RepeatedGroup_extension_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[RepeatedGroup_extension class]
                                      builderClass:[RepeatedGroup_extension_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestRequired_descriptor = [[[self descriptor].messageTypes objectAtIndex:5] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", @"Dummy2", @"B", @"Dummy4", @"Dummy5", @"Dummy6", @"Dummy7", @"Dummy8", @"Dummy9", @"Dummy10", @"Dummy11", @"Dummy12", @"Dummy13", @"Dummy14", @"Dummy15", @"Dummy16", @"Dummy17", @"Dummy18", @"Dummy19", @"Dummy20", @"Dummy21", @"Dummy22", @"Dummy23", @"Dummy24", @"Dummy25", @"Dummy26", @"Dummy27", @"Dummy28", @"Dummy29", @"Dummy30", @"Dummy31", @"Dummy32", @"C", nil];
      internal_static_protobuf_unittest_TestRequired_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestRequired_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestRequired class]
                                      builderClass:[TestRequired_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestRequiredForeign_descriptor = [[[self descriptor].messageTypes objectAtIndex:6] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"OptionalMessage", @"RepeatedMessage", @"Dummy", nil];
      internal_static_protobuf_unittest_TestRequiredForeign_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestRequiredForeign_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestRequiredForeign class]
                                      builderClass:[TestRequiredForeign_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestForeignNested_descriptor = [[[self descriptor].messageTypes objectAtIndex:7] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"ForeignNested", nil];
      internal_static_protobuf_unittest_TestForeignNested_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestForeignNested_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestForeignNested class]
                                      builderClass:[TestForeignNested_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestEmptyMessage_descriptor = [[[self descriptor].messageTypes objectAtIndex:8] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_protobuf_unittest_TestEmptyMessage_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestEmptyMessage_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestEmptyMessage class]
                                      builderClass:[TestEmptyMessage_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_descriptor = [[[self descriptor].messageTypes objectAtIndex:9] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestEmptyMessageWithExtensions class]
                                      builderClass:[TestEmptyMessageWithExtensions_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestReallyLargeTagNumber_descriptor = [[[self descriptor].messageTypes objectAtIndex:10] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", @"Bb", nil];
      internal_static_protobuf_unittest_TestReallyLargeTagNumber_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestReallyLargeTagNumber_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestReallyLargeTagNumber class]
                                      builderClass:[TestReallyLargeTagNumber_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestRecursiveMessage_descriptor = [[[self descriptor].messageTypes objectAtIndex:11] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", @"I", nil];
      internal_static_protobuf_unittest_TestRecursiveMessage_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestRecursiveMessage_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestRecursiveMessage class]
                                      builderClass:[TestRecursiveMessage_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestMutualRecursionA_descriptor = [[[self descriptor].messageTypes objectAtIndex:12] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Bb", nil];
      internal_static_protobuf_unittest_TestMutualRecursionA_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestMutualRecursionA_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestMutualRecursionA class]
                                      builderClass:[TestMutualRecursionA_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestMutualRecursionB_descriptor = [[[self descriptor].messageTypes objectAtIndex:13] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", @"OptionalInt32", nil];
      internal_static_protobuf_unittest_TestMutualRecursionB_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestMutualRecursionB_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestMutualRecursionB class]
                                      builderClass:[TestMutualRecursionB_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestDupFieldNumber_descriptor = [[[self descriptor].messageTypes objectAtIndex:14] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", @"Foo", @"Bar", nil];
      internal_static_protobuf_unittest_TestDupFieldNumber_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestDupFieldNumber_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestDupFieldNumber class]
                                      builderClass:[TestDupFieldNumber_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestDupFieldNumber_Foo_descriptor = [[[internal_static_protobuf_unittest_TestDupFieldNumber_descriptor nestedTypes] objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", nil];
      internal_static_protobuf_unittest_TestDupFieldNumber_Foo_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestDupFieldNumber_Foo_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestDupFieldNumber_Foo class]
                                      builderClass:[TestDupFieldNumber_Foo_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestDupFieldNumber_Bar_descriptor = [[[internal_static_protobuf_unittest_TestDupFieldNumber_descriptor nestedTypes] objectAtIndex:1] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"A", nil];
      internal_static_protobuf_unittest_TestDupFieldNumber_Bar_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestDupFieldNumber_Bar_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestDupFieldNumber_Bar class]
                                      builderClass:[TestDupFieldNumber_Bar_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestNestedMessageHasBits_descriptor = [[[self descriptor].messageTypes objectAtIndex:15] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"OptionalNestedMessage", nil];
      internal_static_protobuf_unittest_TestNestedMessageHasBits_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestNestedMessageHasBits_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestNestedMessageHasBits class]
                                      builderClass:[TestNestedMessageHasBits_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_descriptor = [[[internal_static_protobuf_unittest_TestNestedMessageHasBits_descriptor nestedTypes] objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"NestedmessageRepeatedInt32", @"NestedmessageRepeatedForeignmessage", nil];
      internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestNestedMessageHasBits_NestedMessage class]
                                      builderClass:[TestNestedMessageHasBits_NestedMessage_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestCamelCaseFieldNames_descriptor = [[[self descriptor].messageTypes objectAtIndex:16] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"PrimitiveField", @"StringField", @"EnumField", @"MessageField", @"StringPieceField", @"CordField", @"RepeatedPrimitiveField", @"RepeatedStringField", @"RepeatedEnumField", @"RepeatedMessageField", @"RepeatedStringPieceField", @"RepeatedCordField", nil];
      internal_static_protobuf_unittest_TestCamelCaseFieldNames_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestCamelCaseFieldNames_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestCamelCaseFieldNames class]
                                      builderClass:[TestCamelCaseFieldNames_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestFieldOrderings_descriptor = [[[self descriptor].messageTypes objectAtIndex:17] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"MyString", @"MyInt", @"MyFloat", nil];
      internal_static_protobuf_unittest_TestFieldOrderings_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestFieldOrderings_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestFieldOrderings class]
                                      builderClass:[TestFieldOrderings_Builder class]] retain];
    }
    internal_static_protobuf_unittest_TestExtremeDefaultValues_descriptor = [[[self descriptor].messageTypes objectAtIndex:18] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"EscapedBytes", @"LargeUint32", @"LargeUint64", @"SmallInt32", @"SmallInt64", @"Utf8String", nil];
      internal_static_protobuf_unittest_TestExtremeDefaultValues_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_TestExtremeDefaultValues_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TestExtremeDefaultValues class]
                                      builderClass:[TestExtremeDefaultValues_Builder class]] retain];
    }
    internal_static_protobuf_unittest_FooRequest_descriptor = [[[self descriptor].messageTypes objectAtIndex:19] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_protobuf_unittest_FooRequest_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_FooRequest_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[FooRequest class]
                                      builderClass:[FooRequest_Builder class]] retain];
    }
    internal_static_protobuf_unittest_FooResponse_descriptor = [[[self descriptor].messageTypes objectAtIndex:20] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_protobuf_unittest_FooResponse_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_FooResponse_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[FooResponse class]
                                      builderClass:[FooResponse_Builder class]] retain];
    }
    internal_static_protobuf_unittest_BarRequest_descriptor = [[[self descriptor].messageTypes objectAtIndex:21] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_protobuf_unittest_BarRequest_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_BarRequest_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[BarRequest class]
                                      builderClass:[BarRequest_Builder class]] retain];
    }
    internal_static_protobuf_unittest_BarResponse_descriptor = [[[self descriptor].messageTypes objectAtIndex:22] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_protobuf_unittest_BarResponse_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_protobuf_unittest_BarResponse_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[BarResponse class]
                                      builderClass:[BarResponse_Builder class]] retain];
    }
  }
}
+ (PBGeneratedExtension*) optionalInt32Extension {
  return UnittestProtoRoot_optionalInt32Extension;
}
+ (PBGeneratedExtension*) optionalInt64Extension {
  return UnittestProtoRoot_optionalInt64Extension;
}
+ (PBGeneratedExtension*) optionalUint32Extension {
  return UnittestProtoRoot_optionalUint32Extension;
}
+ (PBGeneratedExtension*) optionalUint64Extension {
  return UnittestProtoRoot_optionalUint64Extension;
}
+ (PBGeneratedExtension*) optionalSint32Extension {
  return UnittestProtoRoot_optionalSint32Extension;
}
+ (PBGeneratedExtension*) optionalSint64Extension {
  return UnittestProtoRoot_optionalSint64Extension;
}
+ (PBGeneratedExtension*) optionalFixed32Extension {
  return UnittestProtoRoot_optionalFixed32Extension;
}
+ (PBGeneratedExtension*) optionalFixed64Extension {
  return UnittestProtoRoot_optionalFixed64Extension;
}
+ (PBGeneratedExtension*) optionalSfixed32Extension {
  return UnittestProtoRoot_optionalSfixed32Extension;
}
+ (PBGeneratedExtension*) optionalSfixed64Extension {
  return UnittestProtoRoot_optionalSfixed64Extension;
}
+ (PBGeneratedExtension*) optionalFloatExtension {
  return UnittestProtoRoot_optionalFloatExtension;
}
+ (PBGeneratedExtension*) optionalDoubleExtension {
  return UnittestProtoRoot_optionalDoubleExtension;
}
+ (PBGeneratedExtension*) optionalBoolExtension {
  return UnittestProtoRoot_optionalBoolExtension;
}
+ (PBGeneratedExtension*) optionalStringExtension {
  return UnittestProtoRoot_optionalStringExtension;
}
+ (PBGeneratedExtension*) optionalBytesExtension {
  return UnittestProtoRoot_optionalBytesExtension;
}
+ (PBGeneratedExtension*) optionalGroupExtension {
  return UnittestProtoRoot_optionalGroupExtension;
}
+ (PBGeneratedExtension*) optionalNestedMessageExtension {
  return UnittestProtoRoot_optionalNestedMessageExtension;
}
+ (PBGeneratedExtension*) optionalForeignMessageExtension {
  return UnittestProtoRoot_optionalForeignMessageExtension;
}
+ (PBGeneratedExtension*) optionalImportMessageExtension {
  return UnittestProtoRoot_optionalImportMessageExtension;
}
+ (PBGeneratedExtension*) optionalNestedEnumExtension {
  return UnittestProtoRoot_optionalNestedEnumExtension;
}
+ (PBGeneratedExtension*) optionalForeignEnumExtension {
  return UnittestProtoRoot_optionalForeignEnumExtension;
}
+ (PBGeneratedExtension*) optionalImportEnumExtension {
  return UnittestProtoRoot_optionalImportEnumExtension;
}
+ (PBGeneratedExtension*) optionalStringPieceExtension {
  return UnittestProtoRoot_optionalStringPieceExtension;
}
+ (PBGeneratedExtension*) optionalCordExtension {
  return UnittestProtoRoot_optionalCordExtension;
}
+ (PBGeneratedExtension*) repeatedInt32Extension {
  return UnittestProtoRoot_repeatedInt32Extension;
}
+ (PBGeneratedExtension*) repeatedInt64Extension {
  return UnittestProtoRoot_repeatedInt64Extension;
}
+ (PBGeneratedExtension*) repeatedUint32Extension {
  return UnittestProtoRoot_repeatedUint32Extension;
}
+ (PBGeneratedExtension*) repeatedUint64Extension {
  return UnittestProtoRoot_repeatedUint64Extension;
}
+ (PBGeneratedExtension*) repeatedSint32Extension {
  return UnittestProtoRoot_repeatedSint32Extension;
}
+ (PBGeneratedExtension*) repeatedSint64Extension {
  return UnittestProtoRoot_repeatedSint64Extension;
}
+ (PBGeneratedExtension*) repeatedFixed32Extension {
  return UnittestProtoRoot_repeatedFixed32Extension;
}
+ (PBGeneratedExtension*) repeatedFixed64Extension {
  return UnittestProtoRoot_repeatedFixed64Extension;
}
+ (PBGeneratedExtension*) repeatedSfixed32Extension {
  return UnittestProtoRoot_repeatedSfixed32Extension;
}
+ (PBGeneratedExtension*) repeatedSfixed64Extension {
  return UnittestProtoRoot_repeatedSfixed64Extension;
}
+ (PBGeneratedExtension*) repeatedFloatExtension {
  return UnittestProtoRoot_repeatedFloatExtension;
}
+ (PBGeneratedExtension*) repeatedDoubleExtension {
  return UnittestProtoRoot_repeatedDoubleExtension;
}
+ (PBGeneratedExtension*) repeatedBoolExtension {
  return UnittestProtoRoot_repeatedBoolExtension;
}
+ (PBGeneratedExtension*) repeatedStringExtension {
  return UnittestProtoRoot_repeatedStringExtension;
}
+ (PBGeneratedExtension*) repeatedBytesExtension {
  return UnittestProtoRoot_repeatedBytesExtension;
}
+ (PBGeneratedExtension*) repeatedGroupExtension {
  return UnittestProtoRoot_repeatedGroupExtension;
}
+ (PBGeneratedExtension*) repeatedNestedMessageExtension {
  return UnittestProtoRoot_repeatedNestedMessageExtension;
}
+ (PBGeneratedExtension*) repeatedForeignMessageExtension {
  return UnittestProtoRoot_repeatedForeignMessageExtension;
}
+ (PBGeneratedExtension*) repeatedImportMessageExtension {
  return UnittestProtoRoot_repeatedImportMessageExtension;
}
+ (PBGeneratedExtension*) repeatedNestedEnumExtension {
  return UnittestProtoRoot_repeatedNestedEnumExtension;
}
+ (PBGeneratedExtension*) repeatedForeignEnumExtension {
  return UnittestProtoRoot_repeatedForeignEnumExtension;
}
+ (PBGeneratedExtension*) repeatedImportEnumExtension {
  return UnittestProtoRoot_repeatedImportEnumExtension;
}
+ (PBGeneratedExtension*) repeatedStringPieceExtension {
  return UnittestProtoRoot_repeatedStringPieceExtension;
}
+ (PBGeneratedExtension*) repeatedCordExtension {
  return UnittestProtoRoot_repeatedCordExtension;
}
+ (PBGeneratedExtension*) defaultInt32Extension {
  return UnittestProtoRoot_defaultInt32Extension;
}
+ (PBGeneratedExtension*) defaultInt64Extension {
  return UnittestProtoRoot_defaultInt64Extension;
}
+ (PBGeneratedExtension*) defaultUint32Extension {
  return UnittestProtoRoot_defaultUint32Extension;
}
+ (PBGeneratedExtension*) defaultUint64Extension {
  return UnittestProtoRoot_defaultUint64Extension;
}
+ (PBGeneratedExtension*) defaultSint32Extension {
  return UnittestProtoRoot_defaultSint32Extension;
}
+ (PBGeneratedExtension*) defaultSint64Extension {
  return UnittestProtoRoot_defaultSint64Extension;
}
+ (PBGeneratedExtension*) defaultFixed32Extension {
  return UnittestProtoRoot_defaultFixed32Extension;
}
+ (PBGeneratedExtension*) defaultFixed64Extension {
  return UnittestProtoRoot_defaultFixed64Extension;
}
+ (PBGeneratedExtension*) defaultSfixed32Extension {
  return UnittestProtoRoot_defaultSfixed32Extension;
}
+ (PBGeneratedExtension*) defaultSfixed64Extension {
  return UnittestProtoRoot_defaultSfixed64Extension;
}
+ (PBGeneratedExtension*) defaultFloatExtension {
  return UnittestProtoRoot_defaultFloatExtension;
}
+ (PBGeneratedExtension*) defaultDoubleExtension {
  return UnittestProtoRoot_defaultDoubleExtension;
}
+ (PBGeneratedExtension*) defaultBoolExtension {
  return UnittestProtoRoot_defaultBoolExtension;
}
+ (PBGeneratedExtension*) defaultStringExtension {
  return UnittestProtoRoot_defaultStringExtension;
}
+ (PBGeneratedExtension*) defaultBytesExtension {
  return UnittestProtoRoot_defaultBytesExtension;
}
+ (PBGeneratedExtension*) defaultNestedEnumExtension {
  return UnittestProtoRoot_defaultNestedEnumExtension;
}
+ (PBGeneratedExtension*) defaultForeignEnumExtension {
  return UnittestProtoRoot_defaultForeignEnumExtension;
}
+ (PBGeneratedExtension*) defaultImportEnumExtension {
  return UnittestProtoRoot_defaultImportEnumExtension;
}
+ (PBGeneratedExtension*) defaultStringPieceExtension {
  return UnittestProtoRoot_defaultStringPieceExtension;
}
+ (PBGeneratedExtension*) defaultCordExtension {
  return UnittestProtoRoot_defaultCordExtension;
}
+ (PBGeneratedExtension*) myExtensionString {
  return UnittestProtoRoot_myExtensionString;
}
+ (PBGeneratedExtension*) myExtensionInt {
  return UnittestProtoRoot_myExtensionInt;
}
+ (PBFileDescriptor*) descriptor {
  return descriptor;
}
+ (PBFileDescriptor*) buildDescriptor {
  static uint8_t descriptorData[] = {
    10,30,103,111,111,103,108,101,47,112,114,111,116,111,98,117,102,47,117,
    110,105,116,116,101,115,116,46,112,114,111,116,111,18,17,112,114,111,116,
    111,98,117,102,95,117,110,105,116,116,101,115,116,26,37,103,111,111,103,
    108,101,47,112,114,111,116,111,98,117,102,47,117,110,105,116,116,101,115,
    116,95,105,109,112,111,114,116,46,112,114,111,116,111,34,187,21,10,12,84,
    101,115,116,65,108,108,84,121,112,101,115,18,22,10,14,111,112,116,105,111,
    110,97,108,95,105,110,116,51,50,24,1,32,1,40,5,18,22,10,14,111,112,116,
    105,111,110,97,108,95,105,110,116,54,52,24,2,32,1,40,3,18,23,10,15,111,
    112,116,105,111,110,97,108,95,117,105,110,116,51,50,24,3,32,1,40,13,18,
    23,10,15,111,112,116,105,111,110,97,108,95,117,105,110,116,54,52,24,4,32,
    1,40,4,18,23,10,15,111,112,116,105,111,110,97,108,95,115,105,110,116,51,
    50,24,5,32,1,40,17,18,23,10,15,111,112,116,105,111,110,97,108,95,115,105,
    110,116,54,52,24,6,32,1,40,18,18,24,10,16,111,112,116,105,111,110,97,108,
    95,102,105,120,101,100,51,50,24,7,32,1,40,7,18,24,10,16,111,112,116,105,
    111,110,97,108,95,102,105,120,101,100,54,52,24,8,32,1,40,6,18,25,10,17,
    111,112,116,105,111,110,97,108,95,115,102,105,120,101,100,51,50,24,9,32,
    1,40,15,18,25,10,17,111,112,116,105,111,110,97,108,95,115,102,105,120,101,
    100,54,52,24,10,32,1,40,16,18,22,10,14,111,112,116,105,111,110,97,108,95,
    102,108,111,97,116,24,11,32,1,40,2,18,23,10,15,111,112,116,105,111,110,
    97,108,95,100,111,117,98,108,101,24,12,32,1,40,1,18,21,10,13,111,112,116,
    105,111,110,97,108,95,98,111,111,108,24,13,32,1,40,8,18,23,10,15,111,112,
    116,105,111,110,97,108,95,115,116,114,105,110,103,24,14,32,1,40,9,18,22,
    10,14,111,112,116,105,111,110,97,108,95,98,121,116,101,115,24,15,32,1,40,
    12,18,68,10,13,111,112,116,105,111,110,97,108,103,114,111,117,112,24,16,
    32,1,40,10,50,45,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,65,108,108,84,121,112,101,115,46,79,112,116,
    105,111,110,97,108,71,114,111,117,112,18,78,10,23,111,112,116,105,111,110,
    97,108,95,110,101,115,116,101,100,95,109,101,115,115,97,103,101,24,18,32,
    1,40,11,50,45,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,65,108,108,84,121,112,101,115,46,78,101,115,
    116,101,100,77,101,115,115,97,103,101,18,67,10,24,111,112,116,105,111,110,
    97,108,95,102,111,114,101,105,103,110,95,109,101,115,115,97,103,101,24,
    19,32,1,40,11,50,33,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,70,111,114,101,105,103,110,77,101,115,115,97,103,101,
    18,72,10,23,111,112,116,105,111,110,97,108,95,105,109,112,111,114,116,95,
    109,101,115,115,97,103,101,24,20,32,1,40,11,50,39,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,95,105,109,112,111,114,116,
    46,73,109,112,111,114,116,77,101,115,115,97,103,101,18,72,10,20,111,112,
    116,105,111,110,97,108,95,110,101,115,116,101,100,95,101,110,117,109,24,
    21,32,1,40,14,50,42,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,65,108,108,84,121,112,101,115,46,78,101,
    115,116,101,100,69,110,117,109,18,61,10,21,111,112,116,105,111,110,97,108,
    95,102,111,114,101,105,103,110,95,101,110,117,109,24,22,32,1,40,14,50,30,
    46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,
    70,111,114,101,105,103,110,69,110,117,109,18,66,10,20,111,112,116,105,111,
    110,97,108,95,105,109,112,111,114,116,95,101,110,117,109,24,23,32,1,40,
    14,50,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,95,105,109,112,111,114,116,46,73,109,112,111,114,116,69,110,117,109,
    18,33,10,21,111,112,116,105,111,110,97,108,95,115,116,114,105,110,103,95,
    112,105,101,99,101,24,24,32,1,40,9,66,2,8,2,18,25,10,13,111,112,116,105,
    111,110,97,108,95,99,111,114,100,24,25,32,1,40,9,66,2,8,1,18,22,10,14,114,
    101,112,101,97,116,101,100,95,105,110,116,51,50,24,31,32,3,40,5,18,22,10,
    14,114,101,112,101,97,116,101,100,95,105,110,116,54,52,24,32,32,3,40,3,
    18,23,10,15,114,101,112,101,97,116,101,100,95,117,105,110,116,51,50,24,
    33,32,3,40,13,18,23,10,15,114,101,112,101,97,116,101,100,95,117,105,110,
    116,54,52,24,34,32,3,40,4,18,23,10,15,114,101,112,101,97,116,101,100,95,
    115,105,110,116,51,50,24,35,32,3,40,17,18,23,10,15,114,101,112,101,97,116,
    101,100,95,115,105,110,116,54,52,24,36,32,3,40,18,18,24,10,16,114,101,112,
    101,97,116,101,100,95,102,105,120,101,100,51,50,24,37,32,3,40,7,18,24,10,
    16,114,101,112,101,97,116,101,100,95,102,105,120,101,100,54,52,24,38,32,
    3,40,6,18,25,10,17,114,101,112,101,97,116,101,100,95,115,102,105,120,101,
    100,51,50,24,39,32,3,40,15,18,25,10,17,114,101,112,101,97,116,101,100,95,
    115,102,105,120,101,100,54,52,24,40,32,3,40,16,18,22,10,14,114,101,112,
    101,97,116,101,100,95,102,108,111,97,116,24,41,32,3,40,2,18,23,10,15,114,
    101,112,101,97,116,101,100,95,100,111,117,98,108,101,24,42,32,3,40,1,18,
    21,10,13,114,101,112,101,97,116,101,100,95,98,111,111,108,24,43,32,3,40,
    8,18,23,10,15,114,101,112,101,97,116,101,100,95,115,116,114,105,110,103,
    24,44,32,3,40,9,18,22,10,14,114,101,112,101,97,116,101,100,95,98,121,116,
    101,115,24,45,32,3,40,12,18,68,10,13,114,101,112,101,97,116,101,100,103,
    114,111,117,112,24,46,32,3,40,10,50,45,46,112,114,111,116,111,98,117,102,
    95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,84,121,
    112,101,115,46,82,101,112,101,97,116,101,100,71,114,111,117,112,18,78,10,
    23,114,101,112,101,97,116,101,100,95,110,101,115,116,101,100,95,109,101,
    115,115,97,103,101,24,48,32,3,40,11,50,45,46,112,114,111,116,111,98,117,
    102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,84,
    121,112,101,115,46,78,101,115,116,101,100,77,101,115,115,97,103,101,18,
    67,10,24,114,101,112,101,97,116,101,100,95,102,111,114,101,105,103,110,
    95,109,101,115,115,97,103,101,24,49,32,3,40,11,50,33,46,112,114,111,116,
    111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,105,
    103,110,77,101,115,115,97,103,101,18,72,10,23,114,101,112,101,97,116,101,
    100,95,105,109,112,111,114,116,95,109,101,115,115,97,103,101,24,50,32,3,
    40,11,50,39,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,
    115,116,95,105,109,112,111,114,116,46,73,109,112,111,114,116,77,101,115,
    115,97,103,101,18,72,10,20,114,101,112,101,97,116,101,100,95,110,101,115,
    116,101,100,95,101,110,117,109,24,51,32,3,40,14,50,42,46,112,114,111,116,
    111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,
    108,108,84,121,112,101,115,46,78,101,115,116,101,100,69,110,117,109,18,
    61,10,21,114,101,112,101,97,116,101,100,95,102,111,114,101,105,103,110,
    95,101,110,117,109,24,52,32,3,40,14,50,30,46,112,114,111,116,111,98,117,
    102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,105,103,110,69,
    110,117,109,18,66,10,20,114,101,112,101,97,116,101,100,95,105,109,112,111,
    114,116,95,101,110,117,109,24,53,32,3,40,14,50,36,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,95,105,109,112,111,114,116,
    46,73,109,112,111,114,116,69,110,117,109,18,33,10,21,114,101,112,101,97,
    116,101,100,95,115,116,114,105,110,103,95,112,105,101,99,101,24,54,32,3,
    40,9,66,2,8,2,18,25,10,13,114,101,112,101,97,116,101,100,95,99,111,114,
    100,24,55,32,3,40,9,66,2,8,1,18,25,10,13,100,101,102,97,117,108,116,95,
    105,110,116,51,50,24,61,32,1,40,5,58,2,52,49,18,25,10,13,100,101,102,97,
    117,108,116,95,105,110,116,54,52,24,62,32,1,40,3,58,2,52,50,18,26,10,14,
    100,101,102,97,117,108,116,95,117,105,110,116,51,50,24,63,32,1,40,13,58,
    2,52,51,18,26,10,14,100,101,102,97,117,108,116,95,117,105,110,116,54,52,
    24,64,32,1,40,4,58,2,52,52,18,27,10,14,100,101,102,97,117,108,116,95,115,
    105,110,116,51,50,24,65,32,1,40,17,58,3,45,52,53,18,26,10,14,100,101,102,
    97,117,108,116,95,115,105,110,116,54,52,24,66,32,1,40,18,58,2,52,54,18,
    27,10,15,100,101,102,97,117,108,116,95,102,105,120,101,100,51,50,24,67,
    32,1,40,7,58,2,52,55,18,27,10,15,100,101,102,97,117,108,116,95,102,105,
    120,101,100,54,52,24,68,32,1,40,6,58,2,52,56,18,28,10,16,100,101,102,97,
    117,108,116,95,115,102,105,120,101,100,51,50,24,69,32,1,40,15,58,2,52,57,
    18,29,10,16,100,101,102,97,117,108,116,95,115,102,105,120,101,100,54,52,
    24,70,32,1,40,16,58,3,45,53,48,18,27,10,13,100,101,102,97,117,108,116,95,
    102,108,111,97,116,24,71,32,1,40,2,58,4,53,49,46,53,18,29,10,14,100,101,
    102,97,117,108,116,95,100,111,117,98,108,101,24,72,32,1,40,1,58,5,53,50,
    48,48,48,18,26,10,12,100,101,102,97,117,108,116,95,98,111,111,108,24,73,
    32,1,40,8,58,4,116,114,117,101,18,29,10,14,100,101,102,97,117,108,116,95,
    115,116,114,105,110,103,24,74,32,1,40,9,58,5,104,101,108,108,111,18,28,
    10,13,100,101,102,97,117,108,116,95,98,121,116,101,115,24,75,32,1,40,12,
    58,5,119,111,114,108,100,18,76,10,19,100,101,102,97,117,108,116,95,110,
    101,115,116,101,100,95,101,110,117,109,24,81,32,1,40,14,50,42,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,
    116,65,108,108,84,121,112,101,115,46,78,101,115,116,101,100,69,110,117,
    109,58,3,66,65,82,18,73,10,20,100,101,102,97,117,108,116,95,102,111,114,
    101,105,103,110,95,101,110,117,109,24,82,32,1,40,14,50,30,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,
    105,103,110,69,110,117,109,58,11,70,79,82,69,73,71,78,95,66,65,82,18,77,
    10,19,100,101,102,97,117,108,116,95,105,109,112,111,114,116,95,101,110,
    117,109,24,83,32,1,40,14,50,36,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,95,105,109,112,111,114,116,46,73,109,112,111,
    114,116,69,110,117,109,58,10,73,77,80,79,82,84,95,66,65,82,18,37,10,20,
    100,101,102,97,117,108,116,95,115,116,114,105,110,103,95,112,105,101,99,
    101,24,84,32,1,40,9,58,3,97,98,99,66,2,8,2,18,29,10,12,100,101,102,97,117,
    108,116,95,99,111,114,100,24,85,32,1,40,9,58,3,49,50,51,66,2,8,1,26,27,
    10,13,78,101,115,116,101,100,77,101,115,115,97,103,101,18,10,10,2,98,98,
    24,1,32,1,40,5,26,26,10,13,79,112,116,105,111,110,97,108,71,114,111,117,
    112,18,9,10,1,97,24,17,32,1,40,5,26,26,10,13,82,101,112,101,97,116,101,
    100,71,114,111,117,112,18,9,10,1,97,24,47,32,1,40,5,34,39,10,10,78,101,
    115,116,101,100,69,110,117,109,18,7,10,3,70,79,79,16,1,18,7,10,3,66,65,
    82,16,2,18,7,10,3,66,65,90,16,3,34,27,10,14,70,111,114,101,105,103,110,
    77,101,115,115,97,103,101,18,9,10,1,99,24,1,32,1,40,5,34,29,10,17,84,101,
    115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,42,8,8,1,16,128,
    128,128,128,2,34,36,10,23,79,112,116,105,111,110,97,108,71,114,111,117,
    112,95,101,120,116,101,110,115,105,111,110,18,9,10,1,97,24,17,32,1,40,5,
    34,36,10,23,82,101,112,101,97,116,101,100,71,114,111,117,112,95,101,120,
    116,101,110,115,105,111,110,18,9,10,1,97,24,47,32,1,40,5,34,213,5,10,12,
    84,101,115,116,82,101,113,117,105,114,101,100,18,9,10,1,97,24,1,32,2,40,
    5,18,14,10,6,100,117,109,109,121,50,24,2,32,1,40,5,18,9,10,1,98,24,3,32,
    2,40,5,18,14,10,6,100,117,109,109,121,52,24,4,32,1,40,5,18,14,10,6,100,
    117,109,109,121,53,24,5,32,1,40,5,18,14,10,6,100,117,109,109,121,54,24,
    6,32,1,40,5,18,14,10,6,100,117,109,109,121,55,24,7,32,1,40,5,18,14,10,6,
    100,117,109,109,121,56,24,8,32,1,40,5,18,14,10,6,100,117,109,109,121,57,
    24,9,32,1,40,5,18,15,10,7,100,117,109,109,121,49,48,24,10,32,1,40,5,18,
    15,10,7,100,117,109,109,121,49,49,24,11,32,1,40,5,18,15,10,7,100,117,109,
    109,121,49,50,24,12,32,1,40,5,18,15,10,7,100,117,109,109,121,49,51,24,13,
    32,1,40,5,18,15,10,7,100,117,109,109,121,49,52,24,14,32,1,40,5,18,15,10,
    7,100,117,109,109,121,49,53,24,15,32,1,40,5,18,15,10,7,100,117,109,109,
    121,49,54,24,16,32,1,40,5,18,15,10,7,100,117,109,109,121,49,55,24,17,32,
    1,40,5,18,15,10,7,100,117,109,109,121,49,56,24,18,32,1,40,5,18,15,10,7,
    100,117,109,109,121,49,57,24,19,32,1,40,5,18,15,10,7,100,117,109,109,121,
    50,48,24,20,32,1,40,5,18,15,10,7,100,117,109,109,121,50,49,24,21,32,1,40,
    5,18,15,10,7,100,117,109,109,121,50,50,24,22,32,1,40,5,18,15,10,7,100,117,
    109,109,121,50,51,24,23,32,1,40,5,18,15,10,7,100,117,109,109,121,50,52,
    24,24,32,1,40,5,18,15,10,7,100,117,109,109,121,50,53,24,25,32,1,40,5,18,
    15,10,7,100,117,109,109,121,50,54,24,26,32,1,40,5,18,15,10,7,100,117,109,
    109,121,50,55,24,27,32,1,40,5,18,15,10,7,100,117,109,109,121,50,56,24,28,
    32,1,40,5,18,15,10,7,100,117,109,109,121,50,57,24,29,32,1,40,5,18,15,10,
    7,100,117,109,109,121,51,48,24,30,32,1,40,5,18,15,10,7,100,117,109,109,
    121,51,49,24,31,32,1,40,5,18,15,10,7,100,117,109,109,121,51,50,24,32,32,
    1,40,5,18,9,10,1,99,24,33,32,2,40,5,50,86,10,6,115,105,110,103,108,101,
    18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,
    24,232,7,32,1,40,11,50,31,46,112,114,111,116,111,98,117,102,95,117,110,
    105,116,116,101,115,116,46,84,101,115,116,82,101,113,117,105,114,101,100,
    50,85,10,5,109,117,108,116,105,18,36,46,112,114,111,116,111,98,117,102,
    95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,
    116,101,110,115,105,111,110,115,24,233,7,32,3,40,11,50,31,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,
    82,101,113,117,105,114,101,100,34,154,1,10,19,84,101,115,116,82,101,113,
    117,105,114,101,100,70,111,114,101,105,103,110,18,57,10,16,111,112,116,
    105,111,110,97,108,95,109,101,115,115,97,103,101,24,1,32,1,40,11,50,31,
    46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,
    84,101,115,116,82,101,113,117,105,114,101,100,18,57,10,16,114,101,112,101,
    97,116,101,100,95,109,101,115,115,97,103,101,24,2,32,3,40,11,50,31,46,112,
    114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,
    115,116,82,101,113,117,105,114,101,100,18,13,10,5,100,117,109,109,121,24,
    3,32,1,40,5,34,90,10,17,84,101,115,116,70,111,114,101,105,103,110,78,101,
    115,116,101,100,18,69,10,14,102,111,114,101,105,103,110,95,110,101,115,
    116,101,100,24,1,32,1,40,11,50,45,46,112,114,111,116,111,98,117,102,95,
    117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,84,121,112,
    101,115,46,78,101,115,116,101,100,77,101,115,115,97,103,101,34,18,10,16,
    84,101,115,116,69,109,112,116,121,77,101,115,115,97,103,101,34,42,10,30,
    84,101,115,116,69,109,112,116,121,77,101,115,115,97,103,101,87,105,116,
    104,69,120,116,101,110,115,105,111,110,115,42,8,8,1,16,128,128,128,128,
    2,34,52,10,24,84,101,115,116,82,101,97,108,108,121,76,97,114,103,101,84,
    97,103,78,117,109,98,101,114,18,9,10,1,97,24,1,32,1,40,5,18,13,10,2,98,
    98,24,255,255,255,127,32,1,40,5,34,85,10,20,84,101,115,116,82,101,99,117,
    114,115,105,118,101,77,101,115,115,97,103,101,18,50,10,1,97,24,1,32,1,40,
    11,50,39,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,82,101,99,117,114,115,105,118,101,77,101,115,115,
    97,103,101,18,9,10,1,105,24,2,32,1,40,5,34,75,10,20,84,101,115,116,77,117,
    116,117,97,108,82,101,99,117,114,115,105,111,110,65,18,51,10,2,98,98,24,
    1,32,1,40,11,50,39,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,77,117,116,117,97,108,82,101,99,117,114,
    115,105,111,110,66,34,98,10,20,84,101,115,116,77,117,116,117,97,108,82,
    101,99,117,114,115,105,111,110,66,18,50,10,1,97,24,1,32,1,40,11,50,39,46,
    112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,
    101,115,116,77,117,116,117,97,108,82,101,99,117,114,115,105,111,110,65,
    18,22,10,14,111,112,116,105,111,110,97,108,95,105,110,116,51,50,24,2,32,
    1,40,5,34,179,1,10,18,84,101,115,116,68,117,112,70,105,101,108,100,78,117,
    109,98,101,114,18,9,10,1,97,24,1,32,1,40,5,18,54,10,3,102,111,111,24,2,
    32,1,40,10,50,41,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,68,117,112,70,105,101,108,100,78,117,109,
    98,101,114,46,70,111,111,18,54,10,3,98,97,114,24,3,32,1,40,10,50,41,46,
    112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,
    101,115,116,68,117,112,70,105,101,108,100,78,117,109,98,101,114,46,66,97,
    114,26,16,10,3,70,111,111,18,9,10,1,97,24,1,32,1,40,5,26,16,10,3,66,97,
    114,18,9,10,1,97,24,1,32,1,40,5,34,128,2,10,24,84,101,115,116,78,101,115,
    116,101,100,77,101,115,115,97,103,101,72,97,115,66,105,116,115,18,90,10,
    23,111,112,116,105,111,110,97,108,95,110,101,115,116,101,100,95,109,101,
    115,115,97,103,101,24,1,32,1,40,11,50,57,46,112,114,111,116,111,98,117,
    102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,78,101,115,116,
    101,100,77,101,115,115,97,103,101,72,97,115,66,105,116,115,46,78,101,115,
    116,101,100,77,101,115,115,97,103,101,26,135,1,10,13,78,101,115,116,101,
    100,77,101,115,115,97,103,101,18,36,10,28,110,101,115,116,101,100,109,101,
    115,115,97,103,101,95,114,101,112,101,97,116,101,100,95,105,110,116,51,
    50,24,1,32,3,40,5,18,80,10,37,110,101,115,116,101,100,109,101,115,115,97,
    103,101,95,114,101,112,101,97,116,101,100,95,102,111,114,101,105,103,110,
    109,101,115,115,97,103,101,24,2,32,3,40,11,50,33,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,105,103,
    110,77,101,115,115,97,103,101,34,229,3,10,23,84,101,115,116,67,97,109,101,
    108,67,97,115,101,70,105,101,108,100,78,97,109,101,115,18,22,10,14,80,114,
    105,109,105,116,105,118,101,70,105,101,108,100,24,1,32,1,40,5,18,19,10,
    11,83,116,114,105,110,103,70,105,101,108,100,24,2,32,1,40,9,18,49,10,9,
    69,110,117,109,70,105,101,108,100,24,3,32,1,40,14,50,30,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,
    105,103,110,69,110,117,109,18,55,10,12,77,101,115,115,97,103,101,70,105,
    101,108,100,24,4,32,1,40,11,50,33,46,112,114,111,116,111,98,117,102,95,
    117,110,105,116,116,101,115,116,46,70,111,114,101,105,103,110,77,101,115,
    115,97,103,101,18,28,10,16,83,116,114,105,110,103,80,105,101,99,101,70,
    105,101,108,100,24,5,32,1,40,9,66,2,8,2,18,21,10,9,67,111,114,100,70,105,
    101,108,100,24,6,32,1,40,9,66,2,8,1,18,30,10,22,82,101,112,101,97,116,101,
    100,80,114,105,109,105,116,105,118,101,70,105,101,108,100,24,7,32,3,40,
    5,18,27,10,19,82,101,112,101,97,116,101,100,83,116,114,105,110,103,70,105,
    101,108,100,24,8,32,3,40,9,18,57,10,17,82,101,112,101,97,116,101,100,69,
    110,117,109,70,105,101,108,100,24,9,32,3,40,14,50,30,46,112,114,111,116,
    111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,105,
    103,110,69,110,117,109,18,63,10,20,82,101,112,101,97,116,101,100,77,101,
    115,115,97,103,101,70,105,101,108,100,24,10,32,3,40,11,50,33,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,
    101,105,103,110,77,101,115,115,97,103,101,18,36,10,24,82,101,112,101,97,
    116,101,100,83,116,114,105,110,103,80,105,101,99,101,70,105,101,108,100,
    24,11,32,3,40,9,66,2,8,2,18,29,10,17,82,101,112,101,97,116,101,100,67,111,
    114,100,70,105,101,108,100,24,12,32,3,40,9,66,2,8,1,34,85,10,18,84,101,
    115,116,70,105,101,108,100,79,114,100,101,114,105,110,103,115,18,17,10,
    9,109,121,95,115,116,114,105,110,103,24,11,32,1,40,9,18,14,10,6,109,121,
    95,105,110,116,24,1,32,1,40,3,18,16,10,8,109,121,95,102,108,111,97,116,
    24,101,32,1,40,2,42,4,8,2,16,11,42,4,8,12,16,101,34,144,2,10,24,84,101,
    115,116,69,120,116,114,101,109,101,68,101,102,97,117,108,116,86,97,108,
    117,101,115,18,63,10,13,101,115,99,97,112,101,100,95,98,121,116,101,115,
    24,1,32,1,40,12,58,40,92,48,48,48,92,48,48,49,92,48,48,55,92,48,49,48,92,
    48,49,52,92,110,92,114,92,116,92,48,49,51,92,92,92,39,92,34,92,51,55,54,
    18,32,10,12,108,97,114,103,101,95,117,105,110,116,51,50,24,2,32,1,40,13,
    58,10,52,50,57,52,57,54,55,50,57,53,18,42,10,12,108,97,114,103,101,95,117,
    105,110,116,54,52,24,3,32,1,40,4,58,20,49,56,52,52,54,55,52,52,48,55,51,
    55,48,57,53,53,49,54,49,53,18,32,10,11,115,109,97,108,108,95,105,110,116,
    51,50,24,4,32,1,40,5,58,11,45,50,49,52,55,52,56,51,54,52,55,18,41,10,11,
    115,109,97,108,108,95,105,110,116,54,52,24,5,32,1,40,3,58,20,45,57,50,50,
    51,51,55,50,48,51,54,56,53,52,55,55,53,56,48,55,18,24,10,11,117,116,102,
    56,95,115,116,114,105,110,103,24,6,32,1,40,9,58,3,225,136,180,34,12,10,
    10,70,111,111,82,101,113,117,101,115,116,34,13,10,11,70,111,111,82,101,
    115,112,111,110,115,101,34,12,10,10,66,97,114,82,101,113,117,101,115,116,
    34,13,10,11,66,97,114,82,101,115,112,111,110,115,101,42,64,10,11,70,111,
    114,101,105,103,110,69,110,117,109,18,15,10,11,70,79,82,69,73,71,78,95,
    70,79,79,16,4,18,15,10,11,70,79,82,69,73,71,78,95,66,65,82,16,5,18,15,10,
    11,70,79,82,69,73,71,78,95,66,65,90,16,6,42,71,10,20,84,101,115,116,69,
    110,117,109,87,105,116,104,68,117,112,86,97,108,117,101,18,8,10,4,70,79,
    79,49,16,1,18,8,10,4,66,65,82,49,16,2,18,7,10,3,66,65,90,16,3,18,8,10,4,
    70,79,79,50,16,1,18,8,10,4,66,65,82,50,16,2,42,137,1,10,14,84,101,115,116,
    83,112,97,114,115,101,69,110,117,109,18,12,10,8,83,80,65,82,83,69,95,65,
    16,123,18,14,10,8,83,80,65,82,83,69,95,66,16,166,231,3,18,15,10,8,83,80,
    65,82,83,69,95,67,16,178,177,128,6,18,21,10,8,83,80,65,82,83,69,95,68,16,
    241,255,255,255,255,255,255,255,255,1,18,21,10,8,83,80,65,82,83,69,95,69,
    16,180,222,252,255,255,255,255,255,255,1,18,12,10,8,83,80,65,82,83,69,95,
    70,16,0,18,12,10,8,83,80,65,82,83,69,95,71,16,2,50,153,1,10,11,84,101,115,
    116,83,101,114,118,105,99,101,18,68,10,3,70,111,111,18,29,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,111,82,
    101,113,117,101,115,116,26,30,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,70,111,111,82,101,115,112,111,110,115,101,
    18,68,10,3,66,97,114,18,29,46,112,114,111,116,111,98,117,102,95,117,110,
    105,116,116,101,115,116,46,66,97,114,82,101,113,117,101,115,116,26,30,46,
    112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,66,
    97,114,82,101,115,112,111,110,115,101,58,70,10,24,111,112,116,105,111,110,
    97,108,95,105,110,116,51,50,95,101,120,116,101,110,115,105,111,110,18,36,
    46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,
    84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,1,32,
    1,40,5,58,70,10,24,111,112,116,105,111,110,97,108,95,105,110,116,54,52,
    95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,
    117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,
    69,120,116,101,110,115,105,111,110,115,24,2,32,1,40,3,58,71,10,25,111,112,
    116,105,111,110,97,108,95,117,105,110,116,51,50,95,101,120,116,101,110,
    115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,
    116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,
    105,111,110,115,24,3,32,1,40,13,58,71,10,25,111,112,116,105,111,110,97,
    108,95,117,105,110,116,54,52,95,101,120,116,101,110,115,105,111,110,18,
    36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,
    46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,
    4,32,1,40,4,58,71,10,25,111,112,116,105,111,110,97,108,95,115,105,110,116,
    51,50,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,
    108,69,120,116,101,110,115,105,111,110,115,24,5,32,1,40,17,58,71,10,25,
    111,112,116,105,111,110,97,108,95,115,105,110,116,54,52,95,101,120,116,
    101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,
    110,115,105,111,110,115,24,6,32,1,40,18,58,72,10,26,111,112,116,105,111,
    110,97,108,95,102,105,120,101,100,51,50,95,101,120,116,101,110,115,105,
    111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,
    110,115,24,7,32,1,40,7,58,72,10,26,111,112,116,105,111,110,97,108,95,102,
    105,120,101,100,54,52,95,101,120,116,101,110,115,105,111,110,18,36,46,112,
    114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,
    115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,8,32,1,40,
    6,58,73,10,27,111,112,116,105,111,110,97,108,95,115,102,105,120,101,100,
    51,50,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,
    108,69,120,116,101,110,115,105,111,110,115,24,9,32,1,40,15,58,73,10,27,
    111,112,116,105,111,110,97,108,95,115,102,105,120,101,100,54,52,95,101,
    120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,
    95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,
    116,101,110,115,105,111,110,115,24,10,32,1,40,16,58,70,10,24,111,112,116,
    105,111,110,97,108,95,102,108,111,97,116,95,101,120,116,101,110,115,105,
    111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,
    110,115,24,11,32,1,40,2,58,71,10,25,111,112,116,105,111,110,97,108,95,100,
    111,117,98,108,101,95,101,120,116,101,110,115,105,111,110,18,36,46,112,
    114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,
    115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,12,32,1,40,
    1,58,69,10,23,111,112,116,105,111,110,97,108,95,98,111,111,108,95,101,120,
    116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,
    117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,
    101,110,115,105,111,110,115,24,13,32,1,40,8,58,71,10,25,111,112,116,105,
    111,110,97,108,95,115,116,114,105,110,103,95,101,120,116,101,110,115,105,
    111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,
    110,115,24,14,32,1,40,9,58,70,10,24,111,112,116,105,111,110,97,108,95,98,
    121,116,101,115,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,
    116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,15,32,1,40,12,
    58,113,10,23,111,112,116,105,111,110,97,108,103,114,111,117,112,95,101,
    120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,
    95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,
    116,101,110,115,105,111,110,115,24,16,32,1,40,10,50,42,46,112,114,111,116,
    111,98,117,102,95,117,110,105,116,116,101,115,116,46,79,112,116,105,111,
    110,97,108,71,114,111,117,112,95,101,120,116,101,110,115,105,111,110,58,
    126,10,33,111,112,116,105,111,110,97,108,95,110,101,115,116,101,100,95,
    109,101,115,115,97,103,101,95,101,120,116,101,110,115,105,111,110,18,36,
    46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,
    84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,18,
    32,1,40,11,50,45,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,65,108,108,84,121,112,101,115,46,78,101,115,
    116,101,100,77,101,115,115,97,103,101,58,115,10,34,111,112,116,105,111,
    110,97,108,95,102,111,114,101,105,103,110,95,109,101,115,115,97,103,101,
    95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,
    117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,
    69,120,116,101,110,115,105,111,110,115,24,19,32,1,40,11,50,33,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,
    101,105,103,110,77,101,115,115,97,103,101,58,120,10,33,111,112,116,105,
    111,110,97,108,95,105,109,112,111,114,116,95,109,101,115,115,97,103,101,
    95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,
    117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,
    69,120,116,101,110,115,105,111,110,115,24,20,32,1,40,11,50,39,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,95,105,109,112,
    111,114,116,46,73,109,112,111,114,116,77,101,115,115,97,103,101,58,120,
    10,30,111,112,116,105,111,110,97,108,95,110,101,115,116,101,100,95,101,
    110,117,109,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,
    65,108,108,69,120,116,101,110,115,105,111,110,115,24,21,32,1,40,14,50,42,
    46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,
    84,101,115,116,65,108,108,84,121,112,101,115,46,78,101,115,116,101,100,
    69,110,117,109,58,109,10,31,111,112,116,105,111,110,97,108,95,102,111,114,
    101,105,103,110,95,101,110,117,109,95,101,120,116,101,110,115,105,111,110,
    18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,
    24,22,32,1,40,14,50,30,46,112,114,111,116,111,98,117,102,95,117,110,105,
    116,116,101,115,116,46,70,111,114,101,105,103,110,69,110,117,109,58,114,
    10,30,111,112,116,105,111,110,97,108,95,105,109,112,111,114,116,95,101,
    110,117,109,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,
    65,108,108,69,120,116,101,110,115,105,111,110,115,24,23,32,1,40,14,50,36,
    46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,95,
    105,109,112,111,114,116,46,73,109,112,111,114,116,69,110,117,109,58,81,
    10,31,111,112,116,105,111,110,97,108,95,115,116,114,105,110,103,95,112,
    105,101,99,101,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,
    116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,24,32,1,40,9,66,
    2,8,2,58,73,10,23,111,112,116,105,111,110,97,108,95,99,111,114,100,95,101,
    120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,
    95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,
    116,101,110,115,105,111,110,115,24,25,32,1,40,9,66,2,8,1,58,70,10,24,114,
    101,112,101,97,116,101,100,95,105,110,116,51,50,95,101,120,116,101,110,
    115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,
    116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,
    105,111,110,115,24,31,32,3,40,5,58,70,10,24,114,101,112,101,97,116,101,
    100,95,105,110,116,54,52,95,101,120,116,101,110,115,105,111,110,18,36,46,
    112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,
    101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,32,32,
    3,40,3,58,71,10,25,114,101,112,101,97,116,101,100,95,117,105,110,116,51,
    50,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,
    108,69,120,116,101,110,115,105,111,110,115,24,33,32,3,40,13,58,71,10,25,
    114,101,112,101,97,116,101,100,95,117,105,110,116,54,52,95,101,120,116,
    101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,
    110,115,105,111,110,115,24,34,32,3,40,4,58,71,10,25,114,101,112,101,97,
    116,101,100,95,115,105,110,116,51,50,95,101,120,116,101,110,115,105,111,
    110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,
    115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,
    115,24,35,32,3,40,17,58,71,10,25,114,101,112,101,97,116,101,100,95,115,
    105,110,116,54,52,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,
    116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,36,32,3,40,18,
    58,72,10,26,114,101,112,101,97,116,101,100,95,102,105,120,101,100,51,50,
    95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,
    117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,
    69,120,116,101,110,115,105,111,110,115,24,37,32,3,40,7,58,72,10,26,114,
    101,112,101,97,116,101,100,95,102,105,120,101,100,54,52,95,101,120,116,
    101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,
    110,115,105,111,110,115,24,38,32,3,40,6,58,73,10,27,114,101,112,101,97,
    116,101,100,95,115,102,105,120,101,100,51,50,95,101,120,116,101,110,115,
    105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,
    111,110,115,24,39,32,3,40,15,58,73,10,27,114,101,112,101,97,116,101,100,
    95,115,102,105,120,101,100,54,52,95,101,120,116,101,110,115,105,111,110,
    18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,
    24,40,32,3,40,16,58,70,10,24,114,101,112,101,97,116,101,100,95,102,108,
    111,97,116,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,
    65,108,108,69,120,116,101,110,115,105,111,110,115,24,41,32,3,40,2,58,71,
    10,25,114,101,112,101,97,116,101,100,95,100,111,117,98,108,101,95,101,120,
    116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,
    117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,
    101,110,115,105,111,110,115,24,42,32,3,40,1,58,69,10,23,114,101,112,101,
    97,116,101,100,95,98,111,111,108,95,101,120,116,101,110,115,105,111,110,
    18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,
    24,43,32,3,40,8,58,71,10,25,114,101,112,101,97,116,101,100,95,115,116,114,
    105,110,103,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,
    65,108,108,69,120,116,101,110,115,105,111,110,115,24,44,32,3,40,9,58,70,
    10,24,114,101,112,101,97,116,101,100,95,98,121,116,101,115,95,101,120,116,
    101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,
    110,115,105,111,110,115,24,45,32,3,40,12,58,113,10,23,114,101,112,101,97,
    116,101,100,103,114,111,117,112,95,101,120,116,101,110,115,105,111,110,
    18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,
    24,46,32,3,40,10,50,42,46,112,114,111,116,111,98,117,102,95,117,110,105,
    116,116,101,115,116,46,82,101,112,101,97,116,101,100,71,114,111,117,112,
    95,101,120,116,101,110,115,105,111,110,58,126,10,33,114,101,112,101,97,
    116,101,100,95,110,101,115,116,101,100,95,109,101,115,115,97,103,101,95,
    101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,
    102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,
    120,116,101,110,115,105,111,110,115,24,48,32,3,40,11,50,45,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,
    65,108,108,84,121,112,101,115,46,78,101,115,116,101,100,77,101,115,115,
    97,103,101,58,115,10,34,114,101,112,101,97,116,101,100,95,102,111,114,101,
    105,103,110,95,109,101,115,115,97,103,101,95,101,120,116,101,110,115,105,
    111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,
    101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,
    110,115,24,49,32,3,40,11,50,33,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,70,111,114,101,105,103,110,77,101,115,115,
    97,103,101,58,120,10,33,114,101,112,101,97,116,101,100,95,105,109,112,111,
    114,116,95,109,101,115,115,97,103,101,95,101,120,116,101,110,115,105,111,
    110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,
    115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,
    115,24,50,32,3,40,11,50,39,46,112,114,111,116,111,98,117,102,95,117,110,
    105,116,116,101,115,116,95,105,109,112,111,114,116,46,73,109,112,111,114,
    116,77,101,115,115,97,103,101,58,120,10,30,114,101,112,101,97,116,101,100,
    95,110,101,115,116,101,100,95,101,110,117,109,95,101,120,116,101,110,115,
    105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,
    111,110,115,24,51,32,3,40,14,50,42,46,112,114,111,116,111,98,117,102,95,
    117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,84,121,112,
    101,115,46,78,101,115,116,101,100,69,110,117,109,58,109,10,31,114,101,112,
    101,97,116,101,100,95,102,111,114,101,105,103,110,95,101,110,117,109,95,
    101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,
    102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,
    120,116,101,110,115,105,111,110,115,24,52,32,3,40,14,50,30,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,
    105,103,110,69,110,117,109,58,114,10,30,114,101,112,101,97,116,101,100,
    95,105,109,112,111,114,116,95,101,110,117,109,95,101,120,116,101,110,115,
    105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,
    111,110,115,24,53,32,3,40,14,50,36,46,112,114,111,116,111,98,117,102,95,
    117,110,105,116,116,101,115,116,95,105,109,112,111,114,116,46,73,109,112,
    111,114,116,69,110,117,109,58,81,10,31,114,101,112,101,97,116,101,100,95,
    115,116,114,105,110,103,95,112,105,101,99,101,95,101,120,116,101,110,115,
    105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,
    111,110,115,24,54,32,3,40,9,66,2,8,2,58,73,10,23,114,101,112,101,97,116,
    101,100,95,99,111,114,100,95,101,120,116,101,110,115,105,111,110,18,36,
    46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,
    84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,55,
    32,3,40,9,66,2,8,1,58,73,10,23,100,101,102,97,117,108,116,95,105,110,116,
    51,50,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,
    108,69,120,116,101,110,115,105,111,110,115,24,61,32,1,40,5,58,2,52,49,58,
    73,10,23,100,101,102,97,117,108,116,95,105,110,116,54,52,95,101,120,116,
    101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,
    110,115,105,111,110,115,24,62,32,1,40,3,58,2,52,50,58,74,10,24,100,101,
    102,97,117,108,116,95,117,105,110,116,51,50,95,101,120,116,101,110,115,
    105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,
    111,110,115,24,63,32,1,40,13,58,2,52,51,58,74,10,24,100,101,102,97,117,
    108,116,95,117,105,110,116,54,52,95,101,120,116,101,110,115,105,111,110,
    18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,
    24,64,32,1,40,4,58,2,52,52,58,75,10,24,100,101,102,97,117,108,116,95,115,
    105,110,116,51,50,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,
    116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,65,32,1,40,17,
    58,3,45,52,53,58,74,10,24,100,101,102,97,117,108,116,95,115,105,110,116,
    54,52,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,
    108,69,120,116,101,110,115,105,111,110,115,24,66,32,1,40,18,58,2,52,54,
    58,75,10,25,100,101,102,97,117,108,116,95,102,105,120,101,100,51,50,95,
    101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,
    102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,
    120,116,101,110,115,105,111,110,115,24,67,32,1,40,7,58,2,52,55,58,75,10,
    25,100,101,102,97,117,108,116,95,102,105,120,101,100,54,52,95,101,120,116,
    101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,
    110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,
    110,115,105,111,110,115,24,68,32,1,40,6,58,2,52,56,58,76,10,26,100,101,
    102,97,117,108,116,95,115,102,105,120,101,100,51,50,95,101,120,116,101,
    110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,
    105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,
    115,105,111,110,115,24,69,32,1,40,15,58,2,52,57,58,77,10,26,100,101,102,
    97,117,108,116,95,115,102,105,120,101,100,54,52,95,101,120,116,101,110,
    115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,
    116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,
    105,111,110,115,24,70,32,1,40,16,58,3,45,53,48,58,75,10,23,100,101,102,
    97,117,108,116,95,102,108,111,97,116,95,101,120,116,101,110,115,105,111,
    110,18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,
    115,116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,
    115,24,71,32,1,40,2,58,4,53,49,46,53,58,77,10,24,100,101,102,97,117,108,
    116,95,100,111,117,98,108,101,95,101,120,116,101,110,115,105,111,110,18,
    36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,
    46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,
    72,32,1,40,1,58,5,53,50,48,48,48,58,74,10,22,100,101,102,97,117,108,116,
    95,98,111,111,108,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,
    116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,73,32,1,40,8,58,
    4,116,114,117,101,58,77,10,24,100,101,102,97,117,108,116,95,115,116,114,
    105,110,103,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,
    116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,
    65,108,108,69,120,116,101,110,115,105,111,110,115,24,74,32,1,40,9,58,5,
    104,101,108,108,111,58,76,10,23,100,101,102,97,117,108,116,95,98,121,116,
    101,115,95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,
    111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,
    108,108,69,120,116,101,110,115,105,111,110,115,24,75,32,1,40,12,58,5,119,
    111,114,108,100,58,124,10,29,100,101,102,97,117,108,116,95,110,101,115,
    116,101,100,95,101,110,117,109,95,101,120,116,101,110,115,105,111,110,18,
    36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,
    46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,
    81,32,1,40,14,50,42,46,112,114,111,116,111,98,117,102,95,117,110,105,116,
    116,101,115,116,46,84,101,115,116,65,108,108,84,121,112,101,115,46,78,101,
    115,116,101,100,69,110,117,109,58,3,66,65,82,58,121,10,30,100,101,102,97,
    117,108,116,95,102,111,114,101,105,103,110,95,101,110,117,109,95,101,120,
    116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,117,102,95,
    117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,69,120,116,
    101,110,115,105,111,110,115,24,82,32,1,40,14,50,30,46,112,114,111,116,111,
    98,117,102,95,117,110,105,116,116,101,115,116,46,70,111,114,101,105,103,
    110,69,110,117,109,58,11,70,79,82,69,73,71,78,95,66,65,82,58,125,10,29,
    100,101,102,97,117,108,116,95,105,109,112,111,114,116,95,101,110,117,109,
    95,101,120,116,101,110,115,105,111,110,18,36,46,112,114,111,116,111,98,
    117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,65,108,108,
    69,120,116,101,110,115,105,111,110,115,24,83,32,1,40,14,50,36,46,112,114,
    111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,95,105,109,112,
    111,114,116,46,73,109,112,111,114,116,69,110,117,109,58,10,73,77,80,79,
    82,84,95,66,65,82,58,85,10,30,100,101,102,97,117,108,116,95,115,116,114,
    105,110,103,95,112,105,101,99,101,95,101,120,116,101,110,115,105,111,110,
    18,36,46,112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,
    116,46,84,101,115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,
    24,84,32,1,40,9,58,3,97,98,99,66,2,8,2,58,77,10,22,100,101,102,97,117,108,
    116,95,99,111,114,100,95,101,120,116,101,110,115,105,111,110,18,36,46,112,
    114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,101,
    115,116,65,108,108,69,120,116,101,110,115,105,111,110,115,24,85,32,1,40,
    9,58,3,49,50,51,66,2,8,1,58,66,10,19,109,121,95,101,120,116,101,110,115,
    105,111,110,95,115,116,114,105,110,103,18,37,46,112,114,111,116,111,98,
    117,102,95,117,110,105,116,116,101,115,116,46,84,101,115,116,70,105,101,
    108,100,79,114,100,101,114,105,110,103,115,24,50,32,1,40,9,58,63,10,16,
    109,121,95,101,120,116,101,110,115,105,111,110,95,105,110,116,18,37,46,
    112,114,111,116,111,98,117,102,95,117,110,105,116,116,101,115,116,46,84,
    101,115,116,70,105,101,108,100,79,114,100,101,114,105,110,103,115,24,5,
    32,1,40,5,66,17,66,13,85,110,105,116,116,101,115,116,80,114,111,116,111,
    72,1,
  };
  NSArray* dependencies = [NSArray arrayWithObjects:[UnittestImportProtoRoot descriptor], nil];
  
  NSData* data = [NSData dataWithBytes:descriptorData length:12136];
  PBFileDescriptorProto* proto = [PBFileDescriptorProto parseFromData:data];
  return [PBFileDescriptor buildFrom:proto dependencies:dependencies];
}
@end

@interface ForeignEnum ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation ForeignEnum
@synthesize index;
@synthesize value;
static ForeignEnum* ForeignEnum_FOREIGN_FOO = nil;
static ForeignEnum* ForeignEnum_FOREIGN_BAR = nil;
static ForeignEnum* ForeignEnum_FOREIGN_BAZ = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (ForeignEnum*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[ForeignEnum alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [ForeignEnum class]) {
    ForeignEnum_FOREIGN_FOO = [[ForeignEnum newWithIndex:0 value:4] retain];
    ForeignEnum_FOREIGN_BAR = [[ForeignEnum newWithIndex:1 value:5] retain];
    ForeignEnum_FOREIGN_BAZ = [[ForeignEnum newWithIndex:2 value:6] retain];
  }
}
+ (ForeignEnum*) FOREIGN_FOO { return ForeignEnum_FOREIGN_FOO; }
+ (ForeignEnum*) FOREIGN_BAR { return ForeignEnum_FOREIGN_BAR; }
+ (ForeignEnum*) FOREIGN_BAZ { return ForeignEnum_FOREIGN_BAZ; }
- (int32_t) number { return value; }
+ (ForeignEnum*) valueOf:(int32_t) value {
  switch (value) {
    case 4: return [ForeignEnum FOREIGN_FOO];
    case 5: return [ForeignEnum FOREIGN_BAR];
    case 6: return [ForeignEnum FOREIGN_BAZ];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[ForeignEnum descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [ForeignEnum descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[UnittestProtoRoot descriptor].enumTypes objectAtIndex:0];
}
+ (ForeignEnum*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [ForeignEnum descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  ForeignEnum* VALUES[] = {
    [ForeignEnum FOREIGN_FOO],
    [ForeignEnum FOREIGN_BAR],
    [ForeignEnum FOREIGN_BAZ],
  };
  return VALUES[desc.index];
}
@end

@interface TestEnumWithDupValue ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation TestEnumWithDupValue
@synthesize index;
@synthesize value;
static TestEnumWithDupValue* TestEnumWithDupValue_FOO1 = nil;
static TestEnumWithDupValue* TestEnumWithDupValue_BAR1 = nil;
static TestEnumWithDupValue* TestEnumWithDupValue_BAZ = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (TestEnumWithDupValue*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[TestEnumWithDupValue alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [TestEnumWithDupValue class]) {
    TestEnumWithDupValue_FOO1 = [[TestEnumWithDupValue newWithIndex:0 value:1] retain];
    TestEnumWithDupValue_BAR1 = [[TestEnumWithDupValue newWithIndex:1 value:2] retain];
    TestEnumWithDupValue_BAZ = [[TestEnumWithDupValue newWithIndex:2 value:3] retain];
  }
}
+ (TestEnumWithDupValue*) FOO1 { return TestEnumWithDupValue_FOO1; }
+ (TestEnumWithDupValue*) BAR1 { return TestEnumWithDupValue_BAR1; }
+ (TestEnumWithDupValue*) BAZ { return TestEnumWithDupValue_BAZ; }
+ (TestEnumWithDupValue*) FOO2 { return [TestEnumWithDupValue FOO1]; }
+ (TestEnumWithDupValue*) BAR2 { return [TestEnumWithDupValue BAR1]; }
- (int32_t) number { return value; }
+ (TestEnumWithDupValue*) valueOf:(int32_t) value {
  switch (value) {
    case 1: return [TestEnumWithDupValue FOO1];
    case 2: return [TestEnumWithDupValue BAR1];
    case 3: return [TestEnumWithDupValue BAZ];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[TestEnumWithDupValue descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [TestEnumWithDupValue descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[UnittestProtoRoot descriptor].enumTypes objectAtIndex:1];
}
+ (TestEnumWithDupValue*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [TestEnumWithDupValue descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  TestEnumWithDupValue* VALUES[] = {
    [TestEnumWithDupValue FOO1],
    [TestEnumWithDupValue BAR1],
    [TestEnumWithDupValue BAZ],
    [TestEnumWithDupValue FOO2],
    [TestEnumWithDupValue BAR2],
  };
  return VALUES[desc.index];
}
@end

@interface TestSparseEnum ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation TestSparseEnum
@synthesize index;
@synthesize value;
static TestSparseEnum* TestSparseEnum_SPARSE_A = nil;
static TestSparseEnum* TestSparseEnum_SPARSE_B = nil;
static TestSparseEnum* TestSparseEnum_SPARSE_C = nil;
static TestSparseEnum* TestSparseEnum_SPARSE_D = nil;
static TestSparseEnum* TestSparseEnum_SPARSE_E = nil;
static TestSparseEnum* TestSparseEnum_SPARSE_F = nil;
static TestSparseEnum* TestSparseEnum_SPARSE_G = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (TestSparseEnum*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[TestSparseEnum alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [TestSparseEnum class]) {
    TestSparseEnum_SPARSE_A = [[TestSparseEnum newWithIndex:0 value:123] retain];
    TestSparseEnum_SPARSE_B = [[TestSparseEnum newWithIndex:1 value:62374] retain];
    TestSparseEnum_SPARSE_C = [[TestSparseEnum newWithIndex:2 value:12589234] retain];
    TestSparseEnum_SPARSE_D = [[TestSparseEnum newWithIndex:3 value:-15] retain];
    TestSparseEnum_SPARSE_E = [[TestSparseEnum newWithIndex:4 value:-53452] retain];
    TestSparseEnum_SPARSE_F = [[TestSparseEnum newWithIndex:5 value:0] retain];
    TestSparseEnum_SPARSE_G = [[TestSparseEnum newWithIndex:6 value:2] retain];
  }
}
+ (TestSparseEnum*) SPARSE_A { return TestSparseEnum_SPARSE_A; }
+ (TestSparseEnum*) SPARSE_B { return TestSparseEnum_SPARSE_B; }
+ (TestSparseEnum*) SPARSE_C { return TestSparseEnum_SPARSE_C; }
+ (TestSparseEnum*) SPARSE_D { return TestSparseEnum_SPARSE_D; }
+ (TestSparseEnum*) SPARSE_E { return TestSparseEnum_SPARSE_E; }
+ (TestSparseEnum*) SPARSE_F { return TestSparseEnum_SPARSE_F; }
+ (TestSparseEnum*) SPARSE_G { return TestSparseEnum_SPARSE_G; }
- (int32_t) number { return value; }
+ (TestSparseEnum*) valueOf:(int32_t) value {
  switch (value) {
    case 123: return [TestSparseEnum SPARSE_A];
    case 62374: return [TestSparseEnum SPARSE_B];
    case 12589234: return [TestSparseEnum SPARSE_C];
    case -15: return [TestSparseEnum SPARSE_D];
    case -53452: return [TestSparseEnum SPARSE_E];
    case 0: return [TestSparseEnum SPARSE_F];
    case 2: return [TestSparseEnum SPARSE_G];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[TestSparseEnum descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [TestSparseEnum descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[UnittestProtoRoot descriptor].enumTypes objectAtIndex:2];
}
+ (TestSparseEnum*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [TestSparseEnum descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  TestSparseEnum* VALUES[] = {
    [TestSparseEnum SPARSE_A],
    [TestSparseEnum SPARSE_B],
    [TestSparseEnum SPARSE_C],
    [TestSparseEnum SPARSE_D],
    [TestSparseEnum SPARSE_E],
    [TestSparseEnum SPARSE_F],
    [TestSparseEnum SPARSE_G],
  };
  return VALUES[desc.index];
}
@end

@interface TestAllTypes ()
@property BOOL hasOptionalInt32;
@property int32_t optionalInt32;
@property BOOL hasOptionalInt64;
@property int64_t optionalInt64;
@property BOOL hasOptionalUint32;
@property int32_t optionalUint32;
@property BOOL hasOptionalUint64;
@property int64_t optionalUint64;
@property BOOL hasOptionalSint32;
@property int32_t optionalSint32;
@property BOOL hasOptionalSint64;
@property int64_t optionalSint64;
@property BOOL hasOptionalFixed32;
@property int32_t optionalFixed32;
@property BOOL hasOptionalFixed64;
@property int64_t optionalFixed64;
@property BOOL hasOptionalSfixed32;
@property int32_t optionalSfixed32;
@property BOOL hasOptionalSfixed64;
@property int64_t optionalSfixed64;
@property BOOL hasOptionalFloat;
@property Float32 optionalFloat;
@property BOOL hasOptionalDouble;
@property Float64 optionalDouble;
@property BOOL hasOptionalBool;
@property BOOL optionalBool;
@property BOOL hasOptionalString;
@property (retain) NSString* optionalString;
@property BOOL hasOptionalBytes;
@property (retain) NSData* optionalBytes;
@property BOOL hasOptionalGroup;
@property (retain) TestAllTypes_OptionalGroup* optionalGroup;
@property BOOL hasOptionalNestedMessage;
@property (retain) TestAllTypes_NestedMessage* optionalNestedMessage;
@property BOOL hasOptionalForeignMessage;
@property (retain) ForeignMessage* optionalForeignMessage;
@property BOOL hasOptionalImportMessage;
@property (retain) ImportMessage* optionalImportMessage;
@property BOOL hasOptionalNestedEnum;
@property (retain) TestAllTypes_NestedEnum* optionalNestedEnum;
@property BOOL hasOptionalForeignEnum;
@property (retain) ForeignEnum* optionalForeignEnum;
@property BOOL hasOptionalImportEnum;
@property (retain) ImportEnum* optionalImportEnum;
@property BOOL hasOptionalStringPiece;
@property (retain) NSString* optionalStringPiece;
@property BOOL hasOptionalCord;
@property (retain) NSString* optionalCord;
@property (retain) NSMutableArray* mutableRepeatedInt32List;
@property (retain) NSMutableArray* mutableRepeatedInt64List;
@property (retain) NSMutableArray* mutableRepeatedUint32List;
@property (retain) NSMutableArray* mutableRepeatedUint64List;
@property (retain) NSMutableArray* mutableRepeatedSint32List;
@property (retain) NSMutableArray* mutableRepeatedSint64List;
@property (retain) NSMutableArray* mutableRepeatedFixed32List;
@property (retain) NSMutableArray* mutableRepeatedFixed64List;
@property (retain) NSMutableArray* mutableRepeatedSfixed32List;
@property (retain) NSMutableArray* mutableRepeatedSfixed64List;
@property (retain) NSMutableArray* mutableRepeatedFloatList;
@property (retain) NSMutableArray* mutableRepeatedDoubleList;
@property (retain) NSMutableArray* mutableRepeatedBoolList;
@property (retain) NSMutableArray* mutableRepeatedStringList;
@property (retain) NSMutableArray* mutableRepeatedBytesList;
@property (retain) NSMutableArray* mutableRepeatedGroupList;
@property (retain) NSMutableArray* mutableRepeatedNestedMessageList;
@property (retain) NSMutableArray* mutableRepeatedForeignMessageList;
@property (retain) NSMutableArray* mutableRepeatedImportMessageList;
@property (retain) NSMutableArray* mutableRepeatedNestedEnumList;
@property (retain) NSMutableArray* mutableRepeatedForeignEnumList;
@property (retain) NSMutableArray* mutableRepeatedImportEnumList;
@property (retain) NSMutableArray* mutableRepeatedStringPieceList;
@property (retain) NSMutableArray* mutableRepeatedCordList;
@property BOOL hasDefaultInt32;
@property int32_t defaultInt32;
@property BOOL hasDefaultInt64;
@property int64_t defaultInt64;
@property BOOL hasDefaultUint32;
@property int32_t defaultUint32;
@property BOOL hasDefaultUint64;
@property int64_t defaultUint64;
@property BOOL hasDefaultSint32;
@property int32_t defaultSint32;
@property BOOL hasDefaultSint64;
@property int64_t defaultSint64;
@property BOOL hasDefaultFixed32;
@property int32_t defaultFixed32;
@property BOOL hasDefaultFixed64;
@property int64_t defaultFixed64;
@property BOOL hasDefaultSfixed32;
@property int32_t defaultSfixed32;
@property BOOL hasDefaultSfixed64;
@property int64_t defaultSfixed64;
@property BOOL hasDefaultFloat;
@property Float32 defaultFloat;
@property BOOL hasDefaultDouble;
@property Float64 defaultDouble;
@property BOOL hasDefaultBool;
@property BOOL defaultBool;
@property BOOL hasDefaultString;
@property (retain) NSString* defaultString;
@property BOOL hasDefaultBytes;
@property (retain) NSData* defaultBytes;
@property BOOL hasDefaultNestedEnum;
@property (retain) TestAllTypes_NestedEnum* defaultNestedEnum;
@property BOOL hasDefaultForeignEnum;
@property (retain) ForeignEnum* defaultForeignEnum;
@property BOOL hasDefaultImportEnum;
@property (retain) ImportEnum* defaultImportEnum;
@property BOOL hasDefaultStringPiece;
@property (retain) NSString* defaultStringPiece;
@property BOOL hasDefaultCord;
@property (retain) NSString* defaultCord;
@end

@implementation TestAllTypes

@synthesize hasOptionalInt32;
@synthesize optionalInt32;
@synthesize hasOptionalInt64;
@synthesize optionalInt64;
@synthesize hasOptionalUint32;
@synthesize optionalUint32;
@synthesize hasOptionalUint64;
@synthesize optionalUint64;
@synthesize hasOptionalSint32;
@synthesize optionalSint32;
@synthesize hasOptionalSint64;
@synthesize optionalSint64;
@synthesize hasOptionalFixed32;
@synthesize optionalFixed32;
@synthesize hasOptionalFixed64;
@synthesize optionalFixed64;
@synthesize hasOptionalSfixed32;
@synthesize optionalSfixed32;
@synthesize hasOptionalSfixed64;
@synthesize optionalSfixed64;
@synthesize hasOptionalFloat;
@synthesize optionalFloat;
@synthesize hasOptionalDouble;
@synthesize optionalDouble;
@synthesize hasOptionalBool;
@synthesize optionalBool;
@synthesize hasOptionalString;
@synthesize optionalString;
@synthesize hasOptionalBytes;
@synthesize optionalBytes;
@synthesize hasOptionalGroup;
@synthesize optionalGroup;
@synthesize hasOptionalNestedMessage;
@synthesize optionalNestedMessage;
@synthesize hasOptionalForeignMessage;
@synthesize optionalForeignMessage;
@synthesize hasOptionalImportMessage;
@synthesize optionalImportMessage;
@synthesize hasOptionalNestedEnum;
@synthesize optionalNestedEnum;
@synthesize hasOptionalForeignEnum;
@synthesize optionalForeignEnum;
@synthesize hasOptionalImportEnum;
@synthesize optionalImportEnum;
@synthesize hasOptionalStringPiece;
@synthesize optionalStringPiece;
@synthesize hasOptionalCord;
@synthesize optionalCord;
@synthesize mutableRepeatedInt32List;
@synthesize mutableRepeatedInt64List;
@synthesize mutableRepeatedUint32List;
@synthesize mutableRepeatedUint64List;
@synthesize mutableRepeatedSint32List;
@synthesize mutableRepeatedSint64List;
@synthesize mutableRepeatedFixed32List;
@synthesize mutableRepeatedFixed64List;
@synthesize mutableRepeatedSfixed32List;
@synthesize mutableRepeatedSfixed64List;
@synthesize mutableRepeatedFloatList;
@synthesize mutableRepeatedDoubleList;
@synthesize mutableRepeatedBoolList;
@synthesize mutableRepeatedStringList;
@synthesize mutableRepeatedBytesList;
@synthesize mutableRepeatedGroupList;
@synthesize mutableRepeatedNestedMessageList;
@synthesize mutableRepeatedForeignMessageList;
@synthesize mutableRepeatedImportMessageList;
@synthesize mutableRepeatedNestedEnumList;
@synthesize mutableRepeatedForeignEnumList;
@synthesize mutableRepeatedImportEnumList;
@synthesize mutableRepeatedStringPieceList;
@synthesize mutableRepeatedCordList;
@synthesize hasDefaultInt32;
@synthesize defaultInt32;
@synthesize hasDefaultInt64;
@synthesize defaultInt64;
@synthesize hasDefaultUint32;
@synthesize defaultUint32;
@synthesize hasDefaultUint64;
@synthesize defaultUint64;
@synthesize hasDefaultSint32;
@synthesize defaultSint32;
@synthesize hasDefaultSint64;
@synthesize defaultSint64;
@synthesize hasDefaultFixed32;
@synthesize defaultFixed32;
@synthesize hasDefaultFixed64;
@synthesize defaultFixed64;
@synthesize hasDefaultSfixed32;
@synthesize defaultSfixed32;
@synthesize hasDefaultSfixed64;
@synthesize defaultSfixed64;
@synthesize hasDefaultFloat;
@synthesize defaultFloat;
@synthesize hasDefaultDouble;
@synthesize defaultDouble;
@synthesize hasDefaultBool;
@synthesize defaultBool;
@synthesize hasDefaultString;
@synthesize defaultString;
@synthesize hasDefaultBytes;
@synthesize defaultBytes;
@synthesize hasDefaultNestedEnum;
@synthesize defaultNestedEnum;
@synthesize hasDefaultForeignEnum;
@synthesize defaultForeignEnum;
@synthesize hasDefaultImportEnum;
@synthesize defaultImportEnum;
@synthesize hasDefaultStringPiece;
@synthesize defaultStringPiece;
@synthesize hasDefaultCord;
@synthesize defaultCord;
- (void) dealloc {
  self.hasOptionalInt32 = NO;
  self.optionalInt32 = 0;
  self.hasOptionalInt64 = NO;
  self.optionalInt64 = 0;
  self.hasOptionalUint32 = NO;
  self.optionalUint32 = 0;
  self.hasOptionalUint64 = NO;
  self.optionalUint64 = 0;
  self.hasOptionalSint32 = NO;
  self.optionalSint32 = 0;
  self.hasOptionalSint64 = NO;
  self.optionalSint64 = 0;
  self.hasOptionalFixed32 = NO;
  self.optionalFixed32 = 0;
  self.hasOptionalFixed64 = NO;
  self.optionalFixed64 = 0;
  self.hasOptionalSfixed32 = NO;
  self.optionalSfixed32 = 0;
  self.hasOptionalSfixed64 = NO;
  self.optionalSfixed64 = 0;
  self.hasOptionalFloat = NO;
  self.optionalFloat = 0;
  self.hasOptionalDouble = NO;
  self.optionalDouble = 0;
  self.hasOptionalBool = NO;
  self.optionalBool = 0;
  self.hasOptionalString = NO;
  self.optionalString = nil;
  self.hasOptionalBytes = NO;
  self.optionalBytes = nil;
  self.hasOptionalGroup = NO;
  self.optionalGroup = nil;
  self.hasOptionalNestedMessage = NO;
  self.optionalNestedMessage = nil;
  self.hasOptionalForeignMessage = NO;
  self.optionalForeignMessage = nil;
  self.hasOptionalImportMessage = NO;
  self.optionalImportMessage = nil;
  self.hasOptionalNestedEnum = NO;
  self.optionalNestedEnum = nil;
  self.hasOptionalForeignEnum = NO;
  self.optionalForeignEnum = nil;
  self.hasOptionalImportEnum = NO;
  self.optionalImportEnum = nil;
  self.hasOptionalStringPiece = NO;
  self.optionalStringPiece = nil;
  self.hasOptionalCord = NO;
  self.optionalCord = nil;
  self.mutableRepeatedInt32List = nil;
  self.mutableRepeatedInt64List = nil;
  self.mutableRepeatedUint32List = nil;
  self.mutableRepeatedUint64List = nil;
  self.mutableRepeatedSint32List = nil;
  self.mutableRepeatedSint64List = nil;
  self.mutableRepeatedFixed32List = nil;
  self.mutableRepeatedFixed64List = nil;
  self.mutableRepeatedSfixed32List = nil;
  self.mutableRepeatedSfixed64List = nil;
  self.mutableRepeatedFloatList = nil;
  self.mutableRepeatedDoubleList = nil;
  self.mutableRepeatedBoolList = nil;
  self.mutableRepeatedStringList = nil;
  self.mutableRepeatedBytesList = nil;
  self.mutableRepeatedGroupList = nil;
  self.mutableRepeatedNestedMessageList = nil;
  self.mutableRepeatedForeignMessageList = nil;
  self.mutableRepeatedImportMessageList = nil;
  self.mutableRepeatedNestedEnumList = nil;
  self.mutableRepeatedForeignEnumList = nil;
  self.mutableRepeatedImportEnumList = nil;
  self.mutableRepeatedStringPieceList = nil;
  self.mutableRepeatedCordList = nil;
  self.hasDefaultInt32 = NO;
  self.defaultInt32 = 0;
  self.hasDefaultInt64 = NO;
  self.defaultInt64 = 0;
  self.hasDefaultUint32 = NO;
  self.defaultUint32 = 0;
  self.hasDefaultUint64 = NO;
  self.defaultUint64 = 0;
  self.hasDefaultSint32 = NO;
  self.defaultSint32 = 0;
  self.hasDefaultSint64 = NO;
  self.defaultSint64 = 0;
  self.hasDefaultFixed32 = NO;
  self.defaultFixed32 = 0;
  self.hasDefaultFixed64 = NO;
  self.defaultFixed64 = 0;
  self.hasDefaultSfixed32 = NO;
  self.defaultSfixed32 = 0;
  self.hasDefaultSfixed64 = NO;
  self.defaultSfixed64 = 0;
  self.hasDefaultFloat = NO;
  self.defaultFloat = 0;
  self.hasDefaultDouble = NO;
  self.defaultDouble = 0;
  self.hasDefaultBool = NO;
  self.defaultBool = 0;
  self.hasDefaultString = NO;
  self.defaultString = nil;
  self.hasDefaultBytes = NO;
  self.defaultBytes = nil;
  self.hasDefaultNestedEnum = NO;
  self.defaultNestedEnum = nil;
  self.hasDefaultForeignEnum = NO;
  self.defaultForeignEnum = nil;
  self.hasDefaultImportEnum = NO;
  self.defaultImportEnum = nil;
  self.hasDefaultStringPiece = NO;
  self.defaultStringPiece = nil;
  self.hasDefaultCord = NO;
  self.defaultCord = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.optionalInt32 = 0;
    self.optionalInt64 = 0L;
    self.optionalUint32 = 0;
    self.optionalUint64 = 0L;
    self.optionalSint32 = 0;
    self.optionalSint64 = 0L;
    self.optionalFixed32 = 0;
    self.optionalFixed64 = 0L;
    self.optionalSfixed32 = 0;
    self.optionalSfixed64 = 0L;
    self.optionalFloat = 0;
    self.optionalDouble = 0;
    self.optionalBool = NO;
    self.optionalString = @"";
    self.optionalBytes = [NSData data];
    self.optionalGroup = [TestAllTypes_OptionalGroup defaultInstance];
    self.optionalNestedMessage = [TestAllTypes_NestedMessage defaultInstance];
    self.optionalForeignMessage = [ForeignMessage defaultInstance];
    self.optionalImportMessage = [ImportMessage defaultInstance];
    self.optionalNestedEnum = [TestAllTypes_NestedEnum FOO];
    self.optionalForeignEnum = [ForeignEnum FOREIGN_FOO];
    self.optionalImportEnum = [ImportEnum IMPORT_FOO];
    self.optionalStringPiece = @"";
    self.optionalCord = @"";
    self.defaultInt32 = 41;
    self.defaultInt64 = 42L;
    self.defaultUint32 = 43;
    self.defaultUint64 = 44L;
    self.defaultSint32 = -45;
    self.defaultSint64 = 46L;
    self.defaultFixed32 = 47;
    self.defaultFixed64 = 48L;
    self.defaultSfixed32 = 49;
    self.defaultSfixed64 = -50L;
    self.defaultFloat = 51.5;
    self.defaultDouble = 52000;
    self.defaultBool = YES;
    self.defaultString = @"hello";
    self.defaultBytes = ([((PBFieldDescriptor*)[[TestAllTypes descriptor].fields objectAtIndex:62]) defaultValue]);
    self.defaultNestedEnum = [TestAllTypes_NestedEnum BAR];
    self.defaultForeignEnum = [ForeignEnum FOREIGN_BAR];
    self.defaultImportEnum = [ImportEnum IMPORT_BAR];
    self.defaultStringPiece = @"abc";
    self.defaultCord = @"123";
  }
  return self;
}
static TestAllTypes* defaultTestAllTypesInstance = nil;
+ (void) initialize {
  if (self == [TestAllTypes class]) {
    defaultTestAllTypesInstance = [[TestAllTypes alloc] init];
  }
}
+ (TestAllTypes*) defaultInstance {
  return defaultTestAllTypesInstance;
}
- (TestAllTypes*) defaultInstance {
  return defaultTestAllTypesInstance;
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_fieldAccessorTable];
}
- (NSArray*) repeatedInt32List {
  return mutableRepeatedInt32List;
}
- (int32_t) repeatedInt32AtIndex:(int32_t) index {
  id value = [mutableRepeatedInt32List objectAtIndex:index];
  return [value intValue];
}
- (NSArray*) repeatedInt64List {
  return mutableRepeatedInt64List;
}
- (int64_t) repeatedInt64AtIndex:(int32_t) index {
  id value = [mutableRepeatedInt64List objectAtIndex:index];
  return [value longLongValue];
}
- (NSArray*) repeatedUint32List {
  return mutableRepeatedUint32List;
}
- (int32_t) repeatedUint32AtIndex:(int32_t) index {
  id value = [mutableRepeatedUint32List objectAtIndex:index];
  return [value intValue];
}
- (NSArray*) repeatedUint64List {
  return mutableRepeatedUint64List;
}
- (int64_t) repeatedUint64AtIndex:(int32_t) index {
  id value = [mutableRepeatedUint64List objectAtIndex:index];
  return [value longLongValue];
}
- (NSArray*) repeatedSint32List {
  return mutableRepeatedSint32List;
}
- (int32_t) repeatedSint32AtIndex:(int32_t) index {
  id value = [mutableRepeatedSint32List objectAtIndex:index];
  return [value intValue];
}
- (NSArray*) repeatedSint64List {
  return mutableRepeatedSint64List;
}
- (int64_t) repeatedSint64AtIndex:(int32_t) index {
  id value = [mutableRepeatedSint64List objectAtIndex:index];
  return [value longLongValue];
}
- (NSArray*) repeatedFixed32List {
  return mutableRepeatedFixed32List;
}
- (int32_t) repeatedFixed32AtIndex:(int32_t) index {
  id value = [mutableRepeatedFixed32List objectAtIndex:index];
  return [value intValue];
}
- (NSArray*) repeatedFixed64List {
  return mutableRepeatedFixed64List;
}
- (int64_t) repeatedFixed64AtIndex:(int32_t) index {
  id value = [mutableRepeatedFixed64List objectAtIndex:index];
  return [value longLongValue];
}
- (NSArray*) repeatedSfixed32List {
  return mutableRepeatedSfixed32List;
}
- (int32_t) repeatedSfixed32AtIndex:(int32_t) index {
  id value = [mutableRepeatedSfixed32List objectAtIndex:index];
  return [value intValue];
}
- (NSArray*) repeatedSfixed64List {
  return mutableRepeatedSfixed64List;
}
- (int64_t) repeatedSfixed64AtIndex:(int32_t) index {
  id value = [mutableRepeatedSfixed64List objectAtIndex:index];
  return [value longLongValue];
}
- (NSArray*) repeatedFloatList {
  return mutableRepeatedFloatList;
}
- (Float32) repeatedFloatAtIndex:(int32_t) index {
  id value = [mutableRepeatedFloatList objectAtIndex:index];
  return [value floatValue];
}
- (NSArray*) repeatedDoubleList {
  return mutableRepeatedDoubleList;
}
- (Float64) repeatedDoubleAtIndex:(int32_t) index {
  id value = [mutableRepeatedDoubleList objectAtIndex:index];
  return [value doubleValue];
}
- (NSArray*) repeatedBoolList {
  return mutableRepeatedBoolList;
}
- (BOOL) repeatedBoolAtIndex:(int32_t) index {
  id value = [mutableRepeatedBoolList objectAtIndex:index];
  return [value boolValue];
}
- (NSArray*) repeatedStringList {
  return mutableRepeatedStringList;
}
- (NSString*) repeatedStringAtIndex:(int32_t) index {
  id value = [mutableRepeatedStringList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedBytesList {
  return mutableRepeatedBytesList;
}
- (NSData*) repeatedBytesAtIndex:(int32_t) index {
  id value = [mutableRepeatedBytesList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedGroupList {
  return mutableRepeatedGroupList;
}
- (TestAllTypes_RepeatedGroup*) repeatedGroupAtIndex:(int32_t) index {
  id value = [mutableRepeatedGroupList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedNestedMessageList {
  return mutableRepeatedNestedMessageList;
}
- (TestAllTypes_NestedMessage*) repeatedNestedMessageAtIndex:(int32_t) index {
  id value = [mutableRepeatedNestedMessageList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedForeignMessageList {
  return mutableRepeatedForeignMessageList;
}
- (ForeignMessage*) repeatedForeignMessageAtIndex:(int32_t) index {
  id value = [mutableRepeatedForeignMessageList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedImportMessageList {
  return mutableRepeatedImportMessageList;
}
- (ImportMessage*) repeatedImportMessageAtIndex:(int32_t) index {
  id value = [mutableRepeatedImportMessageList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedNestedEnumList {
  return mutableRepeatedNestedEnumList;
}
- (TestAllTypes_NestedEnum*) repeatedNestedEnumAtIndex:(int32_t) index {
  id value = [mutableRepeatedNestedEnumList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedForeignEnumList {
  return mutableRepeatedForeignEnumList;
}
- (ForeignEnum*) repeatedForeignEnumAtIndex:(int32_t) index {
  id value = [mutableRepeatedForeignEnumList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedImportEnumList {
  return mutableRepeatedImportEnumList;
}
- (ImportEnum*) repeatedImportEnumAtIndex:(int32_t) index {
  id value = [mutableRepeatedImportEnumList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedStringPieceList {
  return mutableRepeatedStringPieceList;
}
- (NSString*) repeatedStringPieceAtIndex:(int32_t) index {
  id value = [mutableRepeatedStringPieceList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedCordList {
  return mutableRepeatedCordList;
}
- (NSString*) repeatedCordAtIndex:(int32_t) index {
  id value = [mutableRepeatedCordList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasOptionalInt32) {
    [output writeInt32:1 value:self.optionalInt32];
  }
  if (hasOptionalInt64) {
    [output writeInt64:2 value:self.optionalInt64];
  }
  if (hasOptionalUint32) {
    [output writeUInt32:3 value:self.optionalUint32];
  }
  if (hasOptionalUint64) {
    [output writeUInt64:4 value:self.optionalUint64];
  }
  if (hasOptionalSint32) {
    [output writeSInt32:5 value:self.optionalSint32];
  }
  if (hasOptionalSint64) {
    [output writeSInt64:6 value:self.optionalSint64];
  }
  if (hasOptionalFixed32) {
    [output writeFixed32:7 value:self.optionalFixed32];
  }
  if (hasOptionalFixed64) {
    [output writeFixed64:8 value:self.optionalFixed64];
  }
  if (hasOptionalSfixed32) {
    [output writeSFixed32:9 value:self.optionalSfixed32];
  }
  if (hasOptionalSfixed64) {
    [output writeSFixed64:10 value:self.optionalSfixed64];
  }
  if (hasOptionalFloat) {
    [output writeFloat:11 value:self.optionalFloat];
  }
  if (hasOptionalDouble) {
    [output writeDouble:12 value:self.optionalDouble];
  }
  if (hasOptionalBool) {
    [output writeBool:13 value:self.optionalBool];
  }
  if (hasOptionalString) {
    [output writeString:14 value:self.optionalString];
  }
  if (hasOptionalBytes) {
    [output writeData:15 value:self.optionalBytes];
  }
  if (self.hasOptionalGroup) {
    [output writeGroup:16 value:self.optionalGroup];
  }
  if (self.hasOptionalNestedMessage) {
    [output writeMessage:18 value:self.optionalNestedMessage];
  }
  if (self.hasOptionalForeignMessage) {
    [output writeMessage:19 value:self.optionalForeignMessage];
  }
  if (self.hasOptionalImportMessage) {
    [output writeMessage:20 value:self.optionalImportMessage];
  }
  if (self.hasOptionalNestedEnum) {
    [output writeEnum:21 value:self.optionalNestedEnum.number];
  }
  if (self.hasOptionalForeignEnum) {
    [output writeEnum:22 value:self.optionalForeignEnum.number];
  }
  if (self.hasOptionalImportEnum) {
    [output writeEnum:23 value:self.optionalImportEnum.number];
  }
  if (hasOptionalStringPiece) {
    [output writeString:24 value:self.optionalStringPiece];
  }
  if (hasOptionalCord) {
    [output writeString:25 value:self.optionalCord];
  }
  for (NSNumber* value in self.mutableRepeatedInt32List) {
    [output writeInt32:31 value:[value intValue]];
  }
  for (NSNumber* value in self.mutableRepeatedInt64List) {
    [output writeInt64:32 value:[value longLongValue]];
  }
  for (NSNumber* value in self.mutableRepeatedUint32List) {
    [output writeUInt32:33 value:[value intValue]];
  }
  for (NSNumber* value in self.mutableRepeatedUint64List) {
    [output writeUInt64:34 value:[value longLongValue]];
  }
  for (NSNumber* value in self.mutableRepeatedSint32List) {
    [output writeSInt32:35 value:[value intValue]];
  }
  for (NSNumber* value in self.mutableRepeatedSint64List) {
    [output writeSInt64:36 value:[value longLongValue]];
  }
  for (NSNumber* value in self.mutableRepeatedFixed32List) {
    [output writeFixed32:37 value:[value intValue]];
  }
  for (NSNumber* value in self.mutableRepeatedFixed64List) {
    [output writeFixed64:38 value:[value longLongValue]];
  }
  for (NSNumber* value in self.mutableRepeatedSfixed32List) {
    [output writeSFixed32:39 value:[value intValue]];
  }
  for (NSNumber* value in self.mutableRepeatedSfixed64List) {
    [output writeSFixed64:40 value:[value longLongValue]];
  }
  for (NSNumber* value in self.mutableRepeatedFloatList) {
    [output writeFloat:41 value:[value floatValue]];
  }
  for (NSNumber* value in self.mutableRepeatedDoubleList) {
    [output writeDouble:42 value:[value doubleValue]];
  }
  for (NSNumber* value in self.mutableRepeatedBoolList) {
    [output writeBool:43 value:[value boolValue]];
  }
  for (NSString* element in self.mutableRepeatedStringList) {
    [output writeString:44 value:element];
  }
  for (NSData* element in self.mutableRepeatedBytesList) {
    [output writeData:45 value:element];
  }
  for (TestAllTypes_RepeatedGroup* element in self.repeatedGroupList) {
    [output writeGroup:46 value:element];
  }
  for (TestAllTypes_NestedMessage* element in self.repeatedNestedMessageList) {
    [output writeMessage:48 value:element];
  }
  for (ForeignMessage* element in self.repeatedForeignMessageList) {
    [output writeMessage:49 value:element];
  }
  for (ImportMessage* element in self.repeatedImportMessageList) {
    [output writeMessage:50 value:element];
  }
  for (TestAllTypes_NestedEnum* element in self.repeatedNestedEnumList) {
    [output writeEnum:51 value:element.number];
  }
  for (ForeignEnum* element in self.repeatedForeignEnumList) {
    [output writeEnum:52 value:element.number];
  }
  for (ImportEnum* element in self.repeatedImportEnumList) {
    [output writeEnum:53 value:element.number];
  }
  for (NSString* element in self.mutableRepeatedStringPieceList) {
    [output writeString:54 value:element];
  }
  for (NSString* element in self.mutableRepeatedCordList) {
    [output writeString:55 value:element];
  }
  if (hasDefaultInt32) {
    [output writeInt32:61 value:self.defaultInt32];
  }
  if (hasDefaultInt64) {
    [output writeInt64:62 value:self.defaultInt64];
  }
  if (hasDefaultUint32) {
    [output writeUInt32:63 value:self.defaultUint32];
  }
  if (hasDefaultUint64) {
    [output writeUInt64:64 value:self.defaultUint64];
  }
  if (hasDefaultSint32) {
    [output writeSInt32:65 value:self.defaultSint32];
  }
  if (hasDefaultSint64) {
    [output writeSInt64:66 value:self.defaultSint64];
  }
  if (hasDefaultFixed32) {
    [output writeFixed32:67 value:self.defaultFixed32];
  }
  if (hasDefaultFixed64) {
    [output writeFixed64:68 value:self.defaultFixed64];
  }
  if (hasDefaultSfixed32) {
    [output writeSFixed32:69 value:self.defaultSfixed32];
  }
  if (hasDefaultSfixed64) {
    [output writeSFixed64:70 value:self.defaultSfixed64];
  }
  if (hasDefaultFloat) {
    [output writeFloat:71 value:self.defaultFloat];
  }
  if (hasDefaultDouble) {
    [output writeDouble:72 value:self.defaultDouble];
  }
  if (hasDefaultBool) {
    [output writeBool:73 value:self.defaultBool];
  }
  if (hasDefaultString) {
    [output writeString:74 value:self.defaultString];
  }
  if (hasDefaultBytes) {
    [output writeData:75 value:self.defaultBytes];
  }
  if (self.hasDefaultNestedEnum) {
    [output writeEnum:81 value:self.defaultNestedEnum.number];
  }
  if (self.hasDefaultForeignEnum) {
    [output writeEnum:82 value:self.defaultForeignEnum.number];
  }
  if (self.hasDefaultImportEnum) {
    [output writeEnum:83 value:self.defaultImportEnum.number];
  }
  if (hasDefaultStringPiece) {
    [output writeString:84 value:self.defaultStringPiece];
  }
  if (hasDefaultCord) {
    [output writeString:85 value:self.defaultCord];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasOptionalInt32) {
    size += computeInt32Size(1, self.optionalInt32);
  }
  if (hasOptionalInt64) {
    size += computeInt64Size(2, self.optionalInt64);
  }
  if (hasOptionalUint32) {
    size += computeUInt32Size(3, self.optionalUint32);
  }
  if (hasOptionalUint64) {
    size += computeUInt64Size(4, self.optionalUint64);
  }
  if (hasOptionalSint32) {
    size += computeSInt32Size(5, self.optionalSint32);
  }
  if (hasOptionalSint64) {
    size += computeSInt64Size(6, self.optionalSint64);
  }
  if (hasOptionalFixed32) {
    size += computeFixed32Size(7, self.optionalFixed32);
  }
  if (hasOptionalFixed64) {
    size += computeFixed64Size(8, self.optionalFixed64);
  }
  if (hasOptionalSfixed32) {
    size += computeSFixed32Size(9, self.optionalSfixed32);
  }
  if (hasOptionalSfixed64) {
    size += computeSFixed64Size(10, self.optionalSfixed64);
  }
  if (hasOptionalFloat) {
    size += computeFloatSize(11, self.optionalFloat);
  }
  if (hasOptionalDouble) {
    size += computeDoubleSize(12, self.optionalDouble);
  }
  if (hasOptionalBool) {
    size += computeBoolSize(13, self.optionalBool);
  }
  if (hasOptionalString) {
    size += computeStringSize(14, self.optionalString);
  }
  if (hasOptionalBytes) {
    size += computeDataSize(15, self.optionalBytes);
  }
  if (self.hasOptionalGroup) {
    size += computeGroupSize(16, self.optionalGroup);
  }
  if (self.hasOptionalNestedMessage) {
    size += computeMessageSize(18, self.optionalNestedMessage);
  }
  if (self.hasOptionalForeignMessage) {
    size += computeMessageSize(19, self.optionalForeignMessage);
  }
  if (self.hasOptionalImportMessage) {
    size += computeMessageSize(20, self.optionalImportMessage);
  }
  if (self.hasOptionalNestedEnum) {
    size += computeEnumSize(21, self.optionalNestedEnum.number);
  }
  if (self.hasOptionalForeignEnum) {
    size += computeEnumSize(22, self.optionalForeignEnum.number);
  }
  if (self.hasOptionalImportEnum) {
    size += computeEnumSize(23, self.optionalImportEnum.number);
  }
  if (hasOptionalStringPiece) {
    size += computeStringSize(24, self.optionalStringPiece);
  }
  if (hasOptionalCord) {
    size += computeStringSize(25, self.optionalCord);
  }
  for (NSNumber* value in self.mutableRepeatedInt32List) {
    size += computeInt32Size(31, [value intValue]);
  }
  for (NSNumber* value in self.mutableRepeatedInt64List) {
    size += computeInt64Size(32, [value longLongValue]);
  }
  for (NSNumber* value in self.mutableRepeatedUint32List) {
    size += computeUInt32Size(33, [value intValue]);
  }
  for (NSNumber* value in self.mutableRepeatedUint64List) {
    size += computeUInt64Size(34, [value longLongValue]);
  }
  for (NSNumber* value in self.mutableRepeatedSint32List) {
    size += computeSInt32Size(35, [value intValue]);
  }
  for (NSNumber* value in self.mutableRepeatedSint64List) {
    size += computeSInt64Size(36, [value longLongValue]);
  }
  for (NSNumber* value in self.mutableRepeatedFixed32List) {
    size += computeFixed32Size(37, [value intValue]);
  }
  for (NSNumber* value in self.mutableRepeatedFixed64List) {
    size += computeFixed64Size(38, [value longLongValue]);
  }
  for (NSNumber* value in self.mutableRepeatedSfixed32List) {
    size += computeSFixed32Size(39, [value intValue]);
  }
  for (NSNumber* value in self.mutableRepeatedSfixed64List) {
    size += computeSFixed64Size(40, [value longLongValue]);
  }
  for (NSNumber* value in self.mutableRepeatedFloatList) {
    size += computeFloatSize(41, [value floatValue]);
  }
  for (NSNumber* value in self.mutableRepeatedDoubleList) {
    size += computeDoubleSize(42, [value doubleValue]);
  }
  for (NSNumber* value in self.mutableRepeatedBoolList) {
    size += computeBoolSize(43, [value boolValue]);
  }
  for (NSString* element in self.mutableRepeatedStringList) {
    size += computeStringSize(44, element);
  }
  for (NSData* element in self.mutableRepeatedBytesList) {
    size += computeDataSize(45, element);
  }
  for (TestAllTypes_RepeatedGroup* element in self.repeatedGroupList) {
    size += computeGroupSize(46, element);
  }
  for (TestAllTypes_NestedMessage* element in self.repeatedNestedMessageList) {
    size += computeMessageSize(48, element);
  }
  for (ForeignMessage* element in self.repeatedForeignMessageList) {
    size += computeMessageSize(49, element);
  }
  for (ImportMessage* element in self.repeatedImportMessageList) {
    size += computeMessageSize(50, element);
  }
  for (TestAllTypes_NestedEnum* element in self.repeatedNestedEnumList) {
    size += computeEnumSize(51, element.number);
  }
  for (ForeignEnum* element in self.repeatedForeignEnumList) {
    size += computeEnumSize(52, element.number);
  }
  for (ImportEnum* element in self.repeatedImportEnumList) {
    size += computeEnumSize(53, element.number);
  }
  for (NSString* element in self.mutableRepeatedStringPieceList) {
    size += computeStringSize(54, element);
  }
  for (NSString* element in self.mutableRepeatedCordList) {
    size += computeStringSize(55, element);
  }
  if (hasDefaultInt32) {
    size += computeInt32Size(61, self.defaultInt32);
  }
  if (hasDefaultInt64) {
    size += computeInt64Size(62, self.defaultInt64);
  }
  if (hasDefaultUint32) {
    size += computeUInt32Size(63, self.defaultUint32);
  }
  if (hasDefaultUint64) {
    size += computeUInt64Size(64, self.defaultUint64);
  }
  if (hasDefaultSint32) {
    size += computeSInt32Size(65, self.defaultSint32);
  }
  if (hasDefaultSint64) {
    size += computeSInt64Size(66, self.defaultSint64);
  }
  if (hasDefaultFixed32) {
    size += computeFixed32Size(67, self.defaultFixed32);
  }
  if (hasDefaultFixed64) {
    size += computeFixed64Size(68, self.defaultFixed64);
  }
  if (hasDefaultSfixed32) {
    size += computeSFixed32Size(69, self.defaultSfixed32);
  }
  if (hasDefaultSfixed64) {
    size += computeSFixed64Size(70, self.defaultSfixed64);
  }
  if (hasDefaultFloat) {
    size += computeFloatSize(71, self.defaultFloat);
  }
  if (hasDefaultDouble) {
    size += computeDoubleSize(72, self.defaultDouble);
  }
  if (hasDefaultBool) {
    size += computeBoolSize(73, self.defaultBool);
  }
  if (hasDefaultString) {
    size += computeStringSize(74, self.defaultString);
  }
  if (hasDefaultBytes) {
    size += computeDataSize(75, self.defaultBytes);
  }
  if (self.hasDefaultNestedEnum) {
    size += computeEnumSize(81, self.defaultNestedEnum.number);
  }
  if (self.hasDefaultForeignEnum) {
    size += computeEnumSize(82, self.defaultForeignEnum.number);
  }
  if (self.hasDefaultImportEnum) {
    size += computeEnumSize(83, self.defaultImportEnum.number);
  }
  if (hasDefaultStringPiece) {
    size += computeStringSize(84, self.defaultStringPiece);
  }
  if (hasDefaultCord) {
    size += computeStringSize(85, self.defaultCord);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestAllTypes*) parseFromData:(NSData*) data {
  return (TestAllTypes*)[[[TestAllTypes_Builder builder] mergeFromData:data] build];
}
+ (TestAllTypes*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes*)[[[TestAllTypes_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes*) parseFromInputStream:(NSInputStream*) input {
  return (TestAllTypes*)[[[TestAllTypes_Builder builder] mergeFromInputStream:input] build];
}
+ (TestAllTypes*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes*)[[[TestAllTypes_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestAllTypes*)[[[TestAllTypes_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestAllTypes*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes*)[[[TestAllTypes_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestAllTypes_Builder*) createBuilder {
  return [TestAllTypes_Builder builder];
}
@end

@interface TestAllTypes_NestedEnum ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation TestAllTypes_NestedEnum
@synthesize index;
@synthesize value;
static TestAllTypes_NestedEnum* TestAllTypes_NestedEnum_FOO = nil;
static TestAllTypes_NestedEnum* TestAllTypes_NestedEnum_BAR = nil;
static TestAllTypes_NestedEnum* TestAllTypes_NestedEnum_BAZ = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (TestAllTypes_NestedEnum*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[TestAllTypes_NestedEnum alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [TestAllTypes_NestedEnum class]) {
    TestAllTypes_NestedEnum_FOO = [[TestAllTypes_NestedEnum newWithIndex:0 value:1] retain];
    TestAllTypes_NestedEnum_BAR = [[TestAllTypes_NestedEnum newWithIndex:1 value:2] retain];
    TestAllTypes_NestedEnum_BAZ = [[TestAllTypes_NestedEnum newWithIndex:2 value:3] retain];
  }
}
+ (TestAllTypes_NestedEnum*) FOO { return TestAllTypes_NestedEnum_FOO; }
+ (TestAllTypes_NestedEnum*) BAR { return TestAllTypes_NestedEnum_BAR; }
+ (TestAllTypes_NestedEnum*) BAZ { return TestAllTypes_NestedEnum_BAZ; }
- (int32_t) number { return value; }
+ (TestAllTypes_NestedEnum*) valueOf:(int32_t) value {
  switch (value) {
    case 1: return [TestAllTypes_NestedEnum FOO];
    case 2: return [TestAllTypes_NestedEnum BAR];
    case 3: return [TestAllTypes_NestedEnum BAZ];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[TestAllTypes_NestedEnum descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [TestAllTypes_NestedEnum descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[TestAllTypes descriptor].enumTypes objectAtIndex:0];
}
+ (TestAllTypes_NestedEnum*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [TestAllTypes_NestedEnum descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  TestAllTypes_NestedEnum* VALUES[] = {
    [TestAllTypes_NestedEnum FOO],
    [TestAllTypes_NestedEnum BAR],
    [TestAllTypes_NestedEnum BAZ],
  };
  return VALUES[desc.index];
}
@end

@interface TestAllTypes_NestedMessage ()
@property BOOL hasBb;
@property int32_t bb;
@end

@implementation TestAllTypes_NestedMessage

@synthesize hasBb;
@synthesize bb;
- (void) dealloc {
  self.hasBb = NO;
  self.bb = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.bb = 0;
  }
  return self;
}
static TestAllTypes_NestedMessage* defaultTestAllTypes_NestedMessageInstance = nil;
+ (void) initialize {
  if (self == [TestAllTypes_NestedMessage class]) {
    defaultTestAllTypes_NestedMessageInstance = [[TestAllTypes_NestedMessage alloc] init];
  }
}
+ (TestAllTypes_NestedMessage*) defaultInstance {
  return defaultTestAllTypes_NestedMessageInstance;
}
- (TestAllTypes_NestedMessage*) defaultInstance {
  return defaultTestAllTypes_NestedMessageInstance;
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes_NestedMessage descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_NestedMessage_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_NestedMessage_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasBb) {
    [output writeInt32:1 value:self.bb];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasBb) {
    size += computeInt32Size(1, self.bb);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestAllTypes_NestedMessage*) parseFromData:(NSData*) data {
  return (TestAllTypes_NestedMessage*)[[[TestAllTypes_NestedMessage_Builder builder] mergeFromData:data] build];
}
+ (TestAllTypes_NestedMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_NestedMessage*)[[[TestAllTypes_NestedMessage_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes_NestedMessage*) parseFromInputStream:(NSInputStream*) input {
  return (TestAllTypes_NestedMessage*)[[[TestAllTypes_NestedMessage_Builder builder] mergeFromInputStream:input] build];
}
+ (TestAllTypes_NestedMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_NestedMessage*)[[[TestAllTypes_NestedMessage_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes_NestedMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestAllTypes_NestedMessage*)[[[TestAllTypes_NestedMessage_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestAllTypes_NestedMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_NestedMessage*)[[[TestAllTypes_NestedMessage_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestAllTypes_NestedMessage_Builder*) createBuilder {
  return [TestAllTypes_NestedMessage_Builder builder];
}
@end

@implementation TestAllTypes_NestedMessage_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestAllTypes_NestedMessage alloc] init] autorelease];
  }
  return self;
}
+ (TestAllTypes_NestedMessage_Builder*) builder {
  return [[[TestAllTypes_NestedMessage_Builder alloc] init] autorelease];
}
+ (TestAllTypes_NestedMessage_Builder*) builderWithPrototype:(TestAllTypes_NestedMessage*) prototype {
  return [[TestAllTypes_NestedMessage_Builder builder] mergeFromTestAllTypes_NestedMessage:prototype];
}
- (TestAllTypes_NestedMessage*) internalGetResult {
  return result;
}
- (TestAllTypes_NestedMessage_Builder*) clear {
  self.result = [[[TestAllTypes_NestedMessage alloc] init] autorelease];
  return self;
}
- (TestAllTypes_NestedMessage_Builder*) clone {
  return [TestAllTypes_NestedMessage_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes_NestedMessage descriptor];
}
- (TestAllTypes_NestedMessage*) defaultInstance {
  return [TestAllTypes_NestedMessage defaultInstance];
}
- (TestAllTypes_NestedMessage*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestAllTypes_NestedMessage*) buildPartial {
  TestAllTypes_NestedMessage* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestAllTypes_NestedMessage_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestAllTypes_NestedMessage class]]) {
    return [self mergeFromTestAllTypes_NestedMessage:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestAllTypes_NestedMessage_Builder*) mergeFromTestAllTypes_NestedMessage:(TestAllTypes_NestedMessage*) other {
  if (other == [TestAllTypes_NestedMessage defaultInstance]) return self;
  if (other.hasBb) {
    [self setBb:other.bb];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestAllTypes_NestedMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestAllTypes_NestedMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setBb:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasBb {
  return result.hasBb;
}
- (int32_t) bb {
  return result.bb;
}
- (TestAllTypes_NestedMessage_Builder*) setBb:(int32_t) value {
  result.hasBb = YES;
  result.bb = value;
  return self;
}
- (TestAllTypes_NestedMessage_Builder*) clearBb {
  result.hasBb = NO;
  result.bb = 0;
  return self;
}
@end

@interface TestAllTypes_OptionalGroup ()
@property BOOL hasA;
@property int32_t a;
@end

@implementation TestAllTypes_OptionalGroup

@synthesize hasA;
@synthesize a;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
  }
  return self;
}
static TestAllTypes_OptionalGroup* defaultTestAllTypes_OptionalGroupInstance = nil;
+ (void) initialize {
  if (self == [TestAllTypes_OptionalGroup class]) {
    defaultTestAllTypes_OptionalGroupInstance = [[TestAllTypes_OptionalGroup alloc] init];
  }
}
+ (TestAllTypes_OptionalGroup*) defaultInstance {
  return defaultTestAllTypes_OptionalGroupInstance;
}
- (TestAllTypes_OptionalGroup*) defaultInstance {
  return defaultTestAllTypes_OptionalGroupInstance;
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes_OptionalGroup descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_OptionalGroup_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:17 value:self.a];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(17, self.a);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestAllTypes_OptionalGroup*) parseFromData:(NSData*) data {
  return (TestAllTypes_OptionalGroup*)[[[TestAllTypes_OptionalGroup_Builder builder] mergeFromData:data] build];
}
+ (TestAllTypes_OptionalGroup*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_OptionalGroup*)[[[TestAllTypes_OptionalGroup_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes_OptionalGroup*) parseFromInputStream:(NSInputStream*) input {
  return (TestAllTypes_OptionalGroup*)[[[TestAllTypes_OptionalGroup_Builder builder] mergeFromInputStream:input] build];
}
+ (TestAllTypes_OptionalGroup*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_OptionalGroup*)[[[TestAllTypes_OptionalGroup_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes_OptionalGroup*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestAllTypes_OptionalGroup*)[[[TestAllTypes_OptionalGroup_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestAllTypes_OptionalGroup*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_OptionalGroup*)[[[TestAllTypes_OptionalGroup_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestAllTypes_OptionalGroup_Builder*) createBuilder {
  return [TestAllTypes_OptionalGroup_Builder builder];
}
@end

@implementation TestAllTypes_OptionalGroup_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestAllTypes_OptionalGroup alloc] init] autorelease];
  }
  return self;
}
+ (TestAllTypes_OptionalGroup_Builder*) builder {
  return [[[TestAllTypes_OptionalGroup_Builder alloc] init] autorelease];
}
+ (TestAllTypes_OptionalGroup_Builder*) builderWithPrototype:(TestAllTypes_OptionalGroup*) prototype {
  return [[TestAllTypes_OptionalGroup_Builder builder] mergeFromTestAllTypes_OptionalGroup:prototype];
}
- (TestAllTypes_OptionalGroup*) internalGetResult {
  return result;
}
- (TestAllTypes_OptionalGroup_Builder*) clear {
  self.result = [[[TestAllTypes_OptionalGroup alloc] init] autorelease];
  return self;
}
- (TestAllTypes_OptionalGroup_Builder*) clone {
  return [TestAllTypes_OptionalGroup_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes_OptionalGroup descriptor];
}
- (TestAllTypes_OptionalGroup*) defaultInstance {
  return [TestAllTypes_OptionalGroup defaultInstance];
}
- (TestAllTypes_OptionalGroup*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestAllTypes_OptionalGroup*) buildPartial {
  TestAllTypes_OptionalGroup* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestAllTypes_OptionalGroup_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestAllTypes_OptionalGroup class]]) {
    return [self mergeFromTestAllTypes_OptionalGroup:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestAllTypes_OptionalGroup_Builder*) mergeFromTestAllTypes_OptionalGroup:(TestAllTypes_OptionalGroup*) other {
  if (other == [TestAllTypes_OptionalGroup defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestAllTypes_OptionalGroup_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestAllTypes_OptionalGroup_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 136: {
        [self setA:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (TestAllTypes_OptionalGroup_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestAllTypes_OptionalGroup_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
@end

@interface TestAllTypes_RepeatedGroup ()
@property BOOL hasA;
@property int32_t a;
@end

@implementation TestAllTypes_RepeatedGroup

@synthesize hasA;
@synthesize a;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
  }
  return self;
}
static TestAllTypes_RepeatedGroup* defaultTestAllTypes_RepeatedGroupInstance = nil;
+ (void) initialize {
  if (self == [TestAllTypes_RepeatedGroup class]) {
    defaultTestAllTypes_RepeatedGroupInstance = [[TestAllTypes_RepeatedGroup alloc] init];
  }
}
+ (TestAllTypes_RepeatedGroup*) defaultInstance {
  return defaultTestAllTypes_RepeatedGroupInstance;
}
- (TestAllTypes_RepeatedGroup*) defaultInstance {
  return defaultTestAllTypes_RepeatedGroupInstance;
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes_RepeatedGroup descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllTypes_RepeatedGroup_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:47 value:self.a];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(47, self.a);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestAllTypes_RepeatedGroup*) parseFromData:(NSData*) data {
  return (TestAllTypes_RepeatedGroup*)[[[TestAllTypes_RepeatedGroup_Builder builder] mergeFromData:data] build];
}
+ (TestAllTypes_RepeatedGroup*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_RepeatedGroup*)[[[TestAllTypes_RepeatedGroup_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes_RepeatedGroup*) parseFromInputStream:(NSInputStream*) input {
  return (TestAllTypes_RepeatedGroup*)[[[TestAllTypes_RepeatedGroup_Builder builder] mergeFromInputStream:input] build];
}
+ (TestAllTypes_RepeatedGroup*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_RepeatedGroup*)[[[TestAllTypes_RepeatedGroup_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestAllTypes_RepeatedGroup*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestAllTypes_RepeatedGroup*)[[[TestAllTypes_RepeatedGroup_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestAllTypes_RepeatedGroup*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllTypes_RepeatedGroup*)[[[TestAllTypes_RepeatedGroup_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestAllTypes_RepeatedGroup_Builder*) createBuilder {
  return [TestAllTypes_RepeatedGroup_Builder builder];
}
@end

@implementation TestAllTypes_RepeatedGroup_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestAllTypes_RepeatedGroup alloc] init] autorelease];
  }
  return self;
}
+ (TestAllTypes_RepeatedGroup_Builder*) builder {
  return [[[TestAllTypes_RepeatedGroup_Builder alloc] init] autorelease];
}
+ (TestAllTypes_RepeatedGroup_Builder*) builderWithPrototype:(TestAllTypes_RepeatedGroup*) prototype {
  return [[TestAllTypes_RepeatedGroup_Builder builder] mergeFromTestAllTypes_RepeatedGroup:prototype];
}
- (TestAllTypes_RepeatedGroup*) internalGetResult {
  return result;
}
- (TestAllTypes_RepeatedGroup_Builder*) clear {
  self.result = [[[TestAllTypes_RepeatedGroup alloc] init] autorelease];
  return self;
}
- (TestAllTypes_RepeatedGroup_Builder*) clone {
  return [TestAllTypes_RepeatedGroup_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes_RepeatedGroup descriptor];
}
- (TestAllTypes_RepeatedGroup*) defaultInstance {
  return [TestAllTypes_RepeatedGroup defaultInstance];
}
- (TestAllTypes_RepeatedGroup*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestAllTypes_RepeatedGroup*) buildPartial {
  TestAllTypes_RepeatedGroup* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestAllTypes_RepeatedGroup_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestAllTypes_RepeatedGroup class]]) {
    return [self mergeFromTestAllTypes_RepeatedGroup:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestAllTypes_RepeatedGroup_Builder*) mergeFromTestAllTypes_RepeatedGroup:(TestAllTypes_RepeatedGroup*) other {
  if (other == [TestAllTypes_RepeatedGroup defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestAllTypes_RepeatedGroup_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestAllTypes_RepeatedGroup_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 376: {
        [self setA:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (TestAllTypes_RepeatedGroup_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestAllTypes_RepeatedGroup_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
@end

@implementation TestAllTypes_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestAllTypes alloc] init] autorelease];
  }
  return self;
}
+ (TestAllTypes_Builder*) builder {
  return [[[TestAllTypes_Builder alloc] init] autorelease];
}
+ (TestAllTypes_Builder*) builderWithPrototype:(TestAllTypes*) prototype {
  return [[TestAllTypes_Builder builder] mergeFromTestAllTypes:prototype];
}
- (TestAllTypes*) internalGetResult {
  return result;
}
- (TestAllTypes_Builder*) clear {
  self.result = [[[TestAllTypes alloc] init] autorelease];
  return self;
}
- (TestAllTypes_Builder*) clone {
  return [TestAllTypes_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestAllTypes descriptor];
}
- (TestAllTypes*) defaultInstance {
  return [TestAllTypes defaultInstance];
}
- (TestAllTypes*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestAllTypes*) buildPartial {
  TestAllTypes* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestAllTypes_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestAllTypes class]]) {
    return [self mergeFromTestAllTypes:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestAllTypes_Builder*) mergeFromTestAllTypes:(TestAllTypes*) other {
  if (other == [TestAllTypes defaultInstance]) return self;
  if (other.hasOptionalInt32) {
    [self setOptionalInt32:other.optionalInt32];
  }
  if (other.hasOptionalInt64) {
    [self setOptionalInt64:other.optionalInt64];
  }
  if (other.hasOptionalUint32) {
    [self setOptionalUint32:other.optionalUint32];
  }
  if (other.hasOptionalUint64) {
    [self setOptionalUint64:other.optionalUint64];
  }
  if (other.hasOptionalSint32) {
    [self setOptionalSint32:other.optionalSint32];
  }
  if (other.hasOptionalSint64) {
    [self setOptionalSint64:other.optionalSint64];
  }
  if (other.hasOptionalFixed32) {
    [self setOptionalFixed32:other.optionalFixed32];
  }
  if (other.hasOptionalFixed64) {
    [self setOptionalFixed64:other.optionalFixed64];
  }
  if (other.hasOptionalSfixed32) {
    [self setOptionalSfixed32:other.optionalSfixed32];
  }
  if (other.hasOptionalSfixed64) {
    [self setOptionalSfixed64:other.optionalSfixed64];
  }
  if (other.hasOptionalFloat) {
    [self setOptionalFloat:other.optionalFloat];
  }
  if (other.hasOptionalDouble) {
    [self setOptionalDouble:other.optionalDouble];
  }
  if (other.hasOptionalBool) {
    [self setOptionalBool:other.optionalBool];
  }
  if (other.hasOptionalString) {
    [self setOptionalString:other.optionalString];
  }
  if (other.hasOptionalBytes) {
    [self setOptionalBytes:other.optionalBytes];
  }
  if (other.hasOptionalGroup) {
    [self mergeOptionalGroup:other.optionalGroup];
  }
  if (other.hasOptionalNestedMessage) {
    [self mergeOptionalNestedMessage:other.optionalNestedMessage];
  }
  if (other.hasOptionalForeignMessage) {
    [self mergeOptionalForeignMessage:other.optionalForeignMessage];
  }
  if (other.hasOptionalImportMessage) {
    [self mergeOptionalImportMessage:other.optionalImportMessage];
  }
  if (other.hasOptionalNestedEnum) {
    [self setOptionalNestedEnum:other.optionalNestedEnum];
  }
  if (other.hasOptionalForeignEnum) {
    [self setOptionalForeignEnum:other.optionalForeignEnum];
  }
  if (other.hasOptionalImportEnum) {
    [self setOptionalImportEnum:other.optionalImportEnum];
  }
  if (other.hasOptionalStringPiece) {
    [self setOptionalStringPiece:other.optionalStringPiece];
  }
  if (other.hasOptionalCord) {
    [self setOptionalCord:other.optionalCord];
  }
  if (other.mutableRepeatedInt32List.count > 0) {
    if (result.mutableRepeatedInt32List == nil) {
      result.mutableRepeatedInt32List = [NSMutableArray array];
    }
    [result.mutableRepeatedInt32List addObjectsFromArray:other.mutableRepeatedInt32List];
  }
  if (other.mutableRepeatedInt64List.count > 0) {
    if (result.mutableRepeatedInt64List == nil) {
      result.mutableRepeatedInt64List = [NSMutableArray array];
    }
    [result.mutableRepeatedInt64List addObjectsFromArray:other.mutableRepeatedInt64List];
  }
  if (other.mutableRepeatedUint32List.count > 0) {
    if (result.mutableRepeatedUint32List == nil) {
      result.mutableRepeatedUint32List = [NSMutableArray array];
    }
    [result.mutableRepeatedUint32List addObjectsFromArray:other.mutableRepeatedUint32List];
  }
  if (other.mutableRepeatedUint64List.count > 0) {
    if (result.mutableRepeatedUint64List == nil) {
      result.mutableRepeatedUint64List = [NSMutableArray array];
    }
    [result.mutableRepeatedUint64List addObjectsFromArray:other.mutableRepeatedUint64List];
  }
  if (other.mutableRepeatedSint32List.count > 0) {
    if (result.mutableRepeatedSint32List == nil) {
      result.mutableRepeatedSint32List = [NSMutableArray array];
    }
    [result.mutableRepeatedSint32List addObjectsFromArray:other.mutableRepeatedSint32List];
  }
  if (other.mutableRepeatedSint64List.count > 0) {
    if (result.mutableRepeatedSint64List == nil) {
      result.mutableRepeatedSint64List = [NSMutableArray array];
    }
    [result.mutableRepeatedSint64List addObjectsFromArray:other.mutableRepeatedSint64List];
  }
  if (other.mutableRepeatedFixed32List.count > 0) {
    if (result.mutableRepeatedFixed32List == nil) {
      result.mutableRepeatedFixed32List = [NSMutableArray array];
    }
    [result.mutableRepeatedFixed32List addObjectsFromArray:other.mutableRepeatedFixed32List];
  }
  if (other.mutableRepeatedFixed64List.count > 0) {
    if (result.mutableRepeatedFixed64List == nil) {
      result.mutableRepeatedFixed64List = [NSMutableArray array];
    }
    [result.mutableRepeatedFixed64List addObjectsFromArray:other.mutableRepeatedFixed64List];
  }
  if (other.mutableRepeatedSfixed32List.count > 0) {
    if (result.mutableRepeatedSfixed32List == nil) {
      result.mutableRepeatedSfixed32List = [NSMutableArray array];
    }
    [result.mutableRepeatedSfixed32List addObjectsFromArray:other.mutableRepeatedSfixed32List];
  }
  if (other.mutableRepeatedSfixed64List.count > 0) {
    if (result.mutableRepeatedSfixed64List == nil) {
      result.mutableRepeatedSfixed64List = [NSMutableArray array];
    }
    [result.mutableRepeatedSfixed64List addObjectsFromArray:other.mutableRepeatedSfixed64List];
  }
  if (other.mutableRepeatedFloatList.count > 0) {
    if (result.mutableRepeatedFloatList == nil) {
      result.mutableRepeatedFloatList = [NSMutableArray array];
    }
    [result.mutableRepeatedFloatList addObjectsFromArray:other.mutableRepeatedFloatList];
  }
  if (other.mutableRepeatedDoubleList.count > 0) {
    if (result.mutableRepeatedDoubleList == nil) {
      result.mutableRepeatedDoubleList = [NSMutableArray array];
    }
    [result.mutableRepeatedDoubleList addObjectsFromArray:other.mutableRepeatedDoubleList];
  }
  if (other.mutableRepeatedBoolList.count > 0) {
    if (result.mutableRepeatedBoolList == nil) {
      result.mutableRepeatedBoolList = [NSMutableArray array];
    }
    [result.mutableRepeatedBoolList addObjectsFromArray:other.mutableRepeatedBoolList];
  }
  if (other.mutableRepeatedStringList.count > 0) {
    if (result.mutableRepeatedStringList == nil) {
      result.mutableRepeatedStringList = [NSMutableArray array];
    }
    [result.mutableRepeatedStringList addObjectsFromArray:other.mutableRepeatedStringList];
  }
  if (other.mutableRepeatedBytesList.count > 0) {
    if (result.mutableRepeatedBytesList == nil) {
      result.mutableRepeatedBytesList = [NSMutableArray array];
    }
    [result.mutableRepeatedBytesList addObjectsFromArray:other.mutableRepeatedBytesList];
  }
  if (other.mutableRepeatedGroupList.count > 0) {
    if (result.mutableRepeatedGroupList == nil) {
      result.mutableRepeatedGroupList = [NSMutableArray array];
    }
    [result.mutableRepeatedGroupList addObjectsFromArray:other.mutableRepeatedGroupList];
  }
  if (other.mutableRepeatedNestedMessageList.count > 0) {
    if (result.mutableRepeatedNestedMessageList == nil) {
      result.mutableRepeatedNestedMessageList = [NSMutableArray array];
    }
    [result.mutableRepeatedNestedMessageList addObjectsFromArray:other.mutableRepeatedNestedMessageList];
  }
  if (other.mutableRepeatedForeignMessageList.count > 0) {
    if (result.mutableRepeatedForeignMessageList == nil) {
      result.mutableRepeatedForeignMessageList = [NSMutableArray array];
    }
    [result.mutableRepeatedForeignMessageList addObjectsFromArray:other.mutableRepeatedForeignMessageList];
  }
  if (other.mutableRepeatedImportMessageList.count > 0) {
    if (result.mutableRepeatedImportMessageList == nil) {
      result.mutableRepeatedImportMessageList = [NSMutableArray array];
    }
    [result.mutableRepeatedImportMessageList addObjectsFromArray:other.mutableRepeatedImportMessageList];
  }
  if (other.mutableRepeatedNestedEnumList.count > 0) {
    if (result.mutableRepeatedNestedEnumList == nil) {
      result.mutableRepeatedNestedEnumList = [NSMutableArray array];
    }
    [result.mutableRepeatedNestedEnumList addObjectsFromArray:other.mutableRepeatedNestedEnumList];
  }
  if (other.mutableRepeatedForeignEnumList.count > 0) {
    if (result.mutableRepeatedForeignEnumList == nil) {
      result.mutableRepeatedForeignEnumList = [NSMutableArray array];
    }
    [result.mutableRepeatedForeignEnumList addObjectsFromArray:other.mutableRepeatedForeignEnumList];
  }
  if (other.mutableRepeatedImportEnumList.count > 0) {
    if (result.mutableRepeatedImportEnumList == nil) {
      result.mutableRepeatedImportEnumList = [NSMutableArray array];
    }
    [result.mutableRepeatedImportEnumList addObjectsFromArray:other.mutableRepeatedImportEnumList];
  }
  if (other.mutableRepeatedStringPieceList.count > 0) {
    if (result.mutableRepeatedStringPieceList == nil) {
      result.mutableRepeatedStringPieceList = [NSMutableArray array];
    }
    [result.mutableRepeatedStringPieceList addObjectsFromArray:other.mutableRepeatedStringPieceList];
  }
  if (other.mutableRepeatedCordList.count > 0) {
    if (result.mutableRepeatedCordList == nil) {
      result.mutableRepeatedCordList = [NSMutableArray array];
    }
    [result.mutableRepeatedCordList addObjectsFromArray:other.mutableRepeatedCordList];
  }
  if (other.hasDefaultInt32) {
    [self setDefaultInt32:other.defaultInt32];
  }
  if (other.hasDefaultInt64) {
    [self setDefaultInt64:other.defaultInt64];
  }
  if (other.hasDefaultUint32) {
    [self setDefaultUint32:other.defaultUint32];
  }
  if (other.hasDefaultUint64) {
    [self setDefaultUint64:other.defaultUint64];
  }
  if (other.hasDefaultSint32) {
    [self setDefaultSint32:other.defaultSint32];
  }
  if (other.hasDefaultSint64) {
    [self setDefaultSint64:other.defaultSint64];
  }
  if (other.hasDefaultFixed32) {
    [self setDefaultFixed32:other.defaultFixed32];
  }
  if (other.hasDefaultFixed64) {
    [self setDefaultFixed64:other.defaultFixed64];
  }
  if (other.hasDefaultSfixed32) {
    [self setDefaultSfixed32:other.defaultSfixed32];
  }
  if (other.hasDefaultSfixed64) {
    [self setDefaultSfixed64:other.defaultSfixed64];
  }
  if (other.hasDefaultFloat) {
    [self setDefaultFloat:other.defaultFloat];
  }
  if (other.hasDefaultDouble) {
    [self setDefaultDouble:other.defaultDouble];
  }
  if (other.hasDefaultBool) {
    [self setDefaultBool:other.defaultBool];
  }
  if (other.hasDefaultString) {
    [self setDefaultString:other.defaultString];
  }
  if (other.hasDefaultBytes) {
    [self setDefaultBytes:other.defaultBytes];
  }
  if (other.hasDefaultNestedEnum) {
    [self setDefaultNestedEnum:other.defaultNestedEnum];
  }
  if (other.hasDefaultForeignEnum) {
    [self setDefaultForeignEnum:other.defaultForeignEnum];
  }
  if (other.hasDefaultImportEnum) {
    [self setDefaultImportEnum:other.defaultImportEnum];
  }
  if (other.hasDefaultStringPiece) {
    [self setDefaultStringPiece:other.defaultStringPiece];
  }
  if (other.hasDefaultCord) {
    [self setDefaultCord:other.defaultCord];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestAllTypes_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestAllTypes_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setOptionalInt32:[input readInt32]];
        break;
      }
      case 16: {
        [self setOptionalInt64:[input readInt64]];
        break;
      }
      case 24: {
        [self setOptionalUint32:[input readUInt32]];
        break;
      }
      case 32: {
        [self setOptionalUint64:[input readUInt64]];
        break;
      }
      case 40: {
        [self setOptionalSint32:[input readSInt32]];
        break;
      }
      case 48: {
        [self setOptionalSint64:[input readSInt64]];
        break;
      }
      case 61: {
        [self setOptionalFixed32:[input readFixed32]];
        break;
      }
      case 65: {
        [self setOptionalFixed64:[input readFixed64]];
        break;
      }
      case 77: {
        [self setOptionalSfixed32:[input readSFixed32]];
        break;
      }
      case 81: {
        [self setOptionalSfixed64:[input readSFixed64]];
        break;
      }
      case 93: {
        [self setOptionalFloat:[input readFloat]];
        break;
      }
      case 97: {
        [self setOptionalDouble:[input readDouble]];
        break;
      }
      case 104: {
        [self setOptionalBool:[input readBool]];
        break;
      }
      case 114: {
        [self setOptionalString:[input readString]];
        break;
      }
      case 122: {
        [self setOptionalBytes:[input readData]];
        break;
      }
      case 131: {
        TestAllTypes_OptionalGroup_Builder* subBuilder = [TestAllTypes_OptionalGroup_Builder builder];
        if (self.hasOptionalGroup) {
          [subBuilder mergeFromTestAllTypes_OptionalGroup:self.optionalGroup];
        }
        [input readGroup:16 builder:subBuilder extensionRegistry:extensionRegistry];
        [self setOptionalGroup:[subBuilder buildPartial]];
        break;
      }
      case 146: {
        TestAllTypes_NestedMessage_Builder* subBuilder = [TestAllTypes_NestedMessage_Builder builder];
        if (self.hasOptionalNestedMessage) {
          [subBuilder mergeFromTestAllTypes_NestedMessage:self.optionalNestedMessage];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptionalNestedMessage:[subBuilder buildPartial]];
        break;
      }
      case 154: {
        ForeignMessage_Builder* subBuilder = [ForeignMessage_Builder builder];
        if (self.hasOptionalForeignMessage) {
          [subBuilder mergeFromForeignMessage:self.optionalForeignMessage];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptionalForeignMessage:[subBuilder buildPartial]];
        break;
      }
      case 162: {
        ImportMessage_Builder* subBuilder = [ImportMessage_Builder builder];
        if (self.hasOptionalImportMessage) {
          [subBuilder mergeFromImportMessage:self.optionalImportMessage];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptionalImportMessage:[subBuilder buildPartial]];
        break;
      }
      case 168: {
        int32_t rawValue = [input readEnum];
        TestAllTypes_NestedEnum* value = [TestAllTypes_NestedEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:21 value:rawValue];
        } else {
          [self setOptionalNestedEnum:value];
        }
        break;
      }
      case 176: {
        int32_t rawValue = [input readEnum];
        ForeignEnum* value = [ForeignEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:22 value:rawValue];
        } else {
          [self setOptionalForeignEnum:value];
        }
        break;
      }
      case 184: {
        int32_t rawValue = [input readEnum];
        ImportEnum* value = [ImportEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:23 value:rawValue];
        } else {
          [self setOptionalImportEnum:value];
        }
        break;
      }
      case 194: {
        [self setOptionalStringPiece:[input readString]];
        break;
      }
      case 202: {
        [self setOptionalCord:[input readString]];
        break;
      }
      case 248: {
        [self addRepeatedInt32:[input readInt32]];
        break;
      }
      case 256: {
        [self addRepeatedInt64:[input readInt64]];
        break;
      }
      case 264: {
        [self addRepeatedUint32:[input readUInt32]];
        break;
      }
      case 272: {
        [self addRepeatedUint64:[input readUInt64]];
        break;
      }
      case 280: {
        [self addRepeatedSint32:[input readSInt32]];
        break;
      }
      case 288: {
        [self addRepeatedSint64:[input readSInt64]];
        break;
      }
      case 301: {
        [self addRepeatedFixed32:[input readFixed32]];
        break;
      }
      case 305: {
        [self addRepeatedFixed64:[input readFixed64]];
        break;
      }
      case 317: {
        [self addRepeatedSfixed32:[input readSFixed32]];
        break;
      }
      case 321: {
        [self addRepeatedSfixed64:[input readSFixed64]];
        break;
      }
      case 333: {
        [self addRepeatedFloat:[input readFloat]];
        break;
      }
      case 337: {
        [self addRepeatedDouble:[input readDouble]];
        break;
      }
      case 344: {
        [self addRepeatedBool:[input readBool]];
        break;
      }
      case 354: {
        [self addRepeatedString:[input readString]];
        break;
      }
      case 362: {
        [self addRepeatedBytes:[input readData]];
        break;
      }
      case 371: {
        TestAllTypes_RepeatedGroup_Builder* subBuilder = [TestAllTypes_RepeatedGroup_Builder builder];
        [input readGroup:46 builder:subBuilder extensionRegistry:extensionRegistry];
        [self addRepeatedGroup:[subBuilder buildPartial]];
        break;
      }
      case 386: {
        TestAllTypes_NestedMessage_Builder* subBuilder = [TestAllTypes_NestedMessage_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addRepeatedNestedMessage:[subBuilder buildPartial]];
        break;
      }
      case 394: {
        ForeignMessage_Builder* subBuilder = [ForeignMessage_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addRepeatedForeignMessage:[subBuilder buildPartial]];
        break;
      }
      case 402: {
        ImportMessage_Builder* subBuilder = [ImportMessage_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addRepeatedImportMessage:[subBuilder buildPartial]];
        break;
      }
      case 408: {
        int32_t rawValue = [input readEnum];
        TestAllTypes_NestedEnum* value = [TestAllTypes_NestedEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:51 value:rawValue];
        } else {
          [self addRepeatedNestedEnum:value];
        }
        break;
      }
      case 416: {
        int32_t rawValue = [input readEnum];
        ForeignEnum* value = [ForeignEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:52 value:rawValue];
        } else {
          [self addRepeatedForeignEnum:value];
        }
        break;
      }
      case 424: {
        int32_t rawValue = [input readEnum];
        ImportEnum* value = [ImportEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:53 value:rawValue];
        } else {
          [self addRepeatedImportEnum:value];
        }
        break;
      }
      case 434: {
        [self addRepeatedStringPiece:[input readString]];
        break;
      }
      case 442: {
        [self addRepeatedCord:[input readString]];
        break;
      }
      case 488: {
        [self setDefaultInt32:[input readInt32]];
        break;
      }
      case 496: {
        [self setDefaultInt64:[input readInt64]];
        break;
      }
      case 504: {
        [self setDefaultUint32:[input readUInt32]];
        break;
      }
      case 512: {
        [self setDefaultUint64:[input readUInt64]];
        break;
      }
      case 520: {
        [self setDefaultSint32:[input readSInt32]];
        break;
      }
      case 528: {
        [self setDefaultSint64:[input readSInt64]];
        break;
      }
      case 541: {
        [self setDefaultFixed32:[input readFixed32]];
        break;
      }
      case 545: {
        [self setDefaultFixed64:[input readFixed64]];
        break;
      }
      case 557: {
        [self setDefaultSfixed32:[input readSFixed32]];
        break;
      }
      case 561: {
        [self setDefaultSfixed64:[input readSFixed64]];
        break;
      }
      case 573: {
        [self setDefaultFloat:[input readFloat]];
        break;
      }
      case 577: {
        [self setDefaultDouble:[input readDouble]];
        break;
      }
      case 584: {
        [self setDefaultBool:[input readBool]];
        break;
      }
      case 594: {
        [self setDefaultString:[input readString]];
        break;
      }
      case 602: {
        [self setDefaultBytes:[input readData]];
        break;
      }
      case 648: {
        int32_t rawValue = [input readEnum];
        TestAllTypes_NestedEnum* value = [TestAllTypes_NestedEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:81 value:rawValue];
        } else {
          [self setDefaultNestedEnum:value];
        }
        break;
      }
      case 656: {
        int32_t rawValue = [input readEnum];
        ForeignEnum* value = [ForeignEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:82 value:rawValue];
        } else {
          [self setDefaultForeignEnum:value];
        }
        break;
      }
      case 664: {
        int32_t rawValue = [input readEnum];
        ImportEnum* value = [ImportEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:83 value:rawValue];
        } else {
          [self setDefaultImportEnum:value];
        }
        break;
      }
      case 674: {
        [self setDefaultStringPiece:[input readString]];
        break;
      }
      case 682: {
        [self setDefaultCord:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasOptionalInt32 {
  return result.hasOptionalInt32;
}
- (int32_t) optionalInt32 {
  return result.optionalInt32;
}
- (TestAllTypes_Builder*) setOptionalInt32:(int32_t) value {
  result.hasOptionalInt32 = YES;
  result.optionalInt32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalInt32 {
  result.hasOptionalInt32 = NO;
  result.optionalInt32 = 0;
  return self;
}
- (BOOL) hasOptionalInt64 {
  return result.hasOptionalInt64;
}
- (int64_t) optionalInt64 {
  return result.optionalInt64;
}
- (TestAllTypes_Builder*) setOptionalInt64:(int64_t) value {
  result.hasOptionalInt64 = YES;
  result.optionalInt64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalInt64 {
  result.hasOptionalInt64 = NO;
  result.optionalInt64 = 0L;
  return self;
}
- (BOOL) hasOptionalUint32 {
  return result.hasOptionalUint32;
}
- (int32_t) optionalUint32 {
  return result.optionalUint32;
}
- (TestAllTypes_Builder*) setOptionalUint32:(int32_t) value {
  result.hasOptionalUint32 = YES;
  result.optionalUint32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalUint32 {
  result.hasOptionalUint32 = NO;
  result.optionalUint32 = 0;
  return self;
}
- (BOOL) hasOptionalUint64 {
  return result.hasOptionalUint64;
}
- (int64_t) optionalUint64 {
  return result.optionalUint64;
}
- (TestAllTypes_Builder*) setOptionalUint64:(int64_t) value {
  result.hasOptionalUint64 = YES;
  result.optionalUint64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalUint64 {
  result.hasOptionalUint64 = NO;
  result.optionalUint64 = 0L;
  return self;
}
- (BOOL) hasOptionalSint32 {
  return result.hasOptionalSint32;
}
- (int32_t) optionalSint32 {
  return result.optionalSint32;
}
- (TestAllTypes_Builder*) setOptionalSint32:(int32_t) value {
  result.hasOptionalSint32 = YES;
  result.optionalSint32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalSint32 {
  result.hasOptionalSint32 = NO;
  result.optionalSint32 = 0;
  return self;
}
- (BOOL) hasOptionalSint64 {
  return result.hasOptionalSint64;
}
- (int64_t) optionalSint64 {
  return result.optionalSint64;
}
- (TestAllTypes_Builder*) setOptionalSint64:(int64_t) value {
  result.hasOptionalSint64 = YES;
  result.optionalSint64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalSint64 {
  result.hasOptionalSint64 = NO;
  result.optionalSint64 = 0L;
  return self;
}
- (BOOL) hasOptionalFixed32 {
  return result.hasOptionalFixed32;
}
- (int32_t) optionalFixed32 {
  return result.optionalFixed32;
}
- (TestAllTypes_Builder*) setOptionalFixed32:(int32_t) value {
  result.hasOptionalFixed32 = YES;
  result.optionalFixed32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalFixed32 {
  result.hasOptionalFixed32 = NO;
  result.optionalFixed32 = 0;
  return self;
}
- (BOOL) hasOptionalFixed64 {
  return result.hasOptionalFixed64;
}
- (int64_t) optionalFixed64 {
  return result.optionalFixed64;
}
- (TestAllTypes_Builder*) setOptionalFixed64:(int64_t) value {
  result.hasOptionalFixed64 = YES;
  result.optionalFixed64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalFixed64 {
  result.hasOptionalFixed64 = NO;
  result.optionalFixed64 = 0L;
  return self;
}
- (BOOL) hasOptionalSfixed32 {
  return result.hasOptionalSfixed32;
}
- (int32_t) optionalSfixed32 {
  return result.optionalSfixed32;
}
- (TestAllTypes_Builder*) setOptionalSfixed32:(int32_t) value {
  result.hasOptionalSfixed32 = YES;
  result.optionalSfixed32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalSfixed32 {
  result.hasOptionalSfixed32 = NO;
  result.optionalSfixed32 = 0;
  return self;
}
- (BOOL) hasOptionalSfixed64 {
  return result.hasOptionalSfixed64;
}
- (int64_t) optionalSfixed64 {
  return result.optionalSfixed64;
}
- (TestAllTypes_Builder*) setOptionalSfixed64:(int64_t) value {
  result.hasOptionalSfixed64 = YES;
  result.optionalSfixed64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalSfixed64 {
  result.hasOptionalSfixed64 = NO;
  result.optionalSfixed64 = 0L;
  return self;
}
- (BOOL) hasOptionalFloat {
  return result.hasOptionalFloat;
}
- (Float32) optionalFloat {
  return result.optionalFloat;
}
- (TestAllTypes_Builder*) setOptionalFloat:(Float32) value {
  result.hasOptionalFloat = YES;
  result.optionalFloat = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalFloat {
  result.hasOptionalFloat = NO;
  result.optionalFloat = 0;
  return self;
}
- (BOOL) hasOptionalDouble {
  return result.hasOptionalDouble;
}
- (Float64) optionalDouble {
  return result.optionalDouble;
}
- (TestAllTypes_Builder*) setOptionalDouble:(Float64) value {
  result.hasOptionalDouble = YES;
  result.optionalDouble = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalDouble {
  result.hasOptionalDouble = NO;
  result.optionalDouble = 0;
  return self;
}
- (BOOL) hasOptionalBool {
  return result.hasOptionalBool;
}
- (BOOL) optionalBool {
  return result.optionalBool;
}
- (TestAllTypes_Builder*) setOptionalBool:(BOOL) value {
  result.hasOptionalBool = YES;
  result.optionalBool = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalBool {
  result.hasOptionalBool = NO;
  result.optionalBool = NO;
  return self;
}
- (BOOL) hasOptionalString {
  return result.hasOptionalString;
}
- (NSString*) optionalString {
  return result.optionalString;
}
- (TestAllTypes_Builder*) setOptionalString:(NSString*) value {
  result.hasOptionalString = YES;
  result.optionalString = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalString {
  result.hasOptionalString = NO;
  result.optionalString = @"";
  return self;
}
- (BOOL) hasOptionalBytes {
  return result.hasOptionalBytes;
}
- (NSData*) optionalBytes {
  return result.optionalBytes;
}
- (TestAllTypes_Builder*) setOptionalBytes:(NSData*) value {
  result.hasOptionalBytes = YES;
  result.optionalBytes = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalBytes {
  result.hasOptionalBytes = NO;
  result.optionalBytes = [NSData data];
  return self;
}
- (BOOL) hasOptionalGroup {
  return result.hasOptionalGroup;
}
- (TestAllTypes_OptionalGroup*) optionalGroup {
  return result.optionalGroup;
}
- (TestAllTypes_Builder*) setOptionalGroup:(TestAllTypes_OptionalGroup*) value {
  result.hasOptionalGroup = YES;
  result.optionalGroup = value;
  return self;
}
- (TestAllTypes_Builder*) setOptionalGroupBuilder:(TestAllTypes_OptionalGroup_Builder*) builderForValue {
  return [self setOptionalGroup:[builderForValue build]];
}
- (TestAllTypes_Builder*) mergeOptionalGroup:(TestAllTypes_OptionalGroup*) value {
  if (result.hasOptionalGroup &&
      result.optionalGroup != [TestAllTypes_OptionalGroup defaultInstance]) {
    result.optionalGroup =
      [[[TestAllTypes_OptionalGroup_Builder builderWithPrototype:result.optionalGroup] mergeFromTestAllTypes_OptionalGroup:value] buildPartial];
  } else {
    result.optionalGroup = value;
  }
  result.hasOptionalGroup = YES;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalGroup {
  result.hasOptionalGroup = NO;
  result.optionalGroup = [TestAllTypes_OptionalGroup defaultInstance];
  return self;
}
- (BOOL) hasOptionalNestedMessage {
  return result.hasOptionalNestedMessage;
}
- (TestAllTypes_NestedMessage*) optionalNestedMessage {
  return result.optionalNestedMessage;
}
- (TestAllTypes_Builder*) setOptionalNestedMessage:(TestAllTypes_NestedMessage*) value {
  result.hasOptionalNestedMessage = YES;
  result.optionalNestedMessage = value;
  return self;
}
- (TestAllTypes_Builder*) setOptionalNestedMessageBuilder:(TestAllTypes_NestedMessage_Builder*) builderForValue {
  return [self setOptionalNestedMessage:[builderForValue build]];
}
- (TestAllTypes_Builder*) mergeOptionalNestedMessage:(TestAllTypes_NestedMessage*) value {
  if (result.hasOptionalNestedMessage &&
      result.optionalNestedMessage != [TestAllTypes_NestedMessage defaultInstance]) {
    result.optionalNestedMessage =
      [[[TestAllTypes_NestedMessage_Builder builderWithPrototype:result.optionalNestedMessage] mergeFromTestAllTypes_NestedMessage:value] buildPartial];
  } else {
    result.optionalNestedMessage = value;
  }
  result.hasOptionalNestedMessage = YES;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalNestedMessage {
  result.hasOptionalNestedMessage = NO;
  result.optionalNestedMessage = [TestAllTypes_NestedMessage defaultInstance];
  return self;
}
- (BOOL) hasOptionalForeignMessage {
  return result.hasOptionalForeignMessage;
}
- (ForeignMessage*) optionalForeignMessage {
  return result.optionalForeignMessage;
}
- (TestAllTypes_Builder*) setOptionalForeignMessage:(ForeignMessage*) value {
  result.hasOptionalForeignMessage = YES;
  result.optionalForeignMessage = value;
  return self;
}
- (TestAllTypes_Builder*) setOptionalForeignMessageBuilder:(ForeignMessage_Builder*) builderForValue {
  return [self setOptionalForeignMessage:[builderForValue build]];
}
- (TestAllTypes_Builder*) mergeOptionalForeignMessage:(ForeignMessage*) value {
  if (result.hasOptionalForeignMessage &&
      result.optionalForeignMessage != [ForeignMessage defaultInstance]) {
    result.optionalForeignMessage =
      [[[ForeignMessage_Builder builderWithPrototype:result.optionalForeignMessage] mergeFromForeignMessage:value] buildPartial];
  } else {
    result.optionalForeignMessage = value;
  }
  result.hasOptionalForeignMessage = YES;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalForeignMessage {
  result.hasOptionalForeignMessage = NO;
  result.optionalForeignMessage = [ForeignMessage defaultInstance];
  return self;
}
- (BOOL) hasOptionalImportMessage {
  return result.hasOptionalImportMessage;
}
- (ImportMessage*) optionalImportMessage {
  return result.optionalImportMessage;
}
- (TestAllTypes_Builder*) setOptionalImportMessage:(ImportMessage*) value {
  result.hasOptionalImportMessage = YES;
  result.optionalImportMessage = value;
  return self;
}
- (TestAllTypes_Builder*) setOptionalImportMessageBuilder:(ImportMessage_Builder*) builderForValue {
  return [self setOptionalImportMessage:[builderForValue build]];
}
- (TestAllTypes_Builder*) mergeOptionalImportMessage:(ImportMessage*) value {
  if (result.hasOptionalImportMessage &&
      result.optionalImportMessage != [ImportMessage defaultInstance]) {
    result.optionalImportMessage =
      [[[ImportMessage_Builder builderWithPrototype:result.optionalImportMessage] mergeFromImportMessage:value] buildPartial];
  } else {
    result.optionalImportMessage = value;
  }
  result.hasOptionalImportMessage = YES;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalImportMessage {
  result.hasOptionalImportMessage = NO;
  result.optionalImportMessage = [ImportMessage defaultInstance];
  return self;
}
- (BOOL) hasOptionalNestedEnum {
  return result.hasOptionalNestedEnum;
}
- (TestAllTypes_NestedEnum*) optionalNestedEnum {
  return result.optionalNestedEnum;
}
- (TestAllTypes_Builder*) setOptionalNestedEnum:(TestAllTypes_NestedEnum*) value {
  result.hasOptionalNestedEnum = YES;
  result.optionalNestedEnum = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalNestedEnum {
  result.hasOptionalNestedEnum = NO;
  result.optionalNestedEnum = [TestAllTypes_NestedEnum FOO];
  return self;
}
- (BOOL) hasOptionalForeignEnum {
  return result.hasOptionalForeignEnum;
}
- (ForeignEnum*) optionalForeignEnum {
  return result.optionalForeignEnum;
}
- (TestAllTypes_Builder*) setOptionalForeignEnum:(ForeignEnum*) value {
  result.hasOptionalForeignEnum = YES;
  result.optionalForeignEnum = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalForeignEnum {
  result.hasOptionalForeignEnum = NO;
  result.optionalForeignEnum = [ForeignEnum FOREIGN_FOO];
  return self;
}
- (BOOL) hasOptionalImportEnum {
  return result.hasOptionalImportEnum;
}
- (ImportEnum*) optionalImportEnum {
  return result.optionalImportEnum;
}
- (TestAllTypes_Builder*) setOptionalImportEnum:(ImportEnum*) value {
  result.hasOptionalImportEnum = YES;
  result.optionalImportEnum = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalImportEnum {
  result.hasOptionalImportEnum = NO;
  result.optionalImportEnum = [ImportEnum IMPORT_FOO];
  return self;
}
- (BOOL) hasOptionalStringPiece {
  return result.hasOptionalStringPiece;
}
- (NSString*) optionalStringPiece {
  return result.optionalStringPiece;
}
- (TestAllTypes_Builder*) setOptionalStringPiece:(NSString*) value {
  result.hasOptionalStringPiece = YES;
  result.optionalStringPiece = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalStringPiece {
  result.hasOptionalStringPiece = NO;
  result.optionalStringPiece = @"";
  return self;
}
- (BOOL) hasOptionalCord {
  return result.hasOptionalCord;
}
- (NSString*) optionalCord {
  return result.optionalCord;
}
- (TestAllTypes_Builder*) setOptionalCord:(NSString*) value {
  result.hasOptionalCord = YES;
  result.optionalCord = value;
  return self;
}
- (TestAllTypes_Builder*) clearOptionalCord {
  result.hasOptionalCord = NO;
  result.optionalCord = @"";
  return self;
}
- (NSArray*) repeatedInt32List {
  if (result.mutableRepeatedInt32List == nil) { return [NSArray array]; }
  return result.mutableRepeatedInt32List;
}
- (int32_t) repeatedInt32AtIndex:(int32_t) index {
  return [result repeatedInt32AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedInt32AtIndex:(int32_t) index withRepeatedInt32:(int32_t) value {
  [result.mutableRepeatedInt32List replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedInt32:(int32_t) value {
  if (result.mutableRepeatedInt32List == nil) {
    result.mutableRepeatedInt32List = [NSMutableArray array];
  }
  [result.mutableRepeatedInt32List addObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedInt32:(NSArray*) values {
  if (result.mutableRepeatedInt32List == nil) {
    result.mutableRepeatedInt32List = [NSMutableArray array];
  }
  [result.mutableRepeatedInt32List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedInt32List {
  result.mutableRepeatedInt32List = nil;
  return self;
}
- (NSArray*) repeatedInt64List {
  if (result.mutableRepeatedInt64List == nil) { return [NSArray array]; }
  return result.mutableRepeatedInt64List;
}
- (int64_t) repeatedInt64AtIndex:(int32_t) index {
  return [result repeatedInt64AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedInt64AtIndex:(int32_t) index withRepeatedInt64:(int64_t) value {
  [result.mutableRepeatedInt64List replaceObjectAtIndex:index withObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedInt64:(int64_t) value {
  if (result.mutableRepeatedInt64List == nil) {
    result.mutableRepeatedInt64List = [NSMutableArray array];
  }
  [result.mutableRepeatedInt64List addObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedInt64:(NSArray*) values {
  if (result.mutableRepeatedInt64List == nil) {
    result.mutableRepeatedInt64List = [NSMutableArray array];
  }
  [result.mutableRepeatedInt64List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedInt64List {
  result.mutableRepeatedInt64List = nil;
  return self;
}
- (NSArray*) repeatedUint32List {
  if (result.mutableRepeatedUint32List == nil) { return [NSArray array]; }
  return result.mutableRepeatedUint32List;
}
- (int32_t) repeatedUint32AtIndex:(int32_t) index {
  return [result repeatedUint32AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedUint32AtIndex:(int32_t) index withRepeatedUint32:(int32_t) value {
  [result.mutableRepeatedUint32List replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedUint32:(int32_t) value {
  if (result.mutableRepeatedUint32List == nil) {
    result.mutableRepeatedUint32List = [NSMutableArray array];
  }
  [result.mutableRepeatedUint32List addObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedUint32:(NSArray*) values {
  if (result.mutableRepeatedUint32List == nil) {
    result.mutableRepeatedUint32List = [NSMutableArray array];
  }
  [result.mutableRepeatedUint32List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedUint32List {
  result.mutableRepeatedUint32List = nil;
  return self;
}
- (NSArray*) repeatedUint64List {
  if (result.mutableRepeatedUint64List == nil) { return [NSArray array]; }
  return result.mutableRepeatedUint64List;
}
- (int64_t) repeatedUint64AtIndex:(int32_t) index {
  return [result repeatedUint64AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedUint64AtIndex:(int32_t) index withRepeatedUint64:(int64_t) value {
  [result.mutableRepeatedUint64List replaceObjectAtIndex:index withObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedUint64:(int64_t) value {
  if (result.mutableRepeatedUint64List == nil) {
    result.mutableRepeatedUint64List = [NSMutableArray array];
  }
  [result.mutableRepeatedUint64List addObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedUint64:(NSArray*) values {
  if (result.mutableRepeatedUint64List == nil) {
    result.mutableRepeatedUint64List = [NSMutableArray array];
  }
  [result.mutableRepeatedUint64List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedUint64List {
  result.mutableRepeatedUint64List = nil;
  return self;
}
- (NSArray*) repeatedSint32List {
  if (result.mutableRepeatedSint32List == nil) { return [NSArray array]; }
  return result.mutableRepeatedSint32List;
}
- (int32_t) repeatedSint32AtIndex:(int32_t) index {
  return [result repeatedSint32AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedSint32AtIndex:(int32_t) index withRepeatedSint32:(int32_t) value {
  [result.mutableRepeatedSint32List replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedSint32:(int32_t) value {
  if (result.mutableRepeatedSint32List == nil) {
    result.mutableRepeatedSint32List = [NSMutableArray array];
  }
  [result.mutableRepeatedSint32List addObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedSint32:(NSArray*) values {
  if (result.mutableRepeatedSint32List == nil) {
    result.mutableRepeatedSint32List = [NSMutableArray array];
  }
  [result.mutableRepeatedSint32List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedSint32List {
  result.mutableRepeatedSint32List = nil;
  return self;
}
- (NSArray*) repeatedSint64List {
  if (result.mutableRepeatedSint64List == nil) { return [NSArray array]; }
  return result.mutableRepeatedSint64List;
}
- (int64_t) repeatedSint64AtIndex:(int32_t) index {
  return [result repeatedSint64AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedSint64AtIndex:(int32_t) index withRepeatedSint64:(int64_t) value {
  [result.mutableRepeatedSint64List replaceObjectAtIndex:index withObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedSint64:(int64_t) value {
  if (result.mutableRepeatedSint64List == nil) {
    result.mutableRepeatedSint64List = [NSMutableArray array];
  }
  [result.mutableRepeatedSint64List addObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedSint64:(NSArray*) values {
  if (result.mutableRepeatedSint64List == nil) {
    result.mutableRepeatedSint64List = [NSMutableArray array];
  }
  [result.mutableRepeatedSint64List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedSint64List {
  result.mutableRepeatedSint64List = nil;
  return self;
}
- (NSArray*) repeatedFixed32List {
  if (result.mutableRepeatedFixed32List == nil) { return [NSArray array]; }
  return result.mutableRepeatedFixed32List;
}
- (int32_t) repeatedFixed32AtIndex:(int32_t) index {
  return [result repeatedFixed32AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedFixed32AtIndex:(int32_t) index withRepeatedFixed32:(int32_t) value {
  [result.mutableRepeatedFixed32List replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedFixed32:(int32_t) value {
  if (result.mutableRepeatedFixed32List == nil) {
    result.mutableRepeatedFixed32List = [NSMutableArray array];
  }
  [result.mutableRepeatedFixed32List addObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedFixed32:(NSArray*) values {
  if (result.mutableRepeatedFixed32List == nil) {
    result.mutableRepeatedFixed32List = [NSMutableArray array];
  }
  [result.mutableRepeatedFixed32List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedFixed32List {
  result.mutableRepeatedFixed32List = nil;
  return self;
}
- (NSArray*) repeatedFixed64List {
  if (result.mutableRepeatedFixed64List == nil) { return [NSArray array]; }
  return result.mutableRepeatedFixed64List;
}
- (int64_t) repeatedFixed64AtIndex:(int32_t) index {
  return [result repeatedFixed64AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedFixed64AtIndex:(int32_t) index withRepeatedFixed64:(int64_t) value {
  [result.mutableRepeatedFixed64List replaceObjectAtIndex:index withObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedFixed64:(int64_t) value {
  if (result.mutableRepeatedFixed64List == nil) {
    result.mutableRepeatedFixed64List = [NSMutableArray array];
  }
  [result.mutableRepeatedFixed64List addObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedFixed64:(NSArray*) values {
  if (result.mutableRepeatedFixed64List == nil) {
    result.mutableRepeatedFixed64List = [NSMutableArray array];
  }
  [result.mutableRepeatedFixed64List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedFixed64List {
  result.mutableRepeatedFixed64List = nil;
  return self;
}
- (NSArray*) repeatedSfixed32List {
  if (result.mutableRepeatedSfixed32List == nil) { return [NSArray array]; }
  return result.mutableRepeatedSfixed32List;
}
- (int32_t) repeatedSfixed32AtIndex:(int32_t) index {
  return [result repeatedSfixed32AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedSfixed32AtIndex:(int32_t) index withRepeatedSfixed32:(int32_t) value {
  [result.mutableRepeatedSfixed32List replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedSfixed32:(int32_t) value {
  if (result.mutableRepeatedSfixed32List == nil) {
    result.mutableRepeatedSfixed32List = [NSMutableArray array];
  }
  [result.mutableRepeatedSfixed32List addObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedSfixed32:(NSArray*) values {
  if (result.mutableRepeatedSfixed32List == nil) {
    result.mutableRepeatedSfixed32List = [NSMutableArray array];
  }
  [result.mutableRepeatedSfixed32List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedSfixed32List {
  result.mutableRepeatedSfixed32List = nil;
  return self;
}
- (NSArray*) repeatedSfixed64List {
  if (result.mutableRepeatedSfixed64List == nil) { return [NSArray array]; }
  return result.mutableRepeatedSfixed64List;
}
- (int64_t) repeatedSfixed64AtIndex:(int32_t) index {
  return [result repeatedSfixed64AtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedSfixed64AtIndex:(int32_t) index withRepeatedSfixed64:(int64_t) value {
  [result.mutableRepeatedSfixed64List replaceObjectAtIndex:index withObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedSfixed64:(int64_t) value {
  if (result.mutableRepeatedSfixed64List == nil) {
    result.mutableRepeatedSfixed64List = [NSMutableArray array];
  }
  [result.mutableRepeatedSfixed64List addObject:[NSNumber numberWithLongLong:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedSfixed64:(NSArray*) values {
  if (result.mutableRepeatedSfixed64List == nil) {
    result.mutableRepeatedSfixed64List = [NSMutableArray array];
  }
  [result.mutableRepeatedSfixed64List addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedSfixed64List {
  result.mutableRepeatedSfixed64List = nil;
  return self;
}
- (NSArray*) repeatedFloatList {
  if (result.mutableRepeatedFloatList == nil) { return [NSArray array]; }
  return result.mutableRepeatedFloatList;
}
- (Float32) repeatedFloatAtIndex:(int32_t) index {
  return [result repeatedFloatAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedFloatAtIndex:(int32_t) index withRepeatedFloat:(Float32) value {
  [result.mutableRepeatedFloatList replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedFloat:(Float32) value {
  if (result.mutableRepeatedFloatList == nil) {
    result.mutableRepeatedFloatList = [NSMutableArray array];
  }
  [result.mutableRepeatedFloatList addObject:[NSNumber numberWithFloat:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedFloat:(NSArray*) values {
  if (result.mutableRepeatedFloatList == nil) {
    result.mutableRepeatedFloatList = [NSMutableArray array];
  }
  [result.mutableRepeatedFloatList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedFloatList {
  result.mutableRepeatedFloatList = nil;
  return self;
}
- (NSArray*) repeatedDoubleList {
  if (result.mutableRepeatedDoubleList == nil) { return [NSArray array]; }
  return result.mutableRepeatedDoubleList;
}
- (Float64) repeatedDoubleAtIndex:(int32_t) index {
  return [result repeatedDoubleAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedDoubleAtIndex:(int32_t) index withRepeatedDouble:(Float64) value {
  [result.mutableRepeatedDoubleList replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedDouble:(Float64) value {
  if (result.mutableRepeatedDoubleList == nil) {
    result.mutableRepeatedDoubleList = [NSMutableArray array];
  }
  [result.mutableRepeatedDoubleList addObject:[NSNumber numberWithDouble:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedDouble:(NSArray*) values {
  if (result.mutableRepeatedDoubleList == nil) {
    result.mutableRepeatedDoubleList = [NSMutableArray array];
  }
  [result.mutableRepeatedDoubleList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedDoubleList {
  result.mutableRepeatedDoubleList = nil;
  return self;
}
- (NSArray*) repeatedBoolList {
  if (result.mutableRepeatedBoolList == nil) { return [NSArray array]; }
  return result.mutableRepeatedBoolList;
}
- (BOOL) repeatedBoolAtIndex:(int32_t) index {
  return [result repeatedBoolAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedBoolAtIndex:(int32_t) index withRepeatedBool:(BOOL) value {
  [result.mutableRepeatedBoolList replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:value]];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedBool:(BOOL) value {
  if (result.mutableRepeatedBoolList == nil) {
    result.mutableRepeatedBoolList = [NSMutableArray array];
  }
  [result.mutableRepeatedBoolList addObject:[NSNumber numberWithBool:value]];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedBool:(NSArray*) values {
  if (result.mutableRepeatedBoolList == nil) {
    result.mutableRepeatedBoolList = [NSMutableArray array];
  }
  [result.mutableRepeatedBoolList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedBoolList {
  result.mutableRepeatedBoolList = nil;
  return self;
}
- (NSArray*) repeatedStringList {
  if (result.mutableRepeatedStringList == nil) { return [NSArray array]; }
  return result.mutableRepeatedStringList;
}
- (NSString*) repeatedStringAtIndex:(int32_t) index {
  return [result repeatedStringAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedStringAtIndex:(int32_t) index withRepeatedString:(NSString*) value {
  [result.mutableRepeatedStringList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedString:(NSString*) value {
  if (result.mutableRepeatedStringList == nil) {
    result.mutableRepeatedStringList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringList addObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedString:(NSArray*) values {
  if (result.mutableRepeatedStringList == nil) {
    result.mutableRepeatedStringList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedStringList {
  result.mutableRepeatedStringList = nil;
  return self;
}
- (NSArray*) repeatedBytesList {
  if (result.mutableRepeatedBytesList == nil) { return [NSArray array]; }
  return result.mutableRepeatedBytesList;
}
- (NSData*) repeatedBytesAtIndex:(int32_t) index {
  return [result repeatedBytesAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedBytesAtIndex:(int32_t) index withRepeatedBytes:(NSData*) value {
  [result.mutableRepeatedBytesList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedBytes:(NSData*) value {
  if (result.mutableRepeatedBytesList == nil) {
    result.mutableRepeatedBytesList = [NSMutableArray array];
  }
  [result.mutableRepeatedBytesList addObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedBytes:(NSArray*) values {
  if (result.mutableRepeatedBytesList == nil) {
    result.mutableRepeatedBytesList = [NSMutableArray array];
  }
  [result.mutableRepeatedBytesList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedBytesList {
  result.mutableRepeatedBytesList = nil;
  return self;
}
- (NSArray*) repeatedGroupList {
  if (result.mutableRepeatedGroupList == nil) { return [NSArray array]; }
  return result.mutableRepeatedGroupList;
}
- (TestAllTypes_RepeatedGroup*) repeatedGroupAtIndex:(int32_t) index {
  return [result repeatedGroupAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedGroupAtIndex:(int32_t) index withRepeatedGroup:(TestAllTypes_RepeatedGroup*) value {
  [result.mutableRepeatedGroupList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedGroup:(NSArray*) values {
  if (result.mutableRepeatedGroupList == nil) {
    result.mutableRepeatedGroupList = [NSMutableArray array];
  }
  [result.mutableRepeatedGroupList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedGroupList {
  result.mutableRepeatedGroupList = nil;
  return self;
}
- (TestAllTypes_Builder*) addRepeatedGroup:(TestAllTypes_RepeatedGroup*) value {
  if (result.mutableRepeatedGroupList == nil) {
    result.mutableRepeatedGroupList = [NSMutableArray array];
  }
  [result.mutableRepeatedGroupList addObject:value];
  return self;
}
- (NSArray*) repeatedNestedMessageList {
  if (result.mutableRepeatedNestedMessageList == nil) { return [NSArray array]; }
  return result.mutableRepeatedNestedMessageList;
}
- (TestAllTypes_NestedMessage*) repeatedNestedMessageAtIndex:(int32_t) index {
  return [result repeatedNestedMessageAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedNestedMessageAtIndex:(int32_t) index withRepeatedNestedMessage:(TestAllTypes_NestedMessage*) value {
  [result.mutableRepeatedNestedMessageList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedNestedMessage:(NSArray*) values {
  if (result.mutableRepeatedNestedMessageList == nil) {
    result.mutableRepeatedNestedMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedNestedMessageList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedNestedMessageList {
  result.mutableRepeatedNestedMessageList = nil;
  return self;
}
- (TestAllTypes_Builder*) addRepeatedNestedMessage:(TestAllTypes_NestedMessage*) value {
  if (result.mutableRepeatedNestedMessageList == nil) {
    result.mutableRepeatedNestedMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedNestedMessageList addObject:value];
  return self;
}
- (NSArray*) repeatedForeignMessageList {
  if (result.mutableRepeatedForeignMessageList == nil) { return [NSArray array]; }
  return result.mutableRepeatedForeignMessageList;
}
- (ForeignMessage*) repeatedForeignMessageAtIndex:(int32_t) index {
  return [result repeatedForeignMessageAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedForeignMessageAtIndex:(int32_t) index withRepeatedForeignMessage:(ForeignMessage*) value {
  [result.mutableRepeatedForeignMessageList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedForeignMessage:(NSArray*) values {
  if (result.mutableRepeatedForeignMessageList == nil) {
    result.mutableRepeatedForeignMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedForeignMessageList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedForeignMessageList {
  result.mutableRepeatedForeignMessageList = nil;
  return self;
}
- (TestAllTypes_Builder*) addRepeatedForeignMessage:(ForeignMessage*) value {
  if (result.mutableRepeatedForeignMessageList == nil) {
    result.mutableRepeatedForeignMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedForeignMessageList addObject:value];
  return self;
}
- (NSArray*) repeatedImportMessageList {
  if (result.mutableRepeatedImportMessageList == nil) { return [NSArray array]; }
  return result.mutableRepeatedImportMessageList;
}
- (ImportMessage*) repeatedImportMessageAtIndex:(int32_t) index {
  return [result repeatedImportMessageAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedImportMessageAtIndex:(int32_t) index withRepeatedImportMessage:(ImportMessage*) value {
  [result.mutableRepeatedImportMessageList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedImportMessage:(NSArray*) values {
  if (result.mutableRepeatedImportMessageList == nil) {
    result.mutableRepeatedImportMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedImportMessageList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedImportMessageList {
  result.mutableRepeatedImportMessageList = nil;
  return self;
}
- (TestAllTypes_Builder*) addRepeatedImportMessage:(ImportMessage*) value {
  if (result.mutableRepeatedImportMessageList == nil) {
    result.mutableRepeatedImportMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedImportMessageList addObject:value];
  return self;
}
- (NSArray*) repeatedNestedEnumList {
  return result.mutableRepeatedNestedEnumList;
}
- (TestAllTypes_NestedEnum*) repeatedNestedEnumAtIndex:(int32_t) index {
  return [result repeatedNestedEnumAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedNestedEnumAtIndex:(int32_t) index withRepeatedNestedEnum:(TestAllTypes_NestedEnum*) value {
  [result.mutableRepeatedNestedEnumList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedNestedEnum:(TestAllTypes_NestedEnum*) value {
  if (result.mutableRepeatedNestedEnumList == nil) {
    result.mutableRepeatedNestedEnumList = [NSMutableArray array];
  }
  [result.mutableRepeatedNestedEnumList addObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedNestedEnum:(NSArray*) values {
  if (result.mutableRepeatedNestedEnumList == nil) {
    result.mutableRepeatedNestedEnumList = [NSMutableArray array];
  }
  [result.mutableRepeatedNestedEnumList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedNestedEnumList {
  result.mutableRepeatedNestedEnumList = nil;
  return self;
}
- (NSArray*) repeatedForeignEnumList {
  return result.mutableRepeatedForeignEnumList;
}
- (ForeignEnum*) repeatedForeignEnumAtIndex:(int32_t) index {
  return [result repeatedForeignEnumAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedForeignEnumAtIndex:(int32_t) index withRepeatedForeignEnum:(ForeignEnum*) value {
  [result.mutableRepeatedForeignEnumList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedForeignEnum:(ForeignEnum*) value {
  if (result.mutableRepeatedForeignEnumList == nil) {
    result.mutableRepeatedForeignEnumList = [NSMutableArray array];
  }
  [result.mutableRepeatedForeignEnumList addObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedForeignEnum:(NSArray*) values {
  if (result.mutableRepeatedForeignEnumList == nil) {
    result.mutableRepeatedForeignEnumList = [NSMutableArray array];
  }
  [result.mutableRepeatedForeignEnumList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedForeignEnumList {
  result.mutableRepeatedForeignEnumList = nil;
  return self;
}
- (NSArray*) repeatedImportEnumList {
  return result.mutableRepeatedImportEnumList;
}
- (ImportEnum*) repeatedImportEnumAtIndex:(int32_t) index {
  return [result repeatedImportEnumAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedImportEnumAtIndex:(int32_t) index withRepeatedImportEnum:(ImportEnum*) value {
  [result.mutableRepeatedImportEnumList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedImportEnum:(ImportEnum*) value {
  if (result.mutableRepeatedImportEnumList == nil) {
    result.mutableRepeatedImportEnumList = [NSMutableArray array];
  }
  [result.mutableRepeatedImportEnumList addObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedImportEnum:(NSArray*) values {
  if (result.mutableRepeatedImportEnumList == nil) {
    result.mutableRepeatedImportEnumList = [NSMutableArray array];
  }
  [result.mutableRepeatedImportEnumList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedImportEnumList {
  result.mutableRepeatedImportEnumList = nil;
  return self;
}
- (NSArray*) repeatedStringPieceList {
  if (result.mutableRepeatedStringPieceList == nil) { return [NSArray array]; }
  return result.mutableRepeatedStringPieceList;
}
- (NSString*) repeatedStringPieceAtIndex:(int32_t) index {
  return [result repeatedStringPieceAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedStringPieceAtIndex:(int32_t) index withRepeatedStringPiece:(NSString*) value {
  [result.mutableRepeatedStringPieceList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedStringPiece:(NSString*) value {
  if (result.mutableRepeatedStringPieceList == nil) {
    result.mutableRepeatedStringPieceList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringPieceList addObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedStringPiece:(NSArray*) values {
  if (result.mutableRepeatedStringPieceList == nil) {
    result.mutableRepeatedStringPieceList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringPieceList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedStringPieceList {
  result.mutableRepeatedStringPieceList = nil;
  return self;
}
- (NSArray*) repeatedCordList {
  if (result.mutableRepeatedCordList == nil) { return [NSArray array]; }
  return result.mutableRepeatedCordList;
}
- (NSString*) repeatedCordAtIndex:(int32_t) index {
  return [result repeatedCordAtIndex:index];
}
- (TestAllTypes_Builder*) replaceRepeatedCordAtIndex:(int32_t) index withRepeatedCord:(NSString*) value {
  [result.mutableRepeatedCordList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestAllTypes_Builder*) addRepeatedCord:(NSString*) value {
  if (result.mutableRepeatedCordList == nil) {
    result.mutableRepeatedCordList = [NSMutableArray array];
  }
  [result.mutableRepeatedCordList addObject:value];
  return self;
}
- (TestAllTypes_Builder*) addAllRepeatedCord:(NSArray*) values {
  if (result.mutableRepeatedCordList == nil) {
    result.mutableRepeatedCordList = [NSMutableArray array];
  }
  [result.mutableRepeatedCordList addObjectsFromArray:values];
  return self;
}
- (TestAllTypes_Builder*) clearRepeatedCordList {
  result.mutableRepeatedCordList = nil;
  return self;
}
- (BOOL) hasDefaultInt32 {
  return result.hasDefaultInt32;
}
- (int32_t) defaultInt32 {
  return result.defaultInt32;
}
- (TestAllTypes_Builder*) setDefaultInt32:(int32_t) value {
  result.hasDefaultInt32 = YES;
  result.defaultInt32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultInt32 {
  result.hasDefaultInt32 = NO;
  result.defaultInt32 = 41;
  return self;
}
- (BOOL) hasDefaultInt64 {
  return result.hasDefaultInt64;
}
- (int64_t) defaultInt64 {
  return result.defaultInt64;
}
- (TestAllTypes_Builder*) setDefaultInt64:(int64_t) value {
  result.hasDefaultInt64 = YES;
  result.defaultInt64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultInt64 {
  result.hasDefaultInt64 = NO;
  result.defaultInt64 = 42L;
  return self;
}
- (BOOL) hasDefaultUint32 {
  return result.hasDefaultUint32;
}
- (int32_t) defaultUint32 {
  return result.defaultUint32;
}
- (TestAllTypes_Builder*) setDefaultUint32:(int32_t) value {
  result.hasDefaultUint32 = YES;
  result.defaultUint32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultUint32 {
  result.hasDefaultUint32 = NO;
  result.defaultUint32 = 43;
  return self;
}
- (BOOL) hasDefaultUint64 {
  return result.hasDefaultUint64;
}
- (int64_t) defaultUint64 {
  return result.defaultUint64;
}
- (TestAllTypes_Builder*) setDefaultUint64:(int64_t) value {
  result.hasDefaultUint64 = YES;
  result.defaultUint64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultUint64 {
  result.hasDefaultUint64 = NO;
  result.defaultUint64 = 44L;
  return self;
}
- (BOOL) hasDefaultSint32 {
  return result.hasDefaultSint32;
}
- (int32_t) defaultSint32 {
  return result.defaultSint32;
}
- (TestAllTypes_Builder*) setDefaultSint32:(int32_t) value {
  result.hasDefaultSint32 = YES;
  result.defaultSint32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultSint32 {
  result.hasDefaultSint32 = NO;
  result.defaultSint32 = -45;
  return self;
}
- (BOOL) hasDefaultSint64 {
  return result.hasDefaultSint64;
}
- (int64_t) defaultSint64 {
  return result.defaultSint64;
}
- (TestAllTypes_Builder*) setDefaultSint64:(int64_t) value {
  result.hasDefaultSint64 = YES;
  result.defaultSint64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultSint64 {
  result.hasDefaultSint64 = NO;
  result.defaultSint64 = 46L;
  return self;
}
- (BOOL) hasDefaultFixed32 {
  return result.hasDefaultFixed32;
}
- (int32_t) defaultFixed32 {
  return result.defaultFixed32;
}
- (TestAllTypes_Builder*) setDefaultFixed32:(int32_t) value {
  result.hasDefaultFixed32 = YES;
  result.defaultFixed32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultFixed32 {
  result.hasDefaultFixed32 = NO;
  result.defaultFixed32 = 47;
  return self;
}
- (BOOL) hasDefaultFixed64 {
  return result.hasDefaultFixed64;
}
- (int64_t) defaultFixed64 {
  return result.defaultFixed64;
}
- (TestAllTypes_Builder*) setDefaultFixed64:(int64_t) value {
  result.hasDefaultFixed64 = YES;
  result.defaultFixed64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultFixed64 {
  result.hasDefaultFixed64 = NO;
  result.defaultFixed64 = 48L;
  return self;
}
- (BOOL) hasDefaultSfixed32 {
  return result.hasDefaultSfixed32;
}
- (int32_t) defaultSfixed32 {
  return result.defaultSfixed32;
}
- (TestAllTypes_Builder*) setDefaultSfixed32:(int32_t) value {
  result.hasDefaultSfixed32 = YES;
  result.defaultSfixed32 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultSfixed32 {
  result.hasDefaultSfixed32 = NO;
  result.defaultSfixed32 = 49;
  return self;
}
- (BOOL) hasDefaultSfixed64 {
  return result.hasDefaultSfixed64;
}
- (int64_t) defaultSfixed64 {
  return result.defaultSfixed64;
}
- (TestAllTypes_Builder*) setDefaultSfixed64:(int64_t) value {
  result.hasDefaultSfixed64 = YES;
  result.defaultSfixed64 = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultSfixed64 {
  result.hasDefaultSfixed64 = NO;
  result.defaultSfixed64 = -50L;
  return self;
}
- (BOOL) hasDefaultFloat {
  return result.hasDefaultFloat;
}
- (Float32) defaultFloat {
  return result.defaultFloat;
}
- (TestAllTypes_Builder*) setDefaultFloat:(Float32) value {
  result.hasDefaultFloat = YES;
  result.defaultFloat = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultFloat {
  result.hasDefaultFloat = NO;
  result.defaultFloat = 51.5;
  return self;
}
- (BOOL) hasDefaultDouble {
  return result.hasDefaultDouble;
}
- (Float64) defaultDouble {
  return result.defaultDouble;
}
- (TestAllTypes_Builder*) setDefaultDouble:(Float64) value {
  result.hasDefaultDouble = YES;
  result.defaultDouble = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultDouble {
  result.hasDefaultDouble = NO;
  result.defaultDouble = 52000;
  return self;
}
- (BOOL) hasDefaultBool {
  return result.hasDefaultBool;
}
- (BOOL) defaultBool {
  return result.defaultBool;
}
- (TestAllTypes_Builder*) setDefaultBool:(BOOL) value {
  result.hasDefaultBool = YES;
  result.defaultBool = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultBool {
  result.hasDefaultBool = NO;
  result.defaultBool = YES;
  return self;
}
- (BOOL) hasDefaultString {
  return result.hasDefaultString;
}
- (NSString*) defaultString {
  return result.defaultString;
}
- (TestAllTypes_Builder*) setDefaultString:(NSString*) value {
  result.hasDefaultString = YES;
  result.defaultString = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultString {
  result.hasDefaultString = NO;
  result.defaultString = @"hello";
  return self;
}
- (BOOL) hasDefaultBytes {
  return result.hasDefaultBytes;
}
- (NSData*) defaultBytes {
  return result.defaultBytes;
}
- (TestAllTypes_Builder*) setDefaultBytes:(NSData*) value {
  result.hasDefaultBytes = YES;
  result.defaultBytes = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultBytes {
  result.hasDefaultBytes = NO;
  result.defaultBytes = ([((PBFieldDescriptor*)[[TestAllTypes descriptor].fields objectAtIndex:62]) defaultValue]);
  return self;
}
- (BOOL) hasDefaultNestedEnum {
  return result.hasDefaultNestedEnum;
}
- (TestAllTypes_NestedEnum*) defaultNestedEnum {
  return result.defaultNestedEnum;
}
- (TestAllTypes_Builder*) setDefaultNestedEnum:(TestAllTypes_NestedEnum*) value {
  result.hasDefaultNestedEnum = YES;
  result.defaultNestedEnum = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultNestedEnum {
  result.hasDefaultNestedEnum = NO;
  result.defaultNestedEnum = [TestAllTypes_NestedEnum BAR];
  return self;
}
- (BOOL) hasDefaultForeignEnum {
  return result.hasDefaultForeignEnum;
}
- (ForeignEnum*) defaultForeignEnum {
  return result.defaultForeignEnum;
}
- (TestAllTypes_Builder*) setDefaultForeignEnum:(ForeignEnum*) value {
  result.hasDefaultForeignEnum = YES;
  result.defaultForeignEnum = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultForeignEnum {
  result.hasDefaultForeignEnum = NO;
  result.defaultForeignEnum = [ForeignEnum FOREIGN_BAR];
  return self;
}
- (BOOL) hasDefaultImportEnum {
  return result.hasDefaultImportEnum;
}
- (ImportEnum*) defaultImportEnum {
  return result.defaultImportEnum;
}
- (TestAllTypes_Builder*) setDefaultImportEnum:(ImportEnum*) value {
  result.hasDefaultImportEnum = YES;
  result.defaultImportEnum = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultImportEnum {
  result.hasDefaultImportEnum = NO;
  result.defaultImportEnum = [ImportEnum IMPORT_BAR];
  return self;
}
- (BOOL) hasDefaultStringPiece {
  return result.hasDefaultStringPiece;
}
- (NSString*) defaultStringPiece {
  return result.defaultStringPiece;
}
- (TestAllTypes_Builder*) setDefaultStringPiece:(NSString*) value {
  result.hasDefaultStringPiece = YES;
  result.defaultStringPiece = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultStringPiece {
  result.hasDefaultStringPiece = NO;
  result.defaultStringPiece = @"abc";
  return self;
}
- (BOOL) hasDefaultCord {
  return result.hasDefaultCord;
}
- (NSString*) defaultCord {
  return result.defaultCord;
}
- (TestAllTypes_Builder*) setDefaultCord:(NSString*) value {
  result.hasDefaultCord = YES;
  result.defaultCord = value;
  return self;
}
- (TestAllTypes_Builder*) clearDefaultCord {
  result.hasDefaultCord = NO;
  result.defaultCord = @"123";
  return self;
}
@end

@interface ForeignMessage ()
@property BOOL hasC;
@property int32_t c;
@end

@implementation ForeignMessage

@synthesize hasC;
@synthesize c;
- (void) dealloc {
  self.hasC = NO;
  self.c = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.c = 0;
  }
  return self;
}
static ForeignMessage* defaultForeignMessageInstance = nil;
+ (void) initialize {
  if (self == [ForeignMessage class]) {
    defaultForeignMessageInstance = [[ForeignMessage alloc] init];
  }
}
+ (ForeignMessage*) defaultInstance {
  return defaultForeignMessageInstance;
}
- (ForeignMessage*) defaultInstance {
  return defaultForeignMessageInstance;
}
- (PBDescriptor*) descriptor {
  return [ForeignMessage descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_ForeignMessage_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_ForeignMessage_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasC) {
    [output writeInt32:1 value:self.c];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasC) {
    size += computeInt32Size(1, self.c);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (ForeignMessage*) parseFromData:(NSData*) data {
  return (ForeignMessage*)[[[ForeignMessage_Builder builder] mergeFromData:data] build];
}
+ (ForeignMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ForeignMessage*)[[[ForeignMessage_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (ForeignMessage*) parseFromInputStream:(NSInputStream*) input {
  return (ForeignMessage*)[[[ForeignMessage_Builder builder] mergeFromInputStream:input] build];
}
+ (ForeignMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ForeignMessage*)[[[ForeignMessage_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ForeignMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (ForeignMessage*)[[[ForeignMessage_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (ForeignMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ForeignMessage*)[[[ForeignMessage_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (ForeignMessage_Builder*) createBuilder {
  return [ForeignMessage_Builder builder];
}
@end

@implementation ForeignMessage_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[ForeignMessage alloc] init] autorelease];
  }
  return self;
}
+ (ForeignMessage_Builder*) builder {
  return [[[ForeignMessage_Builder alloc] init] autorelease];
}
+ (ForeignMessage_Builder*) builderWithPrototype:(ForeignMessage*) prototype {
  return [[ForeignMessage_Builder builder] mergeFromForeignMessage:prototype];
}
- (ForeignMessage*) internalGetResult {
  return result;
}
- (ForeignMessage_Builder*) clear {
  self.result = [[[ForeignMessage alloc] init] autorelease];
  return self;
}
- (ForeignMessage_Builder*) clone {
  return [ForeignMessage_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [ForeignMessage descriptor];
}
- (ForeignMessage*) defaultInstance {
  return [ForeignMessage defaultInstance];
}
- (ForeignMessage*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (ForeignMessage*) buildPartial {
  ForeignMessage* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (ForeignMessage_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[ForeignMessage class]]) {
    return [self mergeFromForeignMessage:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (ForeignMessage_Builder*) mergeFromForeignMessage:(ForeignMessage*) other {
  if (other == [ForeignMessage defaultInstance]) return self;
  if (other.hasC) {
    [self setC:other.c];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (ForeignMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (ForeignMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setC:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasC {
  return result.hasC;
}
- (int32_t) c {
  return result.c;
}
- (ForeignMessage_Builder*) setC:(int32_t) value {
  result.hasC = YES;
  result.c = value;
  return self;
}
- (ForeignMessage_Builder*) clearC {
  result.hasC = NO;
  result.c = 0;
  return self;
}
@end

@interface TestAllExtensions ()
@end

@implementation TestAllExtensions

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static TestAllExtensions* defaultTestAllExtensionsInstance = nil;
+ (void) initialize {
  if (self == [TestAllExtensions class]) {
    defaultTestAllExtensionsInstance = [[TestAllExtensions alloc] init];
  }
}
+ (TestAllExtensions*) defaultInstance {
  return defaultTestAllExtensionsInstance;
}
- (TestAllExtensions*) defaultInstance {
  return defaultTestAllExtensionsInstance;
}
- (PBDescriptor*) descriptor {
  return [TestAllExtensions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllExtensions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestAllExtensions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  if (!self.extensionsAreInitialized) return false;
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  PBExtensionWriter* extensionWriter = [PBExtensionWriter writerWithExtensions:self.extensions];
  [extensionWriter writeUntil:536870912 output:output];
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += [self extensionsSerializedSize];
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestAllExtensions*) parseFromData:(NSData*) data {
  return (TestAllExtensions*)[[[TestAllExtensions_Builder builder] mergeFromData:data] build];
}
+ (TestAllExtensions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllExtensions*)[[[TestAllExtensions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestAllExtensions*) parseFromInputStream:(NSInputStream*) input {
  return (TestAllExtensions*)[[[TestAllExtensions_Builder builder] mergeFromInputStream:input] build];
}
+ (TestAllExtensions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllExtensions*)[[[TestAllExtensions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestAllExtensions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestAllExtensions*)[[[TestAllExtensions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestAllExtensions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestAllExtensions*)[[[TestAllExtensions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestAllExtensions_Builder*) createBuilder {
  return [TestAllExtensions_Builder builder];
}
@end

@implementation TestAllExtensions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestAllExtensions alloc] init] autorelease];
  }
  return self;
}
+ (TestAllExtensions_Builder*) builder {
  return [[[TestAllExtensions_Builder alloc] init] autorelease];
}
+ (TestAllExtensions_Builder*) builderWithPrototype:(TestAllExtensions*) prototype {
  return [[TestAllExtensions_Builder builder] mergeFromTestAllExtensions:prototype];
}
- (TestAllExtensions*) internalGetResult {
  return result;
}
- (TestAllExtensions_Builder*) clear {
  self.result = [[[TestAllExtensions alloc] init] autorelease];
  return self;
}
- (TestAllExtensions_Builder*) clone {
  return [TestAllExtensions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestAllExtensions descriptor];
}
- (TestAllExtensions*) defaultInstance {
  return [TestAllExtensions defaultInstance];
}
- (TestAllExtensions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestAllExtensions*) buildPartial {
  TestAllExtensions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestAllExtensions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestAllExtensions class]]) {
    return [self mergeFromTestAllExtensions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestAllExtensions_Builder*) mergeFromTestAllExtensions:(TestAllExtensions*) other {
  if (other == [TestAllExtensions defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestAllExtensions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestAllExtensions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface OptionalGroup_extension ()
@property BOOL hasA;
@property int32_t a;
@end

@implementation OptionalGroup_extension

@synthesize hasA;
@synthesize a;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
  }
  return self;
}
static OptionalGroup_extension* defaultOptionalGroup_extensionInstance = nil;
+ (void) initialize {
  if (self == [OptionalGroup_extension class]) {
    defaultOptionalGroup_extensionInstance = [[OptionalGroup_extension alloc] init];
  }
}
+ (OptionalGroup_extension*) defaultInstance {
  return defaultOptionalGroup_extensionInstance;
}
- (OptionalGroup_extension*) defaultInstance {
  return defaultOptionalGroup_extensionInstance;
}
- (PBDescriptor*) descriptor {
  return [OptionalGroup_extension descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_OptionalGroup_extension_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_OptionalGroup_extension_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:17 value:self.a];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(17, self.a);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (OptionalGroup_extension*) parseFromData:(NSData*) data {
  return (OptionalGroup_extension*)[[[OptionalGroup_extension_Builder builder] mergeFromData:data] build];
}
+ (OptionalGroup_extension*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (OptionalGroup_extension*)[[[OptionalGroup_extension_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (OptionalGroup_extension*) parseFromInputStream:(NSInputStream*) input {
  return (OptionalGroup_extension*)[[[OptionalGroup_extension_Builder builder] mergeFromInputStream:input] build];
}
+ (OptionalGroup_extension*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (OptionalGroup_extension*)[[[OptionalGroup_extension_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (OptionalGroup_extension*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (OptionalGroup_extension*)[[[OptionalGroup_extension_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (OptionalGroup_extension*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (OptionalGroup_extension*)[[[OptionalGroup_extension_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (OptionalGroup_extension_Builder*) createBuilder {
  return [OptionalGroup_extension_Builder builder];
}
@end

@implementation OptionalGroup_extension_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[OptionalGroup_extension alloc] init] autorelease];
  }
  return self;
}
+ (OptionalGroup_extension_Builder*) builder {
  return [[[OptionalGroup_extension_Builder alloc] init] autorelease];
}
+ (OptionalGroup_extension_Builder*) builderWithPrototype:(OptionalGroup_extension*) prototype {
  return [[OptionalGroup_extension_Builder builder] mergeFromOptionalGroup_extension:prototype];
}
- (OptionalGroup_extension*) internalGetResult {
  return result;
}
- (OptionalGroup_extension_Builder*) clear {
  self.result = [[[OptionalGroup_extension alloc] init] autorelease];
  return self;
}
- (OptionalGroup_extension_Builder*) clone {
  return [OptionalGroup_extension_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [OptionalGroup_extension descriptor];
}
- (OptionalGroup_extension*) defaultInstance {
  return [OptionalGroup_extension defaultInstance];
}
- (OptionalGroup_extension*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (OptionalGroup_extension*) buildPartial {
  OptionalGroup_extension* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (OptionalGroup_extension_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[OptionalGroup_extension class]]) {
    return [self mergeFromOptionalGroup_extension:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (OptionalGroup_extension_Builder*) mergeFromOptionalGroup_extension:(OptionalGroup_extension*) other {
  if (other == [OptionalGroup_extension defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (OptionalGroup_extension_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (OptionalGroup_extension_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 136: {
        [self setA:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (OptionalGroup_extension_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (OptionalGroup_extension_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
@end

@interface RepeatedGroup_extension ()
@property BOOL hasA;
@property int32_t a;
@end

@implementation RepeatedGroup_extension

@synthesize hasA;
@synthesize a;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
  }
  return self;
}
static RepeatedGroup_extension* defaultRepeatedGroup_extensionInstance = nil;
+ (void) initialize {
  if (self == [RepeatedGroup_extension class]) {
    defaultRepeatedGroup_extensionInstance = [[RepeatedGroup_extension alloc] init];
  }
}
+ (RepeatedGroup_extension*) defaultInstance {
  return defaultRepeatedGroup_extensionInstance;
}
- (RepeatedGroup_extension*) defaultInstance {
  return defaultRepeatedGroup_extensionInstance;
}
- (PBDescriptor*) descriptor {
  return [RepeatedGroup_extension descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_RepeatedGroup_extension_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_RepeatedGroup_extension_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:47 value:self.a];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(47, self.a);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (RepeatedGroup_extension*) parseFromData:(NSData*) data {
  return (RepeatedGroup_extension*)[[[RepeatedGroup_extension_Builder builder] mergeFromData:data] build];
}
+ (RepeatedGroup_extension*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RepeatedGroup_extension*)[[[RepeatedGroup_extension_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (RepeatedGroup_extension*) parseFromInputStream:(NSInputStream*) input {
  return (RepeatedGroup_extension*)[[[RepeatedGroup_extension_Builder builder] mergeFromInputStream:input] build];
}
+ (RepeatedGroup_extension*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RepeatedGroup_extension*)[[[RepeatedGroup_extension_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (RepeatedGroup_extension*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (RepeatedGroup_extension*)[[[RepeatedGroup_extension_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (RepeatedGroup_extension*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (RepeatedGroup_extension*)[[[RepeatedGroup_extension_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (RepeatedGroup_extension_Builder*) createBuilder {
  return [RepeatedGroup_extension_Builder builder];
}
@end

@implementation RepeatedGroup_extension_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[RepeatedGroup_extension alloc] init] autorelease];
  }
  return self;
}
+ (RepeatedGroup_extension_Builder*) builder {
  return [[[RepeatedGroup_extension_Builder alloc] init] autorelease];
}
+ (RepeatedGroup_extension_Builder*) builderWithPrototype:(RepeatedGroup_extension*) prototype {
  return [[RepeatedGroup_extension_Builder builder] mergeFromRepeatedGroup_extension:prototype];
}
- (RepeatedGroup_extension*) internalGetResult {
  return result;
}
- (RepeatedGroup_extension_Builder*) clear {
  self.result = [[[RepeatedGroup_extension alloc] init] autorelease];
  return self;
}
- (RepeatedGroup_extension_Builder*) clone {
  return [RepeatedGroup_extension_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [RepeatedGroup_extension descriptor];
}
- (RepeatedGroup_extension*) defaultInstance {
  return [RepeatedGroup_extension defaultInstance];
}
- (RepeatedGroup_extension*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (RepeatedGroup_extension*) buildPartial {
  RepeatedGroup_extension* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (RepeatedGroup_extension_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[RepeatedGroup_extension class]]) {
    return [self mergeFromRepeatedGroup_extension:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (RepeatedGroup_extension_Builder*) mergeFromRepeatedGroup_extension:(RepeatedGroup_extension*) other {
  if (other == [RepeatedGroup_extension defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (RepeatedGroup_extension_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (RepeatedGroup_extension_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 376: {
        [self setA:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (RepeatedGroup_extension_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (RepeatedGroup_extension_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
@end

@interface TestRequired ()
@property BOOL hasA;
@property int32_t a;
@property BOOL hasDummy2;
@property int32_t dummy2;
@property BOOL hasB;
@property int32_t b;
@property BOOL hasDummy4;
@property int32_t dummy4;
@property BOOL hasDummy5;
@property int32_t dummy5;
@property BOOL hasDummy6;
@property int32_t dummy6;
@property BOOL hasDummy7;
@property int32_t dummy7;
@property BOOL hasDummy8;
@property int32_t dummy8;
@property BOOL hasDummy9;
@property int32_t dummy9;
@property BOOL hasDummy10;
@property int32_t dummy10;
@property BOOL hasDummy11;
@property int32_t dummy11;
@property BOOL hasDummy12;
@property int32_t dummy12;
@property BOOL hasDummy13;
@property int32_t dummy13;
@property BOOL hasDummy14;
@property int32_t dummy14;
@property BOOL hasDummy15;
@property int32_t dummy15;
@property BOOL hasDummy16;
@property int32_t dummy16;
@property BOOL hasDummy17;
@property int32_t dummy17;
@property BOOL hasDummy18;
@property int32_t dummy18;
@property BOOL hasDummy19;
@property int32_t dummy19;
@property BOOL hasDummy20;
@property int32_t dummy20;
@property BOOL hasDummy21;
@property int32_t dummy21;
@property BOOL hasDummy22;
@property int32_t dummy22;
@property BOOL hasDummy23;
@property int32_t dummy23;
@property BOOL hasDummy24;
@property int32_t dummy24;
@property BOOL hasDummy25;
@property int32_t dummy25;
@property BOOL hasDummy26;
@property int32_t dummy26;
@property BOOL hasDummy27;
@property int32_t dummy27;
@property BOOL hasDummy28;
@property int32_t dummy28;
@property BOOL hasDummy29;
@property int32_t dummy29;
@property BOOL hasDummy30;
@property int32_t dummy30;
@property BOOL hasDummy31;
@property int32_t dummy31;
@property BOOL hasDummy32;
@property int32_t dummy32;
@property BOOL hasC;
@property int32_t c;
@end

@implementation TestRequired

@synthesize hasA;
@synthesize a;
@synthesize hasDummy2;
@synthesize dummy2;
@synthesize hasB;
@synthesize b;
@synthesize hasDummy4;
@synthesize dummy4;
@synthesize hasDummy5;
@synthesize dummy5;
@synthesize hasDummy6;
@synthesize dummy6;
@synthesize hasDummy7;
@synthesize dummy7;
@synthesize hasDummy8;
@synthesize dummy8;
@synthesize hasDummy9;
@synthesize dummy9;
@synthesize hasDummy10;
@synthesize dummy10;
@synthesize hasDummy11;
@synthesize dummy11;
@synthesize hasDummy12;
@synthesize dummy12;
@synthesize hasDummy13;
@synthesize dummy13;
@synthesize hasDummy14;
@synthesize dummy14;
@synthesize hasDummy15;
@synthesize dummy15;
@synthesize hasDummy16;
@synthesize dummy16;
@synthesize hasDummy17;
@synthesize dummy17;
@synthesize hasDummy18;
@synthesize dummy18;
@synthesize hasDummy19;
@synthesize dummy19;
@synthesize hasDummy20;
@synthesize dummy20;
@synthesize hasDummy21;
@synthesize dummy21;
@synthesize hasDummy22;
@synthesize dummy22;
@synthesize hasDummy23;
@synthesize dummy23;
@synthesize hasDummy24;
@synthesize dummy24;
@synthesize hasDummy25;
@synthesize dummy25;
@synthesize hasDummy26;
@synthesize dummy26;
@synthesize hasDummy27;
@synthesize dummy27;
@synthesize hasDummy28;
@synthesize dummy28;
@synthesize hasDummy29;
@synthesize dummy29;
@synthesize hasDummy30;
@synthesize dummy30;
@synthesize hasDummy31;
@synthesize dummy31;
@synthesize hasDummy32;
@synthesize dummy32;
@synthesize hasC;
@synthesize c;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  self.hasDummy2 = NO;
  self.dummy2 = 0;
  self.hasB = NO;
  self.b = 0;
  self.hasDummy4 = NO;
  self.dummy4 = 0;
  self.hasDummy5 = NO;
  self.dummy5 = 0;
  self.hasDummy6 = NO;
  self.dummy6 = 0;
  self.hasDummy7 = NO;
  self.dummy7 = 0;
  self.hasDummy8 = NO;
  self.dummy8 = 0;
  self.hasDummy9 = NO;
  self.dummy9 = 0;
  self.hasDummy10 = NO;
  self.dummy10 = 0;
  self.hasDummy11 = NO;
  self.dummy11 = 0;
  self.hasDummy12 = NO;
  self.dummy12 = 0;
  self.hasDummy13 = NO;
  self.dummy13 = 0;
  self.hasDummy14 = NO;
  self.dummy14 = 0;
  self.hasDummy15 = NO;
  self.dummy15 = 0;
  self.hasDummy16 = NO;
  self.dummy16 = 0;
  self.hasDummy17 = NO;
  self.dummy17 = 0;
  self.hasDummy18 = NO;
  self.dummy18 = 0;
  self.hasDummy19 = NO;
  self.dummy19 = 0;
  self.hasDummy20 = NO;
  self.dummy20 = 0;
  self.hasDummy21 = NO;
  self.dummy21 = 0;
  self.hasDummy22 = NO;
  self.dummy22 = 0;
  self.hasDummy23 = NO;
  self.dummy23 = 0;
  self.hasDummy24 = NO;
  self.dummy24 = 0;
  self.hasDummy25 = NO;
  self.dummy25 = 0;
  self.hasDummy26 = NO;
  self.dummy26 = 0;
  self.hasDummy27 = NO;
  self.dummy27 = 0;
  self.hasDummy28 = NO;
  self.dummy28 = 0;
  self.hasDummy29 = NO;
  self.dummy29 = 0;
  self.hasDummy30 = NO;
  self.dummy30 = 0;
  self.hasDummy31 = NO;
  self.dummy31 = 0;
  self.hasDummy32 = NO;
  self.dummy32 = 0;
  self.hasC = NO;
  self.c = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
    self.dummy2 = 0;
    self.b = 0;
    self.dummy4 = 0;
    self.dummy5 = 0;
    self.dummy6 = 0;
    self.dummy7 = 0;
    self.dummy8 = 0;
    self.dummy9 = 0;
    self.dummy10 = 0;
    self.dummy11 = 0;
    self.dummy12 = 0;
    self.dummy13 = 0;
    self.dummy14 = 0;
    self.dummy15 = 0;
    self.dummy16 = 0;
    self.dummy17 = 0;
    self.dummy18 = 0;
    self.dummy19 = 0;
    self.dummy20 = 0;
    self.dummy21 = 0;
    self.dummy22 = 0;
    self.dummy23 = 0;
    self.dummy24 = 0;
    self.dummy25 = 0;
    self.dummy26 = 0;
    self.dummy27 = 0;
    self.dummy28 = 0;
    self.dummy29 = 0;
    self.dummy30 = 0;
    self.dummy31 = 0;
    self.dummy32 = 0;
    self.c = 0;
  }
  return self;
}
static PBGeneratedExtension* TestRequired_single = nil;
static PBGeneratedExtension* TestRequired_multi = nil;
+ (PBGeneratedExtension*) single {
  return TestRequired_single;
}
+ (PBGeneratedExtension*) multi {
  return TestRequired_multi;
}
static TestRequired* defaultTestRequiredInstance = nil;
+ (void) initialize {
  if (self == [TestRequired class]) {
    defaultTestRequiredInstance = [[TestRequired alloc] init];
     TestRequired_single = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:0]
                                                       type:[TestRequired class]] retain];
     TestRequired_multi = [[PBGeneratedExtension extensionWithDescriptor:[[self descriptor].extensions objectAtIndex:1]
                                                       type:[TestRequired class]] retain];
  }
}
+ (TestRequired*) defaultInstance {
  return defaultTestRequiredInstance;
}
- (TestRequired*) defaultInstance {
  return defaultTestRequiredInstance;
}
- (PBDescriptor*) descriptor {
  return [TestRequired descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestRequired_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestRequired_fieldAccessorTable];
}
- (BOOL) isInitialized {
  if (!self.hasA) return false;
  if (!self.hasB) return false;
  if (!self.hasC) return false;
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:1 value:self.a];
  }
  if (hasDummy2) {
    [output writeInt32:2 value:self.dummy2];
  }
  if (hasB) {
    [output writeInt32:3 value:self.b];
  }
  if (hasDummy4) {
    [output writeInt32:4 value:self.dummy4];
  }
  if (hasDummy5) {
    [output writeInt32:5 value:self.dummy5];
  }
  if (hasDummy6) {
    [output writeInt32:6 value:self.dummy6];
  }
  if (hasDummy7) {
    [output writeInt32:7 value:self.dummy7];
  }
  if (hasDummy8) {
    [output writeInt32:8 value:self.dummy8];
  }
  if (hasDummy9) {
    [output writeInt32:9 value:self.dummy9];
  }
  if (hasDummy10) {
    [output writeInt32:10 value:self.dummy10];
  }
  if (hasDummy11) {
    [output writeInt32:11 value:self.dummy11];
  }
  if (hasDummy12) {
    [output writeInt32:12 value:self.dummy12];
  }
  if (hasDummy13) {
    [output writeInt32:13 value:self.dummy13];
  }
  if (hasDummy14) {
    [output writeInt32:14 value:self.dummy14];
  }
  if (hasDummy15) {
    [output writeInt32:15 value:self.dummy15];
  }
  if (hasDummy16) {
    [output writeInt32:16 value:self.dummy16];
  }
  if (hasDummy17) {
    [output writeInt32:17 value:self.dummy17];
  }
  if (hasDummy18) {
    [output writeInt32:18 value:self.dummy18];
  }
  if (hasDummy19) {
    [output writeInt32:19 value:self.dummy19];
  }
  if (hasDummy20) {
    [output writeInt32:20 value:self.dummy20];
  }
  if (hasDummy21) {
    [output writeInt32:21 value:self.dummy21];
  }
  if (hasDummy22) {
    [output writeInt32:22 value:self.dummy22];
  }
  if (hasDummy23) {
    [output writeInt32:23 value:self.dummy23];
  }
  if (hasDummy24) {
    [output writeInt32:24 value:self.dummy24];
  }
  if (hasDummy25) {
    [output writeInt32:25 value:self.dummy25];
  }
  if (hasDummy26) {
    [output writeInt32:26 value:self.dummy26];
  }
  if (hasDummy27) {
    [output writeInt32:27 value:self.dummy27];
  }
  if (hasDummy28) {
    [output writeInt32:28 value:self.dummy28];
  }
  if (hasDummy29) {
    [output writeInt32:29 value:self.dummy29];
  }
  if (hasDummy30) {
    [output writeInt32:30 value:self.dummy30];
  }
  if (hasDummy31) {
    [output writeInt32:31 value:self.dummy31];
  }
  if (hasDummy32) {
    [output writeInt32:32 value:self.dummy32];
  }
  if (hasC) {
    [output writeInt32:33 value:self.c];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(1, self.a);
  }
  if (hasDummy2) {
    size += computeInt32Size(2, self.dummy2);
  }
  if (hasB) {
    size += computeInt32Size(3, self.b);
  }
  if (hasDummy4) {
    size += computeInt32Size(4, self.dummy4);
  }
  if (hasDummy5) {
    size += computeInt32Size(5, self.dummy5);
  }
  if (hasDummy6) {
    size += computeInt32Size(6, self.dummy6);
  }
  if (hasDummy7) {
    size += computeInt32Size(7, self.dummy7);
  }
  if (hasDummy8) {
    size += computeInt32Size(8, self.dummy8);
  }
  if (hasDummy9) {
    size += computeInt32Size(9, self.dummy9);
  }
  if (hasDummy10) {
    size += computeInt32Size(10, self.dummy10);
  }
  if (hasDummy11) {
    size += computeInt32Size(11, self.dummy11);
  }
  if (hasDummy12) {
    size += computeInt32Size(12, self.dummy12);
  }
  if (hasDummy13) {
    size += computeInt32Size(13, self.dummy13);
  }
  if (hasDummy14) {
    size += computeInt32Size(14, self.dummy14);
  }
  if (hasDummy15) {
    size += computeInt32Size(15, self.dummy15);
  }
  if (hasDummy16) {
    size += computeInt32Size(16, self.dummy16);
  }
  if (hasDummy17) {
    size += computeInt32Size(17, self.dummy17);
  }
  if (hasDummy18) {
    size += computeInt32Size(18, self.dummy18);
  }
  if (hasDummy19) {
    size += computeInt32Size(19, self.dummy19);
  }
  if (hasDummy20) {
    size += computeInt32Size(20, self.dummy20);
  }
  if (hasDummy21) {
    size += computeInt32Size(21, self.dummy21);
  }
  if (hasDummy22) {
    size += computeInt32Size(22, self.dummy22);
  }
  if (hasDummy23) {
    size += computeInt32Size(23, self.dummy23);
  }
  if (hasDummy24) {
    size += computeInt32Size(24, self.dummy24);
  }
  if (hasDummy25) {
    size += computeInt32Size(25, self.dummy25);
  }
  if (hasDummy26) {
    size += computeInt32Size(26, self.dummy26);
  }
  if (hasDummy27) {
    size += computeInt32Size(27, self.dummy27);
  }
  if (hasDummy28) {
    size += computeInt32Size(28, self.dummy28);
  }
  if (hasDummy29) {
    size += computeInt32Size(29, self.dummy29);
  }
  if (hasDummy30) {
    size += computeInt32Size(30, self.dummy30);
  }
  if (hasDummy31) {
    size += computeInt32Size(31, self.dummy31);
  }
  if (hasDummy32) {
    size += computeInt32Size(32, self.dummy32);
  }
  if (hasC) {
    size += computeInt32Size(33, self.c);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestRequired*) parseFromData:(NSData*) data {
  return (TestRequired*)[[[TestRequired_Builder builder] mergeFromData:data] build];
}
+ (TestRequired*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRequired*)[[[TestRequired_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestRequired*) parseFromInputStream:(NSInputStream*) input {
  return (TestRequired*)[[[TestRequired_Builder builder] mergeFromInputStream:input] build];
}
+ (TestRequired*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRequired*)[[[TestRequired_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestRequired*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestRequired*)[[[TestRequired_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestRequired*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRequired*)[[[TestRequired_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestRequired_Builder*) createBuilder {
  return [TestRequired_Builder builder];
}
@end

@implementation TestRequired_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestRequired alloc] init] autorelease];
  }
  return self;
}
+ (TestRequired_Builder*) builder {
  return [[[TestRequired_Builder alloc] init] autorelease];
}
+ (TestRequired_Builder*) builderWithPrototype:(TestRequired*) prototype {
  return [[TestRequired_Builder builder] mergeFromTestRequired:prototype];
}
- (TestRequired*) internalGetResult {
  return result;
}
- (TestRequired_Builder*) clear {
  self.result = [[[TestRequired alloc] init] autorelease];
  return self;
}
- (TestRequired_Builder*) clone {
  return [TestRequired_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestRequired descriptor];
}
- (TestRequired*) defaultInstance {
  return [TestRequired defaultInstance];
}
- (TestRequired*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestRequired*) buildPartial {
  TestRequired* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestRequired_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestRequired class]]) {
    return [self mergeFromTestRequired:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestRequired_Builder*) mergeFromTestRequired:(TestRequired*) other {
  if (other == [TestRequired defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  if (other.hasDummy2) {
    [self setDummy2:other.dummy2];
  }
  if (other.hasB) {
    [self setB:other.b];
  }
  if (other.hasDummy4) {
    [self setDummy4:other.dummy4];
  }
  if (other.hasDummy5) {
    [self setDummy5:other.dummy5];
  }
  if (other.hasDummy6) {
    [self setDummy6:other.dummy6];
  }
  if (other.hasDummy7) {
    [self setDummy7:other.dummy7];
  }
  if (other.hasDummy8) {
    [self setDummy8:other.dummy8];
  }
  if (other.hasDummy9) {
    [self setDummy9:other.dummy9];
  }
  if (other.hasDummy10) {
    [self setDummy10:other.dummy10];
  }
  if (other.hasDummy11) {
    [self setDummy11:other.dummy11];
  }
  if (other.hasDummy12) {
    [self setDummy12:other.dummy12];
  }
  if (other.hasDummy13) {
    [self setDummy13:other.dummy13];
  }
  if (other.hasDummy14) {
    [self setDummy14:other.dummy14];
  }
  if (other.hasDummy15) {
    [self setDummy15:other.dummy15];
  }
  if (other.hasDummy16) {
    [self setDummy16:other.dummy16];
  }
  if (other.hasDummy17) {
    [self setDummy17:other.dummy17];
  }
  if (other.hasDummy18) {
    [self setDummy18:other.dummy18];
  }
  if (other.hasDummy19) {
    [self setDummy19:other.dummy19];
  }
  if (other.hasDummy20) {
    [self setDummy20:other.dummy20];
  }
  if (other.hasDummy21) {
    [self setDummy21:other.dummy21];
  }
  if (other.hasDummy22) {
    [self setDummy22:other.dummy22];
  }
  if (other.hasDummy23) {
    [self setDummy23:other.dummy23];
  }
  if (other.hasDummy24) {
    [self setDummy24:other.dummy24];
  }
  if (other.hasDummy25) {
    [self setDummy25:other.dummy25];
  }
  if (other.hasDummy26) {
    [self setDummy26:other.dummy26];
  }
  if (other.hasDummy27) {
    [self setDummy27:other.dummy27];
  }
  if (other.hasDummy28) {
    [self setDummy28:other.dummy28];
  }
  if (other.hasDummy29) {
    [self setDummy29:other.dummy29];
  }
  if (other.hasDummy30) {
    [self setDummy30:other.dummy30];
  }
  if (other.hasDummy31) {
    [self setDummy31:other.dummy31];
  }
  if (other.hasDummy32) {
    [self setDummy32:other.dummy32];
  }
  if (other.hasC) {
    [self setC:other.c];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestRequired_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestRequired_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setA:[input readInt32]];
        break;
      }
      case 16: {
        [self setDummy2:[input readInt32]];
        break;
      }
      case 24: {
        [self setB:[input readInt32]];
        break;
      }
      case 32: {
        [self setDummy4:[input readInt32]];
        break;
      }
      case 40: {
        [self setDummy5:[input readInt32]];
        break;
      }
      case 48: {
        [self setDummy6:[input readInt32]];
        break;
      }
      case 56: {
        [self setDummy7:[input readInt32]];
        break;
      }
      case 64: {
        [self setDummy8:[input readInt32]];
        break;
      }
      case 72: {
        [self setDummy9:[input readInt32]];
        break;
      }
      case 80: {
        [self setDummy10:[input readInt32]];
        break;
      }
      case 88: {
        [self setDummy11:[input readInt32]];
        break;
      }
      case 96: {
        [self setDummy12:[input readInt32]];
        break;
      }
      case 104: {
        [self setDummy13:[input readInt32]];
        break;
      }
      case 112: {
        [self setDummy14:[input readInt32]];
        break;
      }
      case 120: {
        [self setDummy15:[input readInt32]];
        break;
      }
      case 128: {
        [self setDummy16:[input readInt32]];
        break;
      }
      case 136: {
        [self setDummy17:[input readInt32]];
        break;
      }
      case 144: {
        [self setDummy18:[input readInt32]];
        break;
      }
      case 152: {
        [self setDummy19:[input readInt32]];
        break;
      }
      case 160: {
        [self setDummy20:[input readInt32]];
        break;
      }
      case 168: {
        [self setDummy21:[input readInt32]];
        break;
      }
      case 176: {
        [self setDummy22:[input readInt32]];
        break;
      }
      case 184: {
        [self setDummy23:[input readInt32]];
        break;
      }
      case 192: {
        [self setDummy24:[input readInt32]];
        break;
      }
      case 200: {
        [self setDummy25:[input readInt32]];
        break;
      }
      case 208: {
        [self setDummy26:[input readInt32]];
        break;
      }
      case 216: {
        [self setDummy27:[input readInt32]];
        break;
      }
      case 224: {
        [self setDummy28:[input readInt32]];
        break;
      }
      case 232: {
        [self setDummy29:[input readInt32]];
        break;
      }
      case 240: {
        [self setDummy30:[input readInt32]];
        break;
      }
      case 248: {
        [self setDummy31:[input readInt32]];
        break;
      }
      case 256: {
        [self setDummy32:[input readInt32]];
        break;
      }
      case 264: {
        [self setC:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (TestRequired_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestRequired_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
- (BOOL) hasDummy2 {
  return result.hasDummy2;
}
- (int32_t) dummy2 {
  return result.dummy2;
}
- (TestRequired_Builder*) setDummy2:(int32_t) value {
  result.hasDummy2 = YES;
  result.dummy2 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy2 {
  result.hasDummy2 = NO;
  result.dummy2 = 0;
  return self;
}
- (BOOL) hasB {
  return result.hasB;
}
- (int32_t) b {
  return result.b;
}
- (TestRequired_Builder*) setB:(int32_t) value {
  result.hasB = YES;
  result.b = value;
  return self;
}
- (TestRequired_Builder*) clearB {
  result.hasB = NO;
  result.b = 0;
  return self;
}
- (BOOL) hasDummy4 {
  return result.hasDummy4;
}
- (int32_t) dummy4 {
  return result.dummy4;
}
- (TestRequired_Builder*) setDummy4:(int32_t) value {
  result.hasDummy4 = YES;
  result.dummy4 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy4 {
  result.hasDummy4 = NO;
  result.dummy4 = 0;
  return self;
}
- (BOOL) hasDummy5 {
  return result.hasDummy5;
}
- (int32_t) dummy5 {
  return result.dummy5;
}
- (TestRequired_Builder*) setDummy5:(int32_t) value {
  result.hasDummy5 = YES;
  result.dummy5 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy5 {
  result.hasDummy5 = NO;
  result.dummy5 = 0;
  return self;
}
- (BOOL) hasDummy6 {
  return result.hasDummy6;
}
- (int32_t) dummy6 {
  return result.dummy6;
}
- (TestRequired_Builder*) setDummy6:(int32_t) value {
  result.hasDummy6 = YES;
  result.dummy6 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy6 {
  result.hasDummy6 = NO;
  result.dummy6 = 0;
  return self;
}
- (BOOL) hasDummy7 {
  return result.hasDummy7;
}
- (int32_t) dummy7 {
  return result.dummy7;
}
- (TestRequired_Builder*) setDummy7:(int32_t) value {
  result.hasDummy7 = YES;
  result.dummy7 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy7 {
  result.hasDummy7 = NO;
  result.dummy7 = 0;
  return self;
}
- (BOOL) hasDummy8 {
  return result.hasDummy8;
}
- (int32_t) dummy8 {
  return result.dummy8;
}
- (TestRequired_Builder*) setDummy8:(int32_t) value {
  result.hasDummy8 = YES;
  result.dummy8 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy8 {
  result.hasDummy8 = NO;
  result.dummy8 = 0;
  return self;
}
- (BOOL) hasDummy9 {
  return result.hasDummy9;
}
- (int32_t) dummy9 {
  return result.dummy9;
}
- (TestRequired_Builder*) setDummy9:(int32_t) value {
  result.hasDummy9 = YES;
  result.dummy9 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy9 {
  result.hasDummy9 = NO;
  result.dummy9 = 0;
  return self;
}
- (BOOL) hasDummy10 {
  return result.hasDummy10;
}
- (int32_t) dummy10 {
  return result.dummy10;
}
- (TestRequired_Builder*) setDummy10:(int32_t) value {
  result.hasDummy10 = YES;
  result.dummy10 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy10 {
  result.hasDummy10 = NO;
  result.dummy10 = 0;
  return self;
}
- (BOOL) hasDummy11 {
  return result.hasDummy11;
}
- (int32_t) dummy11 {
  return result.dummy11;
}
- (TestRequired_Builder*) setDummy11:(int32_t) value {
  result.hasDummy11 = YES;
  result.dummy11 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy11 {
  result.hasDummy11 = NO;
  result.dummy11 = 0;
  return self;
}
- (BOOL) hasDummy12 {
  return result.hasDummy12;
}
- (int32_t) dummy12 {
  return result.dummy12;
}
- (TestRequired_Builder*) setDummy12:(int32_t) value {
  result.hasDummy12 = YES;
  result.dummy12 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy12 {
  result.hasDummy12 = NO;
  result.dummy12 = 0;
  return self;
}
- (BOOL) hasDummy13 {
  return result.hasDummy13;
}
- (int32_t) dummy13 {
  return result.dummy13;
}
- (TestRequired_Builder*) setDummy13:(int32_t) value {
  result.hasDummy13 = YES;
  result.dummy13 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy13 {
  result.hasDummy13 = NO;
  result.dummy13 = 0;
  return self;
}
- (BOOL) hasDummy14 {
  return result.hasDummy14;
}
- (int32_t) dummy14 {
  return result.dummy14;
}
- (TestRequired_Builder*) setDummy14:(int32_t) value {
  result.hasDummy14 = YES;
  result.dummy14 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy14 {
  result.hasDummy14 = NO;
  result.dummy14 = 0;
  return self;
}
- (BOOL) hasDummy15 {
  return result.hasDummy15;
}
- (int32_t) dummy15 {
  return result.dummy15;
}
- (TestRequired_Builder*) setDummy15:(int32_t) value {
  result.hasDummy15 = YES;
  result.dummy15 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy15 {
  result.hasDummy15 = NO;
  result.dummy15 = 0;
  return self;
}
- (BOOL) hasDummy16 {
  return result.hasDummy16;
}
- (int32_t) dummy16 {
  return result.dummy16;
}
- (TestRequired_Builder*) setDummy16:(int32_t) value {
  result.hasDummy16 = YES;
  result.dummy16 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy16 {
  result.hasDummy16 = NO;
  result.dummy16 = 0;
  return self;
}
- (BOOL) hasDummy17 {
  return result.hasDummy17;
}
- (int32_t) dummy17 {
  return result.dummy17;
}
- (TestRequired_Builder*) setDummy17:(int32_t) value {
  result.hasDummy17 = YES;
  result.dummy17 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy17 {
  result.hasDummy17 = NO;
  result.dummy17 = 0;
  return self;
}
- (BOOL) hasDummy18 {
  return result.hasDummy18;
}
- (int32_t) dummy18 {
  return result.dummy18;
}
- (TestRequired_Builder*) setDummy18:(int32_t) value {
  result.hasDummy18 = YES;
  result.dummy18 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy18 {
  result.hasDummy18 = NO;
  result.dummy18 = 0;
  return self;
}
- (BOOL) hasDummy19 {
  return result.hasDummy19;
}
- (int32_t) dummy19 {
  return result.dummy19;
}
- (TestRequired_Builder*) setDummy19:(int32_t) value {
  result.hasDummy19 = YES;
  result.dummy19 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy19 {
  result.hasDummy19 = NO;
  result.dummy19 = 0;
  return self;
}
- (BOOL) hasDummy20 {
  return result.hasDummy20;
}
- (int32_t) dummy20 {
  return result.dummy20;
}
- (TestRequired_Builder*) setDummy20:(int32_t) value {
  result.hasDummy20 = YES;
  result.dummy20 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy20 {
  result.hasDummy20 = NO;
  result.dummy20 = 0;
  return self;
}
- (BOOL) hasDummy21 {
  return result.hasDummy21;
}
- (int32_t) dummy21 {
  return result.dummy21;
}
- (TestRequired_Builder*) setDummy21:(int32_t) value {
  result.hasDummy21 = YES;
  result.dummy21 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy21 {
  result.hasDummy21 = NO;
  result.dummy21 = 0;
  return self;
}
- (BOOL) hasDummy22 {
  return result.hasDummy22;
}
- (int32_t) dummy22 {
  return result.dummy22;
}
- (TestRequired_Builder*) setDummy22:(int32_t) value {
  result.hasDummy22 = YES;
  result.dummy22 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy22 {
  result.hasDummy22 = NO;
  result.dummy22 = 0;
  return self;
}
- (BOOL) hasDummy23 {
  return result.hasDummy23;
}
- (int32_t) dummy23 {
  return result.dummy23;
}
- (TestRequired_Builder*) setDummy23:(int32_t) value {
  result.hasDummy23 = YES;
  result.dummy23 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy23 {
  result.hasDummy23 = NO;
  result.dummy23 = 0;
  return self;
}
- (BOOL) hasDummy24 {
  return result.hasDummy24;
}
- (int32_t) dummy24 {
  return result.dummy24;
}
- (TestRequired_Builder*) setDummy24:(int32_t) value {
  result.hasDummy24 = YES;
  result.dummy24 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy24 {
  result.hasDummy24 = NO;
  result.dummy24 = 0;
  return self;
}
- (BOOL) hasDummy25 {
  return result.hasDummy25;
}
- (int32_t) dummy25 {
  return result.dummy25;
}
- (TestRequired_Builder*) setDummy25:(int32_t) value {
  result.hasDummy25 = YES;
  result.dummy25 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy25 {
  result.hasDummy25 = NO;
  result.dummy25 = 0;
  return self;
}
- (BOOL) hasDummy26 {
  return result.hasDummy26;
}
- (int32_t) dummy26 {
  return result.dummy26;
}
- (TestRequired_Builder*) setDummy26:(int32_t) value {
  result.hasDummy26 = YES;
  result.dummy26 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy26 {
  result.hasDummy26 = NO;
  result.dummy26 = 0;
  return self;
}
- (BOOL) hasDummy27 {
  return result.hasDummy27;
}
- (int32_t) dummy27 {
  return result.dummy27;
}
- (TestRequired_Builder*) setDummy27:(int32_t) value {
  result.hasDummy27 = YES;
  result.dummy27 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy27 {
  result.hasDummy27 = NO;
  result.dummy27 = 0;
  return self;
}
- (BOOL) hasDummy28 {
  return result.hasDummy28;
}
- (int32_t) dummy28 {
  return result.dummy28;
}
- (TestRequired_Builder*) setDummy28:(int32_t) value {
  result.hasDummy28 = YES;
  result.dummy28 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy28 {
  result.hasDummy28 = NO;
  result.dummy28 = 0;
  return self;
}
- (BOOL) hasDummy29 {
  return result.hasDummy29;
}
- (int32_t) dummy29 {
  return result.dummy29;
}
- (TestRequired_Builder*) setDummy29:(int32_t) value {
  result.hasDummy29 = YES;
  result.dummy29 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy29 {
  result.hasDummy29 = NO;
  result.dummy29 = 0;
  return self;
}
- (BOOL) hasDummy30 {
  return result.hasDummy30;
}
- (int32_t) dummy30 {
  return result.dummy30;
}
- (TestRequired_Builder*) setDummy30:(int32_t) value {
  result.hasDummy30 = YES;
  result.dummy30 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy30 {
  result.hasDummy30 = NO;
  result.dummy30 = 0;
  return self;
}
- (BOOL) hasDummy31 {
  return result.hasDummy31;
}
- (int32_t) dummy31 {
  return result.dummy31;
}
- (TestRequired_Builder*) setDummy31:(int32_t) value {
  result.hasDummy31 = YES;
  result.dummy31 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy31 {
  result.hasDummy31 = NO;
  result.dummy31 = 0;
  return self;
}
- (BOOL) hasDummy32 {
  return result.hasDummy32;
}
- (int32_t) dummy32 {
  return result.dummy32;
}
- (TestRequired_Builder*) setDummy32:(int32_t) value {
  result.hasDummy32 = YES;
  result.dummy32 = value;
  return self;
}
- (TestRequired_Builder*) clearDummy32 {
  result.hasDummy32 = NO;
  result.dummy32 = 0;
  return self;
}
- (BOOL) hasC {
  return result.hasC;
}
- (int32_t) c {
  return result.c;
}
- (TestRequired_Builder*) setC:(int32_t) value {
  result.hasC = YES;
  result.c = value;
  return self;
}
- (TestRequired_Builder*) clearC {
  result.hasC = NO;
  result.c = 0;
  return self;
}
@end

@interface TestRequiredForeign ()
@property BOOL hasOptionalMessage;
@property (retain) TestRequired* optionalMessage;
@property (retain) NSMutableArray* mutableRepeatedMessageList;
@property BOOL hasDummy;
@property int32_t dummy;
@end

@implementation TestRequiredForeign

@synthesize hasOptionalMessage;
@synthesize optionalMessage;
@synthesize mutableRepeatedMessageList;
@synthesize hasDummy;
@synthesize dummy;
- (void) dealloc {
  self.hasOptionalMessage = NO;
  self.optionalMessage = nil;
  self.mutableRepeatedMessageList = nil;
  self.hasDummy = NO;
  self.dummy = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.optionalMessage = [TestRequired defaultInstance];
    self.dummy = 0;
  }
  return self;
}
static TestRequiredForeign* defaultTestRequiredForeignInstance = nil;
+ (void) initialize {
  if (self == [TestRequiredForeign class]) {
    defaultTestRequiredForeignInstance = [[TestRequiredForeign alloc] init];
  }
}
+ (TestRequiredForeign*) defaultInstance {
  return defaultTestRequiredForeignInstance;
}
- (TestRequiredForeign*) defaultInstance {
  return defaultTestRequiredForeignInstance;
}
- (PBDescriptor*) descriptor {
  return [TestRequiredForeign descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestRequiredForeign_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestRequiredForeign_fieldAccessorTable];
}
- (NSArray*) repeatedMessageList {
  return mutableRepeatedMessageList;
}
- (TestRequired*) repeatedMessageAtIndex:(int32_t) index {
  id value = [mutableRepeatedMessageList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  if (self.hasOptionalMessage) {
    if (!self.optionalMessage.isInitialized) return false;
  }
  for (TestRequired* element in self.repeatedMessageList) {
    if (!element.isInitialized) return false;
  }
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasOptionalMessage) {
    [output writeMessage:1 value:self.optionalMessage];
  }
  for (TestRequired* element in self.repeatedMessageList) {
    [output writeMessage:2 value:element];
  }
  if (hasDummy) {
    [output writeInt32:3 value:self.dummy];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (self.hasOptionalMessage) {
    size += computeMessageSize(1, self.optionalMessage);
  }
  for (TestRequired* element in self.repeatedMessageList) {
    size += computeMessageSize(2, element);
  }
  if (hasDummy) {
    size += computeInt32Size(3, self.dummy);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestRequiredForeign*) parseFromData:(NSData*) data {
  return (TestRequiredForeign*)[[[TestRequiredForeign_Builder builder] mergeFromData:data] build];
}
+ (TestRequiredForeign*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRequiredForeign*)[[[TestRequiredForeign_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestRequiredForeign*) parseFromInputStream:(NSInputStream*) input {
  return (TestRequiredForeign*)[[[TestRequiredForeign_Builder builder] mergeFromInputStream:input] build];
}
+ (TestRequiredForeign*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRequiredForeign*)[[[TestRequiredForeign_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestRequiredForeign*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestRequiredForeign*)[[[TestRequiredForeign_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestRequiredForeign*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRequiredForeign*)[[[TestRequiredForeign_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestRequiredForeign_Builder*) createBuilder {
  return [TestRequiredForeign_Builder builder];
}
@end

@implementation TestRequiredForeign_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestRequiredForeign alloc] init] autorelease];
  }
  return self;
}
+ (TestRequiredForeign_Builder*) builder {
  return [[[TestRequiredForeign_Builder alloc] init] autorelease];
}
+ (TestRequiredForeign_Builder*) builderWithPrototype:(TestRequiredForeign*) prototype {
  return [[TestRequiredForeign_Builder builder] mergeFromTestRequiredForeign:prototype];
}
- (TestRequiredForeign*) internalGetResult {
  return result;
}
- (TestRequiredForeign_Builder*) clear {
  self.result = [[[TestRequiredForeign alloc] init] autorelease];
  return self;
}
- (TestRequiredForeign_Builder*) clone {
  return [TestRequiredForeign_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestRequiredForeign descriptor];
}
- (TestRequiredForeign*) defaultInstance {
  return [TestRequiredForeign defaultInstance];
}
- (TestRequiredForeign*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestRequiredForeign*) buildPartial {
  TestRequiredForeign* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestRequiredForeign_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestRequiredForeign class]]) {
    return [self mergeFromTestRequiredForeign:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestRequiredForeign_Builder*) mergeFromTestRequiredForeign:(TestRequiredForeign*) other {
  if (other == [TestRequiredForeign defaultInstance]) return self;
  if (other.hasOptionalMessage) {
    [self mergeOptionalMessage:other.optionalMessage];
  }
  if (other.mutableRepeatedMessageList.count > 0) {
    if (result.mutableRepeatedMessageList == nil) {
      result.mutableRepeatedMessageList = [NSMutableArray array];
    }
    [result.mutableRepeatedMessageList addObjectsFromArray:other.mutableRepeatedMessageList];
  }
  if (other.hasDummy) {
    [self setDummy:other.dummy];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestRequiredForeign_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestRequiredForeign_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        TestRequired_Builder* subBuilder = [TestRequired_Builder builder];
        if (self.hasOptionalMessage) {
          [subBuilder mergeFromTestRequired:self.optionalMessage];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptionalMessage:[subBuilder buildPartial]];
        break;
      }
      case 18: {
        TestRequired_Builder* subBuilder = [TestRequired_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addRepeatedMessage:[subBuilder buildPartial]];
        break;
      }
      case 24: {
        [self setDummy:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasOptionalMessage {
  return result.hasOptionalMessage;
}
- (TestRequired*) optionalMessage {
  return result.optionalMessage;
}
- (TestRequiredForeign_Builder*) setOptionalMessage:(TestRequired*) value {
  result.hasOptionalMessage = YES;
  result.optionalMessage = value;
  return self;
}
- (TestRequiredForeign_Builder*) setOptionalMessageBuilder:(TestRequired_Builder*) builderForValue {
  return [self setOptionalMessage:[builderForValue build]];
}
- (TestRequiredForeign_Builder*) mergeOptionalMessage:(TestRequired*) value {
  if (result.hasOptionalMessage &&
      result.optionalMessage != [TestRequired defaultInstance]) {
    result.optionalMessage =
      [[[TestRequired_Builder builderWithPrototype:result.optionalMessage] mergeFromTestRequired:value] buildPartial];
  } else {
    result.optionalMessage = value;
  }
  result.hasOptionalMessage = YES;
  return self;
}
- (TestRequiredForeign_Builder*) clearOptionalMessage {
  result.hasOptionalMessage = NO;
  result.optionalMessage = [TestRequired defaultInstance];
  return self;
}
- (NSArray*) repeatedMessageList {
  if (result.mutableRepeatedMessageList == nil) { return [NSArray array]; }
  return result.mutableRepeatedMessageList;
}
- (TestRequired*) repeatedMessageAtIndex:(int32_t) index {
  return [result repeatedMessageAtIndex:index];
}
- (TestRequiredForeign_Builder*) replaceRepeatedMessageAtIndex:(int32_t) index withRepeatedMessage:(TestRequired*) value {
  [result.mutableRepeatedMessageList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestRequiredForeign_Builder*) addAllRepeatedMessage:(NSArray*) values {
  if (result.mutableRepeatedMessageList == nil) {
    result.mutableRepeatedMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedMessageList addObjectsFromArray:values];
  return self;
}
- (TestRequiredForeign_Builder*) clearRepeatedMessageList {
  result.mutableRepeatedMessageList = nil;
  return self;
}
- (TestRequiredForeign_Builder*) addRepeatedMessage:(TestRequired*) value {
  if (result.mutableRepeatedMessageList == nil) {
    result.mutableRepeatedMessageList = [NSMutableArray array];
  }
  [result.mutableRepeatedMessageList addObject:value];
  return self;
}
- (BOOL) hasDummy {
  return result.hasDummy;
}
- (int32_t) dummy {
  return result.dummy;
}
- (TestRequiredForeign_Builder*) setDummy:(int32_t) value {
  result.hasDummy = YES;
  result.dummy = value;
  return self;
}
- (TestRequiredForeign_Builder*) clearDummy {
  result.hasDummy = NO;
  result.dummy = 0;
  return self;
}
@end

@interface TestForeignNested ()
@property BOOL hasForeignNested;
@property (retain) TestAllTypes_NestedMessage* foreignNested;
@end

@implementation TestForeignNested

@synthesize hasForeignNested;
@synthesize foreignNested;
- (void) dealloc {
  self.hasForeignNested = NO;
  self.foreignNested = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.foreignNested = [TestAllTypes_NestedMessage defaultInstance];
  }
  return self;
}
static TestForeignNested* defaultTestForeignNestedInstance = nil;
+ (void) initialize {
  if (self == [TestForeignNested class]) {
    defaultTestForeignNestedInstance = [[TestForeignNested alloc] init];
  }
}
+ (TestForeignNested*) defaultInstance {
  return defaultTestForeignNestedInstance;
}
- (TestForeignNested*) defaultInstance {
  return defaultTestForeignNestedInstance;
}
- (PBDescriptor*) descriptor {
  return [TestForeignNested descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestForeignNested_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestForeignNested_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasForeignNested) {
    [output writeMessage:1 value:self.foreignNested];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (self.hasForeignNested) {
    size += computeMessageSize(1, self.foreignNested);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestForeignNested*) parseFromData:(NSData*) data {
  return (TestForeignNested*)[[[TestForeignNested_Builder builder] mergeFromData:data] build];
}
+ (TestForeignNested*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestForeignNested*)[[[TestForeignNested_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestForeignNested*) parseFromInputStream:(NSInputStream*) input {
  return (TestForeignNested*)[[[TestForeignNested_Builder builder] mergeFromInputStream:input] build];
}
+ (TestForeignNested*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestForeignNested*)[[[TestForeignNested_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestForeignNested*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestForeignNested*)[[[TestForeignNested_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestForeignNested*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestForeignNested*)[[[TestForeignNested_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestForeignNested_Builder*) createBuilder {
  return [TestForeignNested_Builder builder];
}
@end

@implementation TestForeignNested_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestForeignNested alloc] init] autorelease];
  }
  return self;
}
+ (TestForeignNested_Builder*) builder {
  return [[[TestForeignNested_Builder alloc] init] autorelease];
}
+ (TestForeignNested_Builder*) builderWithPrototype:(TestForeignNested*) prototype {
  return [[TestForeignNested_Builder builder] mergeFromTestForeignNested:prototype];
}
- (TestForeignNested*) internalGetResult {
  return result;
}
- (TestForeignNested_Builder*) clear {
  self.result = [[[TestForeignNested alloc] init] autorelease];
  return self;
}
- (TestForeignNested_Builder*) clone {
  return [TestForeignNested_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestForeignNested descriptor];
}
- (TestForeignNested*) defaultInstance {
  return [TestForeignNested defaultInstance];
}
- (TestForeignNested*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestForeignNested*) buildPartial {
  TestForeignNested* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestForeignNested_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestForeignNested class]]) {
    return [self mergeFromTestForeignNested:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestForeignNested_Builder*) mergeFromTestForeignNested:(TestForeignNested*) other {
  if (other == [TestForeignNested defaultInstance]) return self;
  if (other.hasForeignNested) {
    [self mergeForeignNested:other.foreignNested];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestForeignNested_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestForeignNested_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        TestAllTypes_NestedMessage_Builder* subBuilder = [TestAllTypes_NestedMessage_Builder builder];
        if (self.hasForeignNested) {
          [subBuilder mergeFromTestAllTypes_NestedMessage:self.foreignNested];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setForeignNested:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasForeignNested {
  return result.hasForeignNested;
}
- (TestAllTypes_NestedMessage*) foreignNested {
  return result.foreignNested;
}
- (TestForeignNested_Builder*) setForeignNested:(TestAllTypes_NestedMessage*) value {
  result.hasForeignNested = YES;
  result.foreignNested = value;
  return self;
}
- (TestForeignNested_Builder*) setForeignNestedBuilder:(TestAllTypes_NestedMessage_Builder*) builderForValue {
  return [self setForeignNested:[builderForValue build]];
}
- (TestForeignNested_Builder*) mergeForeignNested:(TestAllTypes_NestedMessage*) value {
  if (result.hasForeignNested &&
      result.foreignNested != [TestAllTypes_NestedMessage defaultInstance]) {
    result.foreignNested =
      [[[TestAllTypes_NestedMessage_Builder builderWithPrototype:result.foreignNested] mergeFromTestAllTypes_NestedMessage:value] buildPartial];
  } else {
    result.foreignNested = value;
  }
  result.hasForeignNested = YES;
  return self;
}
- (TestForeignNested_Builder*) clearForeignNested {
  result.hasForeignNested = NO;
  result.foreignNested = [TestAllTypes_NestedMessage defaultInstance];
  return self;
}
@end

@interface TestEmptyMessage ()
@end

@implementation TestEmptyMessage

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static TestEmptyMessage* defaultTestEmptyMessageInstance = nil;
+ (void) initialize {
  if (self == [TestEmptyMessage class]) {
    defaultTestEmptyMessageInstance = [[TestEmptyMessage alloc] init];
  }
}
+ (TestEmptyMessage*) defaultInstance {
  return defaultTestEmptyMessageInstance;
}
- (TestEmptyMessage*) defaultInstance {
  return defaultTestEmptyMessageInstance;
}
- (PBDescriptor*) descriptor {
  return [TestEmptyMessage descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestEmptyMessage_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestEmptyMessage_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestEmptyMessage*) parseFromData:(NSData*) data {
  return (TestEmptyMessage*)[[[TestEmptyMessage_Builder builder] mergeFromData:data] build];
}
+ (TestEmptyMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestEmptyMessage*)[[[TestEmptyMessage_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestEmptyMessage*) parseFromInputStream:(NSInputStream*) input {
  return (TestEmptyMessage*)[[[TestEmptyMessage_Builder builder] mergeFromInputStream:input] build];
}
+ (TestEmptyMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestEmptyMessage*)[[[TestEmptyMessage_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestEmptyMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestEmptyMessage*)[[[TestEmptyMessage_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestEmptyMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestEmptyMessage*)[[[TestEmptyMessage_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestEmptyMessage_Builder*) createBuilder {
  return [TestEmptyMessage_Builder builder];
}
@end

@implementation TestEmptyMessage_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestEmptyMessage alloc] init] autorelease];
  }
  return self;
}
+ (TestEmptyMessage_Builder*) builder {
  return [[[TestEmptyMessage_Builder alloc] init] autorelease];
}
+ (TestEmptyMessage_Builder*) builderWithPrototype:(TestEmptyMessage*) prototype {
  return [[TestEmptyMessage_Builder builder] mergeFromTestEmptyMessage:prototype];
}
- (TestEmptyMessage*) internalGetResult {
  return result;
}
- (TestEmptyMessage_Builder*) clear {
  self.result = [[[TestEmptyMessage alloc] init] autorelease];
  return self;
}
- (TestEmptyMessage_Builder*) clone {
  return [TestEmptyMessage_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestEmptyMessage descriptor];
}
- (TestEmptyMessage*) defaultInstance {
  return [TestEmptyMessage defaultInstance];
}
- (TestEmptyMessage*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestEmptyMessage*) buildPartial {
  TestEmptyMessage* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestEmptyMessage_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestEmptyMessage class]]) {
    return [self mergeFromTestEmptyMessage:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestEmptyMessage_Builder*) mergeFromTestEmptyMessage:(TestEmptyMessage*) other {
  if (other == [TestEmptyMessage defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestEmptyMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestEmptyMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface TestEmptyMessageWithExtensions ()
@end

@implementation TestEmptyMessageWithExtensions

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static TestEmptyMessageWithExtensions* defaultTestEmptyMessageWithExtensionsInstance = nil;
+ (void) initialize {
  if (self == [TestEmptyMessageWithExtensions class]) {
    defaultTestEmptyMessageWithExtensionsInstance = [[TestEmptyMessageWithExtensions alloc] init];
  }
}
+ (TestEmptyMessageWithExtensions*) defaultInstance {
  return defaultTestEmptyMessageWithExtensionsInstance;
}
- (TestEmptyMessageWithExtensions*) defaultInstance {
  return defaultTestEmptyMessageWithExtensionsInstance;
}
- (PBDescriptor*) descriptor {
  return [TestEmptyMessageWithExtensions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestEmptyMessageWithExtensions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  if (!self.extensionsAreInitialized) return false;
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  PBExtensionWriter* extensionWriter = [PBExtensionWriter writerWithExtensions:self.extensions];
  [extensionWriter writeUntil:536870912 output:output];
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += [self extensionsSerializedSize];
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestEmptyMessageWithExtensions*) parseFromData:(NSData*) data {
  return (TestEmptyMessageWithExtensions*)[[[TestEmptyMessageWithExtensions_Builder builder] mergeFromData:data] build];
}
+ (TestEmptyMessageWithExtensions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestEmptyMessageWithExtensions*)[[[TestEmptyMessageWithExtensions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestEmptyMessageWithExtensions*) parseFromInputStream:(NSInputStream*) input {
  return (TestEmptyMessageWithExtensions*)[[[TestEmptyMessageWithExtensions_Builder builder] mergeFromInputStream:input] build];
}
+ (TestEmptyMessageWithExtensions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestEmptyMessageWithExtensions*)[[[TestEmptyMessageWithExtensions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestEmptyMessageWithExtensions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestEmptyMessageWithExtensions*)[[[TestEmptyMessageWithExtensions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestEmptyMessageWithExtensions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestEmptyMessageWithExtensions*)[[[TestEmptyMessageWithExtensions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestEmptyMessageWithExtensions_Builder*) createBuilder {
  return [TestEmptyMessageWithExtensions_Builder builder];
}
@end

@implementation TestEmptyMessageWithExtensions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestEmptyMessageWithExtensions alloc] init] autorelease];
  }
  return self;
}
+ (TestEmptyMessageWithExtensions_Builder*) builder {
  return [[[TestEmptyMessageWithExtensions_Builder alloc] init] autorelease];
}
+ (TestEmptyMessageWithExtensions_Builder*) builderWithPrototype:(TestEmptyMessageWithExtensions*) prototype {
  return [[TestEmptyMessageWithExtensions_Builder builder] mergeFromTestEmptyMessageWithExtensions:prototype];
}
- (TestEmptyMessageWithExtensions*) internalGetResult {
  return result;
}
- (TestEmptyMessageWithExtensions_Builder*) clear {
  self.result = [[[TestEmptyMessageWithExtensions alloc] init] autorelease];
  return self;
}
- (TestEmptyMessageWithExtensions_Builder*) clone {
  return [TestEmptyMessageWithExtensions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestEmptyMessageWithExtensions descriptor];
}
- (TestEmptyMessageWithExtensions*) defaultInstance {
  return [TestEmptyMessageWithExtensions defaultInstance];
}
- (TestEmptyMessageWithExtensions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestEmptyMessageWithExtensions*) buildPartial {
  TestEmptyMessageWithExtensions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestEmptyMessageWithExtensions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestEmptyMessageWithExtensions class]]) {
    return [self mergeFromTestEmptyMessageWithExtensions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestEmptyMessageWithExtensions_Builder*) mergeFromTestEmptyMessageWithExtensions:(TestEmptyMessageWithExtensions*) other {
  if (other == [TestEmptyMessageWithExtensions defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestEmptyMessageWithExtensions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestEmptyMessageWithExtensions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface TestReallyLargeTagNumber ()
@property BOOL hasA;
@property int32_t a;
@property BOOL hasBb;
@property int32_t bb;
@end

@implementation TestReallyLargeTagNumber

@synthesize hasA;
@synthesize a;
@synthesize hasBb;
@synthesize bb;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  self.hasBb = NO;
  self.bb = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
    self.bb = 0;
  }
  return self;
}
static TestReallyLargeTagNumber* defaultTestReallyLargeTagNumberInstance = nil;
+ (void) initialize {
  if (self == [TestReallyLargeTagNumber class]) {
    defaultTestReallyLargeTagNumberInstance = [[TestReallyLargeTagNumber alloc] init];
  }
}
+ (TestReallyLargeTagNumber*) defaultInstance {
  return defaultTestReallyLargeTagNumberInstance;
}
- (TestReallyLargeTagNumber*) defaultInstance {
  return defaultTestReallyLargeTagNumberInstance;
}
- (PBDescriptor*) descriptor {
  return [TestReallyLargeTagNumber descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestReallyLargeTagNumber_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestReallyLargeTagNumber_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:1 value:self.a];
  }
  if (hasBb) {
    [output writeInt32:268435455 value:self.bb];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(1, self.a);
  }
  if (hasBb) {
    size += computeInt32Size(268435455, self.bb);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestReallyLargeTagNumber*) parseFromData:(NSData*) data {
  return (TestReallyLargeTagNumber*)[[[TestReallyLargeTagNumber_Builder builder] mergeFromData:data] build];
}
+ (TestReallyLargeTagNumber*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestReallyLargeTagNumber*)[[[TestReallyLargeTagNumber_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestReallyLargeTagNumber*) parseFromInputStream:(NSInputStream*) input {
  return (TestReallyLargeTagNumber*)[[[TestReallyLargeTagNumber_Builder builder] mergeFromInputStream:input] build];
}
+ (TestReallyLargeTagNumber*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestReallyLargeTagNumber*)[[[TestReallyLargeTagNumber_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestReallyLargeTagNumber*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestReallyLargeTagNumber*)[[[TestReallyLargeTagNumber_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestReallyLargeTagNumber*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestReallyLargeTagNumber*)[[[TestReallyLargeTagNumber_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestReallyLargeTagNumber_Builder*) createBuilder {
  return [TestReallyLargeTagNumber_Builder builder];
}
@end

@implementation TestReallyLargeTagNumber_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestReallyLargeTagNumber alloc] init] autorelease];
  }
  return self;
}
+ (TestReallyLargeTagNumber_Builder*) builder {
  return [[[TestReallyLargeTagNumber_Builder alloc] init] autorelease];
}
+ (TestReallyLargeTagNumber_Builder*) builderWithPrototype:(TestReallyLargeTagNumber*) prototype {
  return [[TestReallyLargeTagNumber_Builder builder] mergeFromTestReallyLargeTagNumber:prototype];
}
- (TestReallyLargeTagNumber*) internalGetResult {
  return result;
}
- (TestReallyLargeTagNumber_Builder*) clear {
  self.result = [[[TestReallyLargeTagNumber alloc] init] autorelease];
  return self;
}
- (TestReallyLargeTagNumber_Builder*) clone {
  return [TestReallyLargeTagNumber_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestReallyLargeTagNumber descriptor];
}
- (TestReallyLargeTagNumber*) defaultInstance {
  return [TestReallyLargeTagNumber defaultInstance];
}
- (TestReallyLargeTagNumber*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestReallyLargeTagNumber*) buildPartial {
  TestReallyLargeTagNumber* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestReallyLargeTagNumber_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestReallyLargeTagNumber class]]) {
    return [self mergeFromTestReallyLargeTagNumber:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestReallyLargeTagNumber_Builder*) mergeFromTestReallyLargeTagNumber:(TestReallyLargeTagNumber*) other {
  if (other == [TestReallyLargeTagNumber defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  if (other.hasBb) {
    [self setBb:other.bb];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestReallyLargeTagNumber_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestReallyLargeTagNumber_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setA:[input readInt32]];
        break;
      }
      case 2147483640: {
        [self setBb:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (TestReallyLargeTagNumber_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestReallyLargeTagNumber_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
- (BOOL) hasBb {
  return result.hasBb;
}
- (int32_t) bb {
  return result.bb;
}
- (TestReallyLargeTagNumber_Builder*) setBb:(int32_t) value {
  result.hasBb = YES;
  result.bb = value;
  return self;
}
- (TestReallyLargeTagNumber_Builder*) clearBb {
  result.hasBb = NO;
  result.bb = 0;
  return self;
}
@end

@interface TestRecursiveMessage ()
@property BOOL hasA;
@property (retain) TestRecursiveMessage* a;
@property BOOL hasI;
@property int32_t i;
@end

@implementation TestRecursiveMessage

@synthesize hasA;
@synthesize a;
@synthesize hasI;
@synthesize i;
- (void) dealloc {
  self.hasA = NO;
  self.a = nil;
  self.hasI = NO;
  self.i = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = [TestRecursiveMessage defaultInstance];
    self.i = 0;
  }
  return self;
}
static TestRecursiveMessage* defaultTestRecursiveMessageInstance = nil;
+ (void) initialize {
  if (self == [TestRecursiveMessage class]) {
    defaultTestRecursiveMessageInstance = [[TestRecursiveMessage alloc] init];
  }
}
+ (TestRecursiveMessage*) defaultInstance {
  return defaultTestRecursiveMessageInstance;
}
- (TestRecursiveMessage*) defaultInstance {
  return defaultTestRecursiveMessageInstance;
}
- (PBDescriptor*) descriptor {
  return [TestRecursiveMessage descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestRecursiveMessage_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestRecursiveMessage_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasA) {
    [output writeMessage:1 value:self.a];
  }
  if (hasI) {
    [output writeInt32:2 value:self.i];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (self.hasA) {
    size += computeMessageSize(1, self.a);
  }
  if (hasI) {
    size += computeInt32Size(2, self.i);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestRecursiveMessage*) parseFromData:(NSData*) data {
  return (TestRecursiveMessage*)[[[TestRecursiveMessage_Builder builder] mergeFromData:data] build];
}
+ (TestRecursiveMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRecursiveMessage*)[[[TestRecursiveMessage_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestRecursiveMessage*) parseFromInputStream:(NSInputStream*) input {
  return (TestRecursiveMessage*)[[[TestRecursiveMessage_Builder builder] mergeFromInputStream:input] build];
}
+ (TestRecursiveMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRecursiveMessage*)[[[TestRecursiveMessage_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestRecursiveMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestRecursiveMessage*)[[[TestRecursiveMessage_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestRecursiveMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestRecursiveMessage*)[[[TestRecursiveMessage_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestRecursiveMessage_Builder*) createBuilder {
  return [TestRecursiveMessage_Builder builder];
}
@end

@implementation TestRecursiveMessage_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestRecursiveMessage alloc] init] autorelease];
  }
  return self;
}
+ (TestRecursiveMessage_Builder*) builder {
  return [[[TestRecursiveMessage_Builder alloc] init] autorelease];
}
+ (TestRecursiveMessage_Builder*) builderWithPrototype:(TestRecursiveMessage*) prototype {
  return [[TestRecursiveMessage_Builder builder] mergeFromTestRecursiveMessage:prototype];
}
- (TestRecursiveMessage*) internalGetResult {
  return result;
}
- (TestRecursiveMessage_Builder*) clear {
  self.result = [[[TestRecursiveMessage alloc] init] autorelease];
  return self;
}
- (TestRecursiveMessage_Builder*) clone {
  return [TestRecursiveMessage_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestRecursiveMessage descriptor];
}
- (TestRecursiveMessage*) defaultInstance {
  return [TestRecursiveMessage defaultInstance];
}
- (TestRecursiveMessage*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestRecursiveMessage*) buildPartial {
  TestRecursiveMessage* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestRecursiveMessage_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestRecursiveMessage class]]) {
    return [self mergeFromTestRecursiveMessage:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestRecursiveMessage_Builder*) mergeFromTestRecursiveMessage:(TestRecursiveMessage*) other {
  if (other == [TestRecursiveMessage defaultInstance]) return self;
  if (other.hasA) {
    [self mergeA:other.a];
  }
  if (other.hasI) {
    [self setI:other.i];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestRecursiveMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestRecursiveMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        TestRecursiveMessage_Builder* subBuilder = [TestRecursiveMessage_Builder builder];
        if (self.hasA) {
          [subBuilder mergeFromTestRecursiveMessage:self.a];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setA:[subBuilder buildPartial]];
        break;
      }
      case 16: {
        [self setI:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (TestRecursiveMessage*) a {
  return result.a;
}
- (TestRecursiveMessage_Builder*) setA:(TestRecursiveMessage*) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestRecursiveMessage_Builder*) setABuilder:(TestRecursiveMessage_Builder*) builderForValue {
  return [self setA:[builderForValue build]];
}
- (TestRecursiveMessage_Builder*) mergeA:(TestRecursiveMessage*) value {
  if (result.hasA &&
      result.a != [TestRecursiveMessage defaultInstance]) {
    result.a =
      [[[TestRecursiveMessage_Builder builderWithPrototype:result.a] mergeFromTestRecursiveMessage:value] buildPartial];
  } else {
    result.a = value;
  }
  result.hasA = YES;
  return self;
}
- (TestRecursiveMessage_Builder*) clearA {
  result.hasA = NO;
  result.a = [TestRecursiveMessage defaultInstance];
  return self;
}
- (BOOL) hasI {
  return result.hasI;
}
- (int32_t) i {
  return result.i;
}
- (TestRecursiveMessage_Builder*) setI:(int32_t) value {
  result.hasI = YES;
  result.i = value;
  return self;
}
- (TestRecursiveMessage_Builder*) clearI {
  result.hasI = NO;
  result.i = 0;
  return self;
}
@end

@interface TestMutualRecursionA ()
@property BOOL hasBb;
@property (retain) TestMutualRecursionB* bb;
@end

@implementation TestMutualRecursionA

@synthesize hasBb;
@synthesize bb;
- (void) dealloc {
  self.hasBb = NO;
  self.bb = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.bb = [TestMutualRecursionB defaultInstance];
  }
  return self;
}
static TestMutualRecursionA* defaultTestMutualRecursionAInstance = nil;
+ (void) initialize {
  if (self == [TestMutualRecursionA class]) {
    defaultTestMutualRecursionAInstance = [[TestMutualRecursionA alloc] init];
  }
}
+ (TestMutualRecursionA*) defaultInstance {
  return defaultTestMutualRecursionAInstance;
}
- (TestMutualRecursionA*) defaultInstance {
  return defaultTestMutualRecursionAInstance;
}
- (PBDescriptor*) descriptor {
  return [TestMutualRecursionA descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestMutualRecursionA_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestMutualRecursionA_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasBb) {
    [output writeMessage:1 value:self.bb];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (self.hasBb) {
    size += computeMessageSize(1, self.bb);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestMutualRecursionA*) parseFromData:(NSData*) data {
  return (TestMutualRecursionA*)[[[TestMutualRecursionA_Builder builder] mergeFromData:data] build];
}
+ (TestMutualRecursionA*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMutualRecursionA*)[[[TestMutualRecursionA_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestMutualRecursionA*) parseFromInputStream:(NSInputStream*) input {
  return (TestMutualRecursionA*)[[[TestMutualRecursionA_Builder builder] mergeFromInputStream:input] build];
}
+ (TestMutualRecursionA*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMutualRecursionA*)[[[TestMutualRecursionA_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMutualRecursionA*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestMutualRecursionA*)[[[TestMutualRecursionA_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestMutualRecursionA*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMutualRecursionA*)[[[TestMutualRecursionA_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestMutualRecursionA_Builder*) createBuilder {
  return [TestMutualRecursionA_Builder builder];
}
@end

@implementation TestMutualRecursionA_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestMutualRecursionA alloc] init] autorelease];
  }
  return self;
}
+ (TestMutualRecursionA_Builder*) builder {
  return [[[TestMutualRecursionA_Builder alloc] init] autorelease];
}
+ (TestMutualRecursionA_Builder*) builderWithPrototype:(TestMutualRecursionA*) prototype {
  return [[TestMutualRecursionA_Builder builder] mergeFromTestMutualRecursionA:prototype];
}
- (TestMutualRecursionA*) internalGetResult {
  return result;
}
- (TestMutualRecursionA_Builder*) clear {
  self.result = [[[TestMutualRecursionA alloc] init] autorelease];
  return self;
}
- (TestMutualRecursionA_Builder*) clone {
  return [TestMutualRecursionA_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestMutualRecursionA descriptor];
}
- (TestMutualRecursionA*) defaultInstance {
  return [TestMutualRecursionA defaultInstance];
}
- (TestMutualRecursionA*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestMutualRecursionA*) buildPartial {
  TestMutualRecursionA* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestMutualRecursionA_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestMutualRecursionA class]]) {
    return [self mergeFromTestMutualRecursionA:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestMutualRecursionA_Builder*) mergeFromTestMutualRecursionA:(TestMutualRecursionA*) other {
  if (other == [TestMutualRecursionA defaultInstance]) return self;
  if (other.hasBb) {
    [self mergeBb:other.bb];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestMutualRecursionA_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestMutualRecursionA_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        TestMutualRecursionB_Builder* subBuilder = [TestMutualRecursionB_Builder builder];
        if (self.hasBb) {
          [subBuilder mergeFromTestMutualRecursionB:self.bb];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setBb:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasBb {
  return result.hasBb;
}
- (TestMutualRecursionB*) bb {
  return result.bb;
}
- (TestMutualRecursionA_Builder*) setBb:(TestMutualRecursionB*) value {
  result.hasBb = YES;
  result.bb = value;
  return self;
}
- (TestMutualRecursionA_Builder*) setBbBuilder:(TestMutualRecursionB_Builder*) builderForValue {
  return [self setBb:[builderForValue build]];
}
- (TestMutualRecursionA_Builder*) mergeBb:(TestMutualRecursionB*) value {
  if (result.hasBb &&
      result.bb != [TestMutualRecursionB defaultInstance]) {
    result.bb =
      [[[TestMutualRecursionB_Builder builderWithPrototype:result.bb] mergeFromTestMutualRecursionB:value] buildPartial];
  } else {
    result.bb = value;
  }
  result.hasBb = YES;
  return self;
}
- (TestMutualRecursionA_Builder*) clearBb {
  result.hasBb = NO;
  result.bb = [TestMutualRecursionB defaultInstance];
  return self;
}
@end

@interface TestMutualRecursionB ()
@property BOOL hasA;
@property (retain) TestMutualRecursionA* a;
@property BOOL hasOptionalInt32;
@property int32_t optionalInt32;
@end

@implementation TestMutualRecursionB

@synthesize hasA;
@synthesize a;
@synthesize hasOptionalInt32;
@synthesize optionalInt32;
- (void) dealloc {
  self.hasA = NO;
  self.a = nil;
  self.hasOptionalInt32 = NO;
  self.optionalInt32 = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = [TestMutualRecursionA defaultInstance];
    self.optionalInt32 = 0;
  }
  return self;
}
static TestMutualRecursionB* defaultTestMutualRecursionBInstance = nil;
+ (void) initialize {
  if (self == [TestMutualRecursionB class]) {
    defaultTestMutualRecursionBInstance = [[TestMutualRecursionB alloc] init];
  }
}
+ (TestMutualRecursionB*) defaultInstance {
  return defaultTestMutualRecursionBInstance;
}
- (TestMutualRecursionB*) defaultInstance {
  return defaultTestMutualRecursionBInstance;
}
- (PBDescriptor*) descriptor {
  return [TestMutualRecursionB descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestMutualRecursionB_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestMutualRecursionB_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasA) {
    [output writeMessage:1 value:self.a];
  }
  if (hasOptionalInt32) {
    [output writeInt32:2 value:self.optionalInt32];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (self.hasA) {
    size += computeMessageSize(1, self.a);
  }
  if (hasOptionalInt32) {
    size += computeInt32Size(2, self.optionalInt32);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestMutualRecursionB*) parseFromData:(NSData*) data {
  return (TestMutualRecursionB*)[[[TestMutualRecursionB_Builder builder] mergeFromData:data] build];
}
+ (TestMutualRecursionB*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMutualRecursionB*)[[[TestMutualRecursionB_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestMutualRecursionB*) parseFromInputStream:(NSInputStream*) input {
  return (TestMutualRecursionB*)[[[TestMutualRecursionB_Builder builder] mergeFromInputStream:input] build];
}
+ (TestMutualRecursionB*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMutualRecursionB*)[[[TestMutualRecursionB_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestMutualRecursionB*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestMutualRecursionB*)[[[TestMutualRecursionB_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestMutualRecursionB*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestMutualRecursionB*)[[[TestMutualRecursionB_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestMutualRecursionB_Builder*) createBuilder {
  return [TestMutualRecursionB_Builder builder];
}
@end

@implementation TestMutualRecursionB_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestMutualRecursionB alloc] init] autorelease];
  }
  return self;
}
+ (TestMutualRecursionB_Builder*) builder {
  return [[[TestMutualRecursionB_Builder alloc] init] autorelease];
}
+ (TestMutualRecursionB_Builder*) builderWithPrototype:(TestMutualRecursionB*) prototype {
  return [[TestMutualRecursionB_Builder builder] mergeFromTestMutualRecursionB:prototype];
}
- (TestMutualRecursionB*) internalGetResult {
  return result;
}
- (TestMutualRecursionB_Builder*) clear {
  self.result = [[[TestMutualRecursionB alloc] init] autorelease];
  return self;
}
- (TestMutualRecursionB_Builder*) clone {
  return [TestMutualRecursionB_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestMutualRecursionB descriptor];
}
- (TestMutualRecursionB*) defaultInstance {
  return [TestMutualRecursionB defaultInstance];
}
- (TestMutualRecursionB*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestMutualRecursionB*) buildPartial {
  TestMutualRecursionB* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestMutualRecursionB_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestMutualRecursionB class]]) {
    return [self mergeFromTestMutualRecursionB:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestMutualRecursionB_Builder*) mergeFromTestMutualRecursionB:(TestMutualRecursionB*) other {
  if (other == [TestMutualRecursionB defaultInstance]) return self;
  if (other.hasA) {
    [self mergeA:other.a];
  }
  if (other.hasOptionalInt32) {
    [self setOptionalInt32:other.optionalInt32];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestMutualRecursionB_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestMutualRecursionB_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        TestMutualRecursionA_Builder* subBuilder = [TestMutualRecursionA_Builder builder];
        if (self.hasA) {
          [subBuilder mergeFromTestMutualRecursionA:self.a];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setA:[subBuilder buildPartial]];
        break;
      }
      case 16: {
        [self setOptionalInt32:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (TestMutualRecursionA*) a {
  return result.a;
}
- (TestMutualRecursionB_Builder*) setA:(TestMutualRecursionA*) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestMutualRecursionB_Builder*) setABuilder:(TestMutualRecursionA_Builder*) builderForValue {
  return [self setA:[builderForValue build]];
}
- (TestMutualRecursionB_Builder*) mergeA:(TestMutualRecursionA*) value {
  if (result.hasA &&
      result.a != [TestMutualRecursionA defaultInstance]) {
    result.a =
      [[[TestMutualRecursionA_Builder builderWithPrototype:result.a] mergeFromTestMutualRecursionA:value] buildPartial];
  } else {
    result.a = value;
  }
  result.hasA = YES;
  return self;
}
- (TestMutualRecursionB_Builder*) clearA {
  result.hasA = NO;
  result.a = [TestMutualRecursionA defaultInstance];
  return self;
}
- (BOOL) hasOptionalInt32 {
  return result.hasOptionalInt32;
}
- (int32_t) optionalInt32 {
  return result.optionalInt32;
}
- (TestMutualRecursionB_Builder*) setOptionalInt32:(int32_t) value {
  result.hasOptionalInt32 = YES;
  result.optionalInt32 = value;
  return self;
}
- (TestMutualRecursionB_Builder*) clearOptionalInt32 {
  result.hasOptionalInt32 = NO;
  result.optionalInt32 = 0;
  return self;
}
@end

@interface TestDupFieldNumber ()
@property BOOL hasA;
@property int32_t a;
@property BOOL hasFoo;
@property (retain) TestDupFieldNumber_Foo* foo;
@property BOOL hasBar;
@property (retain) TestDupFieldNumber_Bar* bar;
@end

@implementation TestDupFieldNumber

@synthesize hasA;
@synthesize a;
@synthesize hasFoo;
@synthesize foo;
@synthesize hasBar;
@synthesize bar;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  self.hasFoo = NO;
  self.foo = nil;
  self.hasBar = NO;
  self.bar = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
    self.foo = [TestDupFieldNumber_Foo defaultInstance];
    self.bar = [TestDupFieldNumber_Bar defaultInstance];
  }
  return self;
}
static TestDupFieldNumber* defaultTestDupFieldNumberInstance = nil;
+ (void) initialize {
  if (self == [TestDupFieldNumber class]) {
    defaultTestDupFieldNumberInstance = [[TestDupFieldNumber alloc] init];
  }
}
+ (TestDupFieldNumber*) defaultInstance {
  return defaultTestDupFieldNumberInstance;
}
- (TestDupFieldNumber*) defaultInstance {
  return defaultTestDupFieldNumberInstance;
}
- (PBDescriptor*) descriptor {
  return [TestDupFieldNumber descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestDupFieldNumber_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestDupFieldNumber_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:1 value:self.a];
  }
  if (self.hasFoo) {
    [output writeGroup:2 value:self.foo];
  }
  if (self.hasBar) {
    [output writeGroup:3 value:self.bar];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(1, self.a);
  }
  if (self.hasFoo) {
    size += computeGroupSize(2, self.foo);
  }
  if (self.hasBar) {
    size += computeGroupSize(3, self.bar);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestDupFieldNumber*) parseFromData:(NSData*) data {
  return (TestDupFieldNumber*)[[[TestDupFieldNumber_Builder builder] mergeFromData:data] build];
}
+ (TestDupFieldNumber*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber*)[[[TestDupFieldNumber_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestDupFieldNumber*) parseFromInputStream:(NSInputStream*) input {
  return (TestDupFieldNumber*)[[[TestDupFieldNumber_Builder builder] mergeFromInputStream:input] build];
}
+ (TestDupFieldNumber*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber*)[[[TestDupFieldNumber_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestDupFieldNumber*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestDupFieldNumber*)[[[TestDupFieldNumber_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestDupFieldNumber*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber*)[[[TestDupFieldNumber_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestDupFieldNumber_Builder*) createBuilder {
  return [TestDupFieldNumber_Builder builder];
}
@end

@interface TestDupFieldNumber_Foo ()
@property BOOL hasA;
@property int32_t a;
@end

@implementation TestDupFieldNumber_Foo

@synthesize hasA;
@synthesize a;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
  }
  return self;
}
static TestDupFieldNumber_Foo* defaultTestDupFieldNumber_FooInstance = nil;
+ (void) initialize {
  if (self == [TestDupFieldNumber_Foo class]) {
    defaultTestDupFieldNumber_FooInstance = [[TestDupFieldNumber_Foo alloc] init];
  }
}
+ (TestDupFieldNumber_Foo*) defaultInstance {
  return defaultTestDupFieldNumber_FooInstance;
}
- (TestDupFieldNumber_Foo*) defaultInstance {
  return defaultTestDupFieldNumber_FooInstance;
}
- (PBDescriptor*) descriptor {
  return [TestDupFieldNumber_Foo descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestDupFieldNumber_Foo_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestDupFieldNumber_Foo_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:1 value:self.a];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(1, self.a);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestDupFieldNumber_Foo*) parseFromData:(NSData*) data {
  return (TestDupFieldNumber_Foo*)[[[TestDupFieldNumber_Foo_Builder builder] mergeFromData:data] build];
}
+ (TestDupFieldNumber_Foo*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber_Foo*)[[[TestDupFieldNumber_Foo_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestDupFieldNumber_Foo*) parseFromInputStream:(NSInputStream*) input {
  return (TestDupFieldNumber_Foo*)[[[TestDupFieldNumber_Foo_Builder builder] mergeFromInputStream:input] build];
}
+ (TestDupFieldNumber_Foo*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber_Foo*)[[[TestDupFieldNumber_Foo_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestDupFieldNumber_Foo*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestDupFieldNumber_Foo*)[[[TestDupFieldNumber_Foo_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestDupFieldNumber_Foo*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber_Foo*)[[[TestDupFieldNumber_Foo_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestDupFieldNumber_Foo_Builder*) createBuilder {
  return [TestDupFieldNumber_Foo_Builder builder];
}
@end

@implementation TestDupFieldNumber_Foo_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestDupFieldNumber_Foo alloc] init] autorelease];
  }
  return self;
}
+ (TestDupFieldNumber_Foo_Builder*) builder {
  return [[[TestDupFieldNumber_Foo_Builder alloc] init] autorelease];
}
+ (TestDupFieldNumber_Foo_Builder*) builderWithPrototype:(TestDupFieldNumber_Foo*) prototype {
  return [[TestDupFieldNumber_Foo_Builder builder] mergeFromTestDupFieldNumber_Foo:prototype];
}
- (TestDupFieldNumber_Foo*) internalGetResult {
  return result;
}
- (TestDupFieldNumber_Foo_Builder*) clear {
  self.result = [[[TestDupFieldNumber_Foo alloc] init] autorelease];
  return self;
}
- (TestDupFieldNumber_Foo_Builder*) clone {
  return [TestDupFieldNumber_Foo_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestDupFieldNumber_Foo descriptor];
}
- (TestDupFieldNumber_Foo*) defaultInstance {
  return [TestDupFieldNumber_Foo defaultInstance];
}
- (TestDupFieldNumber_Foo*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestDupFieldNumber_Foo*) buildPartial {
  TestDupFieldNumber_Foo* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestDupFieldNumber_Foo_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestDupFieldNumber_Foo class]]) {
    return [self mergeFromTestDupFieldNumber_Foo:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestDupFieldNumber_Foo_Builder*) mergeFromTestDupFieldNumber_Foo:(TestDupFieldNumber_Foo*) other {
  if (other == [TestDupFieldNumber_Foo defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestDupFieldNumber_Foo_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestDupFieldNumber_Foo_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setA:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (TestDupFieldNumber_Foo_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestDupFieldNumber_Foo_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
@end

@interface TestDupFieldNumber_Bar ()
@property BOOL hasA;
@property int32_t a;
@end

@implementation TestDupFieldNumber_Bar

@synthesize hasA;
@synthesize a;
- (void) dealloc {
  self.hasA = NO;
  self.a = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.a = 0;
  }
  return self;
}
static TestDupFieldNumber_Bar* defaultTestDupFieldNumber_BarInstance = nil;
+ (void) initialize {
  if (self == [TestDupFieldNumber_Bar class]) {
    defaultTestDupFieldNumber_BarInstance = [[TestDupFieldNumber_Bar alloc] init];
  }
}
+ (TestDupFieldNumber_Bar*) defaultInstance {
  return defaultTestDupFieldNumber_BarInstance;
}
- (TestDupFieldNumber_Bar*) defaultInstance {
  return defaultTestDupFieldNumber_BarInstance;
}
- (PBDescriptor*) descriptor {
  return [TestDupFieldNumber_Bar descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestDupFieldNumber_Bar_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestDupFieldNumber_Bar_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasA) {
    [output writeInt32:1 value:self.a];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasA) {
    size += computeInt32Size(1, self.a);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestDupFieldNumber_Bar*) parseFromData:(NSData*) data {
  return (TestDupFieldNumber_Bar*)[[[TestDupFieldNumber_Bar_Builder builder] mergeFromData:data] build];
}
+ (TestDupFieldNumber_Bar*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber_Bar*)[[[TestDupFieldNumber_Bar_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestDupFieldNumber_Bar*) parseFromInputStream:(NSInputStream*) input {
  return (TestDupFieldNumber_Bar*)[[[TestDupFieldNumber_Bar_Builder builder] mergeFromInputStream:input] build];
}
+ (TestDupFieldNumber_Bar*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber_Bar*)[[[TestDupFieldNumber_Bar_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestDupFieldNumber_Bar*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestDupFieldNumber_Bar*)[[[TestDupFieldNumber_Bar_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestDupFieldNumber_Bar*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestDupFieldNumber_Bar*)[[[TestDupFieldNumber_Bar_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestDupFieldNumber_Bar_Builder*) createBuilder {
  return [TestDupFieldNumber_Bar_Builder builder];
}
@end

@implementation TestDupFieldNumber_Bar_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestDupFieldNumber_Bar alloc] init] autorelease];
  }
  return self;
}
+ (TestDupFieldNumber_Bar_Builder*) builder {
  return [[[TestDupFieldNumber_Bar_Builder alloc] init] autorelease];
}
+ (TestDupFieldNumber_Bar_Builder*) builderWithPrototype:(TestDupFieldNumber_Bar*) prototype {
  return [[TestDupFieldNumber_Bar_Builder builder] mergeFromTestDupFieldNumber_Bar:prototype];
}
- (TestDupFieldNumber_Bar*) internalGetResult {
  return result;
}
- (TestDupFieldNumber_Bar_Builder*) clear {
  self.result = [[[TestDupFieldNumber_Bar alloc] init] autorelease];
  return self;
}
- (TestDupFieldNumber_Bar_Builder*) clone {
  return [TestDupFieldNumber_Bar_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestDupFieldNumber_Bar descriptor];
}
- (TestDupFieldNumber_Bar*) defaultInstance {
  return [TestDupFieldNumber_Bar defaultInstance];
}
- (TestDupFieldNumber_Bar*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestDupFieldNumber_Bar*) buildPartial {
  TestDupFieldNumber_Bar* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestDupFieldNumber_Bar_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestDupFieldNumber_Bar class]]) {
    return [self mergeFromTestDupFieldNumber_Bar:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestDupFieldNumber_Bar_Builder*) mergeFromTestDupFieldNumber_Bar:(TestDupFieldNumber_Bar*) other {
  if (other == [TestDupFieldNumber_Bar defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestDupFieldNumber_Bar_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestDupFieldNumber_Bar_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setA:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (TestDupFieldNumber_Bar_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestDupFieldNumber_Bar_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
@end

@implementation TestDupFieldNumber_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestDupFieldNumber alloc] init] autorelease];
  }
  return self;
}
+ (TestDupFieldNumber_Builder*) builder {
  return [[[TestDupFieldNumber_Builder alloc] init] autorelease];
}
+ (TestDupFieldNumber_Builder*) builderWithPrototype:(TestDupFieldNumber*) prototype {
  return [[TestDupFieldNumber_Builder builder] mergeFromTestDupFieldNumber:prototype];
}
- (TestDupFieldNumber*) internalGetResult {
  return result;
}
- (TestDupFieldNumber_Builder*) clear {
  self.result = [[[TestDupFieldNumber alloc] init] autorelease];
  return self;
}
- (TestDupFieldNumber_Builder*) clone {
  return [TestDupFieldNumber_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestDupFieldNumber descriptor];
}
- (TestDupFieldNumber*) defaultInstance {
  return [TestDupFieldNumber defaultInstance];
}
- (TestDupFieldNumber*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestDupFieldNumber*) buildPartial {
  TestDupFieldNumber* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestDupFieldNumber_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestDupFieldNumber class]]) {
    return [self mergeFromTestDupFieldNumber:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestDupFieldNumber_Builder*) mergeFromTestDupFieldNumber:(TestDupFieldNumber*) other {
  if (other == [TestDupFieldNumber defaultInstance]) return self;
  if (other.hasA) {
    [self setA:other.a];
  }
  if (other.hasFoo) {
    [self mergeFoo:other.foo];
  }
  if (other.hasBar) {
    [self mergeBar:other.bar];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestDupFieldNumber_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestDupFieldNumber_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setA:[input readInt32]];
        break;
      }
      case 19: {
        TestDupFieldNumber_Foo_Builder* subBuilder = [TestDupFieldNumber_Foo_Builder builder];
        if (self.hasFoo) {
          [subBuilder mergeFromTestDupFieldNumber_Foo:self.foo];
        }
        [input readGroup:2 builder:subBuilder extensionRegistry:extensionRegistry];
        [self setFoo:[subBuilder buildPartial]];
        break;
      }
      case 27: {
        TestDupFieldNumber_Bar_Builder* subBuilder = [TestDupFieldNumber_Bar_Builder builder];
        if (self.hasBar) {
          [subBuilder mergeFromTestDupFieldNumber_Bar:self.bar];
        }
        [input readGroup:3 builder:subBuilder extensionRegistry:extensionRegistry];
        [self setBar:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasA {
  return result.hasA;
}
- (int32_t) a {
  return result.a;
}
- (TestDupFieldNumber_Builder*) setA:(int32_t) value {
  result.hasA = YES;
  result.a = value;
  return self;
}
- (TestDupFieldNumber_Builder*) clearA {
  result.hasA = NO;
  result.a = 0;
  return self;
}
- (BOOL) hasFoo {
  return result.hasFoo;
}
- (TestDupFieldNumber_Foo*) foo {
  return result.foo;
}
- (TestDupFieldNumber_Builder*) setFoo:(TestDupFieldNumber_Foo*) value {
  result.hasFoo = YES;
  result.foo = value;
  return self;
}
- (TestDupFieldNumber_Builder*) setFooBuilder:(TestDupFieldNumber_Foo_Builder*) builderForValue {
  return [self setFoo:[builderForValue build]];
}
- (TestDupFieldNumber_Builder*) mergeFoo:(TestDupFieldNumber_Foo*) value {
  if (result.hasFoo &&
      result.foo != [TestDupFieldNumber_Foo defaultInstance]) {
    result.foo =
      [[[TestDupFieldNumber_Foo_Builder builderWithPrototype:result.foo] mergeFromTestDupFieldNumber_Foo:value] buildPartial];
  } else {
    result.foo = value;
  }
  result.hasFoo = YES;
  return self;
}
- (TestDupFieldNumber_Builder*) clearFoo {
  result.hasFoo = NO;
  result.foo = [TestDupFieldNumber_Foo defaultInstance];
  return self;
}
- (BOOL) hasBar {
  return result.hasBar;
}
- (TestDupFieldNumber_Bar*) bar {
  return result.bar;
}
- (TestDupFieldNumber_Builder*) setBar:(TestDupFieldNumber_Bar*) value {
  result.hasBar = YES;
  result.bar = value;
  return self;
}
- (TestDupFieldNumber_Builder*) setBarBuilder:(TestDupFieldNumber_Bar_Builder*) builderForValue {
  return [self setBar:[builderForValue build]];
}
- (TestDupFieldNumber_Builder*) mergeBar:(TestDupFieldNumber_Bar*) value {
  if (result.hasBar &&
      result.bar != [TestDupFieldNumber_Bar defaultInstance]) {
    result.bar =
      [[[TestDupFieldNumber_Bar_Builder builderWithPrototype:result.bar] mergeFromTestDupFieldNumber_Bar:value] buildPartial];
  } else {
    result.bar = value;
  }
  result.hasBar = YES;
  return self;
}
- (TestDupFieldNumber_Builder*) clearBar {
  result.hasBar = NO;
  result.bar = [TestDupFieldNumber_Bar defaultInstance];
  return self;
}
@end

@interface TestNestedMessageHasBits ()
@property BOOL hasOptionalNestedMessage;
@property (retain) TestNestedMessageHasBits_NestedMessage* optionalNestedMessage;
@end

@implementation TestNestedMessageHasBits

@synthesize hasOptionalNestedMessage;
@synthesize optionalNestedMessage;
- (void) dealloc {
  self.hasOptionalNestedMessage = NO;
  self.optionalNestedMessage = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.optionalNestedMessage = [TestNestedMessageHasBits_NestedMessage defaultInstance];
  }
  return self;
}
static TestNestedMessageHasBits* defaultTestNestedMessageHasBitsInstance = nil;
+ (void) initialize {
  if (self == [TestNestedMessageHasBits class]) {
    defaultTestNestedMessageHasBitsInstance = [[TestNestedMessageHasBits alloc] init];
  }
}
+ (TestNestedMessageHasBits*) defaultInstance {
  return defaultTestNestedMessageHasBitsInstance;
}
- (TestNestedMessageHasBits*) defaultInstance {
  return defaultTestNestedMessageHasBitsInstance;
}
- (PBDescriptor*) descriptor {
  return [TestNestedMessageHasBits descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestNestedMessageHasBits_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestNestedMessageHasBits_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasOptionalNestedMessage) {
    [output writeMessage:1 value:self.optionalNestedMessage];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (self.hasOptionalNestedMessage) {
    size += computeMessageSize(1, self.optionalNestedMessage);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestNestedMessageHasBits*) parseFromData:(NSData*) data {
  return (TestNestedMessageHasBits*)[[[TestNestedMessageHasBits_Builder builder] mergeFromData:data] build];
}
+ (TestNestedMessageHasBits*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestNestedMessageHasBits*)[[[TestNestedMessageHasBits_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestNestedMessageHasBits*) parseFromInputStream:(NSInputStream*) input {
  return (TestNestedMessageHasBits*)[[[TestNestedMessageHasBits_Builder builder] mergeFromInputStream:input] build];
}
+ (TestNestedMessageHasBits*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestNestedMessageHasBits*)[[[TestNestedMessageHasBits_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestNestedMessageHasBits*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestNestedMessageHasBits*)[[[TestNestedMessageHasBits_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestNestedMessageHasBits*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestNestedMessageHasBits*)[[[TestNestedMessageHasBits_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestNestedMessageHasBits_Builder*) createBuilder {
  return [TestNestedMessageHasBits_Builder builder];
}
@end

@interface TestNestedMessageHasBits_NestedMessage ()
@property (retain) NSMutableArray* mutableNestedmessageRepeatedInt32List;
@property (retain) NSMutableArray* mutableNestedmessageRepeatedForeignmessageList;
@end

@implementation TestNestedMessageHasBits_NestedMessage

@synthesize mutableNestedmessageRepeatedInt32List;
@synthesize mutableNestedmessageRepeatedForeignmessageList;
- (void) dealloc {
  self.mutableNestedmessageRepeatedInt32List = nil;
  self.mutableNestedmessageRepeatedForeignmessageList = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static TestNestedMessageHasBits_NestedMessage* defaultTestNestedMessageHasBits_NestedMessageInstance = nil;
+ (void) initialize {
  if (self == [TestNestedMessageHasBits_NestedMessage class]) {
    defaultTestNestedMessageHasBits_NestedMessageInstance = [[TestNestedMessageHasBits_NestedMessage alloc] init];
  }
}
+ (TestNestedMessageHasBits_NestedMessage*) defaultInstance {
  return defaultTestNestedMessageHasBits_NestedMessageInstance;
}
- (TestNestedMessageHasBits_NestedMessage*) defaultInstance {
  return defaultTestNestedMessageHasBits_NestedMessageInstance;
}
- (PBDescriptor*) descriptor {
  return [TestNestedMessageHasBits_NestedMessage descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestNestedMessageHasBits_NestedMessage_fieldAccessorTable];
}
- (NSArray*) nestedmessageRepeatedInt32List {
  return mutableNestedmessageRepeatedInt32List;
}
- (int32_t) nestedmessageRepeatedInt32AtIndex:(int32_t) index {
  id value = [mutableNestedmessageRepeatedInt32List objectAtIndex:index];
  return [value intValue];
}
- (NSArray*) nestedmessageRepeatedForeignmessageList {
  return mutableNestedmessageRepeatedForeignmessageList;
}
- (ForeignMessage*) nestedmessageRepeatedForeignmessageAtIndex:(int32_t) index {
  id value = [mutableNestedmessageRepeatedForeignmessageList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  for (NSNumber* value in self.mutableNestedmessageRepeatedInt32List) {
    [output writeInt32:1 value:[value intValue]];
  }
  for (ForeignMessage* element in self.nestedmessageRepeatedForeignmessageList) {
    [output writeMessage:2 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  for (NSNumber* value in self.mutableNestedmessageRepeatedInt32List) {
    size += computeInt32Size(1, [value intValue]);
  }
  for (ForeignMessage* element in self.nestedmessageRepeatedForeignmessageList) {
    size += computeMessageSize(2, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestNestedMessageHasBits_NestedMessage*) parseFromData:(NSData*) data {
  return (TestNestedMessageHasBits_NestedMessage*)[[[TestNestedMessageHasBits_NestedMessage_Builder builder] mergeFromData:data] build];
}
+ (TestNestedMessageHasBits_NestedMessage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestNestedMessageHasBits_NestedMessage*)[[[TestNestedMessageHasBits_NestedMessage_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestNestedMessageHasBits_NestedMessage*) parseFromInputStream:(NSInputStream*) input {
  return (TestNestedMessageHasBits_NestedMessage*)[[[TestNestedMessageHasBits_NestedMessage_Builder builder] mergeFromInputStream:input] build];
}
+ (TestNestedMessageHasBits_NestedMessage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestNestedMessageHasBits_NestedMessage*)[[[TestNestedMessageHasBits_NestedMessage_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestNestedMessageHasBits_NestedMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestNestedMessageHasBits_NestedMessage*)[[[TestNestedMessageHasBits_NestedMessage_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestNestedMessageHasBits_NestedMessage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestNestedMessageHasBits_NestedMessage*)[[[TestNestedMessageHasBits_NestedMessage_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) createBuilder {
  return [TestNestedMessageHasBits_NestedMessage_Builder builder];
}
@end

@implementation TestNestedMessageHasBits_NestedMessage_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestNestedMessageHasBits_NestedMessage alloc] init] autorelease];
  }
  return self;
}
+ (TestNestedMessageHasBits_NestedMessage_Builder*) builder {
  return [[[TestNestedMessageHasBits_NestedMessage_Builder alloc] init] autorelease];
}
+ (TestNestedMessageHasBits_NestedMessage_Builder*) builderWithPrototype:(TestNestedMessageHasBits_NestedMessage*) prototype {
  return [[TestNestedMessageHasBits_NestedMessage_Builder builder] mergeFromTestNestedMessageHasBits_NestedMessage:prototype];
}
- (TestNestedMessageHasBits_NestedMessage*) internalGetResult {
  return result;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) clear {
  self.result = [[[TestNestedMessageHasBits_NestedMessage alloc] init] autorelease];
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) clone {
  return [TestNestedMessageHasBits_NestedMessage_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestNestedMessageHasBits_NestedMessage descriptor];
}
- (TestNestedMessageHasBits_NestedMessage*) defaultInstance {
  return [TestNestedMessageHasBits_NestedMessage defaultInstance];
}
- (TestNestedMessageHasBits_NestedMessage*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestNestedMessageHasBits_NestedMessage*) buildPartial {
  TestNestedMessageHasBits_NestedMessage* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestNestedMessageHasBits_NestedMessage class]]) {
    return [self mergeFromTestNestedMessageHasBits_NestedMessage:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) mergeFromTestNestedMessageHasBits_NestedMessage:(TestNestedMessageHasBits_NestedMessage*) other {
  if (other == [TestNestedMessageHasBits_NestedMessage defaultInstance]) return self;
  if (other.mutableNestedmessageRepeatedInt32List.count > 0) {
    if (result.mutableNestedmessageRepeatedInt32List == nil) {
      result.mutableNestedmessageRepeatedInt32List = [NSMutableArray array];
    }
    [result.mutableNestedmessageRepeatedInt32List addObjectsFromArray:other.mutableNestedmessageRepeatedInt32List];
  }
  if (other.mutableNestedmessageRepeatedForeignmessageList.count > 0) {
    if (result.mutableNestedmessageRepeatedForeignmessageList == nil) {
      result.mutableNestedmessageRepeatedForeignmessageList = [NSMutableArray array];
    }
    [result.mutableNestedmessageRepeatedForeignmessageList addObjectsFromArray:other.mutableNestedmessageRepeatedForeignmessageList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self addNestedmessageRepeatedInt32:[input readInt32]];
        break;
      }
      case 18: {
        ForeignMessage_Builder* subBuilder = [ForeignMessage_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addNestedmessageRepeatedForeignmessage:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (NSArray*) nestedmessageRepeatedInt32List {
  if (result.mutableNestedmessageRepeatedInt32List == nil) { return [NSArray array]; }
  return result.mutableNestedmessageRepeatedInt32List;
}
- (int32_t) nestedmessageRepeatedInt32AtIndex:(int32_t) index {
  return [result nestedmessageRepeatedInt32AtIndex:index];
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) replaceNestedmessageRepeatedInt32AtIndex:(int32_t) index withNestedmessageRepeatedInt32:(int32_t) value {
  [result.mutableNestedmessageRepeatedInt32List replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) addNestedmessageRepeatedInt32:(int32_t) value {
  if (result.mutableNestedmessageRepeatedInt32List == nil) {
    result.mutableNestedmessageRepeatedInt32List = [NSMutableArray array];
  }
  [result.mutableNestedmessageRepeatedInt32List addObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) addAllNestedmessageRepeatedInt32:(NSArray*) values {
  if (result.mutableNestedmessageRepeatedInt32List == nil) {
    result.mutableNestedmessageRepeatedInt32List = [NSMutableArray array];
  }
  [result.mutableNestedmessageRepeatedInt32List addObjectsFromArray:values];
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) clearNestedmessageRepeatedInt32List {
  result.mutableNestedmessageRepeatedInt32List = nil;
  return self;
}
- (NSArray*) nestedmessageRepeatedForeignmessageList {
  if (result.mutableNestedmessageRepeatedForeignmessageList == nil) { return [NSArray array]; }
  return result.mutableNestedmessageRepeatedForeignmessageList;
}
- (ForeignMessage*) nestedmessageRepeatedForeignmessageAtIndex:(int32_t) index {
  return [result nestedmessageRepeatedForeignmessageAtIndex:index];
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) replaceNestedmessageRepeatedForeignmessageAtIndex:(int32_t) index withNestedmessageRepeatedForeignmessage:(ForeignMessage*) value {
  [result.mutableNestedmessageRepeatedForeignmessageList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) addAllNestedmessageRepeatedForeignmessage:(NSArray*) values {
  if (result.mutableNestedmessageRepeatedForeignmessageList == nil) {
    result.mutableNestedmessageRepeatedForeignmessageList = [NSMutableArray array];
  }
  [result.mutableNestedmessageRepeatedForeignmessageList addObjectsFromArray:values];
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) clearNestedmessageRepeatedForeignmessageList {
  result.mutableNestedmessageRepeatedForeignmessageList = nil;
  return self;
}
- (TestNestedMessageHasBits_NestedMessage_Builder*) addNestedmessageRepeatedForeignmessage:(ForeignMessage*) value {
  if (result.mutableNestedmessageRepeatedForeignmessageList == nil) {
    result.mutableNestedmessageRepeatedForeignmessageList = [NSMutableArray array];
  }
  [result.mutableNestedmessageRepeatedForeignmessageList addObject:value];
  return self;
}
@end

@implementation TestNestedMessageHasBits_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestNestedMessageHasBits alloc] init] autorelease];
  }
  return self;
}
+ (TestNestedMessageHasBits_Builder*) builder {
  return [[[TestNestedMessageHasBits_Builder alloc] init] autorelease];
}
+ (TestNestedMessageHasBits_Builder*) builderWithPrototype:(TestNestedMessageHasBits*) prototype {
  return [[TestNestedMessageHasBits_Builder builder] mergeFromTestNestedMessageHasBits:prototype];
}
- (TestNestedMessageHasBits*) internalGetResult {
  return result;
}
- (TestNestedMessageHasBits_Builder*) clear {
  self.result = [[[TestNestedMessageHasBits alloc] init] autorelease];
  return self;
}
- (TestNestedMessageHasBits_Builder*) clone {
  return [TestNestedMessageHasBits_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestNestedMessageHasBits descriptor];
}
- (TestNestedMessageHasBits*) defaultInstance {
  return [TestNestedMessageHasBits defaultInstance];
}
- (TestNestedMessageHasBits*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestNestedMessageHasBits*) buildPartial {
  TestNestedMessageHasBits* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestNestedMessageHasBits_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestNestedMessageHasBits class]]) {
    return [self mergeFromTestNestedMessageHasBits:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestNestedMessageHasBits_Builder*) mergeFromTestNestedMessageHasBits:(TestNestedMessageHasBits*) other {
  if (other == [TestNestedMessageHasBits defaultInstance]) return self;
  if (other.hasOptionalNestedMessage) {
    [self mergeOptionalNestedMessage:other.optionalNestedMessage];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestNestedMessageHasBits_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestNestedMessageHasBits_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        TestNestedMessageHasBits_NestedMessage_Builder* subBuilder = [TestNestedMessageHasBits_NestedMessage_Builder builder];
        if (self.hasOptionalNestedMessage) {
          [subBuilder mergeFromTestNestedMessageHasBits_NestedMessage:self.optionalNestedMessage];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptionalNestedMessage:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasOptionalNestedMessage {
  return result.hasOptionalNestedMessage;
}
- (TestNestedMessageHasBits_NestedMessage*) optionalNestedMessage {
  return result.optionalNestedMessage;
}
- (TestNestedMessageHasBits_Builder*) setOptionalNestedMessage:(TestNestedMessageHasBits_NestedMessage*) value {
  result.hasOptionalNestedMessage = YES;
  result.optionalNestedMessage = value;
  return self;
}
- (TestNestedMessageHasBits_Builder*) setOptionalNestedMessageBuilder:(TestNestedMessageHasBits_NestedMessage_Builder*) builderForValue {
  return [self setOptionalNestedMessage:[builderForValue build]];
}
- (TestNestedMessageHasBits_Builder*) mergeOptionalNestedMessage:(TestNestedMessageHasBits_NestedMessage*) value {
  if (result.hasOptionalNestedMessage &&
      result.optionalNestedMessage != [TestNestedMessageHasBits_NestedMessage defaultInstance]) {
    result.optionalNestedMessage =
      [[[TestNestedMessageHasBits_NestedMessage_Builder builderWithPrototype:result.optionalNestedMessage] mergeFromTestNestedMessageHasBits_NestedMessage:value] buildPartial];
  } else {
    result.optionalNestedMessage = value;
  }
  result.hasOptionalNestedMessage = YES;
  return self;
}
- (TestNestedMessageHasBits_Builder*) clearOptionalNestedMessage {
  result.hasOptionalNestedMessage = NO;
  result.optionalNestedMessage = [TestNestedMessageHasBits_NestedMessage defaultInstance];
  return self;
}
@end

@interface TestCamelCaseFieldNames ()
@property BOOL hasPrimitiveField;
@property int32_t primitiveField;
@property BOOL hasStringField;
@property (retain) NSString* stringField;
@property BOOL hasEnumField;
@property (retain) ForeignEnum* enumField;
@property BOOL hasMessageField;
@property (retain) ForeignMessage* messageField;
@property BOOL hasStringPieceField;
@property (retain) NSString* stringPieceField;
@property BOOL hasCordField;
@property (retain) NSString* cordField;
@property (retain) NSMutableArray* mutableRepeatedPrimitiveFieldList;
@property (retain) NSMutableArray* mutableRepeatedStringFieldList;
@property (retain) NSMutableArray* mutableRepeatedEnumFieldList;
@property (retain) NSMutableArray* mutableRepeatedMessageFieldList;
@property (retain) NSMutableArray* mutableRepeatedStringPieceFieldList;
@property (retain) NSMutableArray* mutableRepeatedCordFieldList;
@end

@implementation TestCamelCaseFieldNames

@synthesize hasPrimitiveField;
@synthesize primitiveField;
@synthesize hasStringField;
@synthesize stringField;
@synthesize hasEnumField;
@synthesize enumField;
@synthesize hasMessageField;
@synthesize messageField;
@synthesize hasStringPieceField;
@synthesize stringPieceField;
@synthesize hasCordField;
@synthesize cordField;
@synthesize mutableRepeatedPrimitiveFieldList;
@synthesize mutableRepeatedStringFieldList;
@synthesize mutableRepeatedEnumFieldList;
@synthesize mutableRepeatedMessageFieldList;
@synthesize mutableRepeatedStringPieceFieldList;
@synthesize mutableRepeatedCordFieldList;
- (void) dealloc {
  self.hasPrimitiveField = NO;
  self.primitiveField = 0;
  self.hasStringField = NO;
  self.stringField = nil;
  self.hasEnumField = NO;
  self.enumField = nil;
  self.hasMessageField = NO;
  self.messageField = nil;
  self.hasStringPieceField = NO;
  self.stringPieceField = nil;
  self.hasCordField = NO;
  self.cordField = nil;
  self.mutableRepeatedPrimitiveFieldList = nil;
  self.mutableRepeatedStringFieldList = nil;
  self.mutableRepeatedEnumFieldList = nil;
  self.mutableRepeatedMessageFieldList = nil;
  self.mutableRepeatedStringPieceFieldList = nil;
  self.mutableRepeatedCordFieldList = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.primitiveField = 0;
    self.stringField = @"";
    self.enumField = [ForeignEnum FOREIGN_FOO];
    self.messageField = [ForeignMessage defaultInstance];
    self.stringPieceField = @"";
    self.cordField = @"";
  }
  return self;
}
static TestCamelCaseFieldNames* defaultTestCamelCaseFieldNamesInstance = nil;
+ (void) initialize {
  if (self == [TestCamelCaseFieldNames class]) {
    defaultTestCamelCaseFieldNamesInstance = [[TestCamelCaseFieldNames alloc] init];
  }
}
+ (TestCamelCaseFieldNames*) defaultInstance {
  return defaultTestCamelCaseFieldNamesInstance;
}
- (TestCamelCaseFieldNames*) defaultInstance {
  return defaultTestCamelCaseFieldNamesInstance;
}
- (PBDescriptor*) descriptor {
  return [TestCamelCaseFieldNames descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestCamelCaseFieldNames_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestCamelCaseFieldNames_fieldAccessorTable];
}
- (NSArray*) repeatedPrimitiveFieldList {
  return mutableRepeatedPrimitiveFieldList;
}
- (int32_t) repeatedPrimitiveFieldAtIndex:(int32_t) index {
  id value = [mutableRepeatedPrimitiveFieldList objectAtIndex:index];
  return [value intValue];
}
- (NSArray*) repeatedStringFieldList {
  return mutableRepeatedStringFieldList;
}
- (NSString*) repeatedStringFieldAtIndex:(int32_t) index {
  id value = [mutableRepeatedStringFieldList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedEnumFieldList {
  return mutableRepeatedEnumFieldList;
}
- (ForeignEnum*) repeatedEnumFieldAtIndex:(int32_t) index {
  id value = [mutableRepeatedEnumFieldList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedMessageFieldList {
  return mutableRepeatedMessageFieldList;
}
- (ForeignMessage*) repeatedMessageFieldAtIndex:(int32_t) index {
  id value = [mutableRepeatedMessageFieldList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedStringPieceFieldList {
  return mutableRepeatedStringPieceFieldList;
}
- (NSString*) repeatedStringPieceFieldAtIndex:(int32_t) index {
  id value = [mutableRepeatedStringPieceFieldList objectAtIndex:index];
  return value;
}
- (NSArray*) repeatedCordFieldList {
  return mutableRepeatedCordFieldList;
}
- (NSString*) repeatedCordFieldAtIndex:(int32_t) index {
  id value = [mutableRepeatedCordFieldList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasPrimitiveField) {
    [output writeInt32:1 value:self.primitiveField];
  }
  if (hasStringField) {
    [output writeString:2 value:self.stringField];
  }
  if (self.hasEnumField) {
    [output writeEnum:3 value:self.enumField.number];
  }
  if (self.hasMessageField) {
    [output writeMessage:4 value:self.messageField];
  }
  if (hasStringPieceField) {
    [output writeString:5 value:self.stringPieceField];
  }
  if (hasCordField) {
    [output writeString:6 value:self.cordField];
  }
  for (NSNumber* value in self.mutableRepeatedPrimitiveFieldList) {
    [output writeInt32:7 value:[value intValue]];
  }
  for (NSString* element in self.mutableRepeatedStringFieldList) {
    [output writeString:8 value:element];
  }
  for (ForeignEnum* element in self.repeatedEnumFieldList) {
    [output writeEnum:9 value:element.number];
  }
  for (ForeignMessage* element in self.repeatedMessageFieldList) {
    [output writeMessage:10 value:element];
  }
  for (NSString* element in self.mutableRepeatedStringPieceFieldList) {
    [output writeString:11 value:element];
  }
  for (NSString* element in self.mutableRepeatedCordFieldList) {
    [output writeString:12 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasPrimitiveField) {
    size += computeInt32Size(1, self.primitiveField);
  }
  if (hasStringField) {
    size += computeStringSize(2, self.stringField);
  }
  if (self.hasEnumField) {
    size += computeEnumSize(3, self.enumField.number);
  }
  if (self.hasMessageField) {
    size += computeMessageSize(4, self.messageField);
  }
  if (hasStringPieceField) {
    size += computeStringSize(5, self.stringPieceField);
  }
  if (hasCordField) {
    size += computeStringSize(6, self.cordField);
  }
  for (NSNumber* value in self.mutableRepeatedPrimitiveFieldList) {
    size += computeInt32Size(7, [value intValue]);
  }
  for (NSString* element in self.mutableRepeatedStringFieldList) {
    size += computeStringSize(8, element);
  }
  for (ForeignEnum* element in self.repeatedEnumFieldList) {
    size += computeEnumSize(9, element.number);
  }
  for (ForeignMessage* element in self.repeatedMessageFieldList) {
    size += computeMessageSize(10, element);
  }
  for (NSString* element in self.mutableRepeatedStringPieceFieldList) {
    size += computeStringSize(11, element);
  }
  for (NSString* element in self.mutableRepeatedCordFieldList) {
    size += computeStringSize(12, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestCamelCaseFieldNames*) parseFromData:(NSData*) data {
  return (TestCamelCaseFieldNames*)[[[TestCamelCaseFieldNames_Builder builder] mergeFromData:data] build];
}
+ (TestCamelCaseFieldNames*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestCamelCaseFieldNames*)[[[TestCamelCaseFieldNames_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestCamelCaseFieldNames*) parseFromInputStream:(NSInputStream*) input {
  return (TestCamelCaseFieldNames*)[[[TestCamelCaseFieldNames_Builder builder] mergeFromInputStream:input] build];
}
+ (TestCamelCaseFieldNames*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestCamelCaseFieldNames*)[[[TestCamelCaseFieldNames_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestCamelCaseFieldNames*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestCamelCaseFieldNames*)[[[TestCamelCaseFieldNames_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestCamelCaseFieldNames*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestCamelCaseFieldNames*)[[[TestCamelCaseFieldNames_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestCamelCaseFieldNames_Builder*) createBuilder {
  return [TestCamelCaseFieldNames_Builder builder];
}
@end

@implementation TestCamelCaseFieldNames_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestCamelCaseFieldNames alloc] init] autorelease];
  }
  return self;
}
+ (TestCamelCaseFieldNames_Builder*) builder {
  return [[[TestCamelCaseFieldNames_Builder alloc] init] autorelease];
}
+ (TestCamelCaseFieldNames_Builder*) builderWithPrototype:(TestCamelCaseFieldNames*) prototype {
  return [[TestCamelCaseFieldNames_Builder builder] mergeFromTestCamelCaseFieldNames:prototype];
}
- (TestCamelCaseFieldNames*) internalGetResult {
  return result;
}
- (TestCamelCaseFieldNames_Builder*) clear {
  self.result = [[[TestCamelCaseFieldNames alloc] init] autorelease];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clone {
  return [TestCamelCaseFieldNames_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestCamelCaseFieldNames descriptor];
}
- (TestCamelCaseFieldNames*) defaultInstance {
  return [TestCamelCaseFieldNames defaultInstance];
}
- (TestCamelCaseFieldNames*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestCamelCaseFieldNames*) buildPartial {
  TestCamelCaseFieldNames* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestCamelCaseFieldNames_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestCamelCaseFieldNames class]]) {
    return [self mergeFromTestCamelCaseFieldNames:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestCamelCaseFieldNames_Builder*) mergeFromTestCamelCaseFieldNames:(TestCamelCaseFieldNames*) other {
  if (other == [TestCamelCaseFieldNames defaultInstance]) return self;
  if (other.hasPrimitiveField) {
    [self setPrimitiveField:other.primitiveField];
  }
  if (other.hasStringField) {
    [self setStringField:other.stringField];
  }
  if (other.hasEnumField) {
    [self setEnumField:other.enumField];
  }
  if (other.hasMessageField) {
    [self mergeMessageField:other.messageField];
  }
  if (other.hasStringPieceField) {
    [self setStringPieceField:other.stringPieceField];
  }
  if (other.hasCordField) {
    [self setCordField:other.cordField];
  }
  if (other.mutableRepeatedPrimitiveFieldList.count > 0) {
    if (result.mutableRepeatedPrimitiveFieldList == nil) {
      result.mutableRepeatedPrimitiveFieldList = [NSMutableArray array];
    }
    [result.mutableRepeatedPrimitiveFieldList addObjectsFromArray:other.mutableRepeatedPrimitiveFieldList];
  }
  if (other.mutableRepeatedStringFieldList.count > 0) {
    if (result.mutableRepeatedStringFieldList == nil) {
      result.mutableRepeatedStringFieldList = [NSMutableArray array];
    }
    [result.mutableRepeatedStringFieldList addObjectsFromArray:other.mutableRepeatedStringFieldList];
  }
  if (other.mutableRepeatedEnumFieldList.count > 0) {
    if (result.mutableRepeatedEnumFieldList == nil) {
      result.mutableRepeatedEnumFieldList = [NSMutableArray array];
    }
    [result.mutableRepeatedEnumFieldList addObjectsFromArray:other.mutableRepeatedEnumFieldList];
  }
  if (other.mutableRepeatedMessageFieldList.count > 0) {
    if (result.mutableRepeatedMessageFieldList == nil) {
      result.mutableRepeatedMessageFieldList = [NSMutableArray array];
    }
    [result.mutableRepeatedMessageFieldList addObjectsFromArray:other.mutableRepeatedMessageFieldList];
  }
  if (other.mutableRepeatedStringPieceFieldList.count > 0) {
    if (result.mutableRepeatedStringPieceFieldList == nil) {
      result.mutableRepeatedStringPieceFieldList = [NSMutableArray array];
    }
    [result.mutableRepeatedStringPieceFieldList addObjectsFromArray:other.mutableRepeatedStringPieceFieldList];
  }
  if (other.mutableRepeatedCordFieldList.count > 0) {
    if (result.mutableRepeatedCordFieldList == nil) {
      result.mutableRepeatedCordFieldList = [NSMutableArray array];
    }
    [result.mutableRepeatedCordFieldList addObjectsFromArray:other.mutableRepeatedCordFieldList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestCamelCaseFieldNames_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setPrimitiveField:[input readInt32]];
        break;
      }
      case 18: {
        [self setStringField:[input readString]];
        break;
      }
      case 24: {
        int32_t rawValue = [input readEnum];
        ForeignEnum* value = [ForeignEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:3 value:rawValue];
        } else {
          [self setEnumField:value];
        }
        break;
      }
      case 34: {
        ForeignMessage_Builder* subBuilder = [ForeignMessage_Builder builder];
        if (self.hasMessageField) {
          [subBuilder mergeFromForeignMessage:self.messageField];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setMessageField:[subBuilder buildPartial]];
        break;
      }
      case 42: {
        [self setStringPieceField:[input readString]];
        break;
      }
      case 50: {
        [self setCordField:[input readString]];
        break;
      }
      case 56: {
        [self addRepeatedPrimitiveField:[input readInt32]];
        break;
      }
      case 66: {
        [self addRepeatedStringField:[input readString]];
        break;
      }
      case 72: {
        int32_t rawValue = [input readEnum];
        ForeignEnum* value = [ForeignEnum valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:9 value:rawValue];
        } else {
          [self addRepeatedEnumField:value];
        }
        break;
      }
      case 82: {
        ForeignMessage_Builder* subBuilder = [ForeignMessage_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addRepeatedMessageField:[subBuilder buildPartial]];
        break;
      }
      case 90: {
        [self addRepeatedStringPieceField:[input readString]];
        break;
      }
      case 98: {
        [self addRepeatedCordField:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasPrimitiveField {
  return result.hasPrimitiveField;
}
- (int32_t) primitiveField {
  return result.primitiveField;
}
- (TestCamelCaseFieldNames_Builder*) setPrimitiveField:(int32_t) value {
  result.hasPrimitiveField = YES;
  result.primitiveField = value;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearPrimitiveField {
  result.hasPrimitiveField = NO;
  result.primitiveField = 0;
  return self;
}
- (BOOL) hasStringField {
  return result.hasStringField;
}
- (NSString*) stringField {
  return result.stringField;
}
- (TestCamelCaseFieldNames_Builder*) setStringField:(NSString*) value {
  result.hasStringField = YES;
  result.stringField = value;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearStringField {
  result.hasStringField = NO;
  result.stringField = @"";
  return self;
}
- (BOOL) hasEnumField {
  return result.hasEnumField;
}
- (ForeignEnum*) enumField {
  return result.enumField;
}
- (TestCamelCaseFieldNames_Builder*) setEnumField:(ForeignEnum*) value {
  result.hasEnumField = YES;
  result.enumField = value;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearEnumField {
  result.hasEnumField = NO;
  result.enumField = [ForeignEnum FOREIGN_FOO];
  return self;
}
- (BOOL) hasMessageField {
  return result.hasMessageField;
}
- (ForeignMessage*) messageField {
  return result.messageField;
}
- (TestCamelCaseFieldNames_Builder*) setMessageField:(ForeignMessage*) value {
  result.hasMessageField = YES;
  result.messageField = value;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) setMessageFieldBuilder:(ForeignMessage_Builder*) builderForValue {
  return [self setMessageField:[builderForValue build]];
}
- (TestCamelCaseFieldNames_Builder*) mergeMessageField:(ForeignMessage*) value {
  if (result.hasMessageField &&
      result.messageField != [ForeignMessage defaultInstance]) {
    result.messageField =
      [[[ForeignMessage_Builder builderWithPrototype:result.messageField] mergeFromForeignMessage:value] buildPartial];
  } else {
    result.messageField = value;
  }
  result.hasMessageField = YES;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearMessageField {
  result.hasMessageField = NO;
  result.messageField = [ForeignMessage defaultInstance];
  return self;
}
- (BOOL) hasStringPieceField {
  return result.hasStringPieceField;
}
- (NSString*) stringPieceField {
  return result.stringPieceField;
}
- (TestCamelCaseFieldNames_Builder*) setStringPieceField:(NSString*) value {
  result.hasStringPieceField = YES;
  result.stringPieceField = value;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearStringPieceField {
  result.hasStringPieceField = NO;
  result.stringPieceField = @"";
  return self;
}
- (BOOL) hasCordField {
  return result.hasCordField;
}
- (NSString*) cordField {
  return result.cordField;
}
- (TestCamelCaseFieldNames_Builder*) setCordField:(NSString*) value {
  result.hasCordField = YES;
  result.cordField = value;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearCordField {
  result.hasCordField = NO;
  result.cordField = @"";
  return self;
}
- (NSArray*) repeatedPrimitiveFieldList {
  if (result.mutableRepeatedPrimitiveFieldList == nil) { return [NSArray array]; }
  return result.mutableRepeatedPrimitiveFieldList;
}
- (int32_t) repeatedPrimitiveFieldAtIndex:(int32_t) index {
  return [result repeatedPrimitiveFieldAtIndex:index];
}
- (TestCamelCaseFieldNames_Builder*) replaceRepeatedPrimitiveFieldAtIndex:(int32_t) index withRepeatedPrimitiveField:(int32_t) value {
  [result.mutableRepeatedPrimitiveFieldList replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addRepeatedPrimitiveField:(int32_t) value {
  if (result.mutableRepeatedPrimitiveFieldList == nil) {
    result.mutableRepeatedPrimitiveFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedPrimitiveFieldList addObject:[NSNumber numberWithInt:value]];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addAllRepeatedPrimitiveField:(NSArray*) values {
  if (result.mutableRepeatedPrimitiveFieldList == nil) {
    result.mutableRepeatedPrimitiveFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedPrimitiveFieldList addObjectsFromArray:values];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearRepeatedPrimitiveFieldList {
  result.mutableRepeatedPrimitiveFieldList = nil;
  return self;
}
- (NSArray*) repeatedStringFieldList {
  if (result.mutableRepeatedStringFieldList == nil) { return [NSArray array]; }
  return result.mutableRepeatedStringFieldList;
}
- (NSString*) repeatedStringFieldAtIndex:(int32_t) index {
  return [result repeatedStringFieldAtIndex:index];
}
- (TestCamelCaseFieldNames_Builder*) replaceRepeatedStringFieldAtIndex:(int32_t) index withRepeatedStringField:(NSString*) value {
  [result.mutableRepeatedStringFieldList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addRepeatedStringField:(NSString*) value {
  if (result.mutableRepeatedStringFieldList == nil) {
    result.mutableRepeatedStringFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringFieldList addObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addAllRepeatedStringField:(NSArray*) values {
  if (result.mutableRepeatedStringFieldList == nil) {
    result.mutableRepeatedStringFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringFieldList addObjectsFromArray:values];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearRepeatedStringFieldList {
  result.mutableRepeatedStringFieldList = nil;
  return self;
}
- (NSArray*) repeatedEnumFieldList {
  return result.mutableRepeatedEnumFieldList;
}
- (ForeignEnum*) repeatedEnumFieldAtIndex:(int32_t) index {
  return [result repeatedEnumFieldAtIndex:index];
}
- (TestCamelCaseFieldNames_Builder*) replaceRepeatedEnumFieldAtIndex:(int32_t) index withRepeatedEnumField:(ForeignEnum*) value {
  [result.mutableRepeatedEnumFieldList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addRepeatedEnumField:(ForeignEnum*) value {
  if (result.mutableRepeatedEnumFieldList == nil) {
    result.mutableRepeatedEnumFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedEnumFieldList addObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addAllRepeatedEnumField:(NSArray*) values {
  if (result.mutableRepeatedEnumFieldList == nil) {
    result.mutableRepeatedEnumFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedEnumFieldList addObjectsFromArray:values];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearRepeatedEnumFieldList {
  result.mutableRepeatedEnumFieldList = nil;
  return self;
}
- (NSArray*) repeatedMessageFieldList {
  if (result.mutableRepeatedMessageFieldList == nil) { return [NSArray array]; }
  return result.mutableRepeatedMessageFieldList;
}
- (ForeignMessage*) repeatedMessageFieldAtIndex:(int32_t) index {
  return [result repeatedMessageFieldAtIndex:index];
}
- (TestCamelCaseFieldNames_Builder*) replaceRepeatedMessageFieldAtIndex:(int32_t) index withRepeatedMessageField:(ForeignMessage*) value {
  [result.mutableRepeatedMessageFieldList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addAllRepeatedMessageField:(NSArray*) values {
  if (result.mutableRepeatedMessageFieldList == nil) {
    result.mutableRepeatedMessageFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedMessageFieldList addObjectsFromArray:values];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearRepeatedMessageFieldList {
  result.mutableRepeatedMessageFieldList = nil;
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addRepeatedMessageField:(ForeignMessage*) value {
  if (result.mutableRepeatedMessageFieldList == nil) {
    result.mutableRepeatedMessageFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedMessageFieldList addObject:value];
  return self;
}
- (NSArray*) repeatedStringPieceFieldList {
  if (result.mutableRepeatedStringPieceFieldList == nil) { return [NSArray array]; }
  return result.mutableRepeatedStringPieceFieldList;
}
- (NSString*) repeatedStringPieceFieldAtIndex:(int32_t) index {
  return [result repeatedStringPieceFieldAtIndex:index];
}
- (TestCamelCaseFieldNames_Builder*) replaceRepeatedStringPieceFieldAtIndex:(int32_t) index withRepeatedStringPieceField:(NSString*) value {
  [result.mutableRepeatedStringPieceFieldList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addRepeatedStringPieceField:(NSString*) value {
  if (result.mutableRepeatedStringPieceFieldList == nil) {
    result.mutableRepeatedStringPieceFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringPieceFieldList addObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addAllRepeatedStringPieceField:(NSArray*) values {
  if (result.mutableRepeatedStringPieceFieldList == nil) {
    result.mutableRepeatedStringPieceFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedStringPieceFieldList addObjectsFromArray:values];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearRepeatedStringPieceFieldList {
  result.mutableRepeatedStringPieceFieldList = nil;
  return self;
}
- (NSArray*) repeatedCordFieldList {
  if (result.mutableRepeatedCordFieldList == nil) { return [NSArray array]; }
  return result.mutableRepeatedCordFieldList;
}
- (NSString*) repeatedCordFieldAtIndex:(int32_t) index {
  return [result repeatedCordFieldAtIndex:index];
}
- (TestCamelCaseFieldNames_Builder*) replaceRepeatedCordFieldAtIndex:(int32_t) index withRepeatedCordField:(NSString*) value {
  [result.mutableRepeatedCordFieldList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addRepeatedCordField:(NSString*) value {
  if (result.mutableRepeatedCordFieldList == nil) {
    result.mutableRepeatedCordFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedCordFieldList addObject:value];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) addAllRepeatedCordField:(NSArray*) values {
  if (result.mutableRepeatedCordFieldList == nil) {
    result.mutableRepeatedCordFieldList = [NSMutableArray array];
  }
  [result.mutableRepeatedCordFieldList addObjectsFromArray:values];
  return self;
}
- (TestCamelCaseFieldNames_Builder*) clearRepeatedCordFieldList {
  result.mutableRepeatedCordFieldList = nil;
  return self;
}
@end

@interface TestFieldOrderings ()
@property BOOL hasMyString;
@property (retain) NSString* myString;
@property BOOL hasMyInt;
@property int64_t myInt;
@property BOOL hasMyFloat;
@property Float32 myFloat;
@end

@implementation TestFieldOrderings

@synthesize hasMyString;
@synthesize myString;
@synthesize hasMyInt;
@synthesize myInt;
@synthesize hasMyFloat;
@synthesize myFloat;
- (void) dealloc {
  self.hasMyString = NO;
  self.myString = nil;
  self.hasMyInt = NO;
  self.myInt = 0;
  self.hasMyFloat = NO;
  self.myFloat = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.myString = @"";
    self.myInt = 0L;
    self.myFloat = 0;
  }
  return self;
}
static TestFieldOrderings* defaultTestFieldOrderingsInstance = nil;
+ (void) initialize {
  if (self == [TestFieldOrderings class]) {
    defaultTestFieldOrderingsInstance = [[TestFieldOrderings alloc] init];
  }
}
+ (TestFieldOrderings*) defaultInstance {
  return defaultTestFieldOrderingsInstance;
}
- (TestFieldOrderings*) defaultInstance {
  return defaultTestFieldOrderingsInstance;
}
- (PBDescriptor*) descriptor {
  return [TestFieldOrderings descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestFieldOrderings_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestFieldOrderings_fieldAccessorTable];
}
- (BOOL) isInitialized {
  if (!self.extensionsAreInitialized) return false;
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  PBExtensionWriter* extensionWriter = [PBExtensionWriter writerWithExtensions:self.extensions];
  if (hasMyInt) {
    [output writeInt64:1 value:self.myInt];
  }
  [extensionWriter writeUntil:11 output:output];
  if (hasMyString) {
    [output writeString:11 value:self.myString];
  }
  [extensionWriter writeUntil:101 output:output];
  if (hasMyFloat) {
    [output writeFloat:101 value:self.myFloat];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasMyInt) {
    size += computeInt64Size(1, self.myInt);
  }
  if (hasMyString) {
    size += computeStringSize(11, self.myString);
  }
  if (hasMyFloat) {
    size += computeFloatSize(101, self.myFloat);
  }
  size += [self extensionsSerializedSize];
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestFieldOrderings*) parseFromData:(NSData*) data {
  return (TestFieldOrderings*)[[[TestFieldOrderings_Builder builder] mergeFromData:data] build];
}
+ (TestFieldOrderings*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestFieldOrderings*)[[[TestFieldOrderings_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestFieldOrderings*) parseFromInputStream:(NSInputStream*) input {
  return (TestFieldOrderings*)[[[TestFieldOrderings_Builder builder] mergeFromInputStream:input] build];
}
+ (TestFieldOrderings*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestFieldOrderings*)[[[TestFieldOrderings_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestFieldOrderings*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestFieldOrderings*)[[[TestFieldOrderings_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestFieldOrderings*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestFieldOrderings*)[[[TestFieldOrderings_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestFieldOrderings_Builder*) createBuilder {
  return [TestFieldOrderings_Builder builder];
}
@end

@implementation TestFieldOrderings_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestFieldOrderings alloc] init] autorelease];
  }
  return self;
}
+ (TestFieldOrderings_Builder*) builder {
  return [[[TestFieldOrderings_Builder alloc] init] autorelease];
}
+ (TestFieldOrderings_Builder*) builderWithPrototype:(TestFieldOrderings*) prototype {
  return [[TestFieldOrderings_Builder builder] mergeFromTestFieldOrderings:prototype];
}
- (TestFieldOrderings*) internalGetResult {
  return result;
}
- (TestFieldOrderings_Builder*) clear {
  self.result = [[[TestFieldOrderings alloc] init] autorelease];
  return self;
}
- (TestFieldOrderings_Builder*) clone {
  return [TestFieldOrderings_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestFieldOrderings descriptor];
}
- (TestFieldOrderings*) defaultInstance {
  return [TestFieldOrderings defaultInstance];
}
- (TestFieldOrderings*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestFieldOrderings*) buildPartial {
  TestFieldOrderings* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestFieldOrderings_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestFieldOrderings class]]) {
    return [self mergeFromTestFieldOrderings:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestFieldOrderings_Builder*) mergeFromTestFieldOrderings:(TestFieldOrderings*) other {
  if (other == [TestFieldOrderings defaultInstance]) return self;
  if (other.hasMyString) {
    [self setMyString:other.myString];
  }
  if (other.hasMyInt) {
    [self setMyInt:other.myInt];
  }
  if (other.hasMyFloat) {
    [self setMyFloat:other.myFloat];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestFieldOrderings_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestFieldOrderings_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setMyInt:[input readInt64]];
        break;
      }
      case 90: {
        [self setMyString:[input readString]];
        break;
      }
      case 813: {
        [self setMyFloat:[input readFloat]];
        break;
      }
    }
  }
}
- (BOOL) hasMyString {
  return result.hasMyString;
}
- (NSString*) myString {
  return result.myString;
}
- (TestFieldOrderings_Builder*) setMyString:(NSString*) value {
  result.hasMyString = YES;
  result.myString = value;
  return self;
}
- (TestFieldOrderings_Builder*) clearMyString {
  result.hasMyString = NO;
  result.myString = @"";
  return self;
}
- (BOOL) hasMyInt {
  return result.hasMyInt;
}
- (int64_t) myInt {
  return result.myInt;
}
- (TestFieldOrderings_Builder*) setMyInt:(int64_t) value {
  result.hasMyInt = YES;
  result.myInt = value;
  return self;
}
- (TestFieldOrderings_Builder*) clearMyInt {
  result.hasMyInt = NO;
  result.myInt = 0L;
  return self;
}
- (BOOL) hasMyFloat {
  return result.hasMyFloat;
}
- (Float32) myFloat {
  return result.myFloat;
}
- (TestFieldOrderings_Builder*) setMyFloat:(Float32) value {
  result.hasMyFloat = YES;
  result.myFloat = value;
  return self;
}
- (TestFieldOrderings_Builder*) clearMyFloat {
  result.hasMyFloat = NO;
  result.myFloat = 0;
  return self;
}
@end

@interface TestExtremeDefaultValues ()
@property BOOL hasEscapedBytes;
@property (retain) NSData* escapedBytes;
@property BOOL hasLargeUint32;
@property int32_t largeUint32;
@property BOOL hasLargeUint64;
@property int64_t largeUint64;
@property BOOL hasSmallInt32;
@property int32_t smallInt32;
@property BOOL hasSmallInt64;
@property int64_t smallInt64;
@property BOOL hasUtf8String;
@property (retain) NSString* utf8String;
@end

@implementation TestExtremeDefaultValues

@synthesize hasEscapedBytes;
@synthesize escapedBytes;
@synthesize hasLargeUint32;
@synthesize largeUint32;
@synthesize hasLargeUint64;
@synthesize largeUint64;
@synthesize hasSmallInt32;
@synthesize smallInt32;
@synthesize hasSmallInt64;
@synthesize smallInt64;
@synthesize hasUtf8String;
@synthesize utf8String;
- (void) dealloc {
  self.hasEscapedBytes = NO;
  self.escapedBytes = nil;
  self.hasLargeUint32 = NO;
  self.largeUint32 = 0;
  self.hasLargeUint64 = NO;
  self.largeUint64 = 0;
  self.hasSmallInt32 = NO;
  self.smallInt32 = 0;
  self.hasSmallInt64 = NO;
  self.smallInt64 = 0;
  self.hasUtf8String = NO;
  self.utf8String = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.escapedBytes = ([((PBFieldDescriptor*)[[TestExtremeDefaultValues descriptor].fields objectAtIndex:0]) defaultValue]);
    self.largeUint32 = -1;
    self.largeUint64 = -1L;
    self.smallInt32 = -2147483647;
    self.smallInt64 = -9223372036854775807L;
    self.utf8String = ([((PBFieldDescriptor*)[[TestExtremeDefaultValues descriptor].fields objectAtIndex:5]) defaultValue]);
  }
  return self;
}
static TestExtremeDefaultValues* defaultTestExtremeDefaultValuesInstance = nil;
+ (void) initialize {
  if (self == [TestExtremeDefaultValues class]) {
    defaultTestExtremeDefaultValuesInstance = [[TestExtremeDefaultValues alloc] init];
  }
}
+ (TestExtremeDefaultValues*) defaultInstance {
  return defaultTestExtremeDefaultValuesInstance;
}
- (TestExtremeDefaultValues*) defaultInstance {
  return defaultTestExtremeDefaultValuesInstance;
}
- (PBDescriptor*) descriptor {
  return [TestExtremeDefaultValues descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestExtremeDefaultValues_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_TestExtremeDefaultValues_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasEscapedBytes) {
    [output writeData:1 value:self.escapedBytes];
  }
  if (hasLargeUint32) {
    [output writeUInt32:2 value:self.largeUint32];
  }
  if (hasLargeUint64) {
    [output writeUInt64:3 value:self.largeUint64];
  }
  if (hasSmallInt32) {
    [output writeInt32:4 value:self.smallInt32];
  }
  if (hasSmallInt64) {
    [output writeInt64:5 value:self.smallInt64];
  }
  if (hasUtf8String) {
    [output writeString:6 value:self.utf8String];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasEscapedBytes) {
    size += computeDataSize(1, self.escapedBytes);
  }
  if (hasLargeUint32) {
    size += computeUInt32Size(2, self.largeUint32);
  }
  if (hasLargeUint64) {
    size += computeUInt64Size(3, self.largeUint64);
  }
  if (hasSmallInt32) {
    size += computeInt32Size(4, self.smallInt32);
  }
  if (hasSmallInt64) {
    size += computeInt64Size(5, self.smallInt64);
  }
  if (hasUtf8String) {
    size += computeStringSize(6, self.utf8String);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TestExtremeDefaultValues*) parseFromData:(NSData*) data {
  return (TestExtremeDefaultValues*)[[[TestExtremeDefaultValues_Builder builder] mergeFromData:data] build];
}
+ (TestExtremeDefaultValues*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestExtremeDefaultValues*)[[[TestExtremeDefaultValues_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TestExtremeDefaultValues*) parseFromInputStream:(NSInputStream*) input {
  return (TestExtremeDefaultValues*)[[[TestExtremeDefaultValues_Builder builder] mergeFromInputStream:input] build];
}
+ (TestExtremeDefaultValues*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestExtremeDefaultValues*)[[[TestExtremeDefaultValues_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TestExtremeDefaultValues*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TestExtremeDefaultValues*)[[[TestExtremeDefaultValues_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (TestExtremeDefaultValues*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TestExtremeDefaultValues*)[[[TestExtremeDefaultValues_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (TestExtremeDefaultValues_Builder*) createBuilder {
  return [TestExtremeDefaultValues_Builder builder];
}
@end

@implementation TestExtremeDefaultValues_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TestExtremeDefaultValues alloc] init] autorelease];
  }
  return self;
}
+ (TestExtremeDefaultValues_Builder*) builder {
  return [[[TestExtremeDefaultValues_Builder alloc] init] autorelease];
}
+ (TestExtremeDefaultValues_Builder*) builderWithPrototype:(TestExtremeDefaultValues*) prototype {
  return [[TestExtremeDefaultValues_Builder builder] mergeFromTestExtremeDefaultValues:prototype];
}
- (TestExtremeDefaultValues*) internalGetResult {
  return result;
}
- (TestExtremeDefaultValues_Builder*) clear {
  self.result = [[[TestExtremeDefaultValues alloc] init] autorelease];
  return self;
}
- (TestExtremeDefaultValues_Builder*) clone {
  return [TestExtremeDefaultValues_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TestExtremeDefaultValues descriptor];
}
- (TestExtremeDefaultValues*) defaultInstance {
  return [TestExtremeDefaultValues defaultInstance];
}
- (TestExtremeDefaultValues*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TestExtremeDefaultValues*) buildPartial {
  TestExtremeDefaultValues* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TestExtremeDefaultValues_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TestExtremeDefaultValues class]]) {
    return [self mergeFromTestExtremeDefaultValues:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TestExtremeDefaultValues_Builder*) mergeFromTestExtremeDefaultValues:(TestExtremeDefaultValues*) other {
  if (other == [TestExtremeDefaultValues defaultInstance]) return self;
  if (other.hasEscapedBytes) {
    [self setEscapedBytes:other.escapedBytes];
  }
  if (other.hasLargeUint32) {
    [self setLargeUint32:other.largeUint32];
  }
  if (other.hasLargeUint64) {
    [self setLargeUint64:other.largeUint64];
  }
  if (other.hasSmallInt32) {
    [self setSmallInt32:other.smallInt32];
  }
  if (other.hasSmallInt64) {
    [self setSmallInt64:other.smallInt64];
  }
  if (other.hasUtf8String) {
    [self setUtf8String:other.utf8String];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TestExtremeDefaultValues_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TestExtremeDefaultValues_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setEscapedBytes:[input readData]];
        break;
      }
      case 16: {
        [self setLargeUint32:[input readUInt32]];
        break;
      }
      case 24: {
        [self setLargeUint64:[input readUInt64]];
        break;
      }
      case 32: {
        [self setSmallInt32:[input readInt32]];
        break;
      }
      case 40: {
        [self setSmallInt64:[input readInt64]];
        break;
      }
      case 50: {
        [self setUtf8String:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasEscapedBytes {
  return result.hasEscapedBytes;
}
- (NSData*) escapedBytes {
  return result.escapedBytes;
}
- (TestExtremeDefaultValues_Builder*) setEscapedBytes:(NSData*) value {
  result.hasEscapedBytes = YES;
  result.escapedBytes = value;
  return self;
}
- (TestExtremeDefaultValues_Builder*) clearEscapedBytes {
  result.hasEscapedBytes = NO;
  result.escapedBytes = ([((PBFieldDescriptor*)[[TestExtremeDefaultValues descriptor].fields objectAtIndex:0]) defaultValue]);
  return self;
}
- (BOOL) hasLargeUint32 {
  return result.hasLargeUint32;
}
- (int32_t) largeUint32 {
  return result.largeUint32;
}
- (TestExtremeDefaultValues_Builder*) setLargeUint32:(int32_t) value {
  result.hasLargeUint32 = YES;
  result.largeUint32 = value;
  return self;
}
- (TestExtremeDefaultValues_Builder*) clearLargeUint32 {
  result.hasLargeUint32 = NO;
  result.largeUint32 = -1;
  return self;
}
- (BOOL) hasLargeUint64 {
  return result.hasLargeUint64;
}
- (int64_t) largeUint64 {
  return result.largeUint64;
}
- (TestExtremeDefaultValues_Builder*) setLargeUint64:(int64_t) value {
  result.hasLargeUint64 = YES;
  result.largeUint64 = value;
  return self;
}
- (TestExtremeDefaultValues_Builder*) clearLargeUint64 {
  result.hasLargeUint64 = NO;
  result.largeUint64 = -1L;
  return self;
}
- (BOOL) hasSmallInt32 {
  return result.hasSmallInt32;
}
- (int32_t) smallInt32 {
  return result.smallInt32;
}
- (TestExtremeDefaultValues_Builder*) setSmallInt32:(int32_t) value {
  result.hasSmallInt32 = YES;
  result.smallInt32 = value;
  return self;
}
- (TestExtremeDefaultValues_Builder*) clearSmallInt32 {
  result.hasSmallInt32 = NO;
  result.smallInt32 = -2147483647;
  return self;
}
- (BOOL) hasSmallInt64 {
  return result.hasSmallInt64;
}
- (int64_t) smallInt64 {
  return result.smallInt64;
}
- (TestExtremeDefaultValues_Builder*) setSmallInt64:(int64_t) value {
  result.hasSmallInt64 = YES;
  result.smallInt64 = value;
  return self;
}
- (TestExtremeDefaultValues_Builder*) clearSmallInt64 {
  result.hasSmallInt64 = NO;
  result.smallInt64 = -9223372036854775807L;
  return self;
}
- (BOOL) hasUtf8String {
  return result.hasUtf8String;
}
- (NSString*) utf8String {
  return result.utf8String;
}
- (TestExtremeDefaultValues_Builder*) setUtf8String:(NSString*) value {
  result.hasUtf8String = YES;
  result.utf8String = value;
  return self;
}
- (TestExtremeDefaultValues_Builder*) clearUtf8String {
  result.hasUtf8String = NO;
  result.utf8String = ([((PBFieldDescriptor*)[[TestExtremeDefaultValues descriptor].fields objectAtIndex:5]) defaultValue]);
  return self;
}
@end

@interface FooRequest ()
@end

@implementation FooRequest

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static FooRequest* defaultFooRequestInstance = nil;
+ (void) initialize {
  if (self == [FooRequest class]) {
    defaultFooRequestInstance = [[FooRequest alloc] init];
  }
}
+ (FooRequest*) defaultInstance {
  return defaultFooRequestInstance;
}
- (FooRequest*) defaultInstance {
  return defaultFooRequestInstance;
}
- (PBDescriptor*) descriptor {
  return [FooRequest descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_FooRequest_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_FooRequest_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (FooRequest*) parseFromData:(NSData*) data {
  return (FooRequest*)[[[FooRequest_Builder builder] mergeFromData:data] build];
}
+ (FooRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (FooRequest*)[[[FooRequest_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (FooRequest*) parseFromInputStream:(NSInputStream*) input {
  return (FooRequest*)[[[FooRequest_Builder builder] mergeFromInputStream:input] build];
}
+ (FooRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (FooRequest*)[[[FooRequest_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (FooRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (FooRequest*)[[[FooRequest_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (FooRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (FooRequest*)[[[FooRequest_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (FooRequest_Builder*) createBuilder {
  return [FooRequest_Builder builder];
}
@end

@implementation FooRequest_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[FooRequest alloc] init] autorelease];
  }
  return self;
}
+ (FooRequest_Builder*) builder {
  return [[[FooRequest_Builder alloc] init] autorelease];
}
+ (FooRequest_Builder*) builderWithPrototype:(FooRequest*) prototype {
  return [[FooRequest_Builder builder] mergeFromFooRequest:prototype];
}
- (FooRequest*) internalGetResult {
  return result;
}
- (FooRequest_Builder*) clear {
  self.result = [[[FooRequest alloc] init] autorelease];
  return self;
}
- (FooRequest_Builder*) clone {
  return [FooRequest_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [FooRequest descriptor];
}
- (FooRequest*) defaultInstance {
  return [FooRequest defaultInstance];
}
- (FooRequest*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (FooRequest*) buildPartial {
  FooRequest* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (FooRequest_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[FooRequest class]]) {
    return [self mergeFromFooRequest:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (FooRequest_Builder*) mergeFromFooRequest:(FooRequest*) other {
  if (other == [FooRequest defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (FooRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (FooRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface FooResponse ()
@end

@implementation FooResponse

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static FooResponse* defaultFooResponseInstance = nil;
+ (void) initialize {
  if (self == [FooResponse class]) {
    defaultFooResponseInstance = [[FooResponse alloc] init];
  }
}
+ (FooResponse*) defaultInstance {
  return defaultFooResponseInstance;
}
- (FooResponse*) defaultInstance {
  return defaultFooResponseInstance;
}
- (PBDescriptor*) descriptor {
  return [FooResponse descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_FooResponse_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_FooResponse_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (FooResponse*) parseFromData:(NSData*) data {
  return (FooResponse*)[[[FooResponse_Builder builder] mergeFromData:data] build];
}
+ (FooResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (FooResponse*)[[[FooResponse_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (FooResponse*) parseFromInputStream:(NSInputStream*) input {
  return (FooResponse*)[[[FooResponse_Builder builder] mergeFromInputStream:input] build];
}
+ (FooResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (FooResponse*)[[[FooResponse_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (FooResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (FooResponse*)[[[FooResponse_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (FooResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (FooResponse*)[[[FooResponse_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (FooResponse_Builder*) createBuilder {
  return [FooResponse_Builder builder];
}
@end

@implementation FooResponse_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[FooResponse alloc] init] autorelease];
  }
  return self;
}
+ (FooResponse_Builder*) builder {
  return [[[FooResponse_Builder alloc] init] autorelease];
}
+ (FooResponse_Builder*) builderWithPrototype:(FooResponse*) prototype {
  return [[FooResponse_Builder builder] mergeFromFooResponse:prototype];
}
- (FooResponse*) internalGetResult {
  return result;
}
- (FooResponse_Builder*) clear {
  self.result = [[[FooResponse alloc] init] autorelease];
  return self;
}
- (FooResponse_Builder*) clone {
  return [FooResponse_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [FooResponse descriptor];
}
- (FooResponse*) defaultInstance {
  return [FooResponse defaultInstance];
}
- (FooResponse*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (FooResponse*) buildPartial {
  FooResponse* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (FooResponse_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[FooResponse class]]) {
    return [self mergeFromFooResponse:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (FooResponse_Builder*) mergeFromFooResponse:(FooResponse*) other {
  if (other == [FooResponse defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (FooResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (FooResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface BarRequest ()
@end

@implementation BarRequest

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static BarRequest* defaultBarRequestInstance = nil;
+ (void) initialize {
  if (self == [BarRequest class]) {
    defaultBarRequestInstance = [[BarRequest alloc] init];
  }
}
+ (BarRequest*) defaultInstance {
  return defaultBarRequestInstance;
}
- (BarRequest*) defaultInstance {
  return defaultBarRequestInstance;
}
- (PBDescriptor*) descriptor {
  return [BarRequest descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_BarRequest_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_BarRequest_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (BarRequest*) parseFromData:(NSData*) data {
  return (BarRequest*)[[[BarRequest_Builder builder] mergeFromData:data] build];
}
+ (BarRequest*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BarRequest*)[[[BarRequest_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (BarRequest*) parseFromInputStream:(NSInputStream*) input {
  return (BarRequest*)[[[BarRequest_Builder builder] mergeFromInputStream:input] build];
}
+ (BarRequest*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BarRequest*)[[[BarRequest_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (BarRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (BarRequest*)[[[BarRequest_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (BarRequest*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BarRequest*)[[[BarRequest_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (BarRequest_Builder*) createBuilder {
  return [BarRequest_Builder builder];
}
@end

@implementation BarRequest_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[BarRequest alloc] init] autorelease];
  }
  return self;
}
+ (BarRequest_Builder*) builder {
  return [[[BarRequest_Builder alloc] init] autorelease];
}
+ (BarRequest_Builder*) builderWithPrototype:(BarRequest*) prototype {
  return [[BarRequest_Builder builder] mergeFromBarRequest:prototype];
}
- (BarRequest*) internalGetResult {
  return result;
}
- (BarRequest_Builder*) clear {
  self.result = [[[BarRequest alloc] init] autorelease];
  return self;
}
- (BarRequest_Builder*) clone {
  return [BarRequest_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [BarRequest descriptor];
}
- (BarRequest*) defaultInstance {
  return [BarRequest defaultInstance];
}
- (BarRequest*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (BarRequest*) buildPartial {
  BarRequest* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (BarRequest_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[BarRequest class]]) {
    return [self mergeFromBarRequest:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (BarRequest_Builder*) mergeFromBarRequest:(BarRequest*) other {
  if (other == [BarRequest defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (BarRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (BarRequest_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface BarResponse ()
@end

@implementation BarResponse

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static BarResponse* defaultBarResponseInstance = nil;
+ (void) initialize {
  if (self == [BarResponse class]) {
    defaultBarResponseInstance = [[BarResponse alloc] init];
  }
}
+ (BarResponse*) defaultInstance {
  return defaultBarResponseInstance;
}
- (BarResponse*) defaultInstance {
  return defaultBarResponseInstance;
}
- (PBDescriptor*) descriptor {
  return [BarResponse descriptor];
}
+ (PBDescriptor*) descriptor {
  return [UnittestProtoRoot internal_static_protobuf_unittest_BarResponse_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [UnittestProtoRoot internal_static_protobuf_unittest_BarResponse_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (BarResponse*) parseFromData:(NSData*) data {
  return (BarResponse*)[[[BarResponse_Builder builder] mergeFromData:data] build];
}
+ (BarResponse*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BarResponse*)[[[BarResponse_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (BarResponse*) parseFromInputStream:(NSInputStream*) input {
  return (BarResponse*)[[[BarResponse_Builder builder] mergeFromInputStream:input] build];
}
+ (BarResponse*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BarResponse*)[[[BarResponse_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (BarResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (BarResponse*)[[[BarResponse_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (BarResponse*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (BarResponse*)[[[BarResponse_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (BarResponse_Builder*) createBuilder {
  return [BarResponse_Builder builder];
}
@end

@implementation BarResponse_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[BarResponse alloc] init] autorelease];
  }
  return self;
}
+ (BarResponse_Builder*) builder {
  return [[[BarResponse_Builder alloc] init] autorelease];
}
+ (BarResponse_Builder*) builderWithPrototype:(BarResponse*) prototype {
  return [[BarResponse_Builder builder] mergeFromBarResponse:prototype];
}
- (BarResponse*) internalGetResult {
  return result;
}
- (BarResponse_Builder*) clear {
  self.result = [[[BarResponse alloc] init] autorelease];
  return self;
}
- (BarResponse_Builder*) clone {
  return [BarResponse_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [BarResponse descriptor];
}
- (BarResponse*) defaultInstance {
  return [BarResponse defaultInstance];
}
- (BarResponse*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (BarResponse*) buildPartial {
  BarResponse* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (BarResponse_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[BarResponse class]]) {
    return [self mergeFromBarResponse:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (BarResponse_Builder*) mergeFromBarResponse:(BarResponse*) other {
  if (other == [BarResponse defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (BarResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (BarResponse_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@implementation TestService
- (void) fooWithController:(id<PBRpcController>) controller
                      request:(FooRequest*) request
                       target:(id) target
                     selector:(SEL) selector {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}
- (void) barWithController:(id<PBRpcController>) controller
                      request:(BarRequest*) request
                       target:(id) target
                     selector:(SEL) selector {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}
+ (PBServiceDescriptor*) descriptor {
  return [[UnittestProtoRoot descriptor].services objectAtIndex:0];
}
- (PBServiceDescriptor*) descriptor {
  return [TestService descriptor];
}
- (void) callMethod:(PBMethodDescriptor*) method
         controller:(id<PBRpcController>) controller
            request:(id<PBMessage>) request
             target:(id) target
           selector:(SEL) selector {
  if (method.service != self.descriptor) {
    @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"Service.callMethod given method descriptor for wrong service type." userInfo:nil];
  }
  switch(method.index) {
    case 0:
      [self fooWithController:controller request:(id)request target:target selector:selector];
      return;
    case 1:
      [self barWithController:controller request:(id)request target:target selector:selector];
      return;
    default:
      @throw [NSException exceptionWithName:@"RuntimeError" reason:@"" userInfo:nil];
  }
}
- (id<PBMessage>) getRequestPrototype:(PBMethodDescriptor*) method {
  if (method.service != self.descriptor) {
    @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"Service.callMethod given method descriptor for wrong service type." userInfo:nil];
  }
  switch(method.index) {
    case 0:
      return [FooRequest defaultInstance];
    case 1:
      return [BarRequest defaultInstance];
    default:
      @throw [NSException exceptionWithName:@"RuntimeError" reason:@"" userInfo:nil];
  }
}
- (id<PBMessage>) getResponsePrototype:(PBMethodDescriptor*) method {
  if (method.service != self.descriptor) {
    @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"Service.callMethod given method descriptor for wrong service type." userInfo:nil];
  }
  switch(method.index) {
    case 0:
      return [FooResponse defaultInstance];
    case 1:
      return [BarResponse defaultInstance];
    default:
      @throw [NSException exceptionWithName:@"RuntimeError" reason:@"" userInfo:nil];
  }
}
@end

@implementation TestService_Stub
@synthesize channel;
- (void) dealloc {
  self.channel = nil;
  [super dealloc];
}
- (id) initWithChannel:(id<PBRpcChannel>) channel_ {
  if (self = [super init]) {
    self.channel = channel_;
  }
  return self;
}
+ (TestService_Stub*) stubWithChannel:(id<PBRpcChannel>) channel {
  return [[[TestService_Stub alloc] initWithChannel:channel] autorelease];
}
- (void) fooWithController:(id<PBRpcController>) controller
                        request:(FooRequest*) request
                         target:(id) target
                       selector:(SEL) selector {
  [channel callMethod:[[TestService descriptor].methods objectAtIndex:0]
           controller:controller
              request:request
             response:[FooResponse defaultInstance]
               target:target
             selector:selector];
}
- (void) barWithController:(id<PBRpcController>) controller
                        request:(BarRequest*) request
                         target:(id) target
                       selector:(SEL) selector {
  [channel callMethod:[[TestService descriptor].methods objectAtIndex:1]
           controller:controller
              request:request
             response:[BarResponse defaultInstance]
               target:target
             selector:selector];
}
@end