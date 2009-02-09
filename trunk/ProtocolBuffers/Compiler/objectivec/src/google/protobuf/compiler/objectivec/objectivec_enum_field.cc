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

namespace google { namespace protobuf { namespace compiler { namespace objectivec {

  namespace {
    void SetEnumVariables(const FieldDescriptor* descriptor,
      map<string, string>* variables) {
        const EnumValueDescriptor* default_value;
        default_value = descriptor->default_value_enum();

        string type = ClassName(descriptor->enum_type());

        (*variables)["classname"]             = ClassName(descriptor->containing_type());
        (*variables)["name"]                  = UnderscoresToCamelCase(descriptor);
        (*variables)["capitalized_name"]      = UnderscoresToCapitalizedCamelCase(descriptor);
        (*variables)["list_name"]             = UnderscoresToCamelCase(descriptor) + "List";
        (*variables)["mutable_list_name"] = "mutable" + UnderscoresToCapitalizedCamelCase(descriptor) + "List";
        (*variables)["number"] = SimpleItoa(descriptor->number());
        (*variables)["type"] = type;
        (*variables)["storage_type"] = type + "*";
        (*variables)["default"] = "[" + type + " " + default_value->name() + "]";

        string boxed_value = "value";
        switch (GetObjectiveCType(descriptor)) {
          case OBJECTIVECTYPE_INT:
            boxed_value = "[NSNumber numberWithInt:value]";
            break;
          case OBJECTIVECTYPE_LONG:
            boxed_value = "[NSNumber numberWithLongLong:value]";
            break;
          case OBJECTIVECTYPE_FLOAT:
            boxed_value = "[NSNumber numberWithFloat:value]";
            break;
          case OBJECTIVECTYPE_DOUBLE:
            boxed_value = "[NSNumber numberWithDouble:value]";
            break;
          case OBJECTIVECTYPE_BOOLEAN:
            boxed_value = "[NSNumber numberWithBool:value]";
            break;
        } 

        (*variables)["boxed_value"] = boxed_value;

        string unboxed_value = "value";
        switch (GetObjectiveCType(descriptor)) {
          case OBJECTIVECTYPE_INT:
            unboxed_value = "[value intValue]";
            break;
          case OBJECTIVECTYPE_LONG:
            unboxed_value = "[value longLongValue]";
            break;
          case OBJECTIVECTYPE_FLOAT:
            unboxed_value = "[value floatValue]";
            break;
          case OBJECTIVECTYPE_DOUBLE:
            unboxed_value = "[value doubleValue]";
            break;
          case OBJECTIVECTYPE_BOOLEAN:
            unboxed_value = "[value boolValue]";
            break;
        } 

        (*variables)["unboxed_value"] = unboxed_value;
    }
  }  // namespace

  EnumFieldGenerator::EnumFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
      SetEnumVariables(descriptor, &variables_);
  }


  EnumFieldGenerator::~EnumFieldGenerator() {
  }


  void EnumFieldGenerator::GenerateHasFieldHeader(io::Printer* printer) const {
    printer->Print(variables_, "BOOL has$capitalized_name$:1;\n");
  }


  void EnumFieldGenerator::GenerateFieldHeader(io::Printer* printer) const {
    printer->Print(variables_, "$storage_type$ $name$;\n");
  }


  void EnumFieldGenerator::GenerateHasPropertyHeader(io::Printer* printer) const {
    printer->Print(variables_, "- (BOOL) has$capitalized_name$;\n");
  }


  void EnumFieldGenerator::GeneratePropertyHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "@property (retain, readonly) $storage_type$ $name$;\n");
  }


  void EnumFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
    printer->Print(variables_,
      "@property (retain) $storage_type$ $name$;\n");
  }


  void EnumFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
  }


  void EnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
  }


  void EnumFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "- (BOOL) has$capitalized_name$ {\n"
      "  return has$capitalized_name$ != 0;\n"
      "}\n"
      "- (void) setHas$capitalized_name$:(BOOL) has$capitalized_name$_ {\n"
      "  has$capitalized_name$ = (has$capitalized_name$_ != 0);\n"
      "}\n"
      "@synthesize $name$;\n");
  }


  void EnumFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
    printer->Print(variables_, "self.$name$ = nil;\n");
  }


  void EnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
    printer->Print(variables_, "self.$name$ = $default$;\n");
  }


  void EnumFieldGenerator::GenerateBuilderMembersHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "- (BOOL) has$capitalized_name$;\n"
      "- ($storage_type$) $name$;\n"\
      "- ($classname$_Builder*) set$capitalized_name$:($storage_type$) value;\n"
      "- ($classname$_Builder*) clear$capitalized_name$;\n");
  }


  void EnumFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "- (BOOL) has$capitalized_name$ {\n"
      "  return result.has$capitalized_name$;\n"
      "}\n"
      "- ($storage_type$) $name$ {\n"
      "  return result.$name$;\n"
      "}\n"
      "- ($classname$_Builder*) set$capitalized_name$:($storage_type$) value {\n"
      "  result.has$capitalized_name$ = YES;\n"
      "  result.$name$ = value;\n"
      "  return self;\n"
      "}\n"
      "- ($classname$_Builder*) clear$capitalized_name$ {\n"
      "  result.has$capitalized_name$ = NO;\n"
      "  result.$name$ = $default$;\n"
      "  return self;\n"
      "}\n");
  }


  void EnumFieldGenerator::GenerateMergingCodeHeader(io::Printer* printer) const {
  }


  void EnumFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if (other.has$capitalized_name$) {\n"
      "  [self set$capitalized_name$:other.$name$];\n"
      "}\n");
  }

  void EnumFieldGenerator::GenerateBuildingCodeHeader(io::Printer* printer) const {
  }


  void EnumFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
  }


  void EnumFieldGenerator::GenerateParsingCodeHeader(io::Printer* printer) const {
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


  void EnumFieldGenerator::GenerateSerializationCodeHeader(io::Printer* printer) const {
  }


  void EnumFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if (has$capitalized_name$) {\n"
      "  [output writeEnum:$number$ value:self.$name$.number];\n"
      "}\n");
  }


  void EnumFieldGenerator::GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
  }


  void EnumFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "if (has$capitalized_name$) {\n"
      "  size += computeEnumSize($number$, self.$name$.number);\n"
      "}\n");
  }


  string EnumFieldGenerator::GetBoxedType() const {
    return ClassName(descriptor_->enum_type());
  }


  RepeatedEnumFieldGenerator::RepeatedEnumFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
      SetEnumVariables(descriptor, &variables_);
  }


  RepeatedEnumFieldGenerator::~RepeatedEnumFieldGenerator() {
  }


  void RepeatedEnumFieldGenerator::GenerateHasFieldHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateFieldHeader(io::Printer* printer) const {
    printer->Print(variables_, "NSMutableArray* $mutable_list_name$;\n");
  }


  void RepeatedEnumFieldGenerator::GenerateHasPropertyHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GeneratePropertyHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateExtensionSource(io::Printer* printer) const {
    printer->Print(variables_,
      "@property (retain) NSMutableArray* $mutable_list_name$;\n");
  }

  void RepeatedEnumFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "@synthesize $mutable_list_name$;\n");
  }

  void RepeatedEnumFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
    printer->Print(variables_,
      "self.$mutable_list_name$ = nil;\n");
  }


  void RepeatedEnumFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "- (NSArray*) $list_name$;\n"
      "- ($storage_type$) $name$AtIndex:(int32_t) index;\n");
  }

  void RepeatedEnumFieldGenerator::GenerateBuilderMembersHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "- (NSArray*) $list_name$;\n"
      "- ($storage_type$) $name$AtIndex:(int32_t) index;\n"
      "- ($classname$_Builder*) replace$capitalized_name$AtIndex:(int32_t) index with:($storage_type$) value;\n"
      "- ($classname$_Builder*) add$capitalized_name$:($storage_type$) value;\n"
      "- ($classname$_Builder*) addAll$capitalized_name$:(NSArray*) values;\n"
      "- ($classname$_Builder*) clear$capitalized_name$List;\n");
  }


  void RepeatedEnumFieldGenerator::GenerateMergingCodeHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateBuildingCodeHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateParsingCodeHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateSerializationCodeHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
  }


  void RepeatedEnumFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "- (NSArray*) $list_name$ {\n"
      "  return $mutable_list_name$;\n"
      "}\n"
      "- ($storage_type$) $name$AtIndex:(int32_t) index {\n"
      "  id value = [$mutable_list_name$ objectAtIndex:index];\n"
      "  return $unboxed_value$;\n"
      "}\n");
  }

  void RepeatedEnumFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "- (NSArray*) $list_name$ {\n"
      "  return result.$mutable_list_name$;\n"
      "}\n"
      "- ($storage_type$) $name$AtIndex:(int32_t) index {\n"
      "  return [result $name$AtIndex:index];\n"
      "}\n"
      "- ($classname$_Builder*) replace$capitalized_name$AtIndex:(int32_t) index with:($storage_type$) value {\n"
      "  [result.$mutable_list_name$ replaceObjectAtIndex:index withObject:$boxed_value$];\n"
      "  return self;\n"
      "}\n"
      "- ($classname$_Builder*) add$capitalized_name$:($storage_type$) value {\n"
      "  if (result.$mutable_list_name$ == nil) {\n"
      "    result.$mutable_list_name$ = [NSMutableArray array];\n"
      "  }\n"
      "  [result.$mutable_list_name$ addObject:$boxed_value$];\n"
      "  return self;\n"
      "}\n"
      "- ($classname$_Builder*) addAll$capitalized_name$:(NSArray*) values {\n"
      "  if (result.$mutable_list_name$ == nil) {\n"
      "    result.$mutable_list_name$ = [NSMutableArray array];\n"
      "  }\n"
      "  [result.$mutable_list_name$ addObjectsFromArray:values];\n"
      "  return self;\n"
      "}\n"
      "- ($classname$_Builder*) clear$capitalized_name$List {\n"
      "  result.$mutable_list_name$ = nil;\n"
      "  return self;\n"
      "}\n");
  }

  void RepeatedEnumFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "if (other.$mutable_list_name$.count > 0) {\n"
        "  if (result.$mutable_list_name$ == nil) {\n"
        "    result.$mutable_list_name$ = [NSMutableArray array];\n"
        "  }\n"
        "  [result.$mutable_list_name$ addObjectsFromArray:other.$mutable_list_name$];\n"
        "}\n");
  }

  void RepeatedEnumFieldGenerator::GenerateBuildingCodeSource(io::Printer* printer) const {
  }

  void RepeatedEnumFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "int32_t rawValue = [input readEnum];\n"
      "$storage_type$ value = [$type$ valueOf:rawValue];\n"
      "if (value == nil) {\n"
      "  [unknownFields mergeVarintField:$number$ value:rawValue];\n"
      "} else {\n"
      "  [self add$capitalized_name$:value];\n"
      "}\n");
  }

  void RepeatedEnumFieldGenerator::GenerateSerializationCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "for ($storage_type$ element in self.$list_name$) {\n"
        "  [output writeEnum:$number$ value:element.number];\n"
        "}\n");
  }


  void RepeatedEnumFieldGenerator::GenerateSerializedSizeCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "for ($storage_type$ element in self.$list_name$) {\n"
        "  size += computeEnumSize($number$, element.number);\n"
        "}\n");
  }


  string RepeatedEnumFieldGenerator::GetBoxedType() const {
    return ClassName(descriptor_->enum_type());
  }
}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google