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

#include <google/protobuf/compiler/objectivec/objectivec_service.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>

namespace google { namespace protobuf { namespace compiler { namespace objectivec {

  ServiceGenerator::ServiceGenerator(const ServiceDescriptor* descriptor)
    : descriptor_(descriptor) {}

  ServiceGenerator::~ServiceGenerator() {}

  void ServiceGenerator::DetermineDependencies(set<string>* dependencies) {
    dependencies->insert(ClassName(descriptor_));
  }

  void ServiceGenerator::GenerateHeader(io::Printer* printer) {
    printer->Print(
      "@interface $classname$ : NSObject<Service> {\n"
      "}\n",
      "classname", ClassName(descriptor_));

    // Generate abstract method declarations.
    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["name"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      printer->Print(vars,
        "- (void) $name$:(id<RpcController>) controller\n"
        "        request:($input$*) request\n"
        "         target:(id) target\n"
        "       selector:(SEL) selector;\n");
    }

    // Generate getDescriptor() and getDescriptorForType().
    printer->Print(
      "\n"
      "+ (ServiceDescriptor*) getDescriptor;\n"
      "- (ServiceDescriptor*) getDescriptorForType;\n");

    // Generate more stuff.
    GenerateCallMethodHeader(printer);
    GenerateGetPrototypeHeader(REQUEST, printer);
    GenerateGetPrototypeHeader(RESPONSE, printer);

    printer->Print("@end\n\n");

    GenerateStubHeader(printer);
  }


  void ServiceGenerator::GenerateSource(io::Printer* printer) {
    bool is_own_file = true;//descriptor_->file()->options().objectivec_multiple_files();
    printer->Print(
      "@implementation $classname$\n",
      "classname", ClassName(descriptor_));

    // Generate abstract method declarations.
    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["name"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      printer->Print(vars,
        "- (void) $name$:(id<RpcController>) controller\n"
        "        request:($input$*) request\n"
        "         target:(id) target\n"
        "       selector:(SEL) selector {\n"
        "  [NSException exceptionWithName:@\"NYI\" reason:@\"\" userInfo:nil];\n"
        "}\n");
    }

    // Generate getDescriptor() and getDescriptorForType().
    printer->Print(
      "\n"
      "+ (ServiceDescriptor*) getDescriptor {\n"
      "  return [[$file$ getDescriptor].getServices objectAtIndex:$index$];\n"
      "}\n"
      "- (ServiceDescriptor*) getDescriptorForType {\n"
      "  return [self getDescriptor];\n"
      "}\n",
      "file", FileClassName(descriptor_->file()),
      "index", SimpleItoa(descriptor_->index()));

    // Generate more stuff.
    GenerateCallMethodSource(printer);
    GenerateGetPrototypeSource(REQUEST, printer);
    GenerateGetPrototypeSource(RESPONSE, printer);

    printer->Print("@end\n\n");

    GenerateStubSource(printer);
  }


  void ServiceGenerator::GenerateCallMethodHeader(io::Printer* printer) {
    printer->Print(
      "\n"
      "- (void) callMethod:(PBMethodDescriptor*) method\n"
      "         controller:(id<PBRpcController>) controller\n"
      "            request:(id<PBMessage>) request\n"
      "             target:(id) target\n"
      "           selector:(SEL) selector;\n");
  }


  void ServiceGenerator::GenerateCallMethodSource(io::Printer* printer) {
    printer->Print(
      "\n"
      "- (void) callMethod:(PBMethodDescriptor*) method\n"
      "         controller:(id<PBRpcController>) controller\n"
      "            request:(id<PBMessage>) request\n"
      "             target:(id) target\n"
      "           selector:(SEL) selector {\n"
      "  if (method.getService != self.getDescriptor) {\n"
      "    [NSException exceptionWithName:@\"NYI\" reason:@\"\" userInfo:nil];\n"
      "  }\n"
      "  switch(method.index) {\n");
    printer->Indent();
    printer->Indent();

    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["index"] = SimpleItoa(i);
      vars["method"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      printer->Print(vars,
        "case $index$:\n"
        "  [self $method$WithController:controller request:request target:target selector:selector];\n"
        "  return;\n");
    }

    printer->Print(
      "default:\n"
      "  [NSException exceptionWithName:@\"NYI\" reason:@\"\" userInfo:nil];\n");

    printer->Outdent();
    printer->Outdent();

    printer->Print(
      "  }\n"
      "}\n"
      "\n");
  }

  void ServiceGenerator::GenerateGetPrototypeHeader(RequestOrResponse which,
    io::Printer* printer) {
      printer->Print(
        "- (id<PBMessage>) get$request_or_response$Prototype:(PBMethodDescriptor*) method;\n",
        "request_or_response", (which == REQUEST) ? "Request" : "Response");
  }


  void ServiceGenerator::GenerateGetPrototypeSource(RequestOrResponse which,
    io::Printer* printer) {
      printer->Print(
        "- (id<PBMessage>) get$request_or_response$Prototype:(PBMethodDescriptor*) method {\n"
        "  if (method.getService != getDescriptor) {\n"
        "    [NSException exceptionWithName:@\"IllegalArgument\" reason:@\"\" userInfo:nil];\n"
        "  }\n"
        "  switch(method.index) {\n",
        "request_or_response", (which == REQUEST) ? "Request" : "Response");
      printer->Indent();
      printer->Indent();

      for (int i = 0; i < descriptor_->method_count(); i++) {
        const MethodDescriptor* method = descriptor_->method(i);
        map<string, string> vars;
        vars["index"] = SimpleItoa(i);
        vars["type"] = ClassName(
          (which == REQUEST) ? method->input_type() : method->output_type());
        printer->Print(vars,
          "case $index$:\n"
          "  return [$type$ getDefaultInstance];\n");
      }

      printer->Print(
        "default:\n"
        "  [NSException exceptionWithName:@\"RuntimeError\" reason:@\"\" userInfo:nil];\n");

      printer->Outdent();
      printer->Outdent();

      printer->Print(
        "  }\n"
        "}\n"
        "\n");
  }

  void ServiceGenerator::GenerateStubHeader(io::Printer* printer) {
    printer->Print(
      "@interface $classname$_Stub : $classname$ {\n",
      "classname", ClassName(descriptor_));

    printer->Print(
      "@private\n"
      "  id<RpcChannel> channel;\n"
      "}\n"
      "@property (retain) id<RpcChannel> channel;\n"
      "+ ($classname$_Stub*) newStub:(id<RpcChannel>) channel;\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["index"] = SimpleItoa(i);
      vars["method"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      printer->Print(vars,
        "\n"
        "- (void) $method$WithController:(id<RpcController>) controller\n"
        "                        request:($input$*) request\n"
        "                         target:(id) target\n"
        "                       selector:(SEL) selector;");
    }

    printer->Print("@end\n\n");
  }

  void ServiceGenerator::GenerateStubSource(io::Printer* printer) {
    printer->Print(
      "@implementation $classname$_Stub\n\n"
      "@synthesize channel;\n\n"
      "- (void) dealloc {\n"
      "  self.channel = nil;\n"
      "}\n\n"
      "- (id) initWithChannel:(id<RpcChannel>) channel_ {\n"
      "  if (self = [super init]) {\n"
      "    self.channel = channel_\n"
      "  }\n"
      "}\n\n"
      "+ ($classname$_Stub*) newStub:(id<RpcChannel>) channel {\n"
      "  return [[[$classname$_Stub alloc] initWithChannel:channel] autorelease];\n"
      "}\n"
      "\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["index"] = SimpleItoa(i);
      vars["method"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      printer->Print(vars,
        "\n"
        "- (void) $method$WithController:(id<RpcController>) controller\n"
        "                        request:($input$*) request\n"
        "                         target:(id) target\n"
        "                       selector:(SEL) selector {\n"
        "  [channel callMethod:[self.getDescriptor.getMethods objectAtIndex:$index$]\n"
        "           controller:controller\n"
        "              request:request\n"
        "             response:[$output$ getDefaultInstance]\n"
        "               target:target\n"
        "             selector:selector];\n"
        "}\n");
    }

    printer->Print("@end\n\n");
  }


}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google
