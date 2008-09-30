// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Author: kenton@google.com (Kenton Varda)
//  Based on original Protocol Buffers design by
//  Sanjay Ghemawat, Jeff Dean, and others.

#include <map>
#include <string>

#include <google/protobuf/compiler/objectivec/objectivec_enum_field.h>
#include <google/protobuf/stubs/common.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/stubs/strutil.h>

namespace google {
namespace protobuf {
namespace compiler {
namespace objectivec {

namespace {

// TODO(kenton):  Factor out a "SetCommonFieldVariables()" to get rid of
//   repeat code between this and the other field types.
void SetEnumVariables(const FieldDescriptor* descriptor,
                      map<string, string>* variables) {
  const EnumValueDescriptor* default_value;
  default_value = descriptor->default_value_enum();

  string type = ClassName(descriptor->enum_type());

  (*variables)["classname"] = ClassName(descriptor->containing_type());
  (*variables)["name"] =
    UnderscoresToCamelCase(descriptor);
  (*variables)["capitalized_name"] =
    UnderscoresToCapitalizedCamelCase(descriptor);
  (*variables)["number"] = SimpleItoa(descriptor->number());
  (*variables)["type"] = type;
  (*variables)["storage_type"] = type + "*";
  (*variables)["default"] = "[" + type + " " + default_value->name() + "]";
}

}  // namespace

// ===================================================================

EnumFieldGenerator::
EnumFieldGenerator(const FieldDescriptor* descriptor)
  : descriptor_(descriptor) {
  SetEnumVariables(descriptor, &variables_);
}

EnumFieldGenerator::~EnumFieldGenerator() {}

void EnumFieldGenerator::
GenerateFieldsHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "BOOL has$capitalized_name$;\n"
    "$storage_type$ $name$_;\n");
}
void EnumFieldGenerator::
GeneratePropertiesHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "@property BOOL has$capitalized_name$;\n"
    "@property (retain) $storage_type$ $name$_;\n");
}


void EnumFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "- (BOOL) has$capitalized_name$;\n"
    "- ($storage_type$) get$capitalized_name$;\n");
}

void EnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    "- (BOOL) has$capitalized_name$ { return has$capitalized_name$; }\n"
    "- ($storage_type$) get$capitalized_name$ { return $name$_; }\n");
}

void EnumFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "@synthesize has$capitalized_name$;\n"
    "@synthesize $name$_;\n");
}

void EnumFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
  printer->Print(variables_,
    "self.has$capitalized_name$ = NO;\n"
    "self.$name$_ = nil;\n");
}

void EnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
  printer->Print(variables_,
    "self.$name$_ = $default$;\n");
}

void EnumFieldGenerator::
GenerateBuilderMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "- (BOOL) has$capitalized_name$;\n"
    "- ($storage_type$) get$capitalized_name$;\n"\
    "- ($classname$_Builder*) set$capitalized_name$:($storage_type$) value;\n"
    "- ($classname$_Builder*) clear$capitalized_name$;\n");
}
void EnumFieldGenerator::
GenerateBuilderMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    "- (BOOL) has$capitalized_name$ {\n"
    "  return result.has$capitalized_name$;\n"
    "}\n"
    "- ($storage_type$) get$capitalized_name$ {\n"
    "  return result.get$capitalized_name$;\n"
    "}\n"
    "- ($classname$_Builder*) set$capitalized_name$:($storage_type$) value {\n"
    "  result.has$capitalized_name$ = YES;\n"
    "  result.$name$_ = value;\n"
    "  return self;\n"
    "}\n"
    "- ($classname$_Builder*) clear$capitalized_name$ {\n"
    "  result.has$capitalized_name$ = NO;\n"
    "  result.$name$_ = $default$;\n"
    "  return self;\n"
    "}\n");
}

void EnumFieldGenerator::GenerateMergingCodeHeader(io::Printer* printer) const {
}

void EnumFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (other.has$capitalized_name$) {\n"
    "  [self set$capitalized_name$:other.get$capitalized_name$];\n"
    "}\n");
}

void EnumFieldGenerator::GenerateBuildingCodeHeader(io::Printer* printer) const {
  // Nothing to do here for enum types.
}
void EnumFieldGenerator::
GenerateBuildingCodeSource(io::Printer* printer) const {
  // Nothing to do here for enum types.
}

void EnumFieldGenerator::
GenerateParsingCodeHeader(io::Printer* printer) const {
}
void EnumFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "int32_t rawValue = [input readEnum];\n"
    "$type$* value = [$type$ valueOf:rawValue];\n"
    "if (value == nil) {\n"
    "  [unknownFields mergeVarintField:$number$ value:rawValue];\n"
    "} else {\n"
    "  [self set$capitalized_name$:value];\n"
    "}\n");
}

void EnumFieldGenerator::
GenerateSerializationCodeHeader(io::Printer* printer) const {
}
void EnumFieldGenerator::
GenerateSerializationCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (self.has$capitalized_name$) {\n"
    "  [output writeEnum:$number$ value:self.get$capitalized_name$.getNumber];\n"
    "}\n");
}


void EnumFieldGenerator::
GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
}


void EnumFieldGenerator::
GenerateSerializedSizeCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (self.has$capitalized_name$) {\n"
    "  size += computeEnumSize($number$, self.get$capitalized_name$.getNumber);\n"
    "}\n");
}

string EnumFieldGenerator::GetBoxedType() const {
  return ClassName(descriptor_->enum_type());
}

// ===================================================================

RepeatedEnumFieldGenerator::
RepeatedEnumFieldGenerator(const FieldDescriptor* descriptor)
  : descriptor_(descriptor) {
  SetEnumVariables(descriptor, &variables_);
}

RepeatedEnumFieldGenerator::~RepeatedEnumFieldGenerator() {}


void RepeatedEnumFieldGenerator::GenerateFieldsHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "NSMutableArray* $name$_;\n");
}

void RepeatedEnumFieldGenerator::GeneratePropertiesHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "@property (retain) NSMutableArray* $name$_;\n");
}

void RepeatedEnumFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "@synthesize $name$_;\n");
}

void RepeatedEnumFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
  printer->Print(variables_,
    "self.$name$_ = nil;\n");
}

void RepeatedEnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
}

void RepeatedEnumFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "- (NSArray*) get$capitalized_name$List;\n"
    "- (int32_t) get$capitalized_name$Count;\n"
    "- ($storage_type$) get$capitalized_name$:(int32_t) index;\n");
}

void RepeatedEnumFieldGenerator::GenerateBuilderMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
    // Note:  We return an unmodifiable list because otherwise the caller
    //   could hold on to the returned list and modify it after the message
    //   has been built, thus mutating the message which is supposed to be
    //   immutable.
    "- (NSArray*) get$capitalized_name$List;\n"
    "- (int32_t) get$capitalized_name$Count;\n"
    "- ($storage_type$) get$capitalized_name$:(int32_t) index;\n"
    "- ($classname$_Builder*) set$capitalized_name$:(int32_t) index value:($storage_type$) value;\n"
    "- ($classname$_Builder*) add$capitalized_name$:($storage_type$) value;\n"
    "- ($classname$_Builder*) addAll$capitalized_name$:(NSArray*) values;\n"
    "- ($classname$_Builder*) clear$capitalized_name$;\n");
}

void RepeatedEnumFieldGenerator::
GenerateMergingCodeHeader(io::Printer* printer) const {
}

void RepeatedEnumFieldGenerator::
GenerateBuildingCodeHeader(io::Printer* printer) const {
}

void RepeatedEnumFieldGenerator::
GenerateParsingCodeHeader(io::Printer* printer) const {
}

void RepeatedEnumFieldGenerator::
GenerateSerializationCodeHeader(io::Printer* printer) const {
}

void RepeatedEnumFieldGenerator::
GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
}

void RepeatedEnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    "- (NSArray*) get$capitalized_name$List {\n"
    "  return $name$_;\n"   // note:  unmodifiable list
    "}\n"
    "- (int32_t) get$capitalized_name$Count() { return $name$_.count; }\n"
    "- ($storage_type$) get$capitalized_name$:(int32_t) index {\n"
    "  return [$name$_ objectAtIndex:index];\n"
    "}\n");
}

void RepeatedEnumFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    // Note:  We return an unmodifiable list because otherwise the caller
    //   could hold on to the returned list and modify it after the message
    //   has been built, thus mutating the message which is supposed to be
    //   immutable.
    "- (NSArray*) get$capitalized_name$List {\n"
    "  return result.$name$_;\n"
    "}\n"
    "- (int32_t) get$capitalized_name$Count {\n"
    "  return result.get$capitalized_name$Count;\n"
    "}\n"
    "- ($storage_type$) get$capitalized_name$:(int32_t) index {\n"
    "  return [result get$capitalized_name$:index];\n"
    "}\n"
    "- ($classname$_Builder*) set$capitalized_name$:(int32_t) index value:($storage_type$) value {\n"
    "  result [$name$_ replaceObjectAtIndex:index withObject:value];\n"
    "  return self;\n"
    "}\n"
    "- ($classname$_Builder*) add$capitalized_name$:($storage_type$) value {\n"
    "  if (result.$name$_ == nil) {\n"
    "    result.$name$_ = [NSMutableArray array];\n"
    "  }\n"
    "  [result.$name$_ addObject:value];\n"
    "  return self;\n"
    "}\n"
    "- ($classname$_Builder*) addAll$capitalized_name$:(NSArray*) values {\n"
    "  if (result.$name$_ == nil) {\n"
    "    result.$name$_ = [NSMutableArray array];\n"
    "  }\n"
    "  [result.$name$_ addObjectsFromArray:values];\n"
    "  return self;\n"
    "}\n"
    "- ($classname$_Builder*) clear$capitalized_name$ {\n"
    "  result.$name$_ = nil;\n"
    "  return self;\n"
    "}\n");
}

void RepeatedEnumFieldGenerator::
GenerateMergingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (other.$name$_.count > 0) {\n"
    "  if (result.$name$_ == nil) {\n"
    "    result.$name$_ = [NSMutableArray array];\n"
    "  }\n"
    "  [result.$name$_ addObjectsFromArray:other.$name$_];\n"
    "}\n");
}

void RepeatedEnumFieldGenerator::
GenerateBuildingCodeSource(io::Printer* printer) const {
}

void RepeatedEnumFieldGenerator::
GenerateParsingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "int32_t rawValue = [input readEnum];\n"
    "$storage_type$ value = [$storage_type$ valueOf:rawValue];\n"
    "if (value == nil) {\n"
    "  [unknownFields mergeVarintField:$number$ value:rawValue];\n"
    "} else {\n"
    "  [self add$capitalized_name$:value];\n"
    "}\n");
}

void RepeatedEnumFieldGenerator::
GenerateSerializationCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "for ($storage_type$ element in self.get$capitalized_name$List) {\n"
    "  [output writeEnum:$number$ value:element.getNumber];\n"
    "}\n");
}

void RepeatedEnumFieldGenerator::
GenerateSerializedSizeCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "for ($storage_type$ element : get$capitalized_name$List()) {\n"
    "  size += computeEnumSize($number$, element.getNumber);\n"
    "}\n");
}

string RepeatedEnumFieldGenerator::GetBoxedType() const {
  return ClassName(descriptor_->enum_type());
}

}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
