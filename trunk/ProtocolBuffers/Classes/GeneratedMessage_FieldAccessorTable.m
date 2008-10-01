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

#import "GeneratedMessage_FieldAccessorTable.h"

#import "Descriptor.h"
#import "FieldDescriptor.h"
#import "GeneratedMessage_RepeatedMessageFieldAccessor.h";
#import "GeneratedMessage_RepeatedEnumFieldAccessor.h";
#import "GeneratedMessage_RepeatedFieldAccessor.h";
#import "GeneratedMessage_SingularMessageFieldAccessor.h";
#import "GeneratedMessage_SingularEnumFieldAccessor.h"
#import "GeneratedMessage_SingularFieldAccessor.h"

@implementation GeneratedMessage_FieldAccessorTable

@synthesize descriptor;
@synthesize fields;

- (void) dealloc {
    self.descriptor = nil;
    self.fields = nil;

    [super dealloc];
}


- (id) initWithDescriptor:(Descriptor*) descriptor_
               fieldNames:(NSArray*) fieldNames
             messageClass:(Class) messageClass
             builderClass:(Class) builderClass {
    if (self = [super init]) {
        self.descriptor = descriptor_;

        NSMutableArray* array = [NSMutableArray array];

        for (int i = 0; i < fieldNames.count; i++) {
            NSString* name = [fieldNames objectAtIndex:i];
            FieldDescriptor* field = [descriptor.getFields objectAtIndex:i];
            if (field.isRepeated) {
                if (field.getObjectiveCType == FieldDescriptorTypeMessage) {
                    [array addObject:[GeneratedMessage_RepeatedMessageFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else if (field.getObjectiveCType == FieldDescriptorTypeEnum) {
                    [array addObject:[GeneratedMessage_RepeatedEnumFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else {
                    [array addObject:[GeneratedMessage_RepeatedFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                }
            } else {
                if (field.getObjectiveCType == FieldDescriptorTypeMessage) {
                    [array addObject:[GeneratedMessage_SingularMessageFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else if (field.getObjectiveCType == FieldDescriptorTypeEnum) {
                    [array addObject:[GeneratedMessage_SingularEnumFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else {
                    [array addObject:[GeneratedMessage_SingularFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                }
            }
        }

        self.fields = array;
    }

    return self;
}


+ (GeneratedMessage_FieldAccessorTable*) tableWithDescriptor:(Descriptor*) descriptor
                                                  fieldNames:(NSArray*) fieldNames
                                                messageClass:(Class) messageClass
                                                builderClass:(Class) builderClass {
    return [[[GeneratedMessage_FieldAccessorTable alloc] initWithDescriptor:descriptor
                                                                 fieldNames:fieldNames
                                                               messageClass:messageClass
                                                               builderClass:builderClass] autorelease];
}


- (id<GeneratedMessage_FieldAccessor>) getField:(FieldDescriptor*) field {
    if (field.getContainingType != descriptor) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    } else if (field.isExtension) {
        // If this type had extensions, it would subclass ExtendableMessage,
        // which overrides the reflection interface to handle extensions.
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }

    return [fields objectAtIndex:field.getIndex];
}

@end