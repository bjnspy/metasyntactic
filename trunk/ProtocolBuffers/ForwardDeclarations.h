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

enum FieldDescriptorType;
enum ObjectiveCType;

@protocol Message;
@protocol Message_Builder;
@protocol RpcChannel;
@protocol RpcController;
@protocol Service;

@class AbstractMessage;
@class CodedInputStream;
@class CodedOutputStream;
@class Descriptors;
@class Descriptor;
@class EnumDescriptor;
@class EnumValueDescriptor;
@class ExtensionRegistry_ExtensionInfo;
@class ExtensionRegistry_DescriptorIntPair;
@class Field;
@class Field_Builder;
@class FieldDescriptor;
@class FieldDescriptor_Type;
@class FieldSet;
@class FileDescriptor;
@class MessageOptions;
@class MethodDescriptor;
@class ServiceDescriptor;
@class DynamicMessage;
@class DynamicMessage_Builder;
@class ExtensionRegistry;
@class UnknownFieldSet;
@class UnknownFieldSet_Builder;
@class UnknownFieldSet_Field;
@class UnknownFieldSet_Field_Builder;
@class WireFormat;