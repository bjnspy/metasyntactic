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

#import "FieldAccessorTable.h"

#import "Descriptor.h"
#import "FieldDescriptor.h"
#import "RepeatedEnumFieldAccessor.h";
#import "RepeatedFieldAccessor.h";
#import "RepeatedMessageFieldAccessor.h";
#import "SingularEnumFieldAccessor.h"
#import "SingularFieldAccessor.h"
#import "SingularMessageFieldAccessor.h";


@interface PBFieldAccessorTable()
@property (retain) PBDescriptor* descriptor;
@property (retain) NSArray* fields;
@end


@implementation PBFieldAccessorTable

@synthesize descriptor;
@synthesize fields;

- (void) dealloc {
    self.descriptor = nil;
    self.fields = nil;

    [super dealloc];
}


- (id) initWithDescriptor:(PBDescriptor*) descriptor_
               fieldNames:(NSArray*) fieldNames
             messageClass:(Class) messageClass
             builderClass:(Class) builderClass {
    if (self = [super init]) {
        self.descriptor = descriptor_;

        NSMutableArray* array = [NSMutableArray array];

        for (int i = 0; i < fieldNames.count; i++) {
            NSString* name = [fieldNames objectAtIndex:i];
            PBFieldDescriptor* field = [descriptor.fields objectAtIndex:i];
            if (field.isRepeated) {
                if (field.objectiveCType == PBObjectiveCTypeMessage) {
                    [array addObject:[PBRepeatedMessageFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else if (field.objectiveCType == PBObjectiveCTypeEnum) {
                    [array addObject:[PBRepeatedEnumFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else {
                    [array addObject:[PBRepeatedFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                }
            } else {
                if (field.objectiveCType == PBObjectiveCTypeMessage) {
                    [array addObject:[PBSingularMessageFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else if (field.objectiveCType == PBObjectiveCTypeEnum) {
                    [array addObject:[PBSingularEnumFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                } else {
                    [array addObject:[PBSingularFieldAccessor accessorWithField:field name:name messageClass:messageClass builderClass:builderClass]];
                }
            }
        }

        self.fields = array;
    }

    return self;
}


+ (PBFieldAccessorTable*) tableWithDescriptor:(PBDescriptor*) descriptor
                                   fieldNames:(NSArray*) fieldNames
                                 messageClass:(Class) messageClass
                                 builderClass:(Class) builderClass {
    return [[[PBFieldAccessorTable alloc] initWithDescriptor:descriptor
                                                  fieldNames:fieldNames
                                                messageClass:messageClass
                                                builderClass:builderClass] autorelease];
}


- (id<PBFieldAccessor>) getField:(PBFieldDescriptor*) field {
    if (field.containingType != descriptor) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    } else if (field.isExtension) {
        // If this type had extensions, it would subclass PBExtendableMessage,
        // which overrides the reflection interface to handle extensions.
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }

    return [fields objectAtIndex:field.index];
}

@end