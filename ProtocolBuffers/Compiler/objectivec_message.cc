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

#include <algorithm>
#include <google/protobuf/stubs/hash.h>
#include <google/protobuf/compiler/objectivec/objectivec_message.h>
#include <google/protobuf/compiler/objectivec/objectivec_enum.h>
#include <google/protobuf/compiler/objectivec/objectivec_extension.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/stubs/strutil.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format.h>
#include <google/protobuf/descriptor.pb.h>

namespace google { namespace protobuf { namespace compiler { namespace objectivec {

  using internal::WireFormat;

  namespace {

    void PrintFieldComment(io::Printer* printer, const FieldDescriptor* field) {
      // Print the field's proto-syntax definition as a comment.  We don't want to
      // print group bodies so we cut off after the first line.
      string def = field->DebugString();
      printer->Print("// $def$\n",
        "def", def.substr(0, def.find_first_of('\n')));
    }

    struct FieldOrderingByNumber {
      inline bool operator()(const FieldDescriptor* a,
        const FieldDescriptor* b) const {
          return a->number() < b->number();
      }
    };

    struct ExtensionRangeOrdering {
      bool operator()(const Descriptor::ExtensionRange* a,
        const Descriptor::ExtensionRange* b) const {
          return a->start < b->start;
      }
    };

    // Sort the fields of the given Descriptor by number into a new[]'d array
    // and return it.
    const FieldDescriptor** SortFieldsByNumber(const Descriptor* descriptor) {
      const FieldDescriptor** fields =
        new const FieldDescriptor*[descriptor->field_count()];
      for (int i = 0; i < descriptor->field_count(); i++) {
        fields[i] = descriptor->field(i);
      }
      sort(fields, fields + descriptor->field_count(),
        FieldOrderingByNumber());
      return fields;
    }

    // Get an identifier that uniquely identifies this type within the file.
    // This is used to declare static variables related to this type at the
    // outermost file scope.
    string UniqueFileScopeIdentifier(const Descriptor* descriptor) {
      return "static_" + StringReplace(descriptor->full_name(), ".", "_", true);
    }

    // Returns true if the message type has any required fields.  If it doesn't,
    // we can optimize out calls to its isInitialized() method.
    //
    // already_seen is used to avoid checking the same type multiple times
    // (and also to protect against recursion).
    static bool HasRequiredFields(
      const Descriptor* type,
      hash_set<const Descriptor*>* already_seen) {
        if (already_seen->count(type) > 0) {
          // The type is already in cache.  This means that either:
          // a. The type has no required fields.
          // b. We are in the midst of checking if the type has required fields,
          //    somewhere up the stack.  In this case, we know that if the type
          //    has any required fields, they'll be found when we return to it,
          //    and the whole call to HasRequiredFields() will return true.
          //    Therefore, we don't have to check if this type has required fields
          //    here.
          return false;
        }
        already_seen->insert(type);

        // If the type has extensions, an extension with message type could contain
        // required fields, so we have to be conservative and assume such an
        // extension exists.
        if (type->extension_range_count() > 0) return true;

        for (int i = 0; i < type->field_count(); i++) {
          const FieldDescriptor* field = type->field(i);
          if (field->is_required()) {
            return true;
          }
          if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE) {
            if (HasRequiredFields(field->message_type(), already_seen)) {
              return true;
            }
          }
        }

        return false;
    }

    static bool HasRequiredFields(const Descriptor* type) {
      hash_set<const Descriptor*> already_seen;
      return HasRequiredFields(type, &already_seen);
    }

  }  // namespace

  // ===================================================================

  MessageGenerator::MessageGenerator(const Descriptor* descriptor)
    : descriptor_(descriptor),
    field_generators_(descriptor) {
  }

  MessageGenerator::~MessageGenerator() {}

  void MessageGenerator::GenerateStaticVariablesHeader(io::Printer* printer) {
    // Because descriptor.proto (com.google.protobuf.DescriptorProtos) is
    // used in the construction of descriptors, we have a tricky bootstrapping
    // problem.  To help control static initialization order, we make sure all
    // descriptors and other static data that depends on them are members of
    // the outermost class in the file.  This way, they will be initialized in
    // a deterministic order.

    map<string, string> vars;
    vars["identifier"] = UniqueFileScopeIdentifier(descriptor_);
    vars["index"] = SimpleItoa(descriptor_->index());
    vars["classname"] = ClassName(descriptor_);
    if (descriptor_->containing_type() != NULL) {
      vars["parent"] = UniqueFileScopeIdentifier(descriptor_->containing_type());
    }

    // The descriptor for this type.
    printer->Print(vars,
      "+ (PBDescriptor*) internal_$identifier$_descriptor;\n");

    // And the FieldAccessorTable.
    printer->Print(vars,
      "+ (PBFieldAccessorTable*) internal_$identifier$_fieldAccessorTable;\n");


    // Generate static members for all nested types.
    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
      // TODO(kenton):  Reuse MessageGenerator objects?
      MessageGenerator(descriptor_->nested_type(i)).GenerateStaticVariablesHeader(printer);
    }

  }

  void MessageGenerator::GenerateStaticVariablesInitialization(io::Printer* printer) {
    map<string, string> vars;
    vars["identifier"] = UniqueFileScopeIdentifier(descriptor_);
    vars["index"] = SimpleItoa(descriptor_->index());
    vars["classname"] = ClassName(descriptor_);
    if (descriptor_->containing_type() != NULL) {
      vars["parent"] = UniqueFileScopeIdentifier(descriptor_->containing_type());
    }

    if (descriptor_->containing_type() == NULL) {
      printer->Print(vars,
        "internal_$identifier$_descriptor = [[[self descriptor].messageTypes objectAtIndex:$index$] retain];\n");
    } else {
      printer->Print(vars,
        "internal_$identifier$_descriptor = [[[internal_$parent$_descriptor nestedTypes] objectAtIndex:$index$] retain];\n");
    }

    // And the FieldAccessorTable.
    printer->Print(vars,
      "{\n"
      "  NSArray* fieldNames = [NSArray arrayWithObjects:");
    for (int i = 0; i < descriptor_->field_count(); i++) {
      printer->Print(
        "@\"$field_name$\", ",
        "field_name", UnderscoresToCapitalizedCamelCase(descriptor_->field(i)));
    }
    printer->Print("nil];\n");

    printer->Print(vars,
      "  internal_$identifier$_fieldAccessorTable = \n"
      "    [[PBFieldAccessorTable tableWithDescriptor:internal_$identifier$_descriptor\n"
      "                                    fieldNames:fieldNames\n"
      "                                  messageClass:[$classname$ class]\n"
      "                                  builderClass:[$classname$_Builder class]] retain];\n"
      "}\n");

    // Generate static members for all nested types.
    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
      // TODO(kenton):  Reuse MessageGenerator objects?
      MessageGenerator(descriptor_->nested_type(i)).GenerateStaticVariablesInitialization(printer);
    }
  }

  void MessageGenerator::GenerateStaticVariablesSource(io::Printer* printer) {
    // Because descriptor.proto (com.google.protobuf.DescriptorProtos) is
    // used in the construction of descriptors, we have a tricky bootstrapping
    // problem.  To help control static initialization order, we make sure all
    // descriptors and other static data that depends on them are members of
    // the outermost class in the file.  This way, they will be initialized in
    // a deterministic order.

    map<string, string> vars;
    vars["identifier"] = UniqueFileScopeIdentifier(descriptor_);
    vars["index"] = SimpleItoa(descriptor_->index());
    vars["classname"] = ClassName(descriptor_);
    if (descriptor_->containing_type() != NULL) {
      vars["parent"] = UniqueFileScopeIdentifier(descriptor_->containing_type());
    }

    // The descriptor for this type.
    printer->Print(vars,
      "static PBDescriptor* internal_$identifier$_descriptor = nil;\n"
      "static PBFieldAccessorTable* internal_$identifier$_fieldAccessorTable = nil;\n");

    printer->Print(vars,
      "+ (PBDescriptor*) internal_$identifier$_descriptor {\n"
      "  return internal_$identifier$_descriptor;\n"
      "}\n"
      "+ (PBFieldAccessorTable*) internal_$identifier$_fieldAccessorTable {\n"
      "  return internal_$identifier$_fieldAccessorTable;\n"
      "}\n");

    // Generate static members for all nested types.
    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
      // TODO(kenton):  Reuse MessageGenerator objects?
      MessageGenerator(descriptor_->nested_type(i)).GenerateStaticVariablesSource(printer);
    }
  }

  void MessageGenerator::DetermineDependencies(set<string>* dependencies) {
    dependencies->insert(ClassName(descriptor_));
    dependencies->insert(ClassName(descriptor_) + "_Builder");

    // Nested types and extensions
    for (int i = 0; i < descriptor_->enum_type_count(); i++) {
      EnumGenerator(descriptor_->enum_type(i)).DetermineDependencies(dependencies);
    }
    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
      MessageGenerator(descriptor_->nested_type(i)).DetermineDependencies(dependencies);
    }
  }

  void MessageGenerator::GenerateHeader(io::Printer* printer) {
    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "@interface $classname$ : PBExtendableMessage {\n",
        "classname", ClassName(descriptor_));
    } else {
      printer->Print(
        "@interface $classname$ : PBGeneratedMessage {\n",
        "classname", ClassName(descriptor_));
    }

    printer->Indent();
    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateFieldsHeader(printer);
    }
    printer->Outdent();

    printer->Print("}\n");

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GeneratePropertiesHeader(printer);
    }

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateMembersHeader(printer);
    }

    printer->Print(
      "\n"
      "+ (PBDescriptor*) descriptor;\n"
      "- (PBDescriptor*) descriptor;\n"
      "+ ($classname$*) defaultInstance;\n"
      "- ($classname$*) defaultInstance;\n",
      "classname", ClassName(descriptor_));
    printer->Print(
      "- (PBFieldAccessorTable*) internalGetFieldAccessorTable;\n"
      "\n",
      "fileclass", FileClassName(descriptor_->file()),
      "identifier", UniqueFileScopeIdentifier(descriptor_));

    for (int i = 0; i < descriptor_->extension_count(); i++) {
      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i)).GenerateMembersHeader(printer);
    }

    //if (descriptor_->file()->options().optimize_for() == FileOptions::SPEED) {
    GenerateIsInitializedHeader(printer);
    GenerateMessageSerializationMethodsHeader(printer);
    //}

    printer->Print(
      "- ($classname$_Builder*) createBuilder;\n",
      "classname", ClassName(descriptor_));

    GenerateParseFromMethodsHeader(printer);

    printer->Print("@end\n\n");

    // Nested types and extensions
    for (int i = 0; i < descriptor_->enum_type_count(); i++) {
      EnumGenerator(descriptor_->enum_type(i)).GenerateHeader(printer);
    }
    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
      MessageGenerator(descriptor_->nested_type(i)).GenerateHeader(printer);
    }

    GenerateBuilderHeader(printer);
  }


  void MessageGenerator::GenerateSource(io::Printer* printer) {
    printer->Print(
      "@interface $classname$ ()\n",
      "classname", ClassName(descriptor_));
    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateExtensionSource(printer);
    }
    printer->Print("@end\n\n");

    printer->Print("@implementation $classname$\n\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateSynthesizeSource(printer);
    }

    printer->Print("- (void) dealloc {\n");
    printer->Indent();
    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateDeallocSource(printer);
    }
    printer->Outdent();
    printer->Print(
      "  [super dealloc];\n"
      "}\n");

    printer->Print(
      "- (id) init {\n"
      "  if (self = [super init]) {\n");
    printer->Indent();
    printer->Indent();
    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateInitializationSource(printer);
    }
    printer->Outdent();
    printer->Outdent();
    printer->Print(
      "  }\n"
      "  return self;\n"
      "}\n");

    for (int i = 0; i < descriptor_->extension_count(); i++) {
      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i)).GenerateFieldsSource(printer);
    }
    for (int i = 0; i < descriptor_->extension_count(); i++) {
      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i)).GenerateMembersSource(printer);
    }

    printer->Print(
      "static $classname$* default$classname$Instance = nil;\n"
      "+ (void) initialize {\n"
      "  if (self == [$classname$ class]) {\n"
      "    default$classname$Instance = [[$classname$ alloc] init];\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < descriptor_->extension_count(); i++) {
      ExtensionGenerator(ClassName(descriptor_), descriptor_->extension(i)).GenerateInitializationSource(printer);
    }

    printer->Print(
      "  }\n"
      "}\n"
      "+ ($classname$*) defaultInstance {\n"
      "  return default$classname$Instance;\n"
      "}\n"
      "- ($classname$*) defaultInstance {\n"
      "  return default$classname$Instance;\n"
      "}\n"
      "- (PBDescriptor*) descriptor {\n"
      "  return [$classname$ descriptor];\n"
      "}\n",
      "classname", ClassName(descriptor_));
    printer->Print(
      "+ (PBDescriptor*) descriptor {\n"
      "  return [$fileclass$ internal_$identifier$_descriptor];\n"
      "}\n"
      "- (PBFieldAccessorTable*) internalGetFieldAccessorTable {\n"
      "  return [$fileclass$ internal_$identifier$_fieldAccessorTable];\n"
      "}\n",
      "fileclass", FileClassName(descriptor_->file()),
      "identifier", UniqueFileScopeIdentifier(descriptor_));

    // Fields
    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateMembersSource(printer);
    }

    //if (descriptor_->file()->options().optimize_for() == FileOptions::SPEED) {
    GenerateIsInitializedSource(printer);
    GenerateMessageSerializationMethodsSource(printer);
    //}

    GenerateParseFromMethodsSource(printer);

    printer->Print(
      "- ($classname$_Builder*) createBuilder {\n"
      "  return [$classname$_Builder builder];\n"
      "}\n",
      "classname", ClassName(descriptor_));

    //GenerateStaticVariablesSource(printer);

    printer->Print("@end\n\n");

    // Nested types and extensions
    for (int i = 0; i < descriptor_->enum_type_count(); i++) {
      EnumGenerator(descriptor_->enum_type(i)).GenerateSource(printer);
    }

    for (int i = 0; i < descriptor_->nested_type_count(); i++) {
      MessageGenerator(descriptor_->nested_type(i)).GenerateSource(printer);
    }

    GenerateBuilderSource(printer);
  }


  // ===================================================================

  void MessageGenerator::GenerateMessageSerializationMethodsHeader(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(
      SortFieldsByNumber(descriptor_));

    vector<const Descriptor::ExtensionRange*> sorted_extensions;
    for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
      sorted_extensions.push_back(descriptor_->extension_range(i));
    }
    sort(sorted_extensions.begin(), sorted_extensions.end(),
      ExtensionRangeOrdering());

    printer->Print(
      "- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;\n");
  }

  void MessageGenerator::GenerateParseFromMethodsHeader(io::Printer* printer) {
    // Note:  These are separate from GenerateMessageSerializationMethods()
    //   because they need to be generated even for messages that are optimized
    //   for code size.
    printer->Print(
      "\n"
      "+ ($classname$*) parseFromData:(NSData*) data;\n"
      "+ ($classname$*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;\n"
      "+ ($classname$*) parseFromInputStream:(NSInputStream*) input;\n"
      "+ ($classname$*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;\n"
      "+ ($classname$*) parseFromCodedInputStream:(PBCodedInputStream*) input;\n"
      "+ ($classname$*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;\n",
      "classname", ClassName(descriptor_));
  }

  void MessageGenerator::GenerateSerializeOneFieldHeader(
    io::Printer* printer, const FieldDescriptor* field) {
      field_generators_.get(field).GenerateSerializationCodeHeader(printer);
  }

  void MessageGenerator::GenerateSerializeOneExtensionRangeHeader(
    io::Printer* printer, const Descriptor::ExtensionRange* range) {
  }

  // ===================================================================

  void MessageGenerator::GenerateBuilderHeader(io::Printer* printer) {
    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "@interface $classname$_Builder : PBExtendableBuilder {\n",
        "classname", ClassName(descriptor_));
    } else {
      printer->Print(
        "@interface $classname$_Builder : PBGeneratedMessage_Builder {\n",
        "classname", ClassName(descriptor_));
    }

    printer->Print(
      " @private\n"
      "  $classname$* result;\n"
      "}\n",
      "classname", ClassName(descriptor_));

    printer->Print(
      "@property (retain) $classname$* result;\n",
      "classname", ClassName(descriptor_));

    GenerateCommonBuilderMethodsHeader(printer);

    //if (descriptor_->file()->options().optimize_for() == FileOptions::SPEED) {
    GenerateBuilderParsingMethodsHeader(printer);
    //}

    for (int i = 0; i < descriptor_->field_count(); i++) {
      printer->Print("\n");
      field_generators_.get(descriptor_->field(i)).GenerateBuilderMembersHeader(printer);
    }

    printer->Print("@end\n\n");
  }

  // ===================================================================

  void MessageGenerator::GenerateCommonBuilderMethodsHeader(io::Printer* printer) {
    printer->Print(
      "\n"
      "+ ($classname$_Builder*) builder;\n"
      "+ ($classname$_Builder*) builderWithPrototype:($classname$*) prototype;\n"
      "\n"
      "- (PBDescriptor*) descriptor;\n"
      "- ($classname$*) defaultInstance;\n"
      "\n"
      "- ($classname$_Builder*) clear;\n"
      "- ($classname$_Builder*) clone;\n",
      "classname", ClassName(descriptor_));

    // -----------------------------------------------------------------

    printer->Print(
      "\n"
      "- ($classname$*) build;\n"
      "- ($classname$*) buildPartial;\n",
      "classname", ClassName(descriptor_));
    printer->Indent();

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateBuildingCodeHeader(printer);
    }

    printer->Outdent();

    // -----------------------------------------------------------------

    //if (descriptor_->file()->options().optimize_for() == FileOptions::SPEED) {
    printer->Print(
      "\n"
      "- ($classname$_Builder*) mergeFromMessage:(id<PBMessage>) other;\n"
      "- ($classname$_Builder*) mergeFrom$classname$:($classname$*) other;\n",
      "classname", ClassName(descriptor_));
    printer->Indent();

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateMergingCodeHeader(printer);
    }

    printer->Outdent();
    //}
  }

  // ===================================================================

  void MessageGenerator::GenerateBuilderParsingMethodsHeader(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(
      SortFieldsByNumber(descriptor_));

    printer->Print(
      "- ($classname$_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;\n"
      "- ($classname$_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;\n",
      "classname", ClassName(descriptor_));
  }

  // ===================================================================

  void MessageGenerator::GenerateIsInitializedHeader(io::Printer* printer) {
    printer->Print(
      "- (BOOL) isInitialized;\n");
  }


  void MessageGenerator::GenerateMessageSerializationMethodsSource(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(
      SortFieldsByNumber(descriptor_));

    vector<const Descriptor::ExtensionRange*> sorted_extensions;
    for (int i = 0; i < descriptor_->extension_range_count(); ++i) {
      sorted_extensions.push_back(descriptor_->extension_range(i));
    }
    sort(sorted_extensions.begin(), sorted_extensions.end(),
      ExtensionRangeOrdering());

    printer->Print(
      "- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {\n");
    printer->Indent();

    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "PBExtensionWriter* extensionWriter = [PBExtensionWriter writerWithExtensions:self.extensions];\n");
    }

    // Merge the fields and the extension ranges, both sorted by field number.
    for (int i = 0, j = 0;
      i < descriptor_->field_count() || j < sorted_extensions.size();
      ) {
        if (i == descriptor_->field_count()) {
          GenerateSerializeOneExtensionRangeSource(printer, sorted_extensions[j++]);
        } else if (j == sorted_extensions.size()) {
          GenerateSerializeOneFieldSource(printer, sorted_fields[i++]);
        } else if (sorted_fields[i]->number() < sorted_extensions[j]->start) {
          GenerateSerializeOneFieldSource(printer, sorted_fields[i++]);
        } else {
          GenerateSerializeOneExtensionRangeSource(printer, sorted_extensions[j++]);
        }
    }

    if (descriptor_->options().message_set_wire_format()) {
      printer->Print(
        "[self.unknownFields writeAsMessageSetTo:output];\n");
    } else {
      printer->Print(
        "[self.unknownFields writeToCodedOutputStream:output];\n");
    }

    printer->Outdent();
    printer->Print(
      "}\n"
      "- (int32_t) serializedSize {\n"
      "  int32_t size = memoizedSerializedSize;\n"
      "  if (size != -1) return size;\n"
      "\n"
      "  size = 0;\n");
    printer->Indent();

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(sorted_fields[i]).GenerateSerializedSizeCodeSource(printer);
    }

    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "size += [self extensionsSerializedSize];\n");
    }

    if (descriptor_->options().message_set_wire_format()) {
      printer->Print(
        "size += self.unknownFields.serializedSizeAsMessageSet;\n");
    } else {
      printer->Print(
        "size += self.unknownFields.serializedSize;\n");
    }

    printer->Outdent();
    printer->Print(
      "  memoizedSerializedSize = size;\n"
      "  return size;\n"
      "}\n");
  }

  void MessageGenerator::GenerateParseFromMethodsSource(io::Printer* printer) {
    // Note:  These are separate from GenerateMessageSerializationMethods()
    //   because they need to be generated even for messages that are optimized
    //   for code size.
    printer->Print(
      "+ ($classname$*) parseFromData:(NSData*) data {\n"
      "  return ($classname$*)[[[$classname$_Builder builder] mergeFromData:data] build];\n"
      "}\n"
      "+ ($classname$*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {\n"
      "  return ($classname$*)[[[$classname$_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];\n"
      "}\n"
      "+ ($classname$*) parseFromInputStream:(NSInputStream*) input {\n"
      "  return ($classname$*)[[[$classname$_Builder builder] mergeFromInputStream:input] build];\n"
      "}\n"
      "+ ($classname$*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {\n"
      "  return ($classname$*)[[[$classname$_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];\n"
      "}\n"
      "+ ($classname$*) parseFromCodedInputStream:(PBCodedInputStream*) input {\n"
      "  return ($classname$*)[[[$classname$_Builder builder] mergeFromCodedInputStream:input] build];\n"
      "}\n"
      "+ ($classname$*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {\n"
      "  return ($classname$*)[[[$classname$_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];\n"
      "}\n",
      "classname", ClassName(descriptor_));
  }

  void MessageGenerator::GenerateSerializeOneFieldSource(
    io::Printer* printer, const FieldDescriptor* field) {
      field_generators_.get(field).GenerateSerializationCodeSource(printer);
  }

  void MessageGenerator::GenerateSerializeOneExtensionRangeSource(
    io::Printer* printer, const Descriptor::ExtensionRange* range) {
      printer->Print(
        "[extensionWriter writeUntil:$end$ output:output];\n",
        "end", SimpleItoa(range->end));
  }

  // ===================================================================

  void MessageGenerator::GenerateBuilderSource(io::Printer* printer) {
    printer->Print(
      "@implementation $classname$_Builder\n"
      "@synthesize result;\n"
      "- (void) dealloc {\n"
      "  self.result = nil;\n"
      "  [super dealloc];\n"
      "}\n",
      "classname", ClassName(descriptor_));

    printer->Print(
      "- (id) init {\n"
      "  if (self = [super init]) {\n"
      "    self.result = [[[$classname$ alloc] init] autorelease];\n"
      "  }\n"
      "  return self;\n"
      "}\n",
      "classname", ClassName(descriptor_));

    GenerateCommonBuilderMethodsSource(printer);

    //if (descriptor_->file()->options().optimize_for() == FileOptions::SPEED) {
    GenerateBuilderParsingMethodsSource(printer);
    //}

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateBuilderMembersSource(printer);
    }

    printer->Print("@end\n\n");
  }

  // ===================================================================

  void MessageGenerator::GenerateCommonBuilderMethodsSource(io::Printer* printer) {
    printer->Print(
      "+ ($classname$_Builder*) builder {\n"
      "  return [[[$classname$_Builder alloc] init] autorelease];\n"
      "}\n"
      "+ ($classname$_Builder*) builderWithPrototype:($classname$*) prototype {\n"
      "  return [[$classname$_Builder builder] mergeFrom$classname$:prototype];\n"
      "}\n"
      "- ($classname$*) internalGetResult {\n"
      "  return result;\n"
      "}\n"
      "- ($classname$_Builder*) clear {\n"
      "  self.result = [[[$classname$ alloc] init] autorelease];\n"
      "  return self;\n"
      "}\n"
      "- ($classname$_Builder*) clone {\n"
      "  return [$classname$_Builder builderWithPrototype:result];\n"
      "}\n"
      "- (PBDescriptor*) descriptor {\n"
      "  return [$classname$ descriptor];\n"
      "}\n"
      "- ($classname$*) defaultInstance {\n"
      "  return [$classname$ defaultInstance];\n"
      "}\n",
      "classname", ClassName(descriptor_));

    // -----------------------------------------------------------------

    printer->Print(
      "- ($classname$*) build {\n"
      "  if (!self.isInitialized) {\n"
      "    @throw [NSException exceptionWithName:@\"UninitializedMessage\" reason:@\"\" userInfo:nil];\n"
      "  }\n"
      "  return [self buildPartial];\n"
      "}\n"
      "- ($classname$*) buildPartial {\n",
      "classname", ClassName(descriptor_));
    printer->Indent();

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateBuildingCodeSource(printer);
    }

    printer->Outdent();
    printer->Print(
      "  $classname$* returnMe = [[result retain] autorelease];\n"
      "  self.result = nil;\n"
      "  return returnMe;\n"
      "}\n",
      "classname", ClassName(descriptor_));

    // -----------------------------------------------------------------

    //if (descriptor_->file()->options().optimize_for() == FileOptions::SPEED) {
    printer->Print(
      "- ($classname$_Builder*) mergeFromMessage:(id<PBMessage>) other {\n"
      "  id o = other;\n"
      "  if ([o isKindOfClass:[$classname$ class]]) {\n"
      "    return [self mergeFrom$classname$:o];\n"
      "  } else {\n"
      "    [super mergeFromMessage:other];\n"
      "    return self;\n"
      "  }\n"
      "}\n"
      "- ($classname$_Builder*) mergeFrom$classname$:($classname$*) other {\n"
      // Optimization:  If other is the default instance, we know none of its
      //   fields are set so we can skip the merge.
      "  if (other == [$classname$ defaultInstance]) return self;\n",
      "classname", ClassName(descriptor_));
    printer->Indent();

    for (int i = 0; i < descriptor_->field_count(); i++) {
      field_generators_.get(descriptor_->field(i)).GenerateMergingCodeSource(printer);
    }

    printer->Outdent();
    printer->Print(
      "  [self mergeUnknownFields:other.unknownFields];\n"
      "  return self;\n"
      "}\n");
    //}
  }

  // ===================================================================

  void MessageGenerator::GenerateBuilderParsingMethodsSource(io::Printer* printer) {
    scoped_array<const FieldDescriptor*> sorted_fields(
      SortFieldsByNumber(descriptor_));

    printer->Print(
      "- ($classname$_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {\n"
      "  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];\n"
      "}\n"
      "- ($classname$_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {\n",
      "classname", ClassName(descriptor_));
    printer->Indent();

    printer->Print(
      "PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet_Builder builderWithUnknownFields:self.unknownFields];\n"
      "while (true) {\n");
    printer->Indent();

    printer->Print(
      "int32_t tag = [input readTag];\n"
      "switch (tag) {\n");
    printer->Indent();

    printer->Print(
      "case 0:\n"          // zero signals EOF / limit reached
      "  [self setUnknownFields:[unknownFields build]];\n"
      "  return self;\n"
      "default: {\n"
      "  if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {\n"
      "    [self setUnknownFields:[unknownFields build]];\n"
      "    return self;\n"   // it's an endgroup tag
      "  }\n"
      "  break;\n"
      "}\n");

    for (int i = 0; i < descriptor_->field_count(); i++) {
      const FieldDescriptor* field = sorted_fields[i];
      uint32 tag = WireFormat::MakeTag(field->number(),
        WireFormat::WireTypeForFieldType(field->type()));

      printer->Print(
        "case $tag$: {\n",
        "tag", SimpleItoa(tag));
      printer->Indent();

      field_generators_.get(field).GenerateParsingCodeSource(printer);

      printer->Outdent();
      printer->Print(
        "  break;\n"
        "}\n");
    }

    printer->Outdent();
    printer->Outdent();
    printer->Outdent();
    printer->Print(
      "    }\n"     // switch (tag)
      "  }\n"       // while (true)
      "}\n");
  }

  // ===================================================================

  void MessageGenerator::GenerateIsInitializedSource(io::Printer* printer) {
    printer->Print(
      "- (BOOL) isInitialized {\n");
    printer->Indent();

    // Check that all required fields in this message are set.
    // TODO(kenton):  We can optimize this when we switch to putting all the
    //   "has" fields into a single bitfield.
    for (int i = 0; i < descriptor_->field_count(); i++) {
      const FieldDescriptor* field = descriptor_->field(i);

      if (field->is_required()) {
        printer->Print(
          "if (!self.has$capitalized_name$) return false;\n",
          "capitalized_name", UnderscoresToCapitalizedCamelCase(field));
      }
    }

    // Now check that all embedded messages are initialized.
    for (int i = 0; i < descriptor_->field_count(); i++) {
      const FieldDescriptor* field = descriptor_->field(i);
      if (field->cpp_type() == FieldDescriptor::CPPTYPE_MESSAGE &&
        HasRequiredFields(field->message_type())) {

          map<string,string> vars;
          vars["type"] = ClassName(field->message_type());
          vars["name"] = UnderscoresToCamelCase(field);
          vars["capitalized_name"] = UnderscoresToCapitalizedCamelCase(field);

          switch (field->label()) {
            case FieldDescriptor::LABEL_REQUIRED:
              printer->Print(vars,
                "if (!self.$name$.isInitialized) return false;\n");
              break;
            case FieldDescriptor::LABEL_OPTIONAL:
              printer->Print(vars,
                "if (self.has$capitalized_name$) {\n"
                "  if (!self.$name$.isInitialized) return false;\n"
                "}\n");
              break;
            case FieldDescriptor::LABEL_REPEATED:
              printer->Print(vars,
                "for ($type$* element in self.$name$List) {\n"
                "  if (!element.isInitialized) return false;\n"
                "}\n");
              break;
          }
      }
    }

    if (descriptor_->extension_range_count() > 0) {
      printer->Print(
        "if (!self.extensionsAreInitialized) return false;\n");
    }

    printer->Outdent();
    printer->Print(
      "  return true;\n"
      "}\n");
  }
}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google