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

#include <google/protobuf/compiler/objectivec/objectivec_enum.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>

namespace google { namespace protobuf { namespace compiler { namespace objectivec {

  EnumGenerator::EnumGenerator(const EnumDescriptor* descriptor)
    : descriptor_(descriptor) {
      for (int i = 0; i < descriptor_->value_count(); i++) {
        const EnumValueDescriptor* value = descriptor_->value(i);
        const EnumValueDescriptor* canonical_value =
          descriptor_->FindValueByNumber(value->number());

        if (value == canonical_value) {
          canonical_values_.push_back(value);
        } else {
          Alias alias;
          alias.value = value;
          alias.canonical_value = canonical_value;
          aliases_.push_back(alias);
        }
      }
  }

  EnumGenerator::~EnumGenerator() {}


  void EnumGenerator::DetermineDependencies(set<string>* dependencies) {
    dependencies->insert(ClassName(descriptor_));
  }

  void EnumGenerator::GenerateHeader(io::Printer* printer) {
    printer->Print(
      "@interface $classname$ : NSObject {\n"
      " @private\n"
      "  int32_t index;\n"
      "  int32_t value;\n"
      "}\n"
      "@property int32_t index;\n"
      "@property int32_t value;\n"
      "+ ($classname$*) newWithIndex:(int32_t) index value:(int32_t) value;\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < canonical_values_.size(); i++) {
      printer->Print(
        "+ ($classname$*) $name$;\n",
        "classname", ClassName(descriptor_),
        "name", SafeName(canonical_values_[i]->name()));
    }

    for (int i = 0; i < aliases_.size(); i++) {
      map<string, string> vars;
      vars["classname"] = ClassName(descriptor_);
      vars["name"] = aliases_[i].value->name();
      printer->Print(vars,
        "+ ($classname$*) $name$;\n");
    }

    printer->Print(
      "\n"
      "- (int32_t) number;\n"
      "+ ($classname$*) valueOf:(int32_t) value;\n",
      "classname", ClassName(descriptor_));

    // -----------------------------------------------------------------
    // Reflection

    printer->Print(
      "- (PBEnumValueDescriptor*) getValueDescriptor;\n"
      "- (PBEnumDescriptor*) getDescriptorForType;\n"
      "+ (PBEnumDescriptor*) getDescriptor;\n");

    printer->Print(
      "\n"
      "+ ($classname$*) valueOfDescriptor:(PBEnumValueDescriptor*) desc;\n",
      "classname", ClassName(descriptor_));

    // -----------------------------------------------------------------

    printer->Print("@end\n\n");
  }


  void EnumGenerator::GenerateSource(io::Printer* printer) {
    printer->Print(
      "@implementation $classname$\n"
      "@synthesize index;\n"
      "@synthesize value;\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < canonical_values_.size(); i++) {
      printer->Print(
        "static $classname$* $name$ = nil;\n",
        "classname", ClassName(descriptor_),
        "name", SafeName(canonical_values_[i]->name()));
    }

    printer->Print(
      "- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {\n"
      "  if (self = [super init]) {\n"
      "    self.index = index_;\n"
      "    self.value = value_;\n"
      "  }\n"
      "  return self;\n"
      "}\n"
      "+ ($classname$*) newWithIndex:(int32_t) index value:(int32_t) value {\n"
      "  return [[[$classname$ alloc] initWithIndex:index value:value] autorelease];\n"
      "}\n"
      "+ (void) initialize {\n"
      "  if (self == [$classname$ class]) {\n",
      "classname", ClassName(descriptor_));
    printer->Indent();
    printer->Indent();

    for (int i = 0; i < canonical_values_.size(); i++) {
      map<string, string> vars;
      vars["classname"] = ClassName(descriptor_);
      vars["name"] = SafeName(canonical_values_[i]->name());
      vars["index"] = SimpleItoa(canonical_values_[i]->index());
      vars["number"] = SimpleItoa(canonical_values_[i]->number());
      printer->Print(vars,
        "$name$ = [[$classname$ newWithIndex:$index$ value:$number$] retain];\n");
    }

    printer->Outdent();
    printer->Outdent();
    printer->Print(
      "  }\n"
      "}\n");

    for (int i = 0; i < canonical_values_.size(); i++) {
      map<string, string> vars;
      vars["classname"] = ClassName(descriptor_);
      vars["name"] = SafeName(canonical_values_[i]->name());
      printer->Print(vars,
        "+ ($classname$*) $name$ { return $name$; }\n");
    }

    // -----------------------------------------------------------------

    for (int i = 0; i < aliases_.size(); i++) {
      map<string, string> vars;
      vars["classname"] = ClassName(descriptor_);
      vars["name"] = aliases_[i].value->name();
      vars["canonical_name"] = aliases_[i].canonical_value->name();
      printer->Print(vars,
        "+ ($classname$*) $name$ { return $canonical_name$; }\n");
    }

    // -----------------------------------------------------------------

    printer->Print(
      "- (int32_t) number { return value; }\n"
      "+ ($classname$*) valueOf:(int32_t) value {\n"
      "  switch (value) {\n",
      "classname", ClassName(descriptor_));
    printer->Indent();
    printer->Indent();

    for (int i = 0; i < canonical_values_.size(); i++) {
      printer->Print(
        "case $number$: return $name$;\n",
        "name", SafeName(canonical_values_[i]->name()),
        "number", SimpleItoa(canonical_values_[i]->number()));
    }

    printer->Outdent();
    printer->Outdent();
    printer->Print(
      "    default: return nil;\n"
      "  }\n"
      "}\n"
      "\n");

    // -----------------------------------------------------------------
    // Reflection

    printer->Print(
      "- (PBEnumValueDescriptor*) getValueDescriptor {\n"
      "  return [[$classname$ getDescriptor].values objectAtIndex:index];\n"
      "}\n"
      "- (PBEnumDescriptor*) getDescriptorForType {\n"
      "  return [$classname$ getDescriptor];\n"
      "}\n"
      "+ (PBEnumDescriptor*) getDescriptor {\n",
      "classname", ClassName(descriptor_));

    // TODO(kenton):  Cache statically?  Note that we can't access descriptors
    //   at module init time because it wouldn't work with descriptor.proto, but
    //   we can cache the value the first time getDescriptor() is called.
    if (descriptor_->containing_type() == NULL) {
      printer->Print(
        "  return [[$file$ getDescriptor].enumTypes objectAtIndex:$index$];\n",
        "file", FileClassName(descriptor_->file()),
        "index", SimpleItoa(descriptor_->index()));
    } else {
      printer->Print(
        "  return [[$parent$ getDescriptor].enumTypes objectAtIndex:$index$];\n",
        "parent", ClassName(descriptor_->containing_type()),
        "index", SimpleItoa(descriptor_->index()));
    }

    printer->Print(
      "}\n"
      "\n");

    printer->Print(
      "\n"
      "+ ($classname$*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {\n"
      "  if (desc.type != [$classname$ getDescriptor]) {\n"
      "    [NSException exceptionWithName:@\"\" reason:@\"\" userInfo:nil];\n"
      "  }\n"
      "  $classname$* VALUES[] = {\n",
      "classname", ClassName(descriptor_));

    printer->Indent();
    printer->Indent();
    for (int i = 0; i < descriptor_->value_count(); i++) {
      printer->Print("$name$,\n",
        "name", SafeName(descriptor_->value(i)->name()));
    }
    printer->Outdent();
    printer->Outdent();

    printer->Print(
      "  };\n"
      "  return VALUES[desc.index];\n"
      "}\n");

    // -----------------------------------------------------------------

    printer->Print("@end\n\n");
  }

}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
