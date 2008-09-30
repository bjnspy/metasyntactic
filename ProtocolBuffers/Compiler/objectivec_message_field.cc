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

#include <google/protobuf/compiler/objectivec/objectivec_message_field.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/stubs/strutil.h>

namespace google {
namespace protobuf {
namespace compiler {
namespace objectivec {

namespace {

// TODO(kenton):  Factor out a "SetCommonFieldVariables()" to get rid of
//   repeat code between this and the other field types.
void SetMessageVariables(const FieldDescriptor* descriptor,
                         map<string, string>* variables) {
  (*variables)["classname"] = ClassName(descriptor->containing_type());
  (*variables)["name"] =
    UnderscoresToCamelCase(descriptor);
  (*variables)["capitalized_name"] =
    UnderscoresToCapitalizedCamelCase(descriptor);
  (*variables)["number"] = SimpleItoa(descriptor->number());
    (*variables)["type"] = ClassName(descriptor->message_type());
  if (IsPrimitiveType(GetObjectiveCType(descriptor))) {
    (*variables)["storage_type"] = ClassName(descriptor->message_type());
  } else {
    (*variables)["storage_type"] = string(ClassName(descriptor->message_type())) + "*";
  }
  (*variables)["group_or_message"] =
    (descriptor->type() == FieldDescriptor::TYPE_GROUP) ?
    "Group" : "Message";

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
}

}  // namespace

// ===================================================================

MessageFieldGenerator::
MessageFieldGenerator(const FieldDescriptor* descriptor)
  : descriptor_(descriptor) {
  SetMessageVariables(descriptor, &variables_);
}

MessageFieldGenerator::~MessageFieldGenerator() {}


void MessageFieldGenerator::
GenerateFieldsHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "BOOL has$capitalized_name$;\n"
    "$storage_type$ $name$_;\n");
}

void MessageFieldGenerator::GeneratePropertiesHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "@property BOOL has$capitalized_name$;\n"
    "@property (retain) $storage_type$ $name$_;\n");
}

void MessageFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
   // "- (BOOL) has$capitalized_name$ { return has$capitalized_name$; }\n"
    "- ($storage_type$) get$capitalized_name$;\n");
}

void MessageFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "@synthesize has$capitalized_name$;\n"
    "@synthesize $name$_;\n");
}

void MessageFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
  printer->Print(variables_,
    "self.has$capitalized_name$ = NO;\n"
    "self.$name$_ = nil;\n");
}

void MessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
}

void MessageFieldGenerator::
GenerateBuilderMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "- (BOOL) has$capitalized_name$;\n"
    "- ($storage_type$) get$capitalized_name$;\n"
    "- (id<Message_Builder>) set$capitalized_name$:($storage_type$) value;\n"
    "- (id<Message_Builder>) set$capitalized_name$Builder:($type$_Builder*) builderForValue;\n"
    "- (id<Message_Builder>) merge$capitalized_name$:($storage_type$) value;\n"
    "- (id<Message_Builder>) clear$capitalized_name$;\n");
}

void MessageFieldGenerator::GenerateBuilderMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    "- (BOOL) has$capitalized_name$ {\n"
    "  return result.has$capitalized_name$;\n"
    "}\n"
    "- ($storage_type$) get$capitalized_name$ {\n"
    "  return result.get$capitalized_name$;\n"
    "}\n"
    "- (id<Message_Builder>) set$capitalized_name$:($storage_type$) value {\n"
    "  result.has$capitalized_name$ = YES;\n"
    "  result.$name$_ = value;\n"
    "  return self;\n"
    "}\n"
    "- (id<Message_Builder>) set$capitalized_name$Builder:($type$_Builder*) builderForValue {\n"
    "  result.has$capitalized_name$ = YES;\n"
    "  result.$name$_ = [builderForValue build];\n"
    "  return self;\n"
    "}\n"
    "- (id<Message_Builder>) merge$capitalized_name$:($storage_type$) value {\n"
    "  if (result.has$capitalized_name$ &&\n"
    "      result.$name$_ != [$type$ getDefaultInstance]) {\n"
    "    result.$name$_ =\n"
    "      [[[$type$ newBuilderWith$type$:result.$name$_] mergeFrom$type$:value] buildPartial];\n"
    "  } else {\n"
    "    result.$name$_ = value;\n"
    "  }\n"
    "  result.has$capitalized_name$ = YES;\n"
    "  return self;\n"
    "}\n"
    "- (id<Message_Builder>) clear$capitalized_name$ {\n"
    "  result.has$capitalized_name$ = NO;\n"
    "  result.$name$_ = [$type$ getDefaultInstance];\n"
    "  return self;\n"
    "}\n");
}

void MessageFieldGenerator::GenerateMergingCodeHeader(io::Printer* printer) const {
}

void MessageFieldGenerator::GenerateMergingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (other.has$capitalized_name$) {\n"
    "  [self merge$capitalized_name$:other.get$capitalized_name$];\n"
    "}\n");
}

void MessageFieldGenerator::GenerateBuildingCodeHeader(io::Printer* printer) const {
  // Nothing to do for singular fields.
}

void MessageFieldGenerator::
GenerateBuildingCodeSource(io::Printer* printer) const {
  // Nothing to do for singular fields.
}

void MessageFieldGenerator::GenerateParsingCodeHeader(io::Printer* printer) const {
}

void MessageFieldGenerator::GenerateParsingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "$type$_Builder* subBuilder = [$type$ newBuilder];\n"
    "if (self.has$capitalized_name$) {\n"
    "  [subBuilder mergeFrom$type$:self.get$capitalized_name$];\n"
    "}\n");

  if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
    printer->Print(variables_,
      "[input readGroup:$number$ builder:subBuilder extensionRegistry:extensionRegistry];\n");
  } else {
    printer->Print(variables_,
      "[input readMessage:subBuilder extensionRegistry:extensionRegistry];\n");
  }

  printer->Print(variables_,
    "[self set$capitalized_name$:[subBuilder buildPartial]];\n");
}

void MessageFieldGenerator::GenerateSerializationCodeHeader(io::Printer* printer) const {
}

void MessageFieldGenerator::
GenerateSerializationCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (self.has$capitalized_name$) {\n"
    "  [output write$group_or_message$:$number$ value:self.get$capitalized_name$];\n"
    "}\n");
}

void MessageFieldGenerator::
GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
}

void MessageFieldGenerator::
GenerateSerializedSizeCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (self.has$capitalized_name$) {\n"
    "  size += compute$group_or_message$Size($number$, self.get$capitalized_name$);\n"
    "}\n");
}

void MessageFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    "- (BOOL) has$capitalized_name$ { return has$capitalized_name$; }\n"
    "- ($storage_type$) get$capitalized_name$ { return $name$_; }\n");
}

string MessageFieldGenerator::GetBoxedType() const {
  return ClassName(descriptor_->message_type());
}

// ===================================================================

RepeatedMessageFieldGenerator::
RepeatedMessageFieldGenerator(const FieldDescriptor* descriptor)
  : descriptor_(descriptor) {
  SetMessageVariables(descriptor, &variables_);
}

RepeatedMessageFieldGenerator::~RepeatedMessageFieldGenerator() {}


void RepeatedMessageFieldGenerator::
GenerateFieldsHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "NSMutableArray* $name$_;\n");
}

void RepeatedMessageFieldGenerator::
GeneratePropertiesHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "@property (retain) NSMutableArray* $name$_;\n");
}

void RepeatedMessageFieldGenerator::GenerateSynthesizeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "@synthesize $name$_;\n");
}

void RepeatedMessageFieldGenerator::GenerateDeallocSource(io::Printer* printer) const {
  printer->Print(variables_,
    "self.$name$_ = nil;\n");
}

void RepeatedMessageFieldGenerator::GenerateInitializationSource(io::Printer* printer) const {
}


void RepeatedMessageFieldGenerator::GenerateMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
    "- (NSArray*) get$capitalized_name$List;\n"
    "- (int32_t) get$capitalized_name$Count;\n"
    "- ($storage_type$) get$capitalized_name$:(int32_t) index;\n");
}

void RepeatedMessageFieldGenerator::GenerateMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    "- (NSArray*) get$capitalized_name$List {\n"
    "  return $name$_;\n"   // note:  unmodifiable list
    "}\n"
    "- (int32_t) get$capitalized_name$Count { return $name$_.count; }\n"
    "- ($storage_type$) get$capitalized_name$:(int32_t) index {\n"
    "  return [$name$_ objectAtIndex:index];\n"
    "}\n");
}

void RepeatedMessageFieldGenerator::GenerateBuilderMembersHeader(io::Printer* printer) const {
  printer->Print(variables_,
    // Note:  We return an unmodifiable list because otherwise the caller
    //   could hold on to the returned list and modify it after the message
    //   has been built, thus mutating the message which is supposed to be
    //   immutable.
    "- (NSArray*) get$capitalized_name$List;\n"
    "- (int32_t) get$capitalized_name$Count;\n"
    "- ($storage_type$) get$capitalized_name$:(int32_t) index;\n"
    "- ($classname$_Builder*) set$capitalized_name$:(int32_t) index value:($storage_type$) value;\n"
    "- ($classname$_Builder*) set$capitalized_name$:(int32_t) index builderForValue:($type$_Builder*) builderForValue;\n"
    "- ($classname$_Builder*) add$capitalized_name$Builder:($type$_Builder*) builderForValue;\n"
    "- ($classname$_Builder*) addAll$capitalized_name$:(NSArray*) values;\n"
    "- ($classname$_Builder*) clear$capitalized_name$;\n");
  //    

    printer->Print(variables_,
      "- ($classname$_Builder*) add$capitalized_name$:($storage_type$) value;\n");
}

void RepeatedMessageFieldGenerator::
GenerateBuilderMembersSource(io::Printer* printer) const {
  printer->Print(variables_,
    // Note:  We return an unmodifiable list because otherwise the caller
    //   could hold on to the returned list and modify it after the message
    //   has been built, thus mutating the message which is supposed to be
    //   immutable.
    "- (NSArray*) get$capitalized_name$List {\n"
    "  if (result.$name$_ == nil) { return [NSArray array]; }\n"
    "  return [NSArray arrayWithObjects:result.$name$_];\n"
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
    "- ($classname$_Builder*) set$capitalized_name$:(int32_t) index builderForValue:($type$_Builder*) builderForValue {\n"
    "  [result.$name$_ replaceObjectAtIndex:index withObject:[builderForValue build]];\n"
    "  return self;\n"
    "}\n"
    "- ($classname$_Builder*) add$capitalized_name$Builder:($type$_Builder*) builderForValue {\n"
    "  if (result.$name$_ == nil) {\n"
    "    result.$name$_ = [NSMutableArray array];\n"
    "  }\n"
    "  [result.$name$_ addObject:[builderForValue build]];\n"
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

  if (IsReferenceType(GetObjectiveCType(descriptor_))) {
    printer->Print(
      variables_,
      "- ($classname$_Builder*) add$capitalized_name$:($storage_type$) value {\n"
      "  if (result.$name$_ == nil) {\n"
      "    result.$name$_ = [NSMutableArray array];\n"
      "  }\n"
      "  [result.$name$_ addObject:value];\n"
      "  return self;\n"
      "}\n");
  } else {
    printer->Print(
      variables_,
      "- ($classname$_Builder*) add$capitalized_name$:($storage_type$) value {\n"
      "  if (result.$name$_ == nil) {\n"
      "    result.$name$_ = [NSMutableArray array];\n"
      "  }\n"
      "  [result.$name$_ addObject:$boxed_value$];\n"
      "  return self;\n"
      "}\n");
  }
}

void RepeatedMessageFieldGenerator::
GenerateMergingCodeHeader(io::Printer* printer) const {
}

void RepeatedMessageFieldGenerator::
GenerateBuildingCodeHeader(io::Printer* printer) const {
}

void RepeatedMessageFieldGenerator::
GenerateParsingCodeHeader(io::Printer* printer) const {
}

void RepeatedMessageFieldGenerator::
GenerateSerializationCodeHeader(io::Printer* printer) const {
}

void RepeatedMessageFieldGenerator::
GenerateSerializedSizeCodeHeader(io::Printer* printer) const {
}



void RepeatedMessageFieldGenerator::
GenerateMergingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "if (other.$name$_.count > 0) {\n"
    "  if (result.$name$_ == nil) {\n"
    "    result.$name$_ = [NSMutableArray array];\n"
    "  }\n"
    "  [result.$name$_ addObjectsFromArray:other.$name$_];\n"
    "}\n");
}

void RepeatedMessageFieldGenerator::
GenerateBuildingCodeSource(io::Printer* printer) const {
}

void RepeatedMessageFieldGenerator::
GenerateParsingCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "$type$_Builder* subBuilder = [$type$ newBuilder];\n");

  if (descriptor_->type() == FieldDescriptor::TYPE_GROUP) {
    printer->Print(variables_,
      "[input readGroup:$number$ builder:subBuilder extensionRegistry:extensionRegistry];\n");
  } else {
    printer->Print(variables_,
      "[input readMessage:subBuilder extensionRegistry:extensionRegistry];\n");
  }

  printer->Print(variables_,
    "[self add$capitalized_name$:[subBuilder buildPartial]];\n");
}

void RepeatedMessageFieldGenerator::
GenerateSerializationCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "for ($type$* element in self.get$capitalized_name$List) {\n"
    "  [output write$group_or_message$:$number$ value:element];\n"
    "}\n");
}

void RepeatedMessageFieldGenerator::
GenerateSerializedSizeCodeSource(io::Printer* printer) const {
  printer->Print(variables_,
    "for ($type$* element in self.get$capitalized_name$List) {\n"
    "  size += compute$group_or_message$Size($number$, element);\n"
    "}\n");
}

string RepeatedMessageFieldGenerator::GetBoxedType() const {
  return ClassName(descriptor_->message_type());
}

}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
