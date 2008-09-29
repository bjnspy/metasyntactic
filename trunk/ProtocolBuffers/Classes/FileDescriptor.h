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

@interface FileDescriptor : NSObject {
}

+ (FileDescriptor*) buildFrom:(FileDescriptorProto*) proto dependencies:(NSArray*) dependencies;
+ (FileDescriptor*) internalBuildGeneratedFileFrom:(NSString*) descriptorData dependencies:(NSArray*) dependencies;



#if 0
    FileDescriptorProto* proto;
    NSArray* messageTypes;
    NSArray* enumTypes;
    NSArray* services;
    NSArray* extensions;
    NSArray* dependencies;
    NSArray* DescriptorPool* pool;
}

@property (retain) FileDescriptorProto* proto;
@property (retain) NSArray* messageTypes;
@property (retain) NSArray* enumTypes;
@property (retain) NSArray* services;
@property (retain) NSArray* extensions;
@property (retain) NSArray* dependencies;
@property (retain) NSArray* DescriptorPool* pool;

+ (FileDescriptor*) descriptorWithProto:(FileDescriptorProto*) proto
                           dependencies:(NSArray*) dependencies
                                   pool:(DescriptorPool*) pool;

- (FieldDescriptorProto*) toProto;
- (NSString*) name;
- (NSString*) package;
- (FileOptions*) options; 
- (NSArray*) messageTypes;
- (NSArray*) enumTypes;
- (NSArray*) services;
- (NSArray*) extensions;
- (NSArray*) dependencies;

- (Descriptor*) findMessageTypeByName:(NSString*) name;
- (EnumDescriptor*) findEnumTypeByName:(NSString*) name;
- (ServiceDescriptor*) findServiceByName:(NSString*) name;
- (FieldDescriptor*) findExtensionByName:(NSString*) name;
#endif

@end
