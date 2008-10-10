// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "Descriptor.pb.h"

@implementation DescriptorProtoRoot
static PBFileDescriptor* descriptor = nil;
static PBDescriptor* internal_static_google_protobuf_FileDescriptorSet_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_FileDescriptorSet_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_FileDescriptorSet_descriptor {
  return internal_static_google_protobuf_FileDescriptorSet_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_FileDescriptorSet_fieldAccessorTable {
  return internal_static_google_protobuf_FileDescriptorSet_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_FileDescriptorProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_FileDescriptorProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_FileDescriptorProto_descriptor {
  return internal_static_google_protobuf_FileDescriptorProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_FileDescriptorProto_fieldAccessorTable {
  return internal_static_google_protobuf_FileDescriptorProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_DescriptorProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_DescriptorProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_DescriptorProto_descriptor {
  return internal_static_google_protobuf_DescriptorProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_DescriptorProto_fieldAccessorTable {
  return internal_static_google_protobuf_DescriptorProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_DescriptorProto_ExtensionRange_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_DescriptorProto_ExtensionRange_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_DescriptorProto_ExtensionRange_descriptor {
  return internal_static_google_protobuf_DescriptorProto_ExtensionRange_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_DescriptorProto_ExtensionRange_fieldAccessorTable {
  return internal_static_google_protobuf_DescriptorProto_ExtensionRange_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_FieldDescriptorProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_FieldDescriptorProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_FieldDescriptorProto_descriptor {
  return internal_static_google_protobuf_FieldDescriptorProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_FieldDescriptorProto_fieldAccessorTable {
  return internal_static_google_protobuf_FieldDescriptorProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_EnumDescriptorProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_EnumDescriptorProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_EnumDescriptorProto_descriptor {
  return internal_static_google_protobuf_EnumDescriptorProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_EnumDescriptorProto_fieldAccessorTable {
  return internal_static_google_protobuf_EnumDescriptorProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_EnumValueDescriptorProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_EnumValueDescriptorProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_EnumValueDescriptorProto_descriptor {
  return internal_static_google_protobuf_EnumValueDescriptorProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_EnumValueDescriptorProto_fieldAccessorTable {
  return internal_static_google_protobuf_EnumValueDescriptorProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_ServiceDescriptorProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_ServiceDescriptorProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_ServiceDescriptorProto_descriptor {
  return internal_static_google_protobuf_ServiceDescriptorProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_ServiceDescriptorProto_fieldAccessorTable {
  return internal_static_google_protobuf_ServiceDescriptorProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_MethodDescriptorProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_MethodDescriptorProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_MethodDescriptorProto_descriptor {
  return internal_static_google_protobuf_MethodDescriptorProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_MethodDescriptorProto_fieldAccessorTable {
  return internal_static_google_protobuf_MethodDescriptorProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_FileOptions_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_FileOptions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_FileOptions_descriptor {
  return internal_static_google_protobuf_FileOptions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_FileOptions_fieldAccessorTable {
  return internal_static_google_protobuf_FileOptions_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_MessageOptions_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_MessageOptions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_MessageOptions_descriptor {
  return internal_static_google_protobuf_MessageOptions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_MessageOptions_fieldAccessorTable {
  return internal_static_google_protobuf_MessageOptions_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_FieldOptions_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_FieldOptions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_FieldOptions_descriptor {
  return internal_static_google_protobuf_FieldOptions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_FieldOptions_fieldAccessorTable {
  return internal_static_google_protobuf_FieldOptions_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_EnumOptions_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_EnumOptions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_EnumOptions_descriptor {
  return internal_static_google_protobuf_EnumOptions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_EnumOptions_fieldAccessorTable {
  return internal_static_google_protobuf_EnumOptions_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_EnumValueOptions_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_EnumValueOptions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_EnumValueOptions_descriptor {
  return internal_static_google_protobuf_EnumValueOptions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_EnumValueOptions_fieldAccessorTable {
  return internal_static_google_protobuf_EnumValueOptions_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_ServiceOptions_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_ServiceOptions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_ServiceOptions_descriptor {
  return internal_static_google_protobuf_ServiceOptions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_ServiceOptions_fieldAccessorTable {
  return internal_static_google_protobuf_ServiceOptions_fieldAccessorTable;
}
static PBDescriptor* internal_static_google_protobuf_MethodOptions_descriptor = nil;
static PBFieldAccessorTable* internal_static_google_protobuf_MethodOptions_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_google_protobuf_MethodOptions_descriptor {
  return internal_static_google_protobuf_MethodOptions_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_google_protobuf_MethodOptions_fieldAccessorTable {
  return internal_static_google_protobuf_MethodOptions_fieldAccessorTable;
}
+ (void) initialize {
  if (self == [DescriptorProtoRoot class]) {
    descriptor = [[DescriptorProtoRoot buildDescriptor] retain];
    internal_static_google_protobuf_FileDescriptorSet_descriptor = [[[self descriptor].messageTypes objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"File", nil];
      internal_static_google_protobuf_FileDescriptorSet_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_FileDescriptorSet_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBFileDescriptorSet class]
                                      builderClass:[PBFileDescriptorSet_Builder class]] retain];
    }
    internal_static_google_protobuf_FileDescriptorProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:1] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Name", @"Package", @"Dependency", @"MessageType", @"EnumType", @"Service", @"Extension", @"Options", nil];
      internal_static_google_protobuf_FileDescriptorProto_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_FileDescriptorProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBFileDescriptorProto class]
                                      builderClass:[PBFileDescriptorProto_Builder class]] retain];
    }
    internal_static_google_protobuf_DescriptorProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:2] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Name", @"Field", @"Extension", @"NestedType", @"EnumType", @"ExtensionRange", @"Options", nil];
      internal_static_google_protobuf_DescriptorProto_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_DescriptorProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBDescriptorProto class]
                                      builderClass:[PBDescriptorProto_Builder class]] retain];
    }
    internal_static_google_protobuf_DescriptorProto_ExtensionRange_descriptor = [[[internal_static_google_protobuf_DescriptorProto_descriptor nestedTypes] objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Start", @"End", nil];
      internal_static_google_protobuf_DescriptorProto_ExtensionRange_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_DescriptorProto_ExtensionRange_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBDescriptorProto_ExtensionRange class]
                                      builderClass:[PBDescriptorProto_ExtensionRange_Builder class]] retain];
    }
    internal_static_google_protobuf_FieldDescriptorProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:3] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Name", @"Number", @"Label", @"Type", @"TypeName", @"Extendee", @"DefaultValue", @"Options", nil];
      internal_static_google_protobuf_FieldDescriptorProto_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_FieldDescriptorProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBFieldDescriptorProto class]
                                      builderClass:[PBFieldDescriptorProto_Builder class]] retain];
    }
    internal_static_google_protobuf_EnumDescriptorProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:4] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Name", @"Value", @"Options", nil];
      internal_static_google_protobuf_EnumDescriptorProto_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_EnumDescriptorProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBEnumDescriptorProto class]
                                      builderClass:[PBEnumDescriptorProto_Builder class]] retain];
    }
    internal_static_google_protobuf_EnumValueDescriptorProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:5] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Name", @"Number", @"Options", nil];
      internal_static_google_protobuf_EnumValueDescriptorProto_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_EnumValueDescriptorProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBEnumValueDescriptorProto class]
                                      builderClass:[PBEnumValueDescriptorProto_Builder class]] retain];
    }
    internal_static_google_protobuf_ServiceDescriptorProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:6] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Name", @"Method", @"Options", nil];
      internal_static_google_protobuf_ServiceDescriptorProto_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_ServiceDescriptorProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBServiceDescriptorProto class]
                                      builderClass:[PBServiceDescriptorProto_Builder class]] retain];
    }
    internal_static_google_protobuf_MethodDescriptorProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:7] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Name", @"InputType", @"OutputType", @"Options", nil];
      internal_static_google_protobuf_MethodDescriptorProto_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_MethodDescriptorProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBMethodDescriptorProto class]
                                      builderClass:[PBMethodDescriptorProto_Builder class]] retain];
    }
    internal_static_google_protobuf_FileOptions_descriptor = [[[self descriptor].messageTypes objectAtIndex:8] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"JavaPackage", @"JavaOuterClassname", @"JavaMultipleFiles", @"OptimizeFor", @"ObjectivecPackage", @"ObjectivecClassPrefix", nil];
      internal_static_google_protobuf_FileOptions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_FileOptions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBFileOptions class]
                                      builderClass:[PBFileOptions_Builder class]] retain];
    }
    internal_static_google_protobuf_MessageOptions_descriptor = [[[self descriptor].messageTypes objectAtIndex:9] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"MessageSetWireFormat", nil];
      internal_static_google_protobuf_MessageOptions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_MessageOptions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBMessageOptions class]
                                      builderClass:[PBMessageOptions_Builder class]] retain];
    }
    internal_static_google_protobuf_FieldOptions_descriptor = [[[self descriptor].messageTypes objectAtIndex:10] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Ctype", @"ExperimentalMapKey", nil];
      internal_static_google_protobuf_FieldOptions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_FieldOptions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBFieldOptions class]
                                      builderClass:[PBFieldOptions_Builder class]] retain];
    }
    internal_static_google_protobuf_EnumOptions_descriptor = [[[self descriptor].messageTypes objectAtIndex:11] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_google_protobuf_EnumOptions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_EnumOptions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBEnumOptions class]
                                      builderClass:[PBEnumOptions_Builder class]] retain];
    }
    internal_static_google_protobuf_EnumValueOptions_descriptor = [[[self descriptor].messageTypes objectAtIndex:12] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_google_protobuf_EnumValueOptions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_EnumValueOptions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBEnumValueOptions class]
                                      builderClass:[PBEnumValueOptions_Builder class]] retain];
    }
    internal_static_google_protobuf_ServiceOptions_descriptor = [[[self descriptor].messageTypes objectAtIndex:13] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_google_protobuf_ServiceOptions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_ServiceOptions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBServiceOptions class]
                                      builderClass:[PBServiceOptions_Builder class]] retain];
    }
    internal_static_google_protobuf_MethodOptions_descriptor = [[[self descriptor].messageTypes objectAtIndex:14] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:nil];
      internal_static_google_protobuf_MethodOptions_fieldAccessorTable = 
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_google_protobuf_MethodOptions_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[PBMethodOptions class]
                                      builderClass:[PBMethodOptions_Builder class]] retain];
    }
  }
}
+ (PBFileDescriptor*) descriptor {
  return descriptor;
}
+ (PBFileDescriptor*) buildDescriptor {
  static uint8_t descriptorData[] = {
    10,32,103,111,111,103,108,101,47,112,114,111,116,111,98,117,102,47,100,
    101,115,99,114,105,112,116,111,114,46,112,114,111,116,111,18,15,103,111,
    111,103,108,101,46,112,114,111,116,111,98,117,102,34,71,10,17,70,105,108,
    101,68,101,115,99,114,105,112,116,111,114,83,101,116,18,50,10,4,102,105,
    108,101,24,1,32,3,40,11,50,36,46,103,111,111,103,108,101,46,112,114,111,
    116,111,98,117,102,46,70,105,108,101,68,101,115,99,114,105,112,116,111,
    114,80,114,111,116,111,34,220,2,10,19,70,105,108,101,68,101,115,99,114,
    105,112,116,111,114,80,114,111,116,111,18,12,10,4,110,97,109,101,24,1,32,
    1,40,9,18,15,10,7,112,97,99,107,97,103,101,24,2,32,1,40,9,18,18,10,10,100,
    101,112,101,110,100,101,110,99,121,24,3,32,3,40,9,18,54,10,12,109,101,115,
    115,97,103,101,95,116,121,112,101,24,4,32,3,40,11,50,32,46,103,111,111,
    103,108,101,46,112,114,111,116,111,98,117,102,46,68,101,115,99,114,105,
    112,116,111,114,80,114,111,116,111,18,55,10,9,101,110,117,109,95,116,121,
    112,101,24,5,32,3,40,11,50,36,46,103,111,111,103,108,101,46,112,114,111,
    116,111,98,117,102,46,69,110,117,109,68,101,115,99,114,105,112,116,111,
    114,80,114,111,116,111,18,56,10,7,115,101,114,118,105,99,101,24,6,32,3,
    40,11,50,39,46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,
    46,83,101,114,118,105,99,101,68,101,115,99,114,105,112,116,111,114,80,114,
    111,116,111,18,56,10,9,101,120,116,101,110,115,105,111,110,24,7,32,3,40,
    11,50,37,46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,46,
    70,105,101,108,100,68,101,115,99,114,105,112,116,111,114,80,114,111,116,
    111,18,45,10,7,111,112,116,105,111,110,115,24,8,32,1,40,11,50,28,46,103,
    111,111,103,108,101,46,112,114,111,116,111,98,117,102,46,70,105,108,101,
    79,112,116,105,111,110,115,34,169,3,10,15,68,101,115,99,114,105,112,116,
    111,114,80,114,111,116,111,18,12,10,4,110,97,109,101,24,1,32,1,40,9,18,
    52,10,5,102,105,101,108,100,24,2,32,3,40,11,50,37,46,103,111,111,103,108,
    101,46,112,114,111,116,111,98,117,102,46,70,105,101,108,100,68,101,115,
    99,114,105,112,116,111,114,80,114,111,116,111,18,56,10,9,101,120,116,101,
    110,115,105,111,110,24,6,32,3,40,11,50,37,46,103,111,111,103,108,101,46,
    112,114,111,116,111,98,117,102,46,70,105,101,108,100,68,101,115,99,114,
    105,112,116,111,114,80,114,111,116,111,18,53,10,11,110,101,115,116,101,
    100,95,116,121,112,101,24,3,32,3,40,11,50,32,46,103,111,111,103,108,101,
    46,112,114,111,116,111,98,117,102,46,68,101,115,99,114,105,112,116,111,
    114,80,114,111,116,111,18,55,10,9,101,110,117,109,95,116,121,112,101,24,
    4,32,3,40,11,50,36,46,103,111,111,103,108,101,46,112,114,111,116,111,98,
    117,102,46,69,110,117,109,68,101,115,99,114,105,112,116,111,114,80,114,
    111,116,111,18,72,10,15,101,120,116,101,110,115,105,111,110,95,114,97,110,
    103,101,24,5,32,3,40,11,50,47,46,103,111,111,103,108,101,46,112,114,111,
    116,111,98,117,102,46,68,101,115,99,114,105,112,116,111,114,80,114,111,
    116,111,46,69,120,116,101,110,115,105,111,110,82,97,110,103,101,18,48,10,
    7,111,112,116,105,111,110,115,24,7,32,1,40,11,50,31,46,103,111,111,103,
    108,101,46,112,114,111,116,111,98,117,102,46,77,101,115,115,97,103,101,
    79,112,116,105,111,110,115,26,44,10,14,69,120,116,101,110,115,105,111,110,
    82,97,110,103,101,18,13,10,5,115,116,97,114,116,24,1,32,1,40,5,18,11,10,
    3,101,110,100,24,2,32,1,40,5,34,148,5,10,20,70,105,101,108,100,68,101,115,
    99,114,105,112,116,111,114,80,114,111,116,111,18,12,10,4,110,97,109,101,
    24,1,32,1,40,9,18,14,10,6,110,117,109,98,101,114,24,3,32,1,40,5,18,58,10,
    5,108,97,98,101,108,24,4,32,1,40,14,50,43,46,103,111,111,103,108,101,46,
    112,114,111,116,111,98,117,102,46,70,105,101,108,100,68,101,115,99,114,
    105,112,116,111,114,80,114,111,116,111,46,76,97,98,101,108,18,56,10,4,116,
    121,112,101,24,5,32,1,40,14,50,42,46,103,111,111,103,108,101,46,112,114,
    111,116,111,98,117,102,46,70,105,101,108,100,68,101,115,99,114,105,112,
    116,111,114,80,114,111,116,111,46,84,121,112,101,18,17,10,9,116,121,112,
    101,95,110,97,109,101,24,6,32,1,40,9,18,16,10,8,101,120,116,101,110,100,
    101,101,24,2,32,1,40,9,18,21,10,13,100,101,102,97,117,108,116,95,118,97,
    108,117,101,24,7,32,1,40,9,18,46,10,7,111,112,116,105,111,110,115,24,8,
    32,1,40,11,50,29,46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,
    102,46,70,105,101,108,100,79,112,116,105,111,110,115,34,182,2,10,4,84,121,
    112,101,18,15,10,11,84,89,80,69,95,68,79,85,66,76,69,16,1,18,14,10,10,84,
    89,80,69,95,70,76,79,65,84,16,2,18,14,10,10,84,89,80,69,95,73,78,84,54,
    52,16,3,18,15,10,11,84,89,80,69,95,85,73,78,84,54,52,16,4,18,14,10,10,84,
    89,80,69,95,73,78,84,51,50,16,5,18,16,10,12,84,89,80,69,95,70,73,88,69,
    68,54,52,16,6,18,16,10,12,84,89,80,69,95,70,73,88,69,68,51,50,16,7,18,13,
    10,9,84,89,80,69,95,66,79,79,76,16,8,18,15,10,11,84,89,80,69,95,83,84,82,
    73,78,71,16,9,18,14,10,10,84,89,80,69,95,71,82,79,85,80,16,10,18,16,10,
    12,84,89,80,69,95,77,69,83,83,65,71,69,16,11,18,14,10,10,84,89,80,69,95,
    66,89,84,69,83,16,12,18,15,10,11,84,89,80,69,95,85,73,78,84,51,50,16,13,
    18,13,10,9,84,89,80,69,95,69,78,85,77,16,14,18,17,10,13,84,89,80,69,95,
    83,70,73,88,69,68,51,50,16,15,18,17,10,13,84,89,80,69,95,83,70,73,88,69,
    68,54,52,16,16,18,15,10,11,84,89,80,69,95,83,73,78,84,51,50,16,17,18,15,
    10,11,84,89,80,69,95,83,73,78,84,54,52,16,18,34,67,10,5,76,97,98,101,108,
    18,18,10,14,76,65,66,69,76,95,79,80,84,73,79,78,65,76,16,1,18,18,10,14,
    76,65,66,69,76,95,82,69,81,85,73,82,69,68,16,2,18,18,10,14,76,65,66,69,
    76,95,82,69,80,69,65,84,69,68,16,3,34,140,1,10,19,69,110,117,109,68,101,
    115,99,114,105,112,116,111,114,80,114,111,116,111,18,12,10,4,110,97,109,
    101,24,1,32,1,40,9,18,56,10,5,118,97,108,117,101,24,2,32,3,40,11,50,41,
    46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,46,69,110,
    117,109,86,97,108,117,101,68,101,115,99,114,105,112,116,111,114,80,114,
    111,116,111,18,45,10,7,111,112,116,105,111,110,115,24,3,32,1,40,11,50,28,
    46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,46,69,110,
    117,109,79,112,116,105,111,110,115,34,108,10,24,69,110,117,109,86,97,108,
    117,101,68,101,115,99,114,105,112,116,111,114,80,114,111,116,111,18,12,
    10,4,110,97,109,101,24,1,32,1,40,9,18,14,10,6,110,117,109,98,101,114,24,
    2,32,1,40,5,18,50,10,7,111,112,116,105,111,110,115,24,3,32,1,40,11,50,33,
    46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,46,69,110,
    117,109,86,97,108,117,101,79,112,116,105,111,110,115,34,144,1,10,22,83,
    101,114,118,105,99,101,68,101,115,99,114,105,112,116,111,114,80,114,111,
    116,111,18,12,10,4,110,97,109,101,24,1,32,1,40,9,18,54,10,6,109,101,116,
    104,111,100,24,2,32,3,40,11,50,38,46,103,111,111,103,108,101,46,112,114,
    111,116,111,98,117,102,46,77,101,116,104,111,100,68,101,115,99,114,105,
    112,116,111,114,80,114,111,116,111,18,48,10,7,111,112,116,105,111,110,115,
    24,3,32,1,40,11,50,31,46,103,111,111,103,108,101,46,112,114,111,116,111,
    98,117,102,46,83,101,114,118,105,99,101,79,112,116,105,111,110,115,34,127,
    10,21,77,101,116,104,111,100,68,101,115,99,114,105,112,116,111,114,80,114,
    111,116,111,18,12,10,4,110,97,109,101,24,1,32,1,40,9,18,18,10,10,105,110,
    112,117,116,95,116,121,112,101,24,2,32,1,40,9,18,19,10,11,111,117,116,112,
    117,116,95,116,121,112,101,24,3,32,1,40,9,18,47,10,7,111,112,116,105,111,
    110,115,24,4,32,1,40,11,50,30,46,103,111,111,103,108,101,46,112,114,111,
    116,111,98,117,102,46,77,101,116,104,111,100,79,112,116,105,111,110,115,
    34,152,2,10,11,70,105,108,101,79,112,116,105,111,110,115,18,20,10,12,106,
    97,118,97,95,112,97,99,107,97,103,101,24,1,32,1,40,9,18,28,10,20,106,97,
    118,97,95,111,117,116,101,114,95,99,108,97,115,115,110,97,109,101,24,8,
    32,1,40,9,18,34,10,19,106,97,118,97,95,109,117,108,116,105,112,108,101,
    95,102,105,108,101,115,24,10,32,1,40,8,58,5,102,97,108,115,101,18,74,10,
    12,111,112,116,105,109,105,122,101,95,102,111,114,24,9,32,1,40,14,50,41,
    46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,102,46,70,105,
    108,101,79,112,116,105,111,110,115,46,79,112,116,105,109,105,122,101,77,
    111,100,101,58,9,67,79,68,69,95,83,73,90,69,18,26,10,18,111,98,106,101,
    99,116,105,118,101,99,95,112,97,99,107,97,103,101,24,11,32,1,40,9,18,31,
    10,23,111,98,106,101,99,116,105,118,101,99,95,99,108,97,115,115,95,112,
    114,101,102,105,120,24,12,32,1,40,9,34,40,10,12,79,112,116,105,109,105,
    122,101,77,111,100,101,18,9,10,5,83,80,69,69,68,16,1,18,13,10,9,67,79,68,
    69,95,83,73,90,69,16,2,34,56,10,14,77,101,115,115,97,103,101,79,112,116,
    105,111,110,115,18,38,10,23,109,101,115,115,97,103,101,95,115,101,116,95,
    119,105,114,101,95,102,111,114,109,97,116,24,1,32,1,40,8,58,5,102,97,108,
    115,101,34,133,1,10,12,70,105,101,108,100,79,112,116,105,111,110,115,18,
    50,10,5,99,116,121,112,101,24,1,32,1,40,14,50,35,46,103,111,111,103,108,
    101,46,112,114,111,116,111,98,117,102,46,70,105,101,108,100,79,112,116,
    105,111,110,115,46,67,84,121,112,101,18,28,10,20,101,120,112,101,114,105,
    109,101,110,116,97,108,95,109,97,112,95,107,101,121,24,9,32,1,40,9,34,35,
    10,5,67,84,121,112,101,18,8,10,4,67,79,82,68,16,1,18,16,10,12,83,84,82,
    73,78,71,95,80,73,69,67,69,16,2,34,13,10,11,69,110,117,109,79,112,116,105,
    111,110,115,34,18,10,16,69,110,117,109,86,97,108,117,101,79,112,116,105,
    111,110,115,34,16,10,14,83,101,114,118,105,99,101,79,112,116,105,111,110,
    115,34,15,10,13,77,101,116,104,111,100,79,112,116,105,111,110,115,66,62,
    10,19,99,111,109,46,103,111,111,103,108,101,46,112,114,111,116,111,98,117,
    102,66,16,68,101,115,99,114,105,112,116,111,114,80,114,111,116,111,115,
    72,1,90,15,80,114,111,116,111,99,111,108,66,117,102,102,101,114,115,98,
    2,80,66,
  };
  NSArray* dependencies = [NSArray arrayWithObjects:nil];
  
  NSData* data = [NSData dataWithBytes:descriptorData length:2706];
  PBFileDescriptorProto* proto = [PBFileDescriptorProto parseFromData:data];
  return [PBFileDescriptor buildFrom:proto dependencies:dependencies];
}
@end

@interface PBFileDescriptorSet ()
@property (retain) NSMutableArray* mutableFileList;
@end

@implementation PBFileDescriptorSet

@synthesize mutableFileList;
- (void) dealloc {
  self.mutableFileList = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static PBFileDescriptorSet* defaultPBFileDescriptorSetInstance = nil;
+ (void) initialize {
  if (self == [PBFileDescriptorSet class]) {
    defaultPBFileDescriptorSetInstance = [[PBFileDescriptorSet alloc] init];
  }
}
+ (PBFileDescriptorSet*) defaultInstance {
  return defaultPBFileDescriptorSetInstance;
}
- (PBFileDescriptorSet*) defaultInstance {
  return defaultPBFileDescriptorSetInstance;
}
- (PBDescriptor*) descriptor {
  return [PBFileDescriptorSet descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_FileDescriptorSet_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_FileDescriptorSet_fieldAccessorTable];
}
- (NSArray*) fileList {
  return mutableFileList;
}
- (PBFileDescriptorProto*) fileAtIndex:(int32_t) index {
  id value = [mutableFileList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  for (PBFileDescriptorProto* element in self.fileList) {
    [output writeMessage:1 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  for (PBFileDescriptorProto* element in self.fileList) {
    size += computeMessageSize(1, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBFileDescriptorSet*) parseFromData:(NSData*) data {
  return (PBFileDescriptorSet*)[[[PBFileDescriptorSet_Builder builder] mergeFromData:data] build];
}
+ (PBFileDescriptorSet*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileDescriptorSet*)[[[PBFileDescriptorSet_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBFileDescriptorSet*) parseFromInputStream:(NSInputStream*) input {
  return (PBFileDescriptorSet*)[[[PBFileDescriptorSet_Builder builder] mergeFromInputStream:input] build];
}
+ (PBFileDescriptorSet*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileDescriptorSet*)[[[PBFileDescriptorSet_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBFileDescriptorSet*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBFileDescriptorSet*)[[[PBFileDescriptorSet_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBFileDescriptorSet*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileDescriptorSet*)[[[PBFileDescriptorSet_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBFileDescriptorSet_Builder*) createBuilder {
  return [PBFileDescriptorSet_Builder builder];
}
@end

@implementation PBFileDescriptorSet_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBFileDescriptorSet alloc] init] autorelease];
  }
  return self;
}
+ (PBFileDescriptorSet_Builder*) builder {
  return [[[PBFileDescriptorSet_Builder alloc] init] autorelease];
}
+ (PBFileDescriptorSet_Builder*) builderWithPrototype:(PBFileDescriptorSet*) prototype {
  return [[PBFileDescriptorSet_Builder builder] mergeFromPBFileDescriptorSet:prototype];
}
- (PBFileDescriptorSet*) internalGetResult {
  return result;
}
- (PBFileDescriptorSet_Builder*) clear {
  self.result = [[[PBFileDescriptorSet alloc] init] autorelease];
  return self;
}
- (PBFileDescriptorSet_Builder*) clone {
  return [PBFileDescriptorSet_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBFileDescriptorSet descriptor];
}
- (PBFileDescriptorSet*) defaultInstance {
  return [PBFileDescriptorSet defaultInstance];
}
- (PBFileDescriptorSet*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBFileDescriptorSet*) buildPartial {
  PBFileDescriptorSet* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBFileDescriptorSet_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBFileDescriptorSet class]]) {
    return [self mergeFromPBFileDescriptorSet:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBFileDescriptorSet_Builder*) mergeFromPBFileDescriptorSet:(PBFileDescriptorSet*) other {
  if (other == [PBFileDescriptorSet defaultInstance]) return self;
  if (other.mutableFileList.count > 0) {
    if (result.mutableFileList == nil) {
      result.mutableFileList = [NSMutableArray array];
    }
    [result.mutableFileList addObjectsFromArray:other.mutableFileList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBFileDescriptorSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBFileDescriptorSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        PBFileDescriptorProto_Builder* subBuilder = [PBFileDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addFile:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (NSArray*) fileList {
  if (result.mutableFileList == nil) { return [NSArray array]; }
  return result.mutableFileList;
}
- (PBFileDescriptorProto*) fileAtIndex:(int32_t) index {
  return [result fileAtIndex:index];
}
- (PBFileDescriptorSet_Builder*) replaceFileAtIndex:(int32_t) index withFile:(PBFileDescriptorProto*) value {
  [result.mutableFileList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBFileDescriptorSet_Builder*) addAllFile:(NSArray*) values {
  if (result.mutableFileList == nil) {
    result.mutableFileList = [NSMutableArray array];
  }
  [result.mutableFileList addObjectsFromArray:values];
  return self;
}
- (PBFileDescriptorSet_Builder*) clearFileList {
  result.mutableFileList = nil;
  return self;
}
- (PBFileDescriptorSet_Builder*) addFile:(PBFileDescriptorProto*) value {
  if (result.mutableFileList == nil) {
    result.mutableFileList = [NSMutableArray array];
  }
  [result.mutableFileList addObject:value];
  return self;
}
@end

@interface PBFileDescriptorProto ()
@property BOOL hasName;
@property (retain) NSString* name;
@property BOOL hasPackage;
@property (retain) NSString* package;
@property (retain) NSMutableArray* mutableDependencyList;
@property (retain) NSMutableArray* mutableMessageTypeList;
@property (retain) NSMutableArray* mutableEnumTypeList;
@property (retain) NSMutableArray* mutableServiceList;
@property (retain) NSMutableArray* mutableExtensionList;
@property BOOL hasOptions;
@property (retain) PBFileOptions* options;
@end

@implementation PBFileDescriptorProto

@synthesize hasName;
@synthesize name;
@synthesize hasPackage;
@synthesize package;
@synthesize mutableDependencyList;
@synthesize mutableMessageTypeList;
@synthesize mutableEnumTypeList;
@synthesize mutableServiceList;
@synthesize mutableExtensionList;
@synthesize hasOptions;
@synthesize options;
- (void) dealloc {
  self.hasName = NO;
  self.name = nil;
  self.hasPackage = NO;
  self.package = nil;
  self.mutableDependencyList = nil;
  self.mutableMessageTypeList = nil;
  self.mutableEnumTypeList = nil;
  self.mutableServiceList = nil;
  self.mutableExtensionList = nil;
  self.hasOptions = NO;
  self.options = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.name = @"";
    self.package = @"";
    self.options = [PBFileOptions defaultInstance];
  }
  return self;
}
static PBFileDescriptorProto* defaultPBFileDescriptorProtoInstance = nil;
+ (void) initialize {
  if (self == [PBFileDescriptorProto class]) {
    defaultPBFileDescriptorProtoInstance = [[PBFileDescriptorProto alloc] init];
  }
}
+ (PBFileDescriptorProto*) defaultInstance {
  return defaultPBFileDescriptorProtoInstance;
}
- (PBFileDescriptorProto*) defaultInstance {
  return defaultPBFileDescriptorProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [PBFileDescriptorProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_FileDescriptorProto_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_FileDescriptorProto_fieldAccessorTable];
}
- (NSArray*) dependencyList {
  return mutableDependencyList;
}
- (NSString*) dependencyAtIndex:(int32_t) index {
  id value = [mutableDependencyList objectAtIndex:index];
  return value;
}
- (NSArray*) messageTypeList {
  return mutableMessageTypeList;
}
- (PBDescriptorProto*) messageTypeAtIndex:(int32_t) index {
  id value = [mutableMessageTypeList objectAtIndex:index];
  return value;
}
- (NSArray*) enumTypeList {
  return mutableEnumTypeList;
}
- (PBEnumDescriptorProto*) enumTypeAtIndex:(int32_t) index {
  id value = [mutableEnumTypeList objectAtIndex:index];
  return value;
}
- (NSArray*) serviceList {
  return mutableServiceList;
}
- (PBServiceDescriptorProto*) serviceAtIndex:(int32_t) index {
  id value = [mutableServiceList objectAtIndex:index];
  return value;
}
- (NSArray*) extensionList {
  return mutableExtensionList;
}
- (PBFieldDescriptorProto*) extensionAtIndex:(int32_t) index {
  id value = [mutableExtensionList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasName) {
    [output writeString:1 value:self.name];
  }
  if (hasPackage) {
    [output writeString:2 value:self.package];
  }
  for (NSString* element in self.mutableDependencyList) {
    [output writeString:3 value:element];
  }
  for (PBDescriptorProto* element in self.messageTypeList) {
    [output writeMessage:4 value:element];
  }
  for (PBEnumDescriptorProto* element in self.enumTypeList) {
    [output writeMessage:5 value:element];
  }
  for (PBServiceDescriptorProto* element in self.serviceList) {
    [output writeMessage:6 value:element];
  }
  for (PBFieldDescriptorProto* element in self.extensionList) {
    [output writeMessage:7 value:element];
  }
  if (self.hasOptions) {
    [output writeMessage:8 value:self.options];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasName) {
    size += computeStringSize(1, self.name);
  }
  if (hasPackage) {
    size += computeStringSize(2, self.package);
  }
  for (NSString* element in self.mutableDependencyList) {
    size += computeStringSize(3, element);
  }
  for (PBDescriptorProto* element in self.messageTypeList) {
    size += computeMessageSize(4, element);
  }
  for (PBEnumDescriptorProto* element in self.enumTypeList) {
    size += computeMessageSize(5, element);
  }
  for (PBServiceDescriptorProto* element in self.serviceList) {
    size += computeMessageSize(6, element);
  }
  for (PBFieldDescriptorProto* element in self.extensionList) {
    size += computeMessageSize(7, element);
  }
  if (self.hasOptions) {
    size += computeMessageSize(8, self.options);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBFileDescriptorProto*) parseFromData:(NSData*) data {
  return (PBFileDescriptorProto*)[[[PBFileDescriptorProto_Builder builder] mergeFromData:data] build];
}
+ (PBFileDescriptorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileDescriptorProto*)[[[PBFileDescriptorProto_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBFileDescriptorProto*) parseFromInputStream:(NSInputStream*) input {
  return (PBFileDescriptorProto*)[[[PBFileDescriptorProto_Builder builder] mergeFromInputStream:input] build];
}
+ (PBFileDescriptorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileDescriptorProto*)[[[PBFileDescriptorProto_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBFileDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBFileDescriptorProto*)[[[PBFileDescriptorProto_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBFileDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileDescriptorProto*)[[[PBFileDescriptorProto_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBFileDescriptorProto_Builder*) createBuilder {
  return [PBFileDescriptorProto_Builder builder];
}
@end

@implementation PBFileDescriptorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBFileDescriptorProto alloc] init] autorelease];
  }
  return self;
}
+ (PBFileDescriptorProto_Builder*) builder {
  return [[[PBFileDescriptorProto_Builder alloc] init] autorelease];
}
+ (PBFileDescriptorProto_Builder*) builderWithPrototype:(PBFileDescriptorProto*) prototype {
  return [[PBFileDescriptorProto_Builder builder] mergeFromPBFileDescriptorProto:prototype];
}
- (PBFileDescriptorProto*) internalGetResult {
  return result;
}
- (PBFileDescriptorProto_Builder*) clear {
  self.result = [[[PBFileDescriptorProto alloc] init] autorelease];
  return self;
}
- (PBFileDescriptorProto_Builder*) clone {
  return [PBFileDescriptorProto_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBFileDescriptorProto descriptor];
}
- (PBFileDescriptorProto*) defaultInstance {
  return [PBFileDescriptorProto defaultInstance];
}
- (PBFileDescriptorProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBFileDescriptorProto*) buildPartial {
  PBFileDescriptorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBFileDescriptorProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBFileDescriptorProto class]]) {
    return [self mergeFromPBFileDescriptorProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBFileDescriptorProto_Builder*) mergeFromPBFileDescriptorProto:(PBFileDescriptorProto*) other {
  if (other == [PBFileDescriptorProto defaultInstance]) return self;
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.hasPackage) {
    [self setPackage:other.package];
  }
  if (other.mutableDependencyList.count > 0) {
    if (result.mutableDependencyList == nil) {
      result.mutableDependencyList = [NSMutableArray array];
    }
    [result.mutableDependencyList addObjectsFromArray:other.mutableDependencyList];
  }
  if (other.mutableMessageTypeList.count > 0) {
    if (result.mutableMessageTypeList == nil) {
      result.mutableMessageTypeList = [NSMutableArray array];
    }
    [result.mutableMessageTypeList addObjectsFromArray:other.mutableMessageTypeList];
  }
  if (other.mutableEnumTypeList.count > 0) {
    if (result.mutableEnumTypeList == nil) {
      result.mutableEnumTypeList = [NSMutableArray array];
    }
    [result.mutableEnumTypeList addObjectsFromArray:other.mutableEnumTypeList];
  }
  if (other.mutableServiceList.count > 0) {
    if (result.mutableServiceList == nil) {
      result.mutableServiceList = [NSMutableArray array];
    }
    [result.mutableServiceList addObjectsFromArray:other.mutableServiceList];
  }
  if (other.mutableExtensionList.count > 0) {
    if (result.mutableExtensionList == nil) {
      result.mutableExtensionList = [NSMutableArray array];
    }
    [result.mutableExtensionList addObjectsFromArray:other.mutableExtensionList];
  }
  if (other.hasOptions) {
    [self mergeOptions:other.options];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBFileDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBFileDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setName:[input readString]];
        break;
      }
      case 18: {
        [self setPackage:[input readString]];
        break;
      }
      case 26: {
        [self addDependency:[input readString]];
        break;
      }
      case 34: {
        PBDescriptorProto_Builder* subBuilder = [PBDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addMessageType:[subBuilder buildPartial]];
        break;
      }
      case 42: {
        PBEnumDescriptorProto_Builder* subBuilder = [PBEnumDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addEnumType:[subBuilder buildPartial]];
        break;
      }
      case 50: {
        PBServiceDescriptorProto_Builder* subBuilder = [PBServiceDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addService:[subBuilder buildPartial]];
        break;
      }
      case 58: {
        PBFieldDescriptorProto_Builder* subBuilder = [PBFieldDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addExtension:[subBuilder buildPartial]];
        break;
      }
      case 66: {
        PBFileOptions_Builder* subBuilder = [PBFileOptions_Builder builder];
        if (self.hasOptions) {
          [subBuilder mergeFromPBFileOptions:self.options];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptions:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (PBFileDescriptorProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (PBFileDescriptorProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (BOOL) hasPackage {
  return result.hasPackage;
}
- (NSString*) package {
  return result.package;
}
- (PBFileDescriptorProto_Builder*) setPackage:(NSString*) value {
  result.hasPackage = YES;
  result.package = value;
  return self;
}
- (PBFileDescriptorProto_Builder*) clearPackage {
  result.hasPackage = NO;
  result.package = @"";
  return self;
}
- (NSArray*) dependencyList {
  if (result.mutableDependencyList == nil) { return [NSArray array]; }
  return result.mutableDependencyList;
}
- (NSString*) dependencyAtIndex:(int32_t) index {
  return [result dependencyAtIndex:index];
}
- (PBFileDescriptorProto_Builder*) replaceDependencyAtIndex:(int32_t) index withDependency:(NSString*) value {
  [result.mutableDependencyList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBFileDescriptorProto_Builder*) addDependency:(NSString*) value {
  if (result.mutableDependencyList == nil) {
    result.mutableDependencyList = [NSMutableArray array];
  }
  [result.mutableDependencyList addObject:value];
  return self;
}
- (PBFileDescriptorProto_Builder*) addAllDependency:(NSArray*) values {
  if (result.mutableDependencyList == nil) {
    result.mutableDependencyList = [NSMutableArray array];
  }
  [result.mutableDependencyList addObjectsFromArray:values];
  return self;
}
- (PBFileDescriptorProto_Builder*) clearDependencyList {
  result.mutableDependencyList = nil;
  return self;
}
- (NSArray*) messageTypeList {
  if (result.mutableMessageTypeList == nil) { return [NSArray array]; }
  return result.mutableMessageTypeList;
}
- (PBDescriptorProto*) messageTypeAtIndex:(int32_t) index {
  return [result messageTypeAtIndex:index];
}
- (PBFileDescriptorProto_Builder*) replaceMessageTypeAtIndex:(int32_t) index withMessageType:(PBDescriptorProto*) value {
  [result.mutableMessageTypeList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBFileDescriptorProto_Builder*) addAllMessageType:(NSArray*) values {
  if (result.mutableMessageTypeList == nil) {
    result.mutableMessageTypeList = [NSMutableArray array];
  }
  [result.mutableMessageTypeList addObjectsFromArray:values];
  return self;
}
- (PBFileDescriptorProto_Builder*) clearMessageTypeList {
  result.mutableMessageTypeList = nil;
  return self;
}
- (PBFileDescriptorProto_Builder*) addMessageType:(PBDescriptorProto*) value {
  if (result.mutableMessageTypeList == nil) {
    result.mutableMessageTypeList = [NSMutableArray array];
  }
  [result.mutableMessageTypeList addObject:value];
  return self;
}
- (NSArray*) enumTypeList {
  if (result.mutableEnumTypeList == nil) { return [NSArray array]; }
  return result.mutableEnumTypeList;
}
- (PBEnumDescriptorProto*) enumTypeAtIndex:(int32_t) index {
  return [result enumTypeAtIndex:index];
}
- (PBFileDescriptorProto_Builder*) replaceEnumTypeAtIndex:(int32_t) index withEnumType:(PBEnumDescriptorProto*) value {
  [result.mutableEnumTypeList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBFileDescriptorProto_Builder*) addAllEnumType:(NSArray*) values {
  if (result.mutableEnumTypeList == nil) {
    result.mutableEnumTypeList = [NSMutableArray array];
  }
  [result.mutableEnumTypeList addObjectsFromArray:values];
  return self;
}
- (PBFileDescriptorProto_Builder*) clearEnumTypeList {
  result.mutableEnumTypeList = nil;
  return self;
}
- (PBFileDescriptorProto_Builder*) addEnumType:(PBEnumDescriptorProto*) value {
  if (result.mutableEnumTypeList == nil) {
    result.mutableEnumTypeList = [NSMutableArray array];
  }
  [result.mutableEnumTypeList addObject:value];
  return self;
}
- (NSArray*) serviceList {
  if (result.mutableServiceList == nil) { return [NSArray array]; }
  return result.mutableServiceList;
}
- (PBServiceDescriptorProto*) serviceAtIndex:(int32_t) index {
  return [result serviceAtIndex:index];
}
- (PBFileDescriptorProto_Builder*) replaceServiceAtIndex:(int32_t) index withService:(PBServiceDescriptorProto*) value {
  [result.mutableServiceList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBFileDescriptorProto_Builder*) addAllService:(NSArray*) values {
  if (result.mutableServiceList == nil) {
    result.mutableServiceList = [NSMutableArray array];
  }
  [result.mutableServiceList addObjectsFromArray:values];
  return self;
}
- (PBFileDescriptorProto_Builder*) clearServiceList {
  result.mutableServiceList = nil;
  return self;
}
- (PBFileDescriptorProto_Builder*) addService:(PBServiceDescriptorProto*) value {
  if (result.mutableServiceList == nil) {
    result.mutableServiceList = [NSMutableArray array];
  }
  [result.mutableServiceList addObject:value];
  return self;
}
- (NSArray*) extensionList {
  if (result.mutableExtensionList == nil) { return [NSArray array]; }
  return result.mutableExtensionList;
}
- (PBFieldDescriptorProto*) extensionAtIndex:(int32_t) index {
  return [result extensionAtIndex:index];
}
- (PBFileDescriptorProto_Builder*) replaceExtensionAtIndex:(int32_t) index withExtension:(PBFieldDescriptorProto*) value {
  [result.mutableExtensionList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBFileDescriptorProto_Builder*) addAllExtension:(NSArray*) values {
  if (result.mutableExtensionList == nil) {
    result.mutableExtensionList = [NSMutableArray array];
  }
  [result.mutableExtensionList addObjectsFromArray:values];
  return self;
}
- (PBFileDescriptorProto_Builder*) clearExtensionList {
  result.mutableExtensionList = nil;
  return self;
}
- (PBFileDescriptorProto_Builder*) addExtension:(PBFieldDescriptorProto*) value {
  if (result.mutableExtensionList == nil) {
    result.mutableExtensionList = [NSMutableArray array];
  }
  [result.mutableExtensionList addObject:value];
  return self;
}
- (BOOL) hasOptions {
  return result.hasOptions;
}
- (PBFileOptions*) options {
  return result.options;
}
- (PBFileDescriptorProto_Builder*) setOptions:(PBFileOptions*) value {
  result.hasOptions = YES;
  result.options = value;
  return self;
}
- (PBFileDescriptorProto_Builder*) setOptionsBuilder:(PBFileOptions_Builder*) builderForValue {
  return [self setOptions:[builderForValue build]];
}
- (PBFileDescriptorProto_Builder*) mergeOptions:(PBFileOptions*) value {
  if (result.hasOptions &&
      result.options != [PBFileOptions defaultInstance]) {
    result.options =
      [[[PBFileOptions_Builder builderWithPrototype:result.options] mergeFromPBFileOptions:value] buildPartial];
  } else {
    result.options = value;
  }
  result.hasOptions = YES;
  return self;
}
- (PBFileDescriptorProto_Builder*) clearOptions {
  result.hasOptions = NO;
  result.options = [PBFileOptions defaultInstance];
  return self;
}
@end

@interface PBDescriptorProto ()
@property BOOL hasName;
@property (retain) NSString* name;
@property (retain) NSMutableArray* mutableFieldList;
@property (retain) NSMutableArray* mutableExtensionList;
@property (retain) NSMutableArray* mutableNestedTypeList;
@property (retain) NSMutableArray* mutableEnumTypeList;
@property (retain) NSMutableArray* mutableExtensionRangeList;
@property BOOL hasOptions;
@property (retain) PBMessageOptions* options;
@end

@implementation PBDescriptorProto

@synthesize hasName;
@synthesize name;
@synthesize mutableFieldList;
@synthesize mutableExtensionList;
@synthesize mutableNestedTypeList;
@synthesize mutableEnumTypeList;
@synthesize mutableExtensionRangeList;
@synthesize hasOptions;
@synthesize options;
- (void) dealloc {
  self.hasName = NO;
  self.name = nil;
  self.mutableFieldList = nil;
  self.mutableExtensionList = nil;
  self.mutableNestedTypeList = nil;
  self.mutableEnumTypeList = nil;
  self.mutableExtensionRangeList = nil;
  self.hasOptions = NO;
  self.options = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.name = @"";
    self.options = [PBMessageOptions defaultInstance];
  }
  return self;
}
static PBDescriptorProto* defaultPBDescriptorProtoInstance = nil;
+ (void) initialize {
  if (self == [PBDescriptorProto class]) {
    defaultPBDescriptorProtoInstance = [[PBDescriptorProto alloc] init];
  }
}
+ (PBDescriptorProto*) defaultInstance {
  return defaultPBDescriptorProtoInstance;
}
- (PBDescriptorProto*) defaultInstance {
  return defaultPBDescriptorProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [PBDescriptorProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_DescriptorProto_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_DescriptorProto_fieldAccessorTable];
}
- (NSArray*) fieldList {
  return mutableFieldList;
}
- (PBFieldDescriptorProto*) fieldAtIndex:(int32_t) index {
  id value = [mutableFieldList objectAtIndex:index];
  return value;
}
- (NSArray*) extensionList {
  return mutableExtensionList;
}
- (PBFieldDescriptorProto*) extensionAtIndex:(int32_t) index {
  id value = [mutableExtensionList objectAtIndex:index];
  return value;
}
- (NSArray*) nestedTypeList {
  return mutableNestedTypeList;
}
- (PBDescriptorProto*) nestedTypeAtIndex:(int32_t) index {
  id value = [mutableNestedTypeList objectAtIndex:index];
  return value;
}
- (NSArray*) enumTypeList {
  return mutableEnumTypeList;
}
- (PBEnumDescriptorProto*) enumTypeAtIndex:(int32_t) index {
  id value = [mutableEnumTypeList objectAtIndex:index];
  return value;
}
- (NSArray*) extensionRangeList {
  return mutableExtensionRangeList;
}
- (PBDescriptorProto_ExtensionRange*) extensionRangeAtIndex:(int32_t) index {
  id value = [mutableExtensionRangeList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasName) {
    [output writeString:1 value:self.name];
  }
  for (PBFieldDescriptorProto* element in self.fieldList) {
    [output writeMessage:2 value:element];
  }
  for (PBDescriptorProto* element in self.nestedTypeList) {
    [output writeMessage:3 value:element];
  }
  for (PBEnumDescriptorProto* element in self.enumTypeList) {
    [output writeMessage:4 value:element];
  }
  for (PBDescriptorProto_ExtensionRange* element in self.extensionRangeList) {
    [output writeMessage:5 value:element];
  }
  for (PBFieldDescriptorProto* element in self.extensionList) {
    [output writeMessage:6 value:element];
  }
  if (self.hasOptions) {
    [output writeMessage:7 value:self.options];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasName) {
    size += computeStringSize(1, self.name);
  }
  for (PBFieldDescriptorProto* element in self.fieldList) {
    size += computeMessageSize(2, element);
  }
  for (PBDescriptorProto* element in self.nestedTypeList) {
    size += computeMessageSize(3, element);
  }
  for (PBEnumDescriptorProto* element in self.enumTypeList) {
    size += computeMessageSize(4, element);
  }
  for (PBDescriptorProto_ExtensionRange* element in self.extensionRangeList) {
    size += computeMessageSize(5, element);
  }
  for (PBFieldDescriptorProto* element in self.extensionList) {
    size += computeMessageSize(6, element);
  }
  if (self.hasOptions) {
    size += computeMessageSize(7, self.options);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBDescriptorProto*) parseFromData:(NSData*) data {
  return (PBDescriptorProto*)[[[PBDescriptorProto_Builder builder] mergeFromData:data] build];
}
+ (PBDescriptorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBDescriptorProto*)[[[PBDescriptorProto_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBDescriptorProto*) parseFromInputStream:(NSInputStream*) input {
  return (PBDescriptorProto*)[[[PBDescriptorProto_Builder builder] mergeFromInputStream:input] build];
}
+ (PBDescriptorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBDescriptorProto*)[[[PBDescriptorProto_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBDescriptorProto*)[[[PBDescriptorProto_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBDescriptorProto*)[[[PBDescriptorProto_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBDescriptorProto_Builder*) createBuilder {
  return [PBDescriptorProto_Builder builder];
}
@end

@interface PBDescriptorProto_ExtensionRange ()
@property BOOL hasStart;
@property int32_t start;
@property BOOL hasEnd;
@property int32_t end;
@end

@implementation PBDescriptorProto_ExtensionRange

@synthesize hasStart;
@synthesize start;
@synthesize hasEnd;
@synthesize end;
- (void) dealloc {
  self.hasStart = NO;
  self.start = 0;
  self.hasEnd = NO;
  self.end = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.start = 0;
    self.end = 0;
  }
  return self;
}
static PBDescriptorProto_ExtensionRange* defaultPBDescriptorProto_ExtensionRangeInstance = nil;
+ (void) initialize {
  if (self == [PBDescriptorProto_ExtensionRange class]) {
    defaultPBDescriptorProto_ExtensionRangeInstance = [[PBDescriptorProto_ExtensionRange alloc] init];
  }
}
+ (PBDescriptorProto_ExtensionRange*) defaultInstance {
  return defaultPBDescriptorProto_ExtensionRangeInstance;
}
- (PBDescriptorProto_ExtensionRange*) defaultInstance {
  return defaultPBDescriptorProto_ExtensionRangeInstance;
}
- (PBDescriptor*) descriptor {
  return [PBDescriptorProto_ExtensionRange descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_DescriptorProto_ExtensionRange_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_DescriptorProto_ExtensionRange_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasStart) {
    [output writeInt32:1 value:self.start];
  }
  if (hasEnd) {
    [output writeInt32:2 value:self.end];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasStart) {
    size += computeInt32Size(1, self.start);
  }
  if (hasEnd) {
    size += computeInt32Size(2, self.end);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBDescriptorProto_ExtensionRange*) parseFromData:(NSData*) data {
  return (PBDescriptorProto_ExtensionRange*)[[[PBDescriptorProto_ExtensionRange_Builder builder] mergeFromData:data] build];
}
+ (PBDescriptorProto_ExtensionRange*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBDescriptorProto_ExtensionRange*)[[[PBDescriptorProto_ExtensionRange_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBDescriptorProto_ExtensionRange*) parseFromInputStream:(NSInputStream*) input {
  return (PBDescriptorProto_ExtensionRange*)[[[PBDescriptorProto_ExtensionRange_Builder builder] mergeFromInputStream:input] build];
}
+ (PBDescriptorProto_ExtensionRange*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBDescriptorProto_ExtensionRange*)[[[PBDescriptorProto_ExtensionRange_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBDescriptorProto_ExtensionRange*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBDescriptorProto_ExtensionRange*)[[[PBDescriptorProto_ExtensionRange_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBDescriptorProto_ExtensionRange*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBDescriptorProto_ExtensionRange*)[[[PBDescriptorProto_ExtensionRange_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBDescriptorProto_ExtensionRange_Builder*) createBuilder {
  return [PBDescriptorProto_ExtensionRange_Builder builder];
}
@end

@implementation PBDescriptorProto_ExtensionRange_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBDescriptorProto_ExtensionRange alloc] init] autorelease];
  }
  return self;
}
+ (PBDescriptorProto_ExtensionRange_Builder*) builder {
  return [[[PBDescriptorProto_ExtensionRange_Builder alloc] init] autorelease];
}
+ (PBDescriptorProto_ExtensionRange_Builder*) builderWithPrototype:(PBDescriptorProto_ExtensionRange*) prototype {
  return [[PBDescriptorProto_ExtensionRange_Builder builder] mergeFromPBDescriptorProto_ExtensionRange:prototype];
}
- (PBDescriptorProto_ExtensionRange*) internalGetResult {
  return result;
}
- (PBDescriptorProto_ExtensionRange_Builder*) clear {
  self.result = [[[PBDescriptorProto_ExtensionRange alloc] init] autorelease];
  return self;
}
- (PBDescriptorProto_ExtensionRange_Builder*) clone {
  return [PBDescriptorProto_ExtensionRange_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBDescriptorProto_ExtensionRange descriptor];
}
- (PBDescriptorProto_ExtensionRange*) defaultInstance {
  return [PBDescriptorProto_ExtensionRange defaultInstance];
}
- (PBDescriptorProto_ExtensionRange*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBDescriptorProto_ExtensionRange*) buildPartial {
  PBDescriptorProto_ExtensionRange* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBDescriptorProto_ExtensionRange_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBDescriptorProto_ExtensionRange class]]) {
    return [self mergeFromPBDescriptorProto_ExtensionRange:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBDescriptorProto_ExtensionRange_Builder*) mergeFromPBDescriptorProto_ExtensionRange:(PBDescriptorProto_ExtensionRange*) other {
  if (other == [PBDescriptorProto_ExtensionRange defaultInstance]) return self;
  if (other.hasStart) {
    [self setStart:other.start];
  }
  if (other.hasEnd) {
    [self setEnd:other.end];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBDescriptorProto_ExtensionRange_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBDescriptorProto_ExtensionRange_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setStart:[input readInt32]];
        break;
      }
      case 16: {
        [self setEnd:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasStart {
  return result.hasStart;
}
- (int32_t) start {
  return result.start;
}
- (PBDescriptorProto_ExtensionRange_Builder*) setStart:(int32_t) value {
  result.hasStart = YES;
  result.start = value;
  return self;
}
- (PBDescriptorProto_ExtensionRange_Builder*) clearStart {
  result.hasStart = NO;
  result.start = 0;
  return self;
}
- (BOOL) hasEnd {
  return result.hasEnd;
}
- (int32_t) end {
  return result.end;
}
- (PBDescriptorProto_ExtensionRange_Builder*) setEnd:(int32_t) value {
  result.hasEnd = YES;
  result.end = value;
  return self;
}
- (PBDescriptorProto_ExtensionRange_Builder*) clearEnd {
  result.hasEnd = NO;
  result.end = 0;
  return self;
}
@end

@implementation PBDescriptorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBDescriptorProto alloc] init] autorelease];
  }
  return self;
}
+ (PBDescriptorProto_Builder*) builder {
  return [[[PBDescriptorProto_Builder alloc] init] autorelease];
}
+ (PBDescriptorProto_Builder*) builderWithPrototype:(PBDescriptorProto*) prototype {
  return [[PBDescriptorProto_Builder builder] mergeFromPBDescriptorProto:prototype];
}
- (PBDescriptorProto*) internalGetResult {
  return result;
}
- (PBDescriptorProto_Builder*) clear {
  self.result = [[[PBDescriptorProto alloc] init] autorelease];
  return self;
}
- (PBDescriptorProto_Builder*) clone {
  return [PBDescriptorProto_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBDescriptorProto descriptor];
}
- (PBDescriptorProto*) defaultInstance {
  return [PBDescriptorProto defaultInstance];
}
- (PBDescriptorProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBDescriptorProto*) buildPartial {
  PBDescriptorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBDescriptorProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBDescriptorProto class]]) {
    return [self mergeFromPBDescriptorProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBDescriptorProto_Builder*) mergeFromPBDescriptorProto:(PBDescriptorProto*) other {
  if (other == [PBDescriptorProto defaultInstance]) return self;
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.mutableFieldList.count > 0) {
    if (result.mutableFieldList == nil) {
      result.mutableFieldList = [NSMutableArray array];
    }
    [result.mutableFieldList addObjectsFromArray:other.mutableFieldList];
  }
  if (other.mutableExtensionList.count > 0) {
    if (result.mutableExtensionList == nil) {
      result.mutableExtensionList = [NSMutableArray array];
    }
    [result.mutableExtensionList addObjectsFromArray:other.mutableExtensionList];
  }
  if (other.mutableNestedTypeList.count > 0) {
    if (result.mutableNestedTypeList == nil) {
      result.mutableNestedTypeList = [NSMutableArray array];
    }
    [result.mutableNestedTypeList addObjectsFromArray:other.mutableNestedTypeList];
  }
  if (other.mutableEnumTypeList.count > 0) {
    if (result.mutableEnumTypeList == nil) {
      result.mutableEnumTypeList = [NSMutableArray array];
    }
    [result.mutableEnumTypeList addObjectsFromArray:other.mutableEnumTypeList];
  }
  if (other.mutableExtensionRangeList.count > 0) {
    if (result.mutableExtensionRangeList == nil) {
      result.mutableExtensionRangeList = [NSMutableArray array];
    }
    [result.mutableExtensionRangeList addObjectsFromArray:other.mutableExtensionRangeList];
  }
  if (other.hasOptions) {
    [self mergeOptions:other.options];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setName:[input readString]];
        break;
      }
      case 18: {
        PBFieldDescriptorProto_Builder* subBuilder = [PBFieldDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addField:[subBuilder buildPartial]];
        break;
      }
      case 26: {
        PBDescriptorProto_Builder* subBuilder = [PBDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addNestedType:[subBuilder buildPartial]];
        break;
      }
      case 34: {
        PBEnumDescriptorProto_Builder* subBuilder = [PBEnumDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addEnumType:[subBuilder buildPartial]];
        break;
      }
      case 42: {
        PBDescriptorProto_ExtensionRange_Builder* subBuilder = [PBDescriptorProto_ExtensionRange_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addExtensionRange:[subBuilder buildPartial]];
        break;
      }
      case 50: {
        PBFieldDescriptorProto_Builder* subBuilder = [PBFieldDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addExtension:[subBuilder buildPartial]];
        break;
      }
      case 58: {
        PBMessageOptions_Builder* subBuilder = [PBMessageOptions_Builder builder];
        if (self.hasOptions) {
          [subBuilder mergeFromPBMessageOptions:self.options];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptions:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (PBDescriptorProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (PBDescriptorProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (NSArray*) fieldList {
  if (result.mutableFieldList == nil) { return [NSArray array]; }
  return result.mutableFieldList;
}
- (PBFieldDescriptorProto*) fieldAtIndex:(int32_t) index {
  return [result fieldAtIndex:index];
}
- (PBDescriptorProto_Builder*) replaceFieldAtIndex:(int32_t) index withField:(PBFieldDescriptorProto*) value {
  [result.mutableFieldList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBDescriptorProto_Builder*) addAllField:(NSArray*) values {
  if (result.mutableFieldList == nil) {
    result.mutableFieldList = [NSMutableArray array];
  }
  [result.mutableFieldList addObjectsFromArray:values];
  return self;
}
- (PBDescriptorProto_Builder*) clearFieldList {
  result.mutableFieldList = nil;
  return self;
}
- (PBDescriptorProto_Builder*) addField:(PBFieldDescriptorProto*) value {
  if (result.mutableFieldList == nil) {
    result.mutableFieldList = [NSMutableArray array];
  }
  [result.mutableFieldList addObject:value];
  return self;
}
- (NSArray*) extensionList {
  if (result.mutableExtensionList == nil) { return [NSArray array]; }
  return result.mutableExtensionList;
}
- (PBFieldDescriptorProto*) extensionAtIndex:(int32_t) index {
  return [result extensionAtIndex:index];
}
- (PBDescriptorProto_Builder*) replaceExtensionAtIndex:(int32_t) index withExtension:(PBFieldDescriptorProto*) value {
  [result.mutableExtensionList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBDescriptorProto_Builder*) addAllExtension:(NSArray*) values {
  if (result.mutableExtensionList == nil) {
    result.mutableExtensionList = [NSMutableArray array];
  }
  [result.mutableExtensionList addObjectsFromArray:values];
  return self;
}
- (PBDescriptorProto_Builder*) clearExtensionList {
  result.mutableExtensionList = nil;
  return self;
}
- (PBDescriptorProto_Builder*) addExtension:(PBFieldDescriptorProto*) value {
  if (result.mutableExtensionList == nil) {
    result.mutableExtensionList = [NSMutableArray array];
  }
  [result.mutableExtensionList addObject:value];
  return self;
}
- (NSArray*) nestedTypeList {
  if (result.mutableNestedTypeList == nil) { return [NSArray array]; }
  return result.mutableNestedTypeList;
}
- (PBDescriptorProto*) nestedTypeAtIndex:(int32_t) index {
  return [result nestedTypeAtIndex:index];
}
- (PBDescriptorProto_Builder*) replaceNestedTypeAtIndex:(int32_t) index withNestedType:(PBDescriptorProto*) value {
  [result.mutableNestedTypeList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBDescriptorProto_Builder*) addAllNestedType:(NSArray*) values {
  if (result.mutableNestedTypeList == nil) {
    result.mutableNestedTypeList = [NSMutableArray array];
  }
  [result.mutableNestedTypeList addObjectsFromArray:values];
  return self;
}
- (PBDescriptorProto_Builder*) clearNestedTypeList {
  result.mutableNestedTypeList = nil;
  return self;
}
- (PBDescriptorProto_Builder*) addNestedType:(PBDescriptorProto*) value {
  if (result.mutableNestedTypeList == nil) {
    result.mutableNestedTypeList = [NSMutableArray array];
  }
  [result.mutableNestedTypeList addObject:value];
  return self;
}
- (NSArray*) enumTypeList {
  if (result.mutableEnumTypeList == nil) { return [NSArray array]; }
  return result.mutableEnumTypeList;
}
- (PBEnumDescriptorProto*) enumTypeAtIndex:(int32_t) index {
  return [result enumTypeAtIndex:index];
}
- (PBDescriptorProto_Builder*) replaceEnumTypeAtIndex:(int32_t) index withEnumType:(PBEnumDescriptorProto*) value {
  [result.mutableEnumTypeList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBDescriptorProto_Builder*) addAllEnumType:(NSArray*) values {
  if (result.mutableEnumTypeList == nil) {
    result.mutableEnumTypeList = [NSMutableArray array];
  }
  [result.mutableEnumTypeList addObjectsFromArray:values];
  return self;
}
- (PBDescriptorProto_Builder*) clearEnumTypeList {
  result.mutableEnumTypeList = nil;
  return self;
}
- (PBDescriptorProto_Builder*) addEnumType:(PBEnumDescriptorProto*) value {
  if (result.mutableEnumTypeList == nil) {
    result.mutableEnumTypeList = [NSMutableArray array];
  }
  [result.mutableEnumTypeList addObject:value];
  return self;
}
- (NSArray*) extensionRangeList {
  if (result.mutableExtensionRangeList == nil) { return [NSArray array]; }
  return result.mutableExtensionRangeList;
}
- (PBDescriptorProto_ExtensionRange*) extensionRangeAtIndex:(int32_t) index {
  return [result extensionRangeAtIndex:index];
}
- (PBDescriptorProto_Builder*) replaceExtensionRangeAtIndex:(int32_t) index withExtensionRange:(PBDescriptorProto_ExtensionRange*) value {
  [result.mutableExtensionRangeList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBDescriptorProto_Builder*) addAllExtensionRange:(NSArray*) values {
  if (result.mutableExtensionRangeList == nil) {
    result.mutableExtensionRangeList = [NSMutableArray array];
  }
  [result.mutableExtensionRangeList addObjectsFromArray:values];
  return self;
}
- (PBDescriptorProto_Builder*) clearExtensionRangeList {
  result.mutableExtensionRangeList = nil;
  return self;
}
- (PBDescriptorProto_Builder*) addExtensionRange:(PBDescriptorProto_ExtensionRange*) value {
  if (result.mutableExtensionRangeList == nil) {
    result.mutableExtensionRangeList = [NSMutableArray array];
  }
  [result.mutableExtensionRangeList addObject:value];
  return self;
}
- (BOOL) hasOptions {
  return result.hasOptions;
}
- (PBMessageOptions*) options {
  return result.options;
}
- (PBDescriptorProto_Builder*) setOptions:(PBMessageOptions*) value {
  result.hasOptions = YES;
  result.options = value;
  return self;
}
- (PBDescriptorProto_Builder*) setOptionsBuilder:(PBMessageOptions_Builder*) builderForValue {
  return [self setOptions:[builderForValue build]];
}
- (PBDescriptorProto_Builder*) mergeOptions:(PBMessageOptions*) value {
  if (result.hasOptions &&
      result.options != [PBMessageOptions defaultInstance]) {
    result.options =
      [[[PBMessageOptions_Builder builderWithPrototype:result.options] mergeFromPBMessageOptions:value] buildPartial];
  } else {
    result.options = value;
  }
  result.hasOptions = YES;
  return self;
}
- (PBDescriptorProto_Builder*) clearOptions {
  result.hasOptions = NO;
  result.options = [PBMessageOptions defaultInstance];
  return self;
}
@end

@interface PBFieldDescriptorProto ()
@property BOOL hasName;
@property (retain) NSString* name;
@property BOOL hasNumber;
@property int32_t number;
@property BOOL hasLabel;
@property (retain) PBFieldDescriptorProto_Label* label;
@property BOOL hasType;
@property (retain) PBFieldDescriptorProto_Type* type;
@property BOOL hasTypeName;
@property (retain) NSString* typeName;
@property BOOL hasExtendee;
@property (retain) NSString* extendee;
@property BOOL hasDefaultValue;
@property (retain) NSString* defaultValue;
@property BOOL hasOptions;
@property (retain) PBFieldOptions* options;
@end

@implementation PBFieldDescriptorProto

@synthesize hasName;
@synthesize name;
@synthesize hasNumber;
@synthesize number;
@synthesize hasLabel;
@synthesize label;
@synthesize hasType;
@synthesize type;
@synthesize hasTypeName;
@synthesize typeName;
@synthesize hasExtendee;
@synthesize extendee;
@synthesize hasDefaultValue;
@synthesize defaultValue;
@synthesize hasOptions;
@synthesize options;
- (void) dealloc {
  self.hasName = NO;
  self.name = nil;
  self.hasNumber = NO;
  self.number = 0;
  self.hasLabel = NO;
  self.label = nil;
  self.hasType = NO;
  self.type = nil;
  self.hasTypeName = NO;
  self.typeName = nil;
  self.hasExtendee = NO;
  self.extendee = nil;
  self.hasDefaultValue = NO;
  self.defaultValue = nil;
  self.hasOptions = NO;
  self.options = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.name = @"";
    self.number = 0;
    self.label = [PBFieldDescriptorProto_Label LABEL_OPTIONAL];
    self.type = [PBFieldDescriptorProto_Type TYPE_DOUBLE];
    self.typeName = @"";
    self.extendee = @"";
    self.defaultValue = @"";
    self.options = [PBFieldOptions defaultInstance];
  }
  return self;
}
static PBFieldDescriptorProto* defaultPBFieldDescriptorProtoInstance = nil;
+ (void) initialize {
  if (self == [PBFieldDescriptorProto class]) {
    defaultPBFieldDescriptorProtoInstance = [[PBFieldDescriptorProto alloc] init];
  }
}
+ (PBFieldDescriptorProto*) defaultInstance {
  return defaultPBFieldDescriptorProtoInstance;
}
- (PBFieldDescriptorProto*) defaultInstance {
  return defaultPBFieldDescriptorProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [PBFieldDescriptorProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_FieldDescriptorProto_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_FieldDescriptorProto_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasName) {
    [output writeString:1 value:self.name];
  }
  if (hasExtendee) {
    [output writeString:2 value:self.extendee];
  }
  if (hasNumber) {
    [output writeInt32:3 value:self.number];
  }
  if (self.hasLabel) {
    [output writeEnum:4 value:self.label.number];
  }
  if (self.hasType) {
    [output writeEnum:5 value:self.type.number];
  }
  if (hasTypeName) {
    [output writeString:6 value:self.typeName];
  }
  if (hasDefaultValue) {
    [output writeString:7 value:self.defaultValue];
  }
  if (self.hasOptions) {
    [output writeMessage:8 value:self.options];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasName) {
    size += computeStringSize(1, self.name);
  }
  if (hasExtendee) {
    size += computeStringSize(2, self.extendee);
  }
  if (hasNumber) {
    size += computeInt32Size(3, self.number);
  }
  if (self.hasLabel) {
    size += computeEnumSize(4, self.label.number);
  }
  if (self.hasType) {
    size += computeEnumSize(5, self.type.number);
  }
  if (hasTypeName) {
    size += computeStringSize(6, self.typeName);
  }
  if (hasDefaultValue) {
    size += computeStringSize(7, self.defaultValue);
  }
  if (self.hasOptions) {
    size += computeMessageSize(8, self.options);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBFieldDescriptorProto*) parseFromData:(NSData*) data {
  return (PBFieldDescriptorProto*)[[[PBFieldDescriptorProto_Builder builder] mergeFromData:data] build];
}
+ (PBFieldDescriptorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFieldDescriptorProto*)[[[PBFieldDescriptorProto_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBFieldDescriptorProto*) parseFromInputStream:(NSInputStream*) input {
  return (PBFieldDescriptorProto*)[[[PBFieldDescriptorProto_Builder builder] mergeFromInputStream:input] build];
}
+ (PBFieldDescriptorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFieldDescriptorProto*)[[[PBFieldDescriptorProto_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBFieldDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBFieldDescriptorProto*)[[[PBFieldDescriptorProto_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBFieldDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFieldDescriptorProto*)[[[PBFieldDescriptorProto_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBFieldDescriptorProto_Builder*) createBuilder {
  return [PBFieldDescriptorProto_Builder builder];
}
@end

@interface PBFieldDescriptorProto_Type ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation PBFieldDescriptorProto_Type
@synthesize index;
@synthesize value;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_DOUBLE = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_FLOAT = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_INT64 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_UINT64 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_INT32 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_FIXED64 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_FIXED32 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_BOOL_ = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_STRING = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_GROUP = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_MESSAGE = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_BYTES = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_UINT32 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_ENUM = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_SFIXED32 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_SFIXED64 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_SINT32 = nil;
static PBFieldDescriptorProto_Type* PBFieldDescriptorProto_Type_TYPE_SINT64 = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (PBFieldDescriptorProto_Type*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[PBFieldDescriptorProto_Type alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [PBFieldDescriptorProto_Type class]) {
    PBFieldDescriptorProto_Type_TYPE_DOUBLE = [[PBFieldDescriptorProto_Type newWithIndex:0 value:1] retain];
    PBFieldDescriptorProto_Type_TYPE_FLOAT = [[PBFieldDescriptorProto_Type newWithIndex:1 value:2] retain];
    PBFieldDescriptorProto_Type_TYPE_INT64 = [[PBFieldDescriptorProto_Type newWithIndex:2 value:3] retain];
    PBFieldDescriptorProto_Type_TYPE_UINT64 = [[PBFieldDescriptorProto_Type newWithIndex:3 value:4] retain];
    PBFieldDescriptorProto_Type_TYPE_INT32 = [[PBFieldDescriptorProto_Type newWithIndex:4 value:5] retain];
    PBFieldDescriptorProto_Type_TYPE_FIXED64 = [[PBFieldDescriptorProto_Type newWithIndex:5 value:6] retain];
    PBFieldDescriptorProto_Type_TYPE_FIXED32 = [[PBFieldDescriptorProto_Type newWithIndex:6 value:7] retain];
    PBFieldDescriptorProto_Type_TYPE_BOOL_ = [[PBFieldDescriptorProto_Type newWithIndex:7 value:8] retain];
    PBFieldDescriptorProto_Type_TYPE_STRING = [[PBFieldDescriptorProto_Type newWithIndex:8 value:9] retain];
    PBFieldDescriptorProto_Type_TYPE_GROUP = [[PBFieldDescriptorProto_Type newWithIndex:9 value:10] retain];
    PBFieldDescriptorProto_Type_TYPE_MESSAGE = [[PBFieldDescriptorProto_Type newWithIndex:10 value:11] retain];
    PBFieldDescriptorProto_Type_TYPE_BYTES = [[PBFieldDescriptorProto_Type newWithIndex:11 value:12] retain];
    PBFieldDescriptorProto_Type_TYPE_UINT32 = [[PBFieldDescriptorProto_Type newWithIndex:12 value:13] retain];
    PBFieldDescriptorProto_Type_TYPE_ENUM = [[PBFieldDescriptorProto_Type newWithIndex:13 value:14] retain];
    PBFieldDescriptorProto_Type_TYPE_SFIXED32 = [[PBFieldDescriptorProto_Type newWithIndex:14 value:15] retain];
    PBFieldDescriptorProto_Type_TYPE_SFIXED64 = [[PBFieldDescriptorProto_Type newWithIndex:15 value:16] retain];
    PBFieldDescriptorProto_Type_TYPE_SINT32 = [[PBFieldDescriptorProto_Type newWithIndex:16 value:17] retain];
    PBFieldDescriptorProto_Type_TYPE_SINT64 = [[PBFieldDescriptorProto_Type newWithIndex:17 value:18] retain];
  }
}
+ (PBFieldDescriptorProto_Type*) TYPE_DOUBLE { return PBFieldDescriptorProto_Type_TYPE_DOUBLE; }
+ (PBFieldDescriptorProto_Type*) TYPE_FLOAT { return PBFieldDescriptorProto_Type_TYPE_FLOAT; }
+ (PBFieldDescriptorProto_Type*) TYPE_INT64 { return PBFieldDescriptorProto_Type_TYPE_INT64; }
+ (PBFieldDescriptorProto_Type*) TYPE_UINT64 { return PBFieldDescriptorProto_Type_TYPE_UINT64; }
+ (PBFieldDescriptorProto_Type*) TYPE_INT32 { return PBFieldDescriptorProto_Type_TYPE_INT32; }
+ (PBFieldDescriptorProto_Type*) TYPE_FIXED64 { return PBFieldDescriptorProto_Type_TYPE_FIXED64; }
+ (PBFieldDescriptorProto_Type*) TYPE_FIXED32 { return PBFieldDescriptorProto_Type_TYPE_FIXED32; }
+ (PBFieldDescriptorProto_Type*) TYPE_BOOL_ { return PBFieldDescriptorProto_Type_TYPE_BOOL_; }
+ (PBFieldDescriptorProto_Type*) TYPE_STRING { return PBFieldDescriptorProto_Type_TYPE_STRING; }
+ (PBFieldDescriptorProto_Type*) TYPE_GROUP { return PBFieldDescriptorProto_Type_TYPE_GROUP; }
+ (PBFieldDescriptorProto_Type*) TYPE_MESSAGE { return PBFieldDescriptorProto_Type_TYPE_MESSAGE; }
+ (PBFieldDescriptorProto_Type*) TYPE_BYTES { return PBFieldDescriptorProto_Type_TYPE_BYTES; }
+ (PBFieldDescriptorProto_Type*) TYPE_UINT32 { return PBFieldDescriptorProto_Type_TYPE_UINT32; }
+ (PBFieldDescriptorProto_Type*) TYPE_ENUM { return PBFieldDescriptorProto_Type_TYPE_ENUM; }
+ (PBFieldDescriptorProto_Type*) TYPE_SFIXED32 { return PBFieldDescriptorProto_Type_TYPE_SFIXED32; }
+ (PBFieldDescriptorProto_Type*) TYPE_SFIXED64 { return PBFieldDescriptorProto_Type_TYPE_SFIXED64; }
+ (PBFieldDescriptorProto_Type*) TYPE_SINT32 { return PBFieldDescriptorProto_Type_TYPE_SINT32; }
+ (PBFieldDescriptorProto_Type*) TYPE_SINT64 { return PBFieldDescriptorProto_Type_TYPE_SINT64; }
- (int32_t) number { return value; }
+ (PBFieldDescriptorProto_Type*) valueOf:(int32_t) value {
  switch (value) {
    case 1: return [PBFieldDescriptorProto_Type TYPE_DOUBLE];
    case 2: return [PBFieldDescriptorProto_Type TYPE_FLOAT];
    case 3: return [PBFieldDescriptorProto_Type TYPE_INT64];
    case 4: return [PBFieldDescriptorProto_Type TYPE_UINT64];
    case 5: return [PBFieldDescriptorProto_Type TYPE_INT32];
    case 6: return [PBFieldDescriptorProto_Type TYPE_FIXED64];
    case 7: return [PBFieldDescriptorProto_Type TYPE_FIXED32];
    case 8: return [PBFieldDescriptorProto_Type TYPE_BOOL_];
    case 9: return [PBFieldDescriptorProto_Type TYPE_STRING];
    case 10: return [PBFieldDescriptorProto_Type TYPE_GROUP];
    case 11: return [PBFieldDescriptorProto_Type TYPE_MESSAGE];
    case 12: return [PBFieldDescriptorProto_Type TYPE_BYTES];
    case 13: return [PBFieldDescriptorProto_Type TYPE_UINT32];
    case 14: return [PBFieldDescriptorProto_Type TYPE_ENUM];
    case 15: return [PBFieldDescriptorProto_Type TYPE_SFIXED32];
    case 16: return [PBFieldDescriptorProto_Type TYPE_SFIXED64];
    case 17: return [PBFieldDescriptorProto_Type TYPE_SINT32];
    case 18: return [PBFieldDescriptorProto_Type TYPE_SINT64];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[PBFieldDescriptorProto_Type descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [PBFieldDescriptorProto_Type descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[PBFieldDescriptorProto descriptor].enumTypes objectAtIndex:0];
}
+ (PBFieldDescriptorProto_Type*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [PBFieldDescriptorProto_Type descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  PBFieldDescriptorProto_Type* VALUES[] = {
    [PBFieldDescriptorProto_Type TYPE_DOUBLE],
    [PBFieldDescriptorProto_Type TYPE_FLOAT],
    [PBFieldDescriptorProto_Type TYPE_INT64],
    [PBFieldDescriptorProto_Type TYPE_UINT64],
    [PBFieldDescriptorProto_Type TYPE_INT32],
    [PBFieldDescriptorProto_Type TYPE_FIXED64],
    [PBFieldDescriptorProto_Type TYPE_FIXED32],
    [PBFieldDescriptorProto_Type TYPE_BOOL_],
    [PBFieldDescriptorProto_Type TYPE_STRING],
    [PBFieldDescriptorProto_Type TYPE_GROUP],
    [PBFieldDescriptorProto_Type TYPE_MESSAGE],
    [PBFieldDescriptorProto_Type TYPE_BYTES],
    [PBFieldDescriptorProto_Type TYPE_UINT32],
    [PBFieldDescriptorProto_Type TYPE_ENUM],
    [PBFieldDescriptorProto_Type TYPE_SFIXED32],
    [PBFieldDescriptorProto_Type TYPE_SFIXED64],
    [PBFieldDescriptorProto_Type TYPE_SINT32],
    [PBFieldDescriptorProto_Type TYPE_SINT64],
  };
  return VALUES[desc.index];
}
@end

@interface PBFieldDescriptorProto_Label ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation PBFieldDescriptorProto_Label
@synthesize index;
@synthesize value;
static PBFieldDescriptorProto_Label* PBFieldDescriptorProto_Label_LABEL_OPTIONAL = nil;
static PBFieldDescriptorProto_Label* PBFieldDescriptorProto_Label_LABEL_REQUIRED = nil;
static PBFieldDescriptorProto_Label* PBFieldDescriptorProto_Label_LABEL_REPEATED = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (PBFieldDescriptorProto_Label*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[PBFieldDescriptorProto_Label alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [PBFieldDescriptorProto_Label class]) {
    PBFieldDescriptorProto_Label_LABEL_OPTIONAL = [[PBFieldDescriptorProto_Label newWithIndex:0 value:1] retain];
    PBFieldDescriptorProto_Label_LABEL_REQUIRED = [[PBFieldDescriptorProto_Label newWithIndex:1 value:2] retain];
    PBFieldDescriptorProto_Label_LABEL_REPEATED = [[PBFieldDescriptorProto_Label newWithIndex:2 value:3] retain];
  }
}
+ (PBFieldDescriptorProto_Label*) LABEL_OPTIONAL { return PBFieldDescriptorProto_Label_LABEL_OPTIONAL; }
+ (PBFieldDescriptorProto_Label*) LABEL_REQUIRED { return PBFieldDescriptorProto_Label_LABEL_REQUIRED; }
+ (PBFieldDescriptorProto_Label*) LABEL_REPEATED { return PBFieldDescriptorProto_Label_LABEL_REPEATED; }
- (int32_t) number { return value; }
+ (PBFieldDescriptorProto_Label*) valueOf:(int32_t) value {
  switch (value) {
    case 1: return [PBFieldDescriptorProto_Label LABEL_OPTIONAL];
    case 2: return [PBFieldDescriptorProto_Label LABEL_REQUIRED];
    case 3: return [PBFieldDescriptorProto_Label LABEL_REPEATED];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[PBFieldDescriptorProto_Label descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [PBFieldDescriptorProto_Label descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[PBFieldDescriptorProto descriptor].enumTypes objectAtIndex:1];
}
+ (PBFieldDescriptorProto_Label*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [PBFieldDescriptorProto_Label descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  PBFieldDescriptorProto_Label* VALUES[] = {
    [PBFieldDescriptorProto_Label LABEL_OPTIONAL],
    [PBFieldDescriptorProto_Label LABEL_REQUIRED],
    [PBFieldDescriptorProto_Label LABEL_REPEATED],
  };
  return VALUES[desc.index];
}
@end

@implementation PBFieldDescriptorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBFieldDescriptorProto alloc] init] autorelease];
  }
  return self;
}
+ (PBFieldDescriptorProto_Builder*) builder {
  return [[[PBFieldDescriptorProto_Builder alloc] init] autorelease];
}
+ (PBFieldDescriptorProto_Builder*) builderWithPrototype:(PBFieldDescriptorProto*) prototype {
  return [[PBFieldDescriptorProto_Builder builder] mergeFromPBFieldDescriptorProto:prototype];
}
- (PBFieldDescriptorProto*) internalGetResult {
  return result;
}
- (PBFieldDescriptorProto_Builder*) clear {
  self.result = [[[PBFieldDescriptorProto alloc] init] autorelease];
  return self;
}
- (PBFieldDescriptorProto_Builder*) clone {
  return [PBFieldDescriptorProto_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBFieldDescriptorProto descriptor];
}
- (PBFieldDescriptorProto*) defaultInstance {
  return [PBFieldDescriptorProto defaultInstance];
}
- (PBFieldDescriptorProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBFieldDescriptorProto*) buildPartial {
  PBFieldDescriptorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBFieldDescriptorProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBFieldDescriptorProto class]]) {
    return [self mergeFromPBFieldDescriptorProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBFieldDescriptorProto_Builder*) mergeFromPBFieldDescriptorProto:(PBFieldDescriptorProto*) other {
  if (other == [PBFieldDescriptorProto defaultInstance]) return self;
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.hasNumber) {
    [self setNumber:other.number];
  }
  if (other.hasLabel) {
    [self setLabel:other.label];
  }
  if (other.hasType) {
    [self setType:other.type];
  }
  if (other.hasTypeName) {
    [self setTypeName:other.typeName];
  }
  if (other.hasExtendee) {
    [self setExtendee:other.extendee];
  }
  if (other.hasDefaultValue) {
    [self setDefaultValue:other.defaultValue];
  }
  if (other.hasOptions) {
    [self mergeOptions:other.options];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBFieldDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBFieldDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setName:[input readString]];
        break;
      }
      case 18: {
        [self setExtendee:[input readString]];
        break;
      }
      case 24: {
        [self setNumber:[input readInt32]];
        break;
      }
      case 32: {
        int32_t rawValue = [input readEnum];
        PBFieldDescriptorProto_Label* value = [PBFieldDescriptorProto_Label valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:4 value:rawValue];
        } else {
          [self setLabel:value];
        }
        break;
      }
      case 40: {
        int32_t rawValue = [input readEnum];
        PBFieldDescriptorProto_Type* value = [PBFieldDescriptorProto_Type valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:5 value:rawValue];
        } else {
          [self setType:value];
        }
        break;
      }
      case 50: {
        [self setTypeName:[input readString]];
        break;
      }
      case 58: {
        [self setDefaultValue:[input readString]];
        break;
      }
      case 66: {
        PBFieldOptions_Builder* subBuilder = [PBFieldOptions_Builder builder];
        if (self.hasOptions) {
          [subBuilder mergeFromPBFieldOptions:self.options];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptions:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (PBFieldDescriptorProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (BOOL) hasNumber {
  return result.hasNumber;
}
- (int32_t) number {
  return result.number;
}
- (PBFieldDescriptorProto_Builder*) setNumber:(int32_t) value {
  result.hasNumber = YES;
  result.number = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearNumber {
  result.hasNumber = NO;
  result.number = 0;
  return self;
}
- (BOOL) hasLabel {
  return result.hasLabel;
}
- (PBFieldDescriptorProto_Label*) label {
  return result.label;
}
- (PBFieldDescriptorProto_Builder*) setLabel:(PBFieldDescriptorProto_Label*) value {
  result.hasLabel = YES;
  result.label = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearLabel {
  result.hasLabel = NO;
  result.label = [PBFieldDescriptorProto_Label LABEL_OPTIONAL];
  return self;
}
- (BOOL) hasType {
  return result.hasType;
}
- (PBFieldDescriptorProto_Type*) type {
  return result.type;
}
- (PBFieldDescriptorProto_Builder*) setType:(PBFieldDescriptorProto_Type*) value {
  result.hasType = YES;
  result.type = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearType {
  result.hasType = NO;
  result.type = [PBFieldDescriptorProto_Type TYPE_DOUBLE];
  return self;
}
- (BOOL) hasTypeName {
  return result.hasTypeName;
}
- (NSString*) typeName {
  return result.typeName;
}
- (PBFieldDescriptorProto_Builder*) setTypeName:(NSString*) value {
  result.hasTypeName = YES;
  result.typeName = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearTypeName {
  result.hasTypeName = NO;
  result.typeName = @"";
  return self;
}
- (BOOL) hasExtendee {
  return result.hasExtendee;
}
- (NSString*) extendee {
  return result.extendee;
}
- (PBFieldDescriptorProto_Builder*) setExtendee:(NSString*) value {
  result.hasExtendee = YES;
  result.extendee = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearExtendee {
  result.hasExtendee = NO;
  result.extendee = @"";
  return self;
}
- (BOOL) hasDefaultValue {
  return result.hasDefaultValue;
}
- (NSString*) defaultValue {
  return result.defaultValue;
}
- (PBFieldDescriptorProto_Builder*) setDefaultValue:(NSString*) value {
  result.hasDefaultValue = YES;
  result.defaultValue = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearDefaultValue {
  result.hasDefaultValue = NO;
  result.defaultValue = @"";
  return self;
}
- (BOOL) hasOptions {
  return result.hasOptions;
}
- (PBFieldOptions*) options {
  return result.options;
}
- (PBFieldDescriptorProto_Builder*) setOptions:(PBFieldOptions*) value {
  result.hasOptions = YES;
  result.options = value;
  return self;
}
- (PBFieldDescriptorProto_Builder*) setOptionsBuilder:(PBFieldOptions_Builder*) builderForValue {
  return [self setOptions:[builderForValue build]];
}
- (PBFieldDescriptorProto_Builder*) mergeOptions:(PBFieldOptions*) value {
  if (result.hasOptions &&
      result.options != [PBFieldOptions defaultInstance]) {
    result.options =
      [[[PBFieldOptions_Builder builderWithPrototype:result.options] mergeFromPBFieldOptions:value] buildPartial];
  } else {
    result.options = value;
  }
  result.hasOptions = YES;
  return self;
}
- (PBFieldDescriptorProto_Builder*) clearOptions {
  result.hasOptions = NO;
  result.options = [PBFieldOptions defaultInstance];
  return self;
}
@end

@interface PBEnumDescriptorProto ()
@property BOOL hasName;
@property (retain) NSString* name;
@property (retain) NSMutableArray* mutableValueList;
@property BOOL hasOptions;
@property (retain) PBEnumOptions* options;
@end

@implementation PBEnumDescriptorProto

@synthesize hasName;
@synthesize name;
@synthesize mutableValueList;
@synthesize hasOptions;
@synthesize options;
- (void) dealloc {
  self.hasName = NO;
  self.name = nil;
  self.mutableValueList = nil;
  self.hasOptions = NO;
  self.options = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.name = @"";
    self.options = [PBEnumOptions defaultInstance];
  }
  return self;
}
static PBEnumDescriptorProto* defaultPBEnumDescriptorProtoInstance = nil;
+ (void) initialize {
  if (self == [PBEnumDescriptorProto class]) {
    defaultPBEnumDescriptorProtoInstance = [[PBEnumDescriptorProto alloc] init];
  }
}
+ (PBEnumDescriptorProto*) defaultInstance {
  return defaultPBEnumDescriptorProtoInstance;
}
- (PBEnumDescriptorProto*) defaultInstance {
  return defaultPBEnumDescriptorProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [PBEnumDescriptorProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumDescriptorProto_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumDescriptorProto_fieldAccessorTable];
}
- (NSArray*) valueList {
  return mutableValueList;
}
- (PBEnumValueDescriptorProto*) valueAtIndex:(int32_t) index {
  id value = [mutableValueList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasName) {
    [output writeString:1 value:self.name];
  }
  for (PBEnumValueDescriptorProto* element in self.valueList) {
    [output writeMessage:2 value:element];
  }
  if (self.hasOptions) {
    [output writeMessage:3 value:self.options];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasName) {
    size += computeStringSize(1, self.name);
  }
  for (PBEnumValueDescriptorProto* element in self.valueList) {
    size += computeMessageSize(2, element);
  }
  if (self.hasOptions) {
    size += computeMessageSize(3, self.options);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBEnumDescriptorProto*) parseFromData:(NSData*) data {
  return (PBEnumDescriptorProto*)[[[PBEnumDescriptorProto_Builder builder] mergeFromData:data] build];
}
+ (PBEnumDescriptorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumDescriptorProto*)[[[PBEnumDescriptorProto_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBEnumDescriptorProto*) parseFromInputStream:(NSInputStream*) input {
  return (PBEnumDescriptorProto*)[[[PBEnumDescriptorProto_Builder builder] mergeFromInputStream:input] build];
}
+ (PBEnumDescriptorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumDescriptorProto*)[[[PBEnumDescriptorProto_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBEnumDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBEnumDescriptorProto*)[[[PBEnumDescriptorProto_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBEnumDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumDescriptorProto*)[[[PBEnumDescriptorProto_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBEnumDescriptorProto_Builder*) createBuilder {
  return [PBEnumDescriptorProto_Builder builder];
}
@end

@implementation PBEnumDescriptorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBEnumDescriptorProto alloc] init] autorelease];
  }
  return self;
}
+ (PBEnumDescriptorProto_Builder*) builder {
  return [[[PBEnumDescriptorProto_Builder alloc] init] autorelease];
}
+ (PBEnumDescriptorProto_Builder*) builderWithPrototype:(PBEnumDescriptorProto*) prototype {
  return [[PBEnumDescriptorProto_Builder builder] mergeFromPBEnumDescriptorProto:prototype];
}
- (PBEnumDescriptorProto*) internalGetResult {
  return result;
}
- (PBEnumDescriptorProto_Builder*) clear {
  self.result = [[[PBEnumDescriptorProto alloc] init] autorelease];
  return self;
}
- (PBEnumDescriptorProto_Builder*) clone {
  return [PBEnumDescriptorProto_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBEnumDescriptorProto descriptor];
}
- (PBEnumDescriptorProto*) defaultInstance {
  return [PBEnumDescriptorProto defaultInstance];
}
- (PBEnumDescriptorProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBEnumDescriptorProto*) buildPartial {
  PBEnumDescriptorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBEnumDescriptorProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBEnumDescriptorProto class]]) {
    return [self mergeFromPBEnumDescriptorProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBEnumDescriptorProto_Builder*) mergeFromPBEnumDescriptorProto:(PBEnumDescriptorProto*) other {
  if (other == [PBEnumDescriptorProto defaultInstance]) return self;
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.mutableValueList.count > 0) {
    if (result.mutableValueList == nil) {
      result.mutableValueList = [NSMutableArray array];
    }
    [result.mutableValueList addObjectsFromArray:other.mutableValueList];
  }
  if (other.hasOptions) {
    [self mergeOptions:other.options];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBEnumDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBEnumDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setName:[input readString]];
        break;
      }
      case 18: {
        PBEnumValueDescriptorProto_Builder* subBuilder = [PBEnumValueDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addValue:[subBuilder buildPartial]];
        break;
      }
      case 26: {
        PBEnumOptions_Builder* subBuilder = [PBEnumOptions_Builder builder];
        if (self.hasOptions) {
          [subBuilder mergeFromPBEnumOptions:self.options];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptions:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (PBEnumDescriptorProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (PBEnumDescriptorProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (NSArray*) valueList {
  if (result.mutableValueList == nil) { return [NSArray array]; }
  return result.mutableValueList;
}
- (PBEnumValueDescriptorProto*) valueAtIndex:(int32_t) index {
  return [result valueAtIndex:index];
}
- (PBEnumDescriptorProto_Builder*) replaceValueAtIndex:(int32_t) index withValue:(PBEnumValueDescriptorProto*) value {
  [result.mutableValueList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBEnumDescriptorProto_Builder*) addAllValue:(NSArray*) values {
  if (result.mutableValueList == nil) {
    result.mutableValueList = [NSMutableArray array];
  }
  [result.mutableValueList addObjectsFromArray:values];
  return self;
}
- (PBEnumDescriptorProto_Builder*) clearValueList {
  result.mutableValueList = nil;
  return self;
}
- (PBEnumDescriptorProto_Builder*) addValue:(PBEnumValueDescriptorProto*) value {
  if (result.mutableValueList == nil) {
    result.mutableValueList = [NSMutableArray array];
  }
  [result.mutableValueList addObject:value];
  return self;
}
- (BOOL) hasOptions {
  return result.hasOptions;
}
- (PBEnumOptions*) options {
  return result.options;
}
- (PBEnumDescriptorProto_Builder*) setOptions:(PBEnumOptions*) value {
  result.hasOptions = YES;
  result.options = value;
  return self;
}
- (PBEnumDescriptorProto_Builder*) setOptionsBuilder:(PBEnumOptions_Builder*) builderForValue {
  return [self setOptions:[builderForValue build]];
}
- (PBEnumDescriptorProto_Builder*) mergeOptions:(PBEnumOptions*) value {
  if (result.hasOptions &&
      result.options != [PBEnumOptions defaultInstance]) {
    result.options =
      [[[PBEnumOptions_Builder builderWithPrototype:result.options] mergeFromPBEnumOptions:value] buildPartial];
  } else {
    result.options = value;
  }
  result.hasOptions = YES;
  return self;
}
- (PBEnumDescriptorProto_Builder*) clearOptions {
  result.hasOptions = NO;
  result.options = [PBEnumOptions defaultInstance];
  return self;
}
@end

@interface PBEnumValueDescriptorProto ()
@property BOOL hasName;
@property (retain) NSString* name;
@property BOOL hasNumber;
@property int32_t number;
@property BOOL hasOptions;
@property (retain) PBEnumValueOptions* options;
@end

@implementation PBEnumValueDescriptorProto

@synthesize hasName;
@synthesize name;
@synthesize hasNumber;
@synthesize number;
@synthesize hasOptions;
@synthesize options;
- (void) dealloc {
  self.hasName = NO;
  self.name = nil;
  self.hasNumber = NO;
  self.number = 0;
  self.hasOptions = NO;
  self.options = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.name = @"";
    self.number = 0;
    self.options = [PBEnumValueOptions defaultInstance];
  }
  return self;
}
static PBEnumValueDescriptorProto* defaultPBEnumValueDescriptorProtoInstance = nil;
+ (void) initialize {
  if (self == [PBEnumValueDescriptorProto class]) {
    defaultPBEnumValueDescriptorProtoInstance = [[PBEnumValueDescriptorProto alloc] init];
  }
}
+ (PBEnumValueDescriptorProto*) defaultInstance {
  return defaultPBEnumValueDescriptorProtoInstance;
}
- (PBEnumValueDescriptorProto*) defaultInstance {
  return defaultPBEnumValueDescriptorProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [PBEnumValueDescriptorProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumValueDescriptorProto_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumValueDescriptorProto_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasName) {
    [output writeString:1 value:self.name];
  }
  if (hasNumber) {
    [output writeInt32:2 value:self.number];
  }
  if (self.hasOptions) {
    [output writeMessage:3 value:self.options];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasName) {
    size += computeStringSize(1, self.name);
  }
  if (hasNumber) {
    size += computeInt32Size(2, self.number);
  }
  if (self.hasOptions) {
    size += computeMessageSize(3, self.options);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBEnumValueDescriptorProto*) parseFromData:(NSData*) data {
  return (PBEnumValueDescriptorProto*)[[[PBEnumValueDescriptorProto_Builder builder] mergeFromData:data] build];
}
+ (PBEnumValueDescriptorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumValueDescriptorProto*)[[[PBEnumValueDescriptorProto_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBEnumValueDescriptorProto*) parseFromInputStream:(NSInputStream*) input {
  return (PBEnumValueDescriptorProto*)[[[PBEnumValueDescriptorProto_Builder builder] mergeFromInputStream:input] build];
}
+ (PBEnumValueDescriptorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumValueDescriptorProto*)[[[PBEnumValueDescriptorProto_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBEnumValueDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBEnumValueDescriptorProto*)[[[PBEnumValueDescriptorProto_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBEnumValueDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumValueDescriptorProto*)[[[PBEnumValueDescriptorProto_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBEnumValueDescriptorProto_Builder*) createBuilder {
  return [PBEnumValueDescriptorProto_Builder builder];
}
@end

@implementation PBEnumValueDescriptorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBEnumValueDescriptorProto alloc] init] autorelease];
  }
  return self;
}
+ (PBEnumValueDescriptorProto_Builder*) builder {
  return [[[PBEnumValueDescriptorProto_Builder alloc] init] autorelease];
}
+ (PBEnumValueDescriptorProto_Builder*) builderWithPrototype:(PBEnumValueDescriptorProto*) prototype {
  return [[PBEnumValueDescriptorProto_Builder builder] mergeFromPBEnumValueDescriptorProto:prototype];
}
- (PBEnumValueDescriptorProto*) internalGetResult {
  return result;
}
- (PBEnumValueDescriptorProto_Builder*) clear {
  self.result = [[[PBEnumValueDescriptorProto alloc] init] autorelease];
  return self;
}
- (PBEnumValueDescriptorProto_Builder*) clone {
  return [PBEnumValueDescriptorProto_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBEnumValueDescriptorProto descriptor];
}
- (PBEnumValueDescriptorProto*) defaultInstance {
  return [PBEnumValueDescriptorProto defaultInstance];
}
- (PBEnumValueDescriptorProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBEnumValueDescriptorProto*) buildPartial {
  PBEnumValueDescriptorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBEnumValueDescriptorProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBEnumValueDescriptorProto class]]) {
    return [self mergeFromPBEnumValueDescriptorProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBEnumValueDescriptorProto_Builder*) mergeFromPBEnumValueDescriptorProto:(PBEnumValueDescriptorProto*) other {
  if (other == [PBEnumValueDescriptorProto defaultInstance]) return self;
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.hasNumber) {
    [self setNumber:other.number];
  }
  if (other.hasOptions) {
    [self mergeOptions:other.options];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBEnumValueDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBEnumValueDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setName:[input readString]];
        break;
      }
      case 16: {
        [self setNumber:[input readInt32]];
        break;
      }
      case 26: {
        PBEnumValueOptions_Builder* subBuilder = [PBEnumValueOptions_Builder builder];
        if (self.hasOptions) {
          [subBuilder mergeFromPBEnumValueOptions:self.options];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptions:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (PBEnumValueDescriptorProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (PBEnumValueDescriptorProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (BOOL) hasNumber {
  return result.hasNumber;
}
- (int32_t) number {
  return result.number;
}
- (PBEnumValueDescriptorProto_Builder*) setNumber:(int32_t) value {
  result.hasNumber = YES;
  result.number = value;
  return self;
}
- (PBEnumValueDescriptorProto_Builder*) clearNumber {
  result.hasNumber = NO;
  result.number = 0;
  return self;
}
- (BOOL) hasOptions {
  return result.hasOptions;
}
- (PBEnumValueOptions*) options {
  return result.options;
}
- (PBEnumValueDescriptorProto_Builder*) setOptions:(PBEnumValueOptions*) value {
  result.hasOptions = YES;
  result.options = value;
  return self;
}
- (PBEnumValueDescriptorProto_Builder*) setOptionsBuilder:(PBEnumValueOptions_Builder*) builderForValue {
  return [self setOptions:[builderForValue build]];
}
- (PBEnumValueDescriptorProto_Builder*) mergeOptions:(PBEnumValueOptions*) value {
  if (result.hasOptions &&
      result.options != [PBEnumValueOptions defaultInstance]) {
    result.options =
      [[[PBEnumValueOptions_Builder builderWithPrototype:result.options] mergeFromPBEnumValueOptions:value] buildPartial];
  } else {
    result.options = value;
  }
  result.hasOptions = YES;
  return self;
}
- (PBEnumValueDescriptorProto_Builder*) clearOptions {
  result.hasOptions = NO;
  result.options = [PBEnumValueOptions defaultInstance];
  return self;
}
@end

@interface PBServiceDescriptorProto ()
@property BOOL hasName;
@property (retain) NSString* name;
@property (retain) NSMutableArray* mutableMethodList;
@property BOOL hasOptions;
@property (retain) PBServiceOptions* options;
@end

@implementation PBServiceDescriptorProto

@synthesize hasName;
@synthesize name;
@synthesize mutableMethodList;
@synthesize hasOptions;
@synthesize options;
- (void) dealloc {
  self.hasName = NO;
  self.name = nil;
  self.mutableMethodList = nil;
  self.hasOptions = NO;
  self.options = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.name = @"";
    self.options = [PBServiceOptions defaultInstance];
  }
  return self;
}
static PBServiceDescriptorProto* defaultPBServiceDescriptorProtoInstance = nil;
+ (void) initialize {
  if (self == [PBServiceDescriptorProto class]) {
    defaultPBServiceDescriptorProtoInstance = [[PBServiceDescriptorProto alloc] init];
  }
}
+ (PBServiceDescriptorProto*) defaultInstance {
  return defaultPBServiceDescriptorProtoInstance;
}
- (PBServiceDescriptorProto*) defaultInstance {
  return defaultPBServiceDescriptorProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [PBServiceDescriptorProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_ServiceDescriptorProto_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_ServiceDescriptorProto_fieldAccessorTable];
}
- (NSArray*) methodList {
  return mutableMethodList;
}
- (PBMethodDescriptorProto*) methodAtIndex:(int32_t) index {
  id value = [mutableMethodList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasName) {
    [output writeString:1 value:self.name];
  }
  for (PBMethodDescriptorProto* element in self.methodList) {
    [output writeMessage:2 value:element];
  }
  if (self.hasOptions) {
    [output writeMessage:3 value:self.options];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasName) {
    size += computeStringSize(1, self.name);
  }
  for (PBMethodDescriptorProto* element in self.methodList) {
    size += computeMessageSize(2, element);
  }
  if (self.hasOptions) {
    size += computeMessageSize(3, self.options);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBServiceDescriptorProto*) parseFromData:(NSData*) data {
  return (PBServiceDescriptorProto*)[[[PBServiceDescriptorProto_Builder builder] mergeFromData:data] build];
}
+ (PBServiceDescriptorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBServiceDescriptorProto*)[[[PBServiceDescriptorProto_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBServiceDescriptorProto*) parseFromInputStream:(NSInputStream*) input {
  return (PBServiceDescriptorProto*)[[[PBServiceDescriptorProto_Builder builder] mergeFromInputStream:input] build];
}
+ (PBServiceDescriptorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBServiceDescriptorProto*)[[[PBServiceDescriptorProto_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBServiceDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBServiceDescriptorProto*)[[[PBServiceDescriptorProto_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBServiceDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBServiceDescriptorProto*)[[[PBServiceDescriptorProto_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBServiceDescriptorProto_Builder*) createBuilder {
  return [PBServiceDescriptorProto_Builder builder];
}
@end

@implementation PBServiceDescriptorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBServiceDescriptorProto alloc] init] autorelease];
  }
  return self;
}
+ (PBServiceDescriptorProto_Builder*) builder {
  return [[[PBServiceDescriptorProto_Builder alloc] init] autorelease];
}
+ (PBServiceDescriptorProto_Builder*) builderWithPrototype:(PBServiceDescriptorProto*) prototype {
  return [[PBServiceDescriptorProto_Builder builder] mergeFromPBServiceDescriptorProto:prototype];
}
- (PBServiceDescriptorProto*) internalGetResult {
  return result;
}
- (PBServiceDescriptorProto_Builder*) clear {
  self.result = [[[PBServiceDescriptorProto alloc] init] autorelease];
  return self;
}
- (PBServiceDescriptorProto_Builder*) clone {
  return [PBServiceDescriptorProto_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBServiceDescriptorProto descriptor];
}
- (PBServiceDescriptorProto*) defaultInstance {
  return [PBServiceDescriptorProto defaultInstance];
}
- (PBServiceDescriptorProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBServiceDescriptorProto*) buildPartial {
  PBServiceDescriptorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBServiceDescriptorProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBServiceDescriptorProto class]]) {
    return [self mergeFromPBServiceDescriptorProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBServiceDescriptorProto_Builder*) mergeFromPBServiceDescriptorProto:(PBServiceDescriptorProto*) other {
  if (other == [PBServiceDescriptorProto defaultInstance]) return self;
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.mutableMethodList.count > 0) {
    if (result.mutableMethodList == nil) {
      result.mutableMethodList = [NSMutableArray array];
    }
    [result.mutableMethodList addObjectsFromArray:other.mutableMethodList];
  }
  if (other.hasOptions) {
    [self mergeOptions:other.options];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBServiceDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBServiceDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setName:[input readString]];
        break;
      }
      case 18: {
        PBMethodDescriptorProto_Builder* subBuilder = [PBMethodDescriptorProto_Builder builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addMethod:[subBuilder buildPartial]];
        break;
      }
      case 26: {
        PBServiceOptions_Builder* subBuilder = [PBServiceOptions_Builder builder];
        if (self.hasOptions) {
          [subBuilder mergeFromPBServiceOptions:self.options];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptions:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (PBServiceDescriptorProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (PBServiceDescriptorProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (NSArray*) methodList {
  if (result.mutableMethodList == nil) { return [NSArray array]; }
  return result.mutableMethodList;
}
- (PBMethodDescriptorProto*) methodAtIndex:(int32_t) index {
  return [result methodAtIndex:index];
}
- (PBServiceDescriptorProto_Builder*) replaceMethodAtIndex:(int32_t) index withMethod:(PBMethodDescriptorProto*) value {
  [result.mutableMethodList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (PBServiceDescriptorProto_Builder*) addAllMethod:(NSArray*) values {
  if (result.mutableMethodList == nil) {
    result.mutableMethodList = [NSMutableArray array];
  }
  [result.mutableMethodList addObjectsFromArray:values];
  return self;
}
- (PBServiceDescriptorProto_Builder*) clearMethodList {
  result.mutableMethodList = nil;
  return self;
}
- (PBServiceDescriptorProto_Builder*) addMethod:(PBMethodDescriptorProto*) value {
  if (result.mutableMethodList == nil) {
    result.mutableMethodList = [NSMutableArray array];
  }
  [result.mutableMethodList addObject:value];
  return self;
}
- (BOOL) hasOptions {
  return result.hasOptions;
}
- (PBServiceOptions*) options {
  return result.options;
}
- (PBServiceDescriptorProto_Builder*) setOptions:(PBServiceOptions*) value {
  result.hasOptions = YES;
  result.options = value;
  return self;
}
- (PBServiceDescriptorProto_Builder*) setOptionsBuilder:(PBServiceOptions_Builder*) builderForValue {
  return [self setOptions:[builderForValue build]];
}
- (PBServiceDescriptorProto_Builder*) mergeOptions:(PBServiceOptions*) value {
  if (result.hasOptions &&
      result.options != [PBServiceOptions defaultInstance]) {
    result.options =
      [[[PBServiceOptions_Builder builderWithPrototype:result.options] mergeFromPBServiceOptions:value] buildPartial];
  } else {
    result.options = value;
  }
  result.hasOptions = YES;
  return self;
}
- (PBServiceDescriptorProto_Builder*) clearOptions {
  result.hasOptions = NO;
  result.options = [PBServiceOptions defaultInstance];
  return self;
}
@end

@interface PBMethodDescriptorProto ()
@property BOOL hasName;
@property (retain) NSString* name;
@property BOOL hasInputType;
@property (retain) NSString* inputType;
@property BOOL hasOutputType;
@property (retain) NSString* outputType;
@property BOOL hasOptions;
@property (retain) PBMethodOptions* options;
@end

@implementation PBMethodDescriptorProto

@synthesize hasName;
@synthesize name;
@synthesize hasInputType;
@synthesize inputType;
@synthesize hasOutputType;
@synthesize outputType;
@synthesize hasOptions;
@synthesize options;
- (void) dealloc {
  self.hasName = NO;
  self.name = nil;
  self.hasInputType = NO;
  self.inputType = nil;
  self.hasOutputType = NO;
  self.outputType = nil;
  self.hasOptions = NO;
  self.options = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.name = @"";
    self.inputType = @"";
    self.outputType = @"";
    self.options = [PBMethodOptions defaultInstance];
  }
  return self;
}
static PBMethodDescriptorProto* defaultPBMethodDescriptorProtoInstance = nil;
+ (void) initialize {
  if (self == [PBMethodDescriptorProto class]) {
    defaultPBMethodDescriptorProtoInstance = [[PBMethodDescriptorProto alloc] init];
  }
}
+ (PBMethodDescriptorProto*) defaultInstance {
  return defaultPBMethodDescriptorProtoInstance;
}
- (PBMethodDescriptorProto*) defaultInstance {
  return defaultPBMethodDescriptorProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [PBMethodDescriptorProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_MethodDescriptorProto_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_MethodDescriptorProto_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasName) {
    [output writeString:1 value:self.name];
  }
  if (hasInputType) {
    [output writeString:2 value:self.inputType];
  }
  if (hasOutputType) {
    [output writeString:3 value:self.outputType];
  }
  if (self.hasOptions) {
    [output writeMessage:4 value:self.options];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasName) {
    size += computeStringSize(1, self.name);
  }
  if (hasInputType) {
    size += computeStringSize(2, self.inputType);
  }
  if (hasOutputType) {
    size += computeStringSize(3, self.outputType);
  }
  if (self.hasOptions) {
    size += computeMessageSize(4, self.options);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBMethodDescriptorProto*) parseFromData:(NSData*) data {
  return (PBMethodDescriptorProto*)[[[PBMethodDescriptorProto_Builder builder] mergeFromData:data] build];
}
+ (PBMethodDescriptorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMethodDescriptorProto*)[[[PBMethodDescriptorProto_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBMethodDescriptorProto*) parseFromInputStream:(NSInputStream*) input {
  return (PBMethodDescriptorProto*)[[[PBMethodDescriptorProto_Builder builder] mergeFromInputStream:input] build];
}
+ (PBMethodDescriptorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMethodDescriptorProto*)[[[PBMethodDescriptorProto_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBMethodDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBMethodDescriptorProto*)[[[PBMethodDescriptorProto_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBMethodDescriptorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMethodDescriptorProto*)[[[PBMethodDescriptorProto_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBMethodDescriptorProto_Builder*) createBuilder {
  return [PBMethodDescriptorProto_Builder builder];
}
@end

@implementation PBMethodDescriptorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBMethodDescriptorProto alloc] init] autorelease];
  }
  return self;
}
+ (PBMethodDescriptorProto_Builder*) builder {
  return [[[PBMethodDescriptorProto_Builder alloc] init] autorelease];
}
+ (PBMethodDescriptorProto_Builder*) builderWithPrototype:(PBMethodDescriptorProto*) prototype {
  return [[PBMethodDescriptorProto_Builder builder] mergeFromPBMethodDescriptorProto:prototype];
}
- (PBMethodDescriptorProto*) internalGetResult {
  return result;
}
- (PBMethodDescriptorProto_Builder*) clear {
  self.result = [[[PBMethodDescriptorProto alloc] init] autorelease];
  return self;
}
- (PBMethodDescriptorProto_Builder*) clone {
  return [PBMethodDescriptorProto_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBMethodDescriptorProto descriptor];
}
- (PBMethodDescriptorProto*) defaultInstance {
  return [PBMethodDescriptorProto defaultInstance];
}
- (PBMethodDescriptorProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBMethodDescriptorProto*) buildPartial {
  PBMethodDescriptorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBMethodDescriptorProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBMethodDescriptorProto class]]) {
    return [self mergeFromPBMethodDescriptorProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBMethodDescriptorProto_Builder*) mergeFromPBMethodDescriptorProto:(PBMethodDescriptorProto*) other {
  if (other == [PBMethodDescriptorProto defaultInstance]) return self;
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.hasInputType) {
    [self setInputType:other.inputType];
  }
  if (other.hasOutputType) {
    [self setOutputType:other.outputType];
  }
  if (other.hasOptions) {
    [self mergeOptions:other.options];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBMethodDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBMethodDescriptorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setName:[input readString]];
        break;
      }
      case 18: {
        [self setInputType:[input readString]];
        break;
      }
      case 26: {
        [self setOutputType:[input readString]];
        break;
      }
      case 34: {
        PBMethodOptions_Builder* subBuilder = [PBMethodOptions_Builder builder];
        if (self.hasOptions) {
          [subBuilder mergeFromPBMethodOptions:self.options];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setOptions:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (PBMethodDescriptorProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (PBMethodDescriptorProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (BOOL) hasInputType {
  return result.hasInputType;
}
- (NSString*) inputType {
  return result.inputType;
}
- (PBMethodDescriptorProto_Builder*) setInputType:(NSString*) value {
  result.hasInputType = YES;
  result.inputType = value;
  return self;
}
- (PBMethodDescriptorProto_Builder*) clearInputType {
  result.hasInputType = NO;
  result.inputType = @"";
  return self;
}
- (BOOL) hasOutputType {
  return result.hasOutputType;
}
- (NSString*) outputType {
  return result.outputType;
}
- (PBMethodDescriptorProto_Builder*) setOutputType:(NSString*) value {
  result.hasOutputType = YES;
  result.outputType = value;
  return self;
}
- (PBMethodDescriptorProto_Builder*) clearOutputType {
  result.hasOutputType = NO;
  result.outputType = @"";
  return self;
}
- (BOOL) hasOptions {
  return result.hasOptions;
}
- (PBMethodOptions*) options {
  return result.options;
}
- (PBMethodDescriptorProto_Builder*) setOptions:(PBMethodOptions*) value {
  result.hasOptions = YES;
  result.options = value;
  return self;
}
- (PBMethodDescriptorProto_Builder*) setOptionsBuilder:(PBMethodOptions_Builder*) builderForValue {
  return [self setOptions:[builderForValue build]];
}
- (PBMethodDescriptorProto_Builder*) mergeOptions:(PBMethodOptions*) value {
  if (result.hasOptions &&
      result.options != [PBMethodOptions defaultInstance]) {
    result.options =
      [[[PBMethodOptions_Builder builderWithPrototype:result.options] mergeFromPBMethodOptions:value] buildPartial];
  } else {
    result.options = value;
  }
  result.hasOptions = YES;
  return self;
}
- (PBMethodDescriptorProto_Builder*) clearOptions {
  result.hasOptions = NO;
  result.options = [PBMethodOptions defaultInstance];
  return self;
}
@end

@interface PBFileOptions ()
@property BOOL hasJavaPackage;
@property (retain) NSString* javaPackage;
@property BOOL hasJavaOuterClassname;
@property (retain) NSString* javaOuterClassname;
@property BOOL hasJavaMultipleFiles;
@property BOOL javaMultipleFiles;
@property BOOL hasOptimizeFor;
@property (retain) PBFileOptions_OptimizeMode* optimizeFor;
@property BOOL hasObjectivecPackage;
@property (retain) NSString* objectivecPackage;
@property BOOL hasObjectivecClassPrefix;
@property (retain) NSString* objectivecClassPrefix;
@end

@implementation PBFileOptions

@synthesize hasJavaPackage;
@synthesize javaPackage;
@synthesize hasJavaOuterClassname;
@synthesize javaOuterClassname;
@synthesize hasJavaMultipleFiles;
@synthesize javaMultipleFiles;
@synthesize hasOptimizeFor;
@synthesize optimizeFor;
@synthesize hasObjectivecPackage;
@synthesize objectivecPackage;
@synthesize hasObjectivecClassPrefix;
@synthesize objectivecClassPrefix;
- (void) dealloc {
  self.hasJavaPackage = NO;
  self.javaPackage = nil;
  self.hasJavaOuterClassname = NO;
  self.javaOuterClassname = nil;
  self.hasJavaMultipleFiles = NO;
  self.javaMultipleFiles = 0;
  self.hasOptimizeFor = NO;
  self.optimizeFor = nil;
  self.hasObjectivecPackage = NO;
  self.objectivecPackage = nil;
  self.hasObjectivecClassPrefix = NO;
  self.objectivecClassPrefix = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.javaPackage = @"";
    self.javaOuterClassname = @"";
    self.javaMultipleFiles = NO;
    self.optimizeFor = [PBFileOptions_OptimizeMode CODE_SIZE];
    self.objectivecPackage = @"";
    self.objectivecClassPrefix = @"";
  }
  return self;
}
static PBFileOptions* defaultPBFileOptionsInstance = nil;
+ (void) initialize {
  if (self == [PBFileOptions class]) {
    defaultPBFileOptionsInstance = [[PBFileOptions alloc] init];
  }
}
+ (PBFileOptions*) defaultInstance {
  return defaultPBFileOptionsInstance;
}
- (PBFileOptions*) defaultInstance {
  return defaultPBFileOptionsInstance;
}
- (PBDescriptor*) descriptor {
  return [PBFileOptions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_FileOptions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_FileOptions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasJavaPackage) {
    [output writeString:1 value:self.javaPackage];
  }
  if (hasJavaOuterClassname) {
    [output writeString:8 value:self.javaOuterClassname];
  }
  if (self.hasOptimizeFor) {
    [output writeEnum:9 value:self.optimizeFor.number];
  }
  if (hasJavaMultipleFiles) {
    [output writeBool:10 value:self.javaMultipleFiles];
  }
  if (hasObjectivecPackage) {
    [output writeString:11 value:self.objectivecPackage];
  }
  if (hasObjectivecClassPrefix) {
    [output writeString:12 value:self.objectivecClassPrefix];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasJavaPackage) {
    size += computeStringSize(1, self.javaPackage);
  }
  if (hasJavaOuterClassname) {
    size += computeStringSize(8, self.javaOuterClassname);
  }
  if (self.hasOptimizeFor) {
    size += computeEnumSize(9, self.optimizeFor.number);
  }
  if (hasJavaMultipleFiles) {
    size += computeBoolSize(10, self.javaMultipleFiles);
  }
  if (hasObjectivecPackage) {
    size += computeStringSize(11, self.objectivecPackage);
  }
  if (hasObjectivecClassPrefix) {
    size += computeStringSize(12, self.objectivecClassPrefix);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBFileOptions*) parseFromData:(NSData*) data {
  return (PBFileOptions*)[[[PBFileOptions_Builder builder] mergeFromData:data] build];
}
+ (PBFileOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileOptions*)[[[PBFileOptions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBFileOptions*) parseFromInputStream:(NSInputStream*) input {
  return (PBFileOptions*)[[[PBFileOptions_Builder builder] mergeFromInputStream:input] build];
}
+ (PBFileOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileOptions*)[[[PBFileOptions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBFileOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBFileOptions*)[[[PBFileOptions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBFileOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFileOptions*)[[[PBFileOptions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBFileOptions_Builder*) createBuilder {
  return [PBFileOptions_Builder builder];
}
@end

@interface PBFileOptions_OptimizeMode ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation PBFileOptions_OptimizeMode
@synthesize index;
@synthesize value;
static PBFileOptions_OptimizeMode* PBFileOptions_OptimizeMode_SPEED = nil;
static PBFileOptions_OptimizeMode* PBFileOptions_OptimizeMode_CODE_SIZE = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (PBFileOptions_OptimizeMode*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[PBFileOptions_OptimizeMode alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [PBFileOptions_OptimizeMode class]) {
    PBFileOptions_OptimizeMode_SPEED = [[PBFileOptions_OptimizeMode newWithIndex:0 value:1] retain];
    PBFileOptions_OptimizeMode_CODE_SIZE = [[PBFileOptions_OptimizeMode newWithIndex:1 value:2] retain];
  }
}
+ (PBFileOptions_OptimizeMode*) SPEED { return PBFileOptions_OptimizeMode_SPEED; }
+ (PBFileOptions_OptimizeMode*) CODE_SIZE { return PBFileOptions_OptimizeMode_CODE_SIZE; }
- (int32_t) number { return value; }
+ (PBFileOptions_OptimizeMode*) valueOf:(int32_t) value {
  switch (value) {
    case 1: return [PBFileOptions_OptimizeMode SPEED];
    case 2: return [PBFileOptions_OptimizeMode CODE_SIZE];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[PBFileOptions_OptimizeMode descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [PBFileOptions_OptimizeMode descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[PBFileOptions descriptor].enumTypes objectAtIndex:0];
}
+ (PBFileOptions_OptimizeMode*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [PBFileOptions_OptimizeMode descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  PBFileOptions_OptimizeMode* VALUES[] = {
    [PBFileOptions_OptimizeMode SPEED],
    [PBFileOptions_OptimizeMode CODE_SIZE],
  };
  return VALUES[desc.index];
}
@end

@implementation PBFileOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBFileOptions alloc] init] autorelease];
  }
  return self;
}
+ (PBFileOptions_Builder*) builder {
  return [[[PBFileOptions_Builder alloc] init] autorelease];
}
+ (PBFileOptions_Builder*) builderWithPrototype:(PBFileOptions*) prototype {
  return [[PBFileOptions_Builder builder] mergeFromPBFileOptions:prototype];
}
- (PBFileOptions*) internalGetResult {
  return result;
}
- (PBFileOptions_Builder*) clear {
  self.result = [[[PBFileOptions alloc] init] autorelease];
  return self;
}
- (PBFileOptions_Builder*) clone {
  return [PBFileOptions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBFileOptions descriptor];
}
- (PBFileOptions*) defaultInstance {
  return [PBFileOptions defaultInstance];
}
- (PBFileOptions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBFileOptions*) buildPartial {
  PBFileOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBFileOptions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBFileOptions class]]) {
    return [self mergeFromPBFileOptions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBFileOptions_Builder*) mergeFromPBFileOptions:(PBFileOptions*) other {
  if (other == [PBFileOptions defaultInstance]) return self;
  if (other.hasJavaPackage) {
    [self setJavaPackage:other.javaPackage];
  }
  if (other.hasJavaOuterClassname) {
    [self setJavaOuterClassname:other.javaOuterClassname];
  }
  if (other.hasJavaMultipleFiles) {
    [self setJavaMultipleFiles:other.javaMultipleFiles];
  }
  if (other.hasOptimizeFor) {
    [self setOptimizeFor:other.optimizeFor];
  }
  if (other.hasObjectivecPackage) {
    [self setObjectivecPackage:other.objectivecPackage];
  }
  if (other.hasObjectivecClassPrefix) {
    [self setObjectivecClassPrefix:other.objectivecClassPrefix];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBFileOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBFileOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setJavaPackage:[input readString]];
        break;
      }
      case 66: {
        [self setJavaOuterClassname:[input readString]];
        break;
      }
      case 72: {
        int32_t rawValue = [input readEnum];
        PBFileOptions_OptimizeMode* value = [PBFileOptions_OptimizeMode valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:9 value:rawValue];
        } else {
          [self setOptimizeFor:value];
        }
        break;
      }
      case 80: {
        [self setJavaMultipleFiles:[input readBool]];
        break;
      }
      case 90: {
        [self setObjectivecPackage:[input readString]];
        break;
      }
      case 98: {
        [self setObjectivecClassPrefix:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasJavaPackage {
  return result.hasJavaPackage;
}
- (NSString*) javaPackage {
  return result.javaPackage;
}
- (PBFileOptions_Builder*) setJavaPackage:(NSString*) value {
  result.hasJavaPackage = YES;
  result.javaPackage = value;
  return self;
}
- (PBFileOptions_Builder*) clearJavaPackage {
  result.hasJavaPackage = NO;
  result.javaPackage = @"";
  return self;
}
- (BOOL) hasJavaOuterClassname {
  return result.hasJavaOuterClassname;
}
- (NSString*) javaOuterClassname {
  return result.javaOuterClassname;
}
- (PBFileOptions_Builder*) setJavaOuterClassname:(NSString*) value {
  result.hasJavaOuterClassname = YES;
  result.javaOuterClassname = value;
  return self;
}
- (PBFileOptions_Builder*) clearJavaOuterClassname {
  result.hasJavaOuterClassname = NO;
  result.javaOuterClassname = @"";
  return self;
}
- (BOOL) hasJavaMultipleFiles {
  return result.hasJavaMultipleFiles;
}
- (BOOL) javaMultipleFiles {
  return result.javaMultipleFiles;
}
- (PBFileOptions_Builder*) setJavaMultipleFiles:(BOOL) value {
  result.hasJavaMultipleFiles = YES;
  result.javaMultipleFiles = value;
  return self;
}
- (PBFileOptions_Builder*) clearJavaMultipleFiles {
  result.hasJavaMultipleFiles = NO;
  result.javaMultipleFiles = NO;
  return self;
}
- (BOOL) hasOptimizeFor {
  return result.hasOptimizeFor;
}
- (PBFileOptions_OptimizeMode*) optimizeFor {
  return result.optimizeFor;
}
- (PBFileOptions_Builder*) setOptimizeFor:(PBFileOptions_OptimizeMode*) value {
  result.hasOptimizeFor = YES;
  result.optimizeFor = value;
  return self;
}
- (PBFileOptions_Builder*) clearOptimizeFor {
  result.hasOptimizeFor = NO;
  result.optimizeFor = [PBFileOptions_OptimizeMode CODE_SIZE];
  return self;
}
- (BOOL) hasObjectivecPackage {
  return result.hasObjectivecPackage;
}
- (NSString*) objectivecPackage {
  return result.objectivecPackage;
}
- (PBFileOptions_Builder*) setObjectivecPackage:(NSString*) value {
  result.hasObjectivecPackage = YES;
  result.objectivecPackage = value;
  return self;
}
- (PBFileOptions_Builder*) clearObjectivecPackage {
  result.hasObjectivecPackage = NO;
  result.objectivecPackage = @"";
  return self;
}
- (BOOL) hasObjectivecClassPrefix {
  return result.hasObjectivecClassPrefix;
}
- (NSString*) objectivecClassPrefix {
  return result.objectivecClassPrefix;
}
- (PBFileOptions_Builder*) setObjectivecClassPrefix:(NSString*) value {
  result.hasObjectivecClassPrefix = YES;
  result.objectivecClassPrefix = value;
  return self;
}
- (PBFileOptions_Builder*) clearObjectivecClassPrefix {
  result.hasObjectivecClassPrefix = NO;
  result.objectivecClassPrefix = @"";
  return self;
}
@end

@interface PBMessageOptions ()
@property BOOL hasMessageSetWireFormat;
@property BOOL messageSetWireFormat;
@end

@implementation PBMessageOptions

@synthesize hasMessageSetWireFormat;
@synthesize messageSetWireFormat;
- (void) dealloc {
  self.hasMessageSetWireFormat = NO;
  self.messageSetWireFormat = 0;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.messageSetWireFormat = NO;
  }
  return self;
}
static PBMessageOptions* defaultPBMessageOptionsInstance = nil;
+ (void) initialize {
  if (self == [PBMessageOptions class]) {
    defaultPBMessageOptionsInstance = [[PBMessageOptions alloc] init];
  }
}
+ (PBMessageOptions*) defaultInstance {
  return defaultPBMessageOptionsInstance;
}
- (PBMessageOptions*) defaultInstance {
  return defaultPBMessageOptionsInstance;
}
- (PBDescriptor*) descriptor {
  return [PBMessageOptions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_MessageOptions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_MessageOptions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasMessageSetWireFormat) {
    [output writeBool:1 value:self.messageSetWireFormat];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (hasMessageSetWireFormat) {
    size += computeBoolSize(1, self.messageSetWireFormat);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBMessageOptions*) parseFromData:(NSData*) data {
  return (PBMessageOptions*)[[[PBMessageOptions_Builder builder] mergeFromData:data] build];
}
+ (PBMessageOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMessageOptions*)[[[PBMessageOptions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBMessageOptions*) parseFromInputStream:(NSInputStream*) input {
  return (PBMessageOptions*)[[[PBMessageOptions_Builder builder] mergeFromInputStream:input] build];
}
+ (PBMessageOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMessageOptions*)[[[PBMessageOptions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBMessageOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBMessageOptions*)[[[PBMessageOptions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBMessageOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMessageOptions*)[[[PBMessageOptions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBMessageOptions_Builder*) createBuilder {
  return [PBMessageOptions_Builder builder];
}
@end

@implementation PBMessageOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBMessageOptions alloc] init] autorelease];
  }
  return self;
}
+ (PBMessageOptions_Builder*) builder {
  return [[[PBMessageOptions_Builder alloc] init] autorelease];
}
+ (PBMessageOptions_Builder*) builderWithPrototype:(PBMessageOptions*) prototype {
  return [[PBMessageOptions_Builder builder] mergeFromPBMessageOptions:prototype];
}
- (PBMessageOptions*) internalGetResult {
  return result;
}
- (PBMessageOptions_Builder*) clear {
  self.result = [[[PBMessageOptions alloc] init] autorelease];
  return self;
}
- (PBMessageOptions_Builder*) clone {
  return [PBMessageOptions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBMessageOptions descriptor];
}
- (PBMessageOptions*) defaultInstance {
  return [PBMessageOptions defaultInstance];
}
- (PBMessageOptions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBMessageOptions*) buildPartial {
  PBMessageOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBMessageOptions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBMessageOptions class]]) {
    return [self mergeFromPBMessageOptions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBMessageOptions_Builder*) mergeFromPBMessageOptions:(PBMessageOptions*) other {
  if (other == [PBMessageOptions defaultInstance]) return self;
  if (other.hasMessageSetWireFormat) {
    [self setMessageSetWireFormat:other.messageSetWireFormat];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBMessageOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBMessageOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setMessageSetWireFormat:[input readBool]];
        break;
      }
    }
  }
}
- (BOOL) hasMessageSetWireFormat {
  return result.hasMessageSetWireFormat;
}
- (BOOL) messageSetWireFormat {
  return result.messageSetWireFormat;
}
- (PBMessageOptions_Builder*) setMessageSetWireFormat:(BOOL) value {
  result.hasMessageSetWireFormat = YES;
  result.messageSetWireFormat = value;
  return self;
}
- (PBMessageOptions_Builder*) clearMessageSetWireFormat {
  result.hasMessageSetWireFormat = NO;
  result.messageSetWireFormat = NO;
  return self;
}
@end

@interface PBFieldOptions ()
@property BOOL hasCtype;
@property (retain) PBFieldOptions_CType* ctype;
@property BOOL hasExperimentalMapKey;
@property (retain) NSString* experimentalMapKey;
@end

@implementation PBFieldOptions

@synthesize hasCtype;
@synthesize ctype;
@synthesize hasExperimentalMapKey;
@synthesize experimentalMapKey;
- (void) dealloc {
  self.hasCtype = NO;
  self.ctype = nil;
  self.hasExperimentalMapKey = NO;
  self.experimentalMapKey = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.ctype = [PBFieldOptions_CType CORD];
    self.experimentalMapKey = @"";
  }
  return self;
}
static PBFieldOptions* defaultPBFieldOptionsInstance = nil;
+ (void) initialize {
  if (self == [PBFieldOptions class]) {
    defaultPBFieldOptionsInstance = [[PBFieldOptions alloc] init];
  }
}
+ (PBFieldOptions*) defaultInstance {
  return defaultPBFieldOptionsInstance;
}
- (PBFieldOptions*) defaultInstance {
  return defaultPBFieldOptionsInstance;
}
- (PBDescriptor*) descriptor {
  return [PBFieldOptions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_FieldOptions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_FieldOptions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasCtype) {
    [output writeEnum:1 value:self.ctype.number];
  }
  if (hasExperimentalMapKey) {
    [output writeString:9 value:self.experimentalMapKey];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  if (self.hasCtype) {
    size += computeEnumSize(1, self.ctype.number);
  }
  if (hasExperimentalMapKey) {
    size += computeStringSize(9, self.experimentalMapKey);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBFieldOptions*) parseFromData:(NSData*) data {
  return (PBFieldOptions*)[[[PBFieldOptions_Builder builder] mergeFromData:data] build];
}
+ (PBFieldOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFieldOptions*)[[[PBFieldOptions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBFieldOptions*) parseFromInputStream:(NSInputStream*) input {
  return (PBFieldOptions*)[[[PBFieldOptions_Builder builder] mergeFromInputStream:input] build];
}
+ (PBFieldOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFieldOptions*)[[[PBFieldOptions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBFieldOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBFieldOptions*)[[[PBFieldOptions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBFieldOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBFieldOptions*)[[[PBFieldOptions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBFieldOptions_Builder*) createBuilder {
  return [PBFieldOptions_Builder builder];
}
@end

@interface PBFieldOptions_CType ()
  @property int32_t index;
  @property int32_t value;
@end

@implementation PBFieldOptions_CType
@synthesize index;
@synthesize value;
static PBFieldOptions_CType* PBFieldOptions_CType_CORD = nil;
static PBFieldOptions_CType* PBFieldOptions_CType_STRING_PIECE = nil;
- (id) initWithIndex:(int32_t) index_ value:(int32_t) value_ {
  if (self = [super init]) {
    self.index = index_;
    self.value = value_;
  }
  return self;
}
+ (PBFieldOptions_CType*) newWithIndex:(int32_t) index value:(int32_t) value {
  return [[[PBFieldOptions_CType alloc] initWithIndex:index value:value] autorelease];
}
+ (void) initialize {
  if (self == [PBFieldOptions_CType class]) {
    PBFieldOptions_CType_CORD = [[PBFieldOptions_CType newWithIndex:0 value:1] retain];
    PBFieldOptions_CType_STRING_PIECE = [[PBFieldOptions_CType newWithIndex:1 value:2] retain];
  }
}
+ (PBFieldOptions_CType*) CORD { return PBFieldOptions_CType_CORD; }
+ (PBFieldOptions_CType*) STRING_PIECE { return PBFieldOptions_CType_STRING_PIECE; }
- (int32_t) number { return value; }
+ (PBFieldOptions_CType*) valueOf:(int32_t) value {
  switch (value) {
    case 1: return [PBFieldOptions_CType CORD];
    case 2: return [PBFieldOptions_CType STRING_PIECE];
    default: return nil;
  }
}
- (PBEnumValueDescriptor*) valueDescriptor {
  return [[PBFieldOptions_CType descriptor].values objectAtIndex:index];
}
- (PBEnumDescriptor*) descriptor {
  return [PBFieldOptions_CType descriptor];
}
+ (PBEnumDescriptor*) descriptor {
  return [[PBFieldOptions descriptor].enumTypes objectAtIndex:0];
}
+ (PBFieldOptions_CType*) valueOfDescriptor:(PBEnumValueDescriptor*) desc {
  if (desc.type != [PBFieldOptions_CType descriptor]) {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
  }
  PBFieldOptions_CType* VALUES[] = {
    [PBFieldOptions_CType CORD],
    [PBFieldOptions_CType STRING_PIECE],
  };
  return VALUES[desc.index];
}
@end

@implementation PBFieldOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBFieldOptions alloc] init] autorelease];
  }
  return self;
}
+ (PBFieldOptions_Builder*) builder {
  return [[[PBFieldOptions_Builder alloc] init] autorelease];
}
+ (PBFieldOptions_Builder*) builderWithPrototype:(PBFieldOptions*) prototype {
  return [[PBFieldOptions_Builder builder] mergeFromPBFieldOptions:prototype];
}
- (PBFieldOptions*) internalGetResult {
  return result;
}
- (PBFieldOptions_Builder*) clear {
  self.result = [[[PBFieldOptions alloc] init] autorelease];
  return self;
}
- (PBFieldOptions_Builder*) clone {
  return [PBFieldOptions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBFieldOptions descriptor];
}
- (PBFieldOptions*) defaultInstance {
  return [PBFieldOptions defaultInstance];
}
- (PBFieldOptions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBFieldOptions*) buildPartial {
  PBFieldOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBFieldOptions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBFieldOptions class]]) {
    return [self mergeFromPBFieldOptions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBFieldOptions_Builder*) mergeFromPBFieldOptions:(PBFieldOptions*) other {
  if (other == [PBFieldOptions defaultInstance]) return self;
  if (other.hasCtype) {
    [self setCtype:other.ctype];
  }
  if (other.hasExperimentalMapKey) {
    [self setExperimentalMapKey:other.experimentalMapKey];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBFieldOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBFieldOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        int32_t rawValue = [input readEnum];
        PBFieldOptions_CType* value = [PBFieldOptions_CType valueOf:rawValue];
        if (value == nil) {
          [unknownFields mergeVarintField:1 value:rawValue];
        } else {
          [self setCtype:value];
        }
        break;
      }
      case 74: {
        [self setExperimentalMapKey:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasCtype {
  return result.hasCtype;
}
- (PBFieldOptions_CType*) ctype {
  return result.ctype;
}
- (PBFieldOptions_Builder*) setCtype:(PBFieldOptions_CType*) value {
  result.hasCtype = YES;
  result.ctype = value;
  return self;
}
- (PBFieldOptions_Builder*) clearCtype {
  result.hasCtype = NO;
  result.ctype = [PBFieldOptions_CType CORD];
  return self;
}
- (BOOL) hasExperimentalMapKey {
  return result.hasExperimentalMapKey;
}
- (NSString*) experimentalMapKey {
  return result.experimentalMapKey;
}
- (PBFieldOptions_Builder*) setExperimentalMapKey:(NSString*) value {
  result.hasExperimentalMapKey = YES;
  result.experimentalMapKey = value;
  return self;
}
- (PBFieldOptions_Builder*) clearExperimentalMapKey {
  result.hasExperimentalMapKey = NO;
  result.experimentalMapKey = @"";
  return self;
}
@end

@interface PBEnumOptions ()
@end

@implementation PBEnumOptions

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static PBEnumOptions* defaultPBEnumOptionsInstance = nil;
+ (void) initialize {
  if (self == [PBEnumOptions class]) {
    defaultPBEnumOptionsInstance = [[PBEnumOptions alloc] init];
  }
}
+ (PBEnumOptions*) defaultInstance {
  return defaultPBEnumOptionsInstance;
}
- (PBEnumOptions*) defaultInstance {
  return defaultPBEnumOptionsInstance;
}
- (PBDescriptor*) descriptor {
  return [PBEnumOptions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumOptions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumOptions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBEnumOptions*) parseFromData:(NSData*) data {
  return (PBEnumOptions*)[[[PBEnumOptions_Builder builder] mergeFromData:data] build];
}
+ (PBEnumOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumOptions*)[[[PBEnumOptions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBEnumOptions*) parseFromInputStream:(NSInputStream*) input {
  return (PBEnumOptions*)[[[PBEnumOptions_Builder builder] mergeFromInputStream:input] build];
}
+ (PBEnumOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumOptions*)[[[PBEnumOptions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBEnumOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBEnumOptions*)[[[PBEnumOptions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBEnumOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumOptions*)[[[PBEnumOptions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBEnumOptions_Builder*) createBuilder {
  return [PBEnumOptions_Builder builder];
}
@end

@implementation PBEnumOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBEnumOptions alloc] init] autorelease];
  }
  return self;
}
+ (PBEnumOptions_Builder*) builder {
  return [[[PBEnumOptions_Builder alloc] init] autorelease];
}
+ (PBEnumOptions_Builder*) builderWithPrototype:(PBEnumOptions*) prototype {
  return [[PBEnumOptions_Builder builder] mergeFromPBEnumOptions:prototype];
}
- (PBEnumOptions*) internalGetResult {
  return result;
}
- (PBEnumOptions_Builder*) clear {
  self.result = [[[PBEnumOptions alloc] init] autorelease];
  return self;
}
- (PBEnumOptions_Builder*) clone {
  return [PBEnumOptions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBEnumOptions descriptor];
}
- (PBEnumOptions*) defaultInstance {
  return [PBEnumOptions defaultInstance];
}
- (PBEnumOptions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBEnumOptions*) buildPartial {
  PBEnumOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBEnumOptions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBEnumOptions class]]) {
    return [self mergeFromPBEnumOptions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBEnumOptions_Builder*) mergeFromPBEnumOptions:(PBEnumOptions*) other {
  if (other == [PBEnumOptions defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBEnumOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBEnumOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface PBEnumValueOptions ()
@end

@implementation PBEnumValueOptions

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static PBEnumValueOptions* defaultPBEnumValueOptionsInstance = nil;
+ (void) initialize {
  if (self == [PBEnumValueOptions class]) {
    defaultPBEnumValueOptionsInstance = [[PBEnumValueOptions alloc] init];
  }
}
+ (PBEnumValueOptions*) defaultInstance {
  return defaultPBEnumValueOptionsInstance;
}
- (PBEnumValueOptions*) defaultInstance {
  return defaultPBEnumValueOptionsInstance;
}
- (PBDescriptor*) descriptor {
  return [PBEnumValueOptions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumValueOptions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_EnumValueOptions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBEnumValueOptions*) parseFromData:(NSData*) data {
  return (PBEnumValueOptions*)[[[PBEnumValueOptions_Builder builder] mergeFromData:data] build];
}
+ (PBEnumValueOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumValueOptions*)[[[PBEnumValueOptions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBEnumValueOptions*) parseFromInputStream:(NSInputStream*) input {
  return (PBEnumValueOptions*)[[[PBEnumValueOptions_Builder builder] mergeFromInputStream:input] build];
}
+ (PBEnumValueOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumValueOptions*)[[[PBEnumValueOptions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBEnumValueOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBEnumValueOptions*)[[[PBEnumValueOptions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBEnumValueOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBEnumValueOptions*)[[[PBEnumValueOptions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBEnumValueOptions_Builder*) createBuilder {
  return [PBEnumValueOptions_Builder builder];
}
@end

@implementation PBEnumValueOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBEnumValueOptions alloc] init] autorelease];
  }
  return self;
}
+ (PBEnumValueOptions_Builder*) builder {
  return [[[PBEnumValueOptions_Builder alloc] init] autorelease];
}
+ (PBEnumValueOptions_Builder*) builderWithPrototype:(PBEnumValueOptions*) prototype {
  return [[PBEnumValueOptions_Builder builder] mergeFromPBEnumValueOptions:prototype];
}
- (PBEnumValueOptions*) internalGetResult {
  return result;
}
- (PBEnumValueOptions_Builder*) clear {
  self.result = [[[PBEnumValueOptions alloc] init] autorelease];
  return self;
}
- (PBEnumValueOptions_Builder*) clone {
  return [PBEnumValueOptions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBEnumValueOptions descriptor];
}
- (PBEnumValueOptions*) defaultInstance {
  return [PBEnumValueOptions defaultInstance];
}
- (PBEnumValueOptions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBEnumValueOptions*) buildPartial {
  PBEnumValueOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBEnumValueOptions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBEnumValueOptions class]]) {
    return [self mergeFromPBEnumValueOptions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBEnumValueOptions_Builder*) mergeFromPBEnumValueOptions:(PBEnumValueOptions*) other {
  if (other == [PBEnumValueOptions defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBEnumValueOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBEnumValueOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface PBServiceOptions ()
@end

@implementation PBServiceOptions

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static PBServiceOptions* defaultPBServiceOptionsInstance = nil;
+ (void) initialize {
  if (self == [PBServiceOptions class]) {
    defaultPBServiceOptionsInstance = [[PBServiceOptions alloc] init];
  }
}
+ (PBServiceOptions*) defaultInstance {
  return defaultPBServiceOptionsInstance;
}
- (PBServiceOptions*) defaultInstance {
  return defaultPBServiceOptionsInstance;
}
- (PBDescriptor*) descriptor {
  return [PBServiceOptions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_ServiceOptions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_ServiceOptions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBServiceOptions*) parseFromData:(NSData*) data {
  return (PBServiceOptions*)[[[PBServiceOptions_Builder builder] mergeFromData:data] build];
}
+ (PBServiceOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBServiceOptions*)[[[PBServiceOptions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBServiceOptions*) parseFromInputStream:(NSInputStream*) input {
  return (PBServiceOptions*)[[[PBServiceOptions_Builder builder] mergeFromInputStream:input] build];
}
+ (PBServiceOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBServiceOptions*)[[[PBServiceOptions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBServiceOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBServiceOptions*)[[[PBServiceOptions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBServiceOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBServiceOptions*)[[[PBServiceOptions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBServiceOptions_Builder*) createBuilder {
  return [PBServiceOptions_Builder builder];
}
@end

@implementation PBServiceOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBServiceOptions alloc] init] autorelease];
  }
  return self;
}
+ (PBServiceOptions_Builder*) builder {
  return [[[PBServiceOptions_Builder alloc] init] autorelease];
}
+ (PBServiceOptions_Builder*) builderWithPrototype:(PBServiceOptions*) prototype {
  return [[PBServiceOptions_Builder builder] mergeFromPBServiceOptions:prototype];
}
- (PBServiceOptions*) internalGetResult {
  return result;
}
- (PBServiceOptions_Builder*) clear {
  self.result = [[[PBServiceOptions alloc] init] autorelease];
  return self;
}
- (PBServiceOptions_Builder*) clone {
  return [PBServiceOptions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBServiceOptions descriptor];
}
- (PBServiceOptions*) defaultInstance {
  return [PBServiceOptions defaultInstance];
}
- (PBServiceOptions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBServiceOptions*) buildPartial {
  PBServiceOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBServiceOptions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBServiceOptions class]]) {
    return [self mergeFromPBServiceOptions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBServiceOptions_Builder*) mergeFromPBServiceOptions:(PBServiceOptions*) other {
  if (other == [PBServiceOptions defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBServiceOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBServiceOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end

@interface PBMethodOptions ()
@end

@implementation PBMethodOptions

- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static PBMethodOptions* defaultPBMethodOptionsInstance = nil;
+ (void) initialize {
  if (self == [PBMethodOptions class]) {
    defaultPBMethodOptionsInstance = [[PBMethodOptions alloc] init];
  }
}
+ (PBMethodOptions*) defaultInstance {
  return defaultPBMethodOptionsInstance;
}
- (PBMethodOptions*) defaultInstance {
  return defaultPBMethodOptionsInstance;
}
- (PBDescriptor*) descriptor {
  return [PBMethodOptions descriptor];
}
+ (PBDescriptor*) descriptor {
  return [DescriptorProtoRoot internal_static_google_protobuf_MethodOptions_descriptor];
}
- (PBFieldAccessorTable*) internalGetFieldAccessorTable {
  return [DescriptorProtoRoot internal_static_google_protobuf_MethodOptions_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return true;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) return size;

  size = 0;
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PBMethodOptions*) parseFromData:(NSData*) data {
  return (PBMethodOptions*)[[[PBMethodOptions_Builder builder] mergeFromData:data] build];
}
+ (PBMethodOptions*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMethodOptions*)[[[PBMethodOptions_Builder builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PBMethodOptions*) parseFromInputStream:(NSInputStream*) input {
  return (PBMethodOptions*)[[[PBMethodOptions_Builder builder] mergeFromInputStream:input] build];
}
+ (PBMethodOptions*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMethodOptions*)[[[PBMethodOptions_Builder builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PBMethodOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PBMethodOptions*)[[[PBMethodOptions_Builder builder] mergeFromCodedInputStream:input] build];
}
+ (PBMethodOptions*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PBMethodOptions*)[[[PBMethodOptions_Builder builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
- (PBMethodOptions_Builder*) createBuilder {
  return [PBMethodOptions_Builder builder];
}
@end

@implementation PBMethodOptions_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[PBMethodOptions alloc] init] autorelease];
  }
  return self;
}
+ (PBMethodOptions_Builder*) builder {
  return [[[PBMethodOptions_Builder alloc] init] autorelease];
}
+ (PBMethodOptions_Builder*) builderWithPrototype:(PBMethodOptions*) prototype {
  return [[PBMethodOptions_Builder builder] mergeFromPBMethodOptions:prototype];
}
- (PBMethodOptions*) internalGetResult {
  return result;
}
- (PBMethodOptions_Builder*) clear {
  self.result = [[[PBMethodOptions alloc] init] autorelease];
  return self;
}
- (PBMethodOptions_Builder*) clone {
  return [PBMethodOptions_Builder builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [PBMethodOptions descriptor];
}
- (PBMethodOptions*) defaultInstance {
  return [PBMethodOptions defaultInstance];
}
- (PBMethodOptions*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (PBMethodOptions*) buildPartial {
  PBMethodOptions* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PBMethodOptions_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[PBMethodOptions class]]) {
    return [self mergeFromPBMethodOptions:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (PBMethodOptions_Builder*) mergeFromPBMethodOptions:(PBMethodOptions*) other {
  if (other == [PBMethodOptions defaultInstance]) return self;
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PBMethodOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PBMethodOptions_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (true) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
    }
  }
}
@end