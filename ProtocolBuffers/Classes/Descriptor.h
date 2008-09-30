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

#import "GenericDescriptor.h"

@interface ProtocolBufferDescriptor : NSObject/*<GenericDescriptor>*/ {
    NSArray* nestedTypes;
}

@property (retain) NSArray* nestedTypes;

- (NSArray*) getFields;
- (MessageOptions*) getOptions;

- (NSString*) getFullName;

- (NSArray*) getEnumTypes;
- (NSArray*) getNestedTypes;

- (BOOL) isExtensionNumber:(int32_t) number;
- (FieldDescriptor*) findFieldByNumber:(int32_t) number;

#if 0
NSArray* fields;
    int32_t index;
    DescriptorProto* proto;
    FileDescriptor* file;
    ProtocolBufferDescriptor* containingType;
    NSArray* nestedTypes;
    NSArray* enumTypes;
    NSArray* extensions;
}

@property int32_t index;
@property (retain) DescriptorProto* proto;
@property (retain) NSString* fullName;
@property (retain) FileDescriptor* file;
@property (retain) ProtocolBufferDescriptor* containingType;
@property (retain) NSArray* nestedTypes;
@property (retain) NSArray* enumTypes;
@property (retain) NSArray* extensions;
@property (retain) NSArray* fields;

- (NSString*) name;

- (FieldDescriptor*) findFieldByName:(NSString*) name;
- (ProtocolBufferDescriptor*) findNestedTypeByName:(NSString*) name;
- (EnumDescriptor*) findEnumTypeByName:(NSString*) name;

+ (ProtocolBufferDescriptor*) descriptorWithProto:(DescriptorProto*) proto
                               file:(FileDescriptor*) file
                             parent:(ProtocolBufferDescriptor*) parent
                              index:(int32_t) index;
#endif

@end
