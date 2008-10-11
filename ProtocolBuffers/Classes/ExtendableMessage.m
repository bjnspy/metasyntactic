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

#import "ExtendableMessage.h"

#import "DynamicMessage.h"
#import "ExtensionWriter.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "GeneratedExtension.h"


@interface PBExtendableMessage ()
    @property (retain) PBFieldSet* extensions;
@end


@implementation PBExtendableMessage

@synthesize extensions;

- (void) dealloc {
    self.extensions = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.extensions = [PBFieldSet set];
    }

    return self;
}


- (void) verifyExtensionContainingType:(PBGeneratedExtension*) extension {
    if (extension.descriptor.containingType != [self descriptor]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
}


- (BOOL) hasExtension:(PBGeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    return [extensions hasField:extension.descriptor];
}


/** Get the value of an extension. */
- (id) getExtension:(PBGeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    id value = [extensions getField:extension.descriptor];
    if (value == nil) {
        return extension.messageDefaultInstance;
    } else {
        return [extension fromReflectionType:value];
    }
}


/** Get one element of a repeated extension. */
- (NSArray*) getRepeatedExtension:(PBGeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    NSArray* array = [extensions getRepeatedField:extension.descriptor];
    NSMutableArray* result = [NSMutableArray array];
    for (id element in array) {
        [result addObject:[extension singularFromReflectionType:element]];
    }
    return result;
}


/** Called by subclasses to check if all extensions are initialized. */
- (BOOL) extensionsAreInitialized {
    return extensions.isInitialized;
}


- (PBExtensionWriter*) newExtensionWriter {
    return [[[PBExtensionWriter alloc] init] autorelease];
}


/** Called by subclasses to compute the size of extensions. */
- (int32_t) extensionsSerializedSize {
    return extensions.serializedSize;
}


// ---------------------------------------------------------------
// Reflection

- (NSMutableDictionary*) allFieldsMutable {
    NSMutableDictionary* result = [super allFieldsMutable];
    [result addEntriesFromDictionary:extensions.allFields];
    return result;
}


- (void) verifyContainingType:(PBFieldDescriptor*) field {
    if (field.containingType != [self descriptor]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"PBFieldDescriptor does not match message type." userInfo:nil];
    }
}


- (BOOL) hasField:(PBFieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions hasField:field];
    } else {
        return [super hasField:field];
    }
}


- (id) getField:(PBFieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        id value = [extensions getField:field];
        if (value == nil) {
            // Lacking an PBExtensionRegistry, we have no way to determine the
            // extension's real type, so we return a DynamicMessage.
            return [PBDynamicMessage defaultInstance:field.messageType];
        } else {
            return value;
        }
    } else {
        return [super getField:field];
    }
}


- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions getRepeatedField:field];
    } else {
        return [super getRepeatedField:field];
    }
}

@end