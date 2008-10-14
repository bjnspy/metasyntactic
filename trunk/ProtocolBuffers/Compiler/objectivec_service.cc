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
    : descriptor_(descriptor) {
  }


  ServiceGenerator::~ServiceGenerator() {
  }


  void ServiceGenerator::DetermineDependencies(set<string>* dependencies) {
    dependencies->insert(ClassName(descriptor_));
  }


  void ServiceGenerator::GenerateHeader(io::Printer* printer) {
    printer->Print(
      "@interface $classname$ : NSObject<PBService> {\n"
      "}\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["name"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      printer->Print(vars,
        "- (void) $name$WithController:(id<PBRpcController>) controller\n"
        "                      request:($input$*) request\n"
        "                       target:(id) target\n"
        "                     selector:(SEL) selector;\n");
    }

    printer->Print(
      "\n"
      "+ (PBServiceDescriptor*) descriptor;\n"
      "- (PBServiceDescriptor*) descriptor;\n");

    GenerateCallMethodHeader(printer);
    GenerateGetPrototypeHeader(REQUEST, printer);
    GenerateGetPrototypeHeader(RESPONSE, printer);

    printer->Print("@end\n\n");

    GenerateStubHeader(printer);
  }


  void ServiceGenerator::GenerateSource(io::Printer* printer) {
    printer->Print(
      "@implementation $classname$\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["name"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      printer->Print(vars,
        "- (void) $name$WithController:(id<PBRpcController>) controller\n"
        "                      request:($input$*) request\n"
        "                       target:(id) target\n"
        "                     selector:(SEL) selector {\n"
        "  @throw [NSException exceptionWithName:@\"ImproperSubclassing\" reason:@\"\" userInfo:nil];\n"
        "}\n");
    }

    {
      map<string, string> vars;
      vars["file"] = FileClassName(descriptor_->file());
      vars["index"] = SimpleItoa(descriptor_->index());
      vars["classname"] = ClassName(descriptor_);

      printer->Print(vars,
        "+ (PBServiceDescriptor*) descriptor {\n"
        "  return [[$file$ descriptor].services objectAtIndex:$index$];\n"
        "}\n"
        "- (PBServiceDescriptor*) descriptor {\n"
        "  return [$classname$ descriptor];\n"
        "}\n");
    }

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
      "- (void) callMethod:(PBMethodDescriptor*) method\n"
      "         controller:(id<PBRpcController>) controller\n"
      "            request:(id<PBMessage>) request\n"
      "             target:(id) target\n"
      "           selector:(SEL) selector {\n"
      "  if (method.service != self.descriptor) {\n"
      "    @throw [NSException exceptionWithName:@\"IllegalArgument\" reason:@\"callMethod: given method descriptor for wrong service type.\" userInfo:nil];\n"
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
        "  [self $method$WithController:controller request:(id)request target:target selector:selector];\n"
        "  return;\n");
    }

    printer->Print(
      "default:\n"
      "  @throw [NSException exceptionWithName:@\"RuntimeError\" reason:@\"\" userInfo:nil];\n");

    printer->Outdent();
    printer->Outdent();

    printer->Print(
      "  }\n"
      "}\n");
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
        "  if (method.service != self.descriptor) {\n"
        "    @throw [NSException exceptionWithName:@\"IllegalArgument\" reason:@\"callMethod: given method descriptor for wrong service type.\" userInfo:nil];\n"
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
          "  return [$type$ defaultInstance];\n");
      }

      printer->Print(
        "default:\n"
        "  @throw [NSException exceptionWithName:@\"RuntimeError\" reason:@\"\" userInfo:nil];\n");

      printer->Outdent();
      printer->Outdent();

      printer->Print(
        "  }\n"
        "}\n");
  }


  void ServiceGenerator::GenerateStubHeader(io::Printer* printer) {
    printer->Print(
      "@interface $classname$_Stub : $classname$ {\n",
      "classname", ClassName(descriptor_));

    printer->Print(
      " @private\n"
      "  id<PBRpcChannel> channel;\n"
      "}\n"
      "@property (retain) id<PBRpcChannel> channel;\n"
      "+ ($classname$_Stub*) stubWithChannel:(id<PBRpcChannel>) channel;\n",
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
        "- (void) $method$WithController:(id<PBRpcController>) controller\n"
        "                        request:($input$*) request\n"
        "                         target:(id) target\n"
        "                       selector:(SEL) selector;");
    }

    printer->Print("@end\n\n");
  }


  void ServiceGenerator::GenerateStubSource(io::Printer* printer) {
    printer->Print(
      "@implementation $classname$_Stub\n"
      "@synthesize channel;\n"
      "- (void) dealloc {\n"
      "  self.channel = nil;\n"
      "  [super dealloc];\n"
      "}\n"
      "- (id) initWithChannel:(id<PBRpcChannel>) channel_ {\n"
      "  if (self = [super init]) {\n"
      "    self.channel = channel_;\n"
      "  }\n"
      "  return self;\n"
      "}\n"
      "+ ($classname$_Stub*) stubWithChannel:(id<PBRpcChannel>) channel {\n"
      "  return [[[$classname$_Stub alloc] initWithChannel:channel] autorelease];\n"
      "}\n",
      "classname", ClassName(descriptor_));

    for (int i = 0; i < descriptor_->method_count(); i++) {
      const MethodDescriptor* method = descriptor_->method(i);
      map<string, string> vars;
      vars["index"] = SimpleItoa(i);
      vars["method"] = UnderscoresToCamelCase(method);
      vars["input"] = ClassName(method->input_type());
      vars["output"] = ClassName(method->output_type());
      vars["classname"] = ClassName(descriptor_);
      printer->Print(vars,
        "- (void) $method$WithController:(id<PBRpcController>) controller\n"
        "                        request:($input$*) request\n"
        "                         target:(id) target\n"
        "                       selector:(SEL) selector {\n"
        "  [channel callMethod:[[$classname$ descriptor].methods objectAtIndex:$index$]\n"
        "           controller:controller\n"
        "              request:request\n"
        "             response:[$output$ defaultInstance]\n"
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