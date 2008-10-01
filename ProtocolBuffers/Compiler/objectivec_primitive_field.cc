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

#include <google/protobuf/compiler/objectivec/objectivec_primitive_field.h>
#include <google/protobuf/stubs/common.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/stubs/substitute.h>

namespace google { namespace protobuf { namespace compiler { namespace objectivec {

  namespace {

    const char* PrimitiveTypeName(ObjectiveCType type) {
      switch (type) {
    case OBJECTIVECTYPE_INT    : return "int32_t";
    case OBJECTIVECTYPE_LONG   : return "int64_t";
    case OBJECTIVECTYPE_FLOAT  : return "Float32";
    case OBJECTIVECTYPE_DOUBLE : return "Float64";
    case OBJECTIVECTYPE_BOOLEAN: return "BOOL";
    case OBJECTIVECTYPE_STRING : return "NSString";
    case OBJECTIVECTYPE_DATA   : return "NSData";
    case OBJECTIVECTYPE_ENUM   : return NULL;
    case OBJECTIVECTYPE_MESSAGE: return NULL;

      // No default because we want the compiler to complain if any new
      // ObjectiveCTypes are added.
      }

      GOOGLE_LOG(FATAL) << "Can't get here.";
      return NULL;
    }

    const char* GetCapitalizedType(const FieldDescriptor* field) {
      switch (field->type()) {
    case FieldDescriptor::TYPE_INT32   : return "Int32"   ;
    case FieldDescriptor::TYPE_UINT32  : return "UInt32"  ;
    case FieldDescriptor::TYPE_SINT32  : return "SInt32"  ;
    case FieldDescriptor::TYPE_FIXED32 : return "Fixed32" ;
    case FieldDescriptor::TYPE_SFIXED32: return "SFixed32";
    case FieldDescriptor::TYPE_INT64   : return "Int64"   ;
    case FieldDescriptor::TYPE_UINT64  : return "UInt64"  ;
    case FieldDescriptor::TYPE_SINT64  : return "SInt64"  ;
    case FieldDescriptor::TYPE_FIXED64 : return "Fixed64" ;
    case FieldDescriptor::TYPE_SFIXED64: return "SFixed64";
    case FieldDescriptor::TYPE_FLOAT   : return "Float"   ;
    case FieldDescriptor::TYPE_DOUBLE  : return "Double"  ;
    case FieldDescriptor::TYPE_BOOL    : return "Bool"    ;
    case FieldDescriptor::TYPE_STRING  : return "String"  ;
    case FieldDescriptor::TYPE_BYTES   : return "Bytes"   ;
    case FieldDescriptor::TYPE_ENUM    : return "Enum"    ;
    case FieldDescriptor::TYPE_GROUP   : return "Group"   ;
    case FieldDescriptor::TYPE_MESSAGE : return "Message" ;

      // No default because we want the compiler to complain if any new
      // types are added.
      }

      GOOGLE_LOG(FATAL) << "Can't get here.";
      return NULL;
    }

    bool AllPrintableAscii(const string& text) {
      // Cannot use isprint() because it's locale-specific.  :(
      for (int i = 0; i < text.size(); i++) {
        if ((text[i] < 0x20) || text[i] >= 0x7F) {
          return false;
        }
      }
      return true;
    }

    string DefaultValue(const FieldDescriptor* field) {
      // Switch on cpp_type since we need to know which default_value_* method
      // of FieldDescriptor to call.
      switch (field->cpp_type()) {
    case FieldDescriptor::CPPTYPE_INT32:
      return SimpleItoa(field->default_value_int32());
    case FieldDescriptor::CPPTYPE_UINT32:
      // Need to print as a signed int since ObjectiveC has no unsigned.
      return SimpleItoa(static_cast<int32>(field->default_value_uint32()));
    case FieldDescriptor::CPPTYPE_INT64:
      return SimpleItoa(field->default_value_int64()) + "L";
    case FieldDescriptor::CPPTYPE_UINT64:
      return SimpleItoa(static_cast<int64>(field->default_value_uint64())) +
        "L";
    case FieldDescriptor::CPPTYPE_DOUBLE:
      return SimpleDtoa(field->default_value_double());
    case FieldDescriptor::CPPTYPE_FLOAT:
      return SimpleFtoa(field->default_value_float());
    case FieldDescriptor::CPPTYPE_BOOL:
      return field->default_value_bool() ? "YES" : "NO";
    case FieldDescriptor::CPPTYPE_STRING: {
      bool isBytes = field->type() == FieldDescriptor::TYPE_BYTES;

      if (!isBytes && AllPrintableAscii(field->default_value_string())) {
        // All chars are ASCII and printable.  In this case CEscape() works
        // fine (it will only escape quotes and backslashes).
        // Note:  If this "optimization" is removed, DescriptorProtos will
        //   no longer be able to initialize itself due to bootstrapping
        //   problems.
        return "@\"" + CEscape(field->default_value_string()) + "\"";
      }

      if (isBytes && !field->has_default_value()) {
        return "[NSData data]";
      }

      // Escaping strings correctly for ObjectiveC and generating efficient
      // initializers for ByteStrings are both tricky.  We can sidestep the
      // whole problem by just grabbing the default value from the descriptor.
      return strings::Substitute(
        "([[[$0 getDescriptor].getFields objectAtIndex:$1] getDefaultValue])",
        ClassName(field->containing_type()), field->index());
                                          }

    case FieldDescriptor::CPPTYPE_ENUM:
    case FieldDescriptor::CPPTYPE_MESSAGE:
      GOOGLE_LOG(FATAL) << "Can't get here.";
      return "";

      // No default because we want the compiler to complain if any new
      // types are added.
      }

      GOOGLE_LOG(FATAL) << "Can't get here.";
      return "";
    }

    void SetPrimitiveVariables(const FieldDescriptor* descriptor,
      map<string, string>* variables) {
        (*variables)["classname"] = ClassName(descriptor->containing_type());
        (*variables)["name"] = UnderscoresToCamelCase(descriptor);
        (*variables)["capitalized_name"] = UnderscoresToCapitalizedCamelCase(descriptor);
        (*variables)["number"] = SimpleItoa(descriptor->number());
        (*variables)["type"] = PrimitiveTypeName(GetObjectiveCType(descriptor));

        if (IsPrimitiveType(GetObjectiveCType(descriptor))) {
          (*variables)["storage_type"] = PrimitiveTypeName(GetObjectiveCType(descriptor));
        } else {
          (*variables)["storage_type"] = string(PrimitiveTypeName(GetObjectiveCType(descriptor))) + "*";
        }

        (*variables)["boxed_type"] = BoxedPrimitiveTypeName(GetObjectiveCType(descriptor));
        (*variables)["default"] = DefaultValue(descriptor);
        (*variables)["capitalized_type"] = GetCapitalizedType(descriptor);
    }

  }  // namespace

  // ===================================================================

  PrimitiveFieldGenerator::
    PrimitiveFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
      SetPrimitiveVariables(descriptor, &variables_);
  }

  PrimitiveFieldGenerator::~PrimitiveFieldGenerator() {}

  void PrimitiveFieldGenerator::GenerateFieldsHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "BOOL has$capitalized_name$;\n"
      "$storage_type$ $name$_;\n");
  }

  void PrimitiveFieldGenerator::GeneratePropertiesHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "@property BOOL has$capitalized_name$;\n");
    if (IsReferenceType(GetObjectiveCType(descriptor_))) {
      printer->Print(variables_,
        "@property (retain) $storage_type$ $name$_;\n");
    } else {
      printer->Print(variables_,
        "@property $storage_type$ $name$_;\n");
    }
  }

  void PrimitiveFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "@synthesize has$capitalized_name$;\n"
      "@synthesize $name$_;\n");
  }

  void PrimitiveFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
    printer->Print(variables_,
      "self.has$capitalized_name$ = NO;\n");

    if (IsReferenceType(GetObjectiveCType(descriptor_))) {
      printer->Print(variables_,
        "self.$name$_ = nil;\n");
    } else {
      printer->Print(variables_,
        "self.$name$_ = 0;\n");
    }
  }


  void PrimitiveFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
    printer->Print(variables_,
      "self.$name$_ = $default$;\n");
  }

  void PrimitiveFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "- (BOOL) has$capitalized_name$;\n"
      "- ($storage_type$) get$capitalized_name$;\n");
  }

  void PrimitiveFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "- (BOOL) has$capitalized_name$ { return has$capitalized_name$; }\n"
      "- ($storage_type$) get$capitalized_name$ { return $name$_; }\n");
  }

  void PrimitiveFieldGenerator::
    GenerateBuilderMembersHeader(io::Printer* printer) const {
      printer->Print(variables_,
        "- (BOOL) has$capitalized_name$;\n"
        "- ($storage_type$) get$capitalized_name$;\n"
        "- ($classname$_Builder*) set$capitalized_name$:($storage_type$) value;\n"
        "- ($classname$_Builder*) clear$capitalized_name$;\n");
  }

  void PrimitiveFieldGenerator::
    GenerateMergingCodeHeader(io::Printer* printer) const {
  }

  void PrimitiveFieldGenerator::
    GenerateBuildingCodeHeader(io::Printer* printer) const {
      // Nothing to do here for primitive types.
  }

  void PrimitiveFieldGenerator::
    GenerateParsingCodeHeader(io::Printer* printer) const {
  }

  void PrimitiveFieldGenerator::
    GenerateSerializationCodeHeader(io::Printer* printer) const {
  }

  void PrimitiveFieldGenerator::
    GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
  }

  void PrimitiveFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
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

  void PrimitiveFieldGenerator::
    GenerateMergingCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "if (other.has$capitalized_name$) {\n"
        "  [self set$capitalized_name$:other.get$capitalized_name$];\n"
        "}\n");
  }

  void PrimitiveFieldGenerator::
    GenerateBuildingCodeSource(io::Printer* printer) const {
      // Nothing to do here for primitive types.
  }

  void PrimitiveFieldGenerator::
    GenerateParsingCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "[self set$capitalized_name$:[input read$capitalized_type$]];\n");
  }

  void PrimitiveFieldGenerator::
    GenerateSerializationCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "if (has$capitalized_name$) {\n"
        "  [output write$capitalized_type$:$number$ value:self.get$capitalized_name$];\n"
        "}\n");
  }

  void PrimitiveFieldGenerator::
    GenerateSerializedSizeCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "if (has$capitalized_name$) {\n"
        "  size += compute$capitalized_type$Size($number$, self.get$capitalized_name$);\n"
        "}\n");
  }

  string PrimitiveFieldGenerator::GetBoxedType() const {
    return BoxedPrimitiveTypeName(GetObjectiveCType(descriptor_));
  }

  // ===================================================================

  RepeatedPrimitiveFieldGenerator::
    RepeatedPrimitiveFieldGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {
      SetPrimitiveVariables(descriptor, &variables_);
  }

  RepeatedPrimitiveFieldGenerator::~RepeatedPrimitiveFieldGenerator() {}


  void RepeatedPrimitiveFieldGenerator::GenerateFieldsHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "NSMutableArray* $name$_;\n");
  }

  void RepeatedPrimitiveFieldGenerator::GeneratePropertiesHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "@property (retain) NSMutableArray* $name$_;\n");
  }

  void RepeatedPrimitiveFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
    printer->Print(variables_,
      "@synthesize $name$_;\n");
  }

  void RepeatedPrimitiveFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
    printer->Print(variables_,
      "self.$name$_ = nil;\n");
  }

  void RepeatedPrimitiveFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {;
  }

  void RepeatedPrimitiveFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
    printer->Print(variables_,
      "- (NSArray*) get$capitalized_name$List;\n"
      "- (int32_t) get$capitalized_name$Count;\n"
      "- ($storage_type$) get$capitalized_name$:(int32_t) index;\n");
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateBuilderMembersHeader(io::Printer* printer) const {
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

  void RepeatedPrimitiveFieldGenerator::
    GenerateMergingCodeHeader(io::Printer* printer) const {
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateBuildingCodeHeader(io::Printer* printer) const {
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateParsingCodeHeader(io::Printer* printer) const {
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateSerializationCodeHeader(io::Printer* printer) const {
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
  }


  void RepeatedPrimitiveFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
    printer->Print(variables_,
      "- (NSArray*) get$capitalized_name$List {\n"
      "  return $name$_;\n"   // note:  unmodifiable list
      "}\n"
      "- (int32_t) get$capitalized_name$Count { return $name$_.count; }\n"
      "- ($storage_type$) get$capitalized_name$:(int32_t) index {\n"
      "  return [$name$_ objectAtIndex:index];\n"
      "}\n");
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateBuilderMembersSource(io::Printer* printer) const {
      printer->Print(variables_,
        // Note:  We return an unmodifiable list because otherwise the caller
        //   could hold on to the returned list and modify it after the message
        //   has been built, thus mutating the message which is supposed to be
        //   immutable.
        "- (NSArray*) get$capitalized_name$List {\n"
        "  if (result.$name$_ == nil) { return [NSArray array]; }\n"
        "  return [NSArray arrayWithArray:result.$name$_];\n"
        "}\n"
        "- (int32_t) get$capitalized_name$Count {\n"
        "  return result.get$capitalized_name$Count;\n"
        "}\n"
        "- ($storage_type$) get$capitalized_name$:(int32_t) index {\n"
        "  return [result get$capitalized_name$:index];\n"
        "}\n"
        "- ($classname$_Builder*) set$capitalized_name$:(int32_t) index value:($storage_type$) value {\n"
        "  [result.$name$_ replaceObjectAtIndex:index withObject:value];\n"
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

  void RepeatedPrimitiveFieldGenerator::
    GenerateMergingCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "if (other.$name$_.count > 0) {\n"
        "  if (result.$name$_ == nil) {\n"
        "    result.$name$_ = [NSMutableArray array];\n"
        "  }\n"
        "  [result.$name$_ addObjectsFromArray:other.$name$_];\n"
        "}\n");
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateBuildingCodeSource(io::Printer* printer) const {
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateParsingCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "[self add$capitalized_name$:[input read$capitalized_type$]];\n");
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateSerializationCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "for ($storage_type$ element in self.get$capitalized_name$List) {\n"
        "  [output write$capitalized_type$:$number$ value:element];\n"
        "}\n");
  }

  void RepeatedPrimitiveFieldGenerator::
    GenerateSerializedSizeCodeSource(io::Printer* printer) const {
      printer->Print(variables_,
        "for ($storage_type$ element in self.get$capitalized_name$List) {\n"
        "  size += compute$capitalized_type$Size($number$, element);\n"
        "}\n");
  }


  string RepeatedPrimitiveFieldGenerator::GetBoxedType() const {
    return BoxedPrimitiveTypeName(GetObjectiveCType(descriptor_));
  }

}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
