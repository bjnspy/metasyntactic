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

#import "GeneratedExtension.h"

#import "Descriptor.h"
#import "FieldDescriptor.h"
#import "ObjectiveCType.h"

@interface PBGeneratedExtension ()
    @property (retain) PBFieldDescriptor* descriptor;
    @property (retain) Class type;
    @property (retain) id<PBMessage> messageDefaultInstance;
    @property SEL enumValueOf;
    @property SEL enumGetValueDescriptor;
@end


@implementation PBGeneratedExtension

@synthesize descriptor;
@synthesize type;
@synthesize enumValueOf;
@synthesize enumGetValueDescriptor;
@synthesize messageDefaultInstance;

- (void) dealloc {
    self.descriptor = nil;
    self.type = nil;
    self.enumValueOf = 0;
    self.enumGetValueDescriptor = 0;
    self.messageDefaultInstance = 0;

    [super dealloc];
}


- (id) initWithDescriptor:(PBFieldDescriptor*) descriptor_
                     type:(Class) type_ {
    if (self = [super init]) {
        if (!descriptor_.isExtension) {
            @throw [NSException exceptionWithName:@"" reason:@"PBGeneratedExtension given a regular (non-extension) field." userInfo:nil];
        }

        self.descriptor = descriptor_;
        self.type = type_;

        switch (descriptor.objectiveCType) {
            case PBObjectiveCTypeMessage:
self.messageDefaultInstance = [type performSelector:@selector(defaultInstance)];
                break;
            case PBObjectiveCTypeEnum:
self.enumValueOf = @selector(valueOfDescriptor:),
                self.enumGetValueDescriptor = @selector(valueDescriptor);
                break;
        }
    }

    return self;
}


+ (PBGeneratedExtension*) extensionWithDescriptor:(PBFieldDescriptor*) descriptor
                                             type:(Class) type {
    return [[[PBGeneratedExtension alloc] initWithDescriptor:descriptor type:type] autorelease];
}


/**
 * Like {@link #toReflectionType(Object)}, but if the type is a repeated
 * type, this converts a single element.
 */
- (id) singularToReflectionType:(id) value {
    switch (descriptor.objectiveCType) {
        case PBObjectiveCTypeEnum:
            //invokeOrDie(enumGetValueDescriptor, value);
            return [value performSelector:enumGetValueDescriptor];
        default:
            return value;
    }
}


- (id) toReflectionType:(id) value {
    if (descriptor.isRepeated) {
        if (descriptor.objectiveCType == PBObjectiveCTypeEnum) {
            // Must convert the whole list.
            NSMutableArray* result = [NSMutableArray array];
            for (id element in value) {
                [result addObject:[self singularToReflectionType:element]];
            }
            return result;
        } else {
            return value;
        }
    } else {
        return [self singularToReflectionType:value];
    }
}


/**
 * Like {@link #fromReflectionType(Object)}, but if the type is a repeated
 * type, this converts a single element.
 */
- (id) singularFromReflectionType:(id) value {
    switch (descriptor.objectiveCType) {
        case PBObjectiveCTypeMessage:
            if ([value isKindOfClass:type]) {
                return value;
            } else {
                // It seems the copy of the embedded message stored inside the
                // extended message is not of the exact type the user was
                // expecting.  This can happen if a user defines a
                // PBGeneratedExtension manually and gives it a different type.
                // This should not happen in normal use.  But, to be nice, we'll
                // copy the message to whatever type the caller was expecting.
                return [[[messageDefaultInstance builder] mergeFromMessage:value] build];
            }
        case PBObjectiveCTypeEnum:
     return [type performSelector:enumValueOf withObject:value];
        default:
            return value;
    }
}


- (id) fromReflectionType:(id) value {
    if (descriptor.isRepeated) {
        if (descriptor.objectiveCType == PBObjectiveCTypeMessage ||
            descriptor.objectiveCType == PBObjectiveCTypeEnum) {
            // Must convert the whole list.
            NSMutableArray* result = [NSMutableArray array];
            for (id element in value) {
                [result addObject:[self singularFromReflectionType:element]];
            }
            return result;
        } else {
            return value;
        }
    } else {
        return [self singularFromReflectionType:value];
    }
}

@end