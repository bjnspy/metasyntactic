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

#include <google/protobuf/compiler/objectivec/objectivec_extension.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/io/printer.h>

namespace google { namespace protobuf { namespace compiler { namespace objectivec {

  ExtensionGenerator::ExtensionGenerator(const FieldDescriptor* descriptor)
    : descriptor_(descriptor) {}

  ExtensionGenerator::~ExtensionGenerator() {}

  void ExtensionGenerator::GenerateFieldsSource(io::Printer* printer) {
    map<string, string> vars;
    vars["name"] = UnderscoresToCamelCase(descriptor_);
    vars["containing_type"] = ClassName(descriptor_->containing_type());
    vars["index"] = SimpleItoa(descriptor_->index());

    ObjectiveCType objectivec_type = GetObjectiveCType(descriptor_);
    string singular_type;
    switch (objectivec_type) {
    case OBJECTIVECTYPE_MESSAGE:
      vars["type"] = ClassName(descriptor_->message_type());
      break;
    case OBJECTIVECTYPE_ENUM:
      vars["type"] = ClassName(descriptor_->enum_type());
      break;
    default:
      vars["type"] = BoxedPrimitiveTypeName(objectivec_type);
      break;
    }

    printer->Print(vars,
      "static GeneratedMessage_GeneratedExtension* $name$ = nil;\n");
  }

  void ExtensionGenerator::GenerateInitializationSource(io::Printer* printer) {
    map<string, string> vars;
    vars["name"] = UnderscoresToCamelCase(descriptor_);
    vars["containing_type"] = ClassName(descriptor_->containing_type());
    vars["index"] = SimpleItoa(descriptor_->index());

    ObjectiveCType objectivec_type = GetObjectiveCType(descriptor_);
    string singular_type;
    switch (objectivec_type) {
    case OBJECTIVECTYPE_MESSAGE:
      vars["type"] = ClassName(descriptor_->message_type());
      break;
    case OBJECTIVECTYPE_ENUM:
      vars["type"] = ClassName(descriptor_->enum_type());
      break;
    default:
      vars["type"] = BoxedPrimitiveTypeName(objectivec_type);
      break;
    }

    if (descriptor_->is_repeated()) {
      printer->Print(vars,
        "    $name$ = [[PBGeneratedMessage newRepeatedGeneratedExtension:\n"
        "          [[self getDescriptor].getExtensions objectAtIndex:$index$]\n"
        "          class:[$type$ class]] retain];\n");
    } else {
      printer->Print(vars,
        "    $name$ = [[PBGeneratedMessage newGeneratedExtension:\n"
        "        [[self getDescriptor].getExtensions objectAtIndex:$index$\n"
        "        class:[$type$ class]] retain];\n");
    }
  }

}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google