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

#import "ExtendableBuilder.h"

#import "ExtendableMessage.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"

@implementation PBExtendableBuilder


- (PBExtendableMessage*) internalGetResult {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (PBExtendableBuilder*) setExtension:(PBGeneratedExtension*) extension
                                       value:(id) value {
    PBExtendableMessage* message = self.internalGetResult;
    [message verifyExtensionContainingType:extension];
    [message.extensions setField:extension.descriptor value:[extension toReflectionType:value]];

    return self;
}


- (PBExtendableBuilder*) setExtension:(PBGeneratedExtension*) extension
                                       index:(int32_t) index
                                       value:(id) value {
    PBExtendableMessage* message = self.internalGetResult;
    [message verifyExtensionContainingType:extension];
    [message.extensions setRepeatedField:extension.descriptor
     index:index
     value:[extension singularToReflectionType:value]];

    return self;
}


/** Append a value to a repeated extension. */
- (PBExtendableBuilder*) addExtension:(PBGeneratedExtension*) extension
                                       value:(id) value {
    PBExtendableMessage* message = self.internalGetResult;
    [message verifyExtensionContainingType:extension];
    [message.extensions addRepeatedField:extension.descriptor value:[extension singularToReflectionType:value]];
    return self;
}


/** Check if a singular extension is present. */
- (BOOL) hasExtension:(PBGeneratedExtension*) extension {
    return [self.internalGetResult hasExtension:extension];
}


/** Get the number of elements in a repeated extension. */
- (NSArray*) getRepeatedExtension:(PBGeneratedExtension*) extension {
    return [self.internalGetResult getRepeatedExtension:extension];
}


/** Get the value of an extension. */
- (id) getExtension:(PBGeneratedExtension*) extension {
    return [self.internalGetResult getExtension:extension];
}


/** Clear an extension. */
- (PBExtendableBuilder*) clearExtension:(PBGeneratedExtension*) extension {
    PBExtendableMessage* message = self.internalGetResult;
    [message verifyExtensionContainingType:extension];
    [message.extensions clearField:extension.descriptor];
    return self;
}


/**
 * Called by subclasses to parse an unknown field or an extension.
 * @return {@code YES} unless the tag is an end-group tag.
 */
- (BOOL) parseUnknownField:(PBCodedInputStream*) input
             unknownFields:(PBUnknownFieldSet_Builder*) unknownFields
         extensionRegistry:(PBExtensionRegistry*) extensionRegistry
                       tag:(int32_t) tag {
    //return [message.extensions mergeFieldFrom(input, unknownFields, extensionRegistry, this, tag);
    return [PBFieldSet mergeFieldFromCodedInputStream:input
                                        unknownFields:unknownFields
                                    extensionRegistry:extensionRegistry
                                              builder:self
                                                  tag:tag];
}


// ---------------------------------------------------------------
// Reflection

// We don't have to override the get*() methods here because they already
// just forward to the underlying message.

- (PBGeneratedMessage_Builder*) setField:(PBFieldDescriptor*) field
                                   value:(id) value {
    if (field.isExtension) {
        PBExtendableMessage* message = self.internalGetResult;
        [message verifyContainingType:field];
        [message.extensions setField:field value:value];
        return self;
    } else {
        return (PBGeneratedMessage_Builder*)[super setField:field value:value];
    }
}

- (PBGeneratedMessage_Builder*) clearField:(PBFieldDescriptor*) field {
    if (field.isExtension) {
        PBExtendableMessage* message = self.internalGetResult;
        [message verifyContainingType:field];
        [message.extensions clearField:field];
        return self;
    } else {
        return (PBGeneratedMessage_Builder*)[super clearField:field];
    }
}

- (PBGeneratedMessage_Builder*) setRepeatedField:(PBFieldDescriptor*) field
                                           index:(int32_t) index
                                           value:(id) value {
    if (field.isExtension) {
        PBExtendableMessage* message = self.internalGetResult;
        [message verifyContainingType:field];
        [message.extensions setRepeatedField:field index:index value:value];
        return self;
    } else {
        return (PBGeneratedMessage_Builder*)[super setRepeatedField:field index:index value:value];
    }
}

- (PBGeneratedMessage_Builder*) addRepeatedField:(PBFieldDescriptor*) field
                                           value:(id) value {
    if (field.isExtension) {
        PBExtendableMessage* message = self.internalGetResult;
        [message verifyContainingType:field];
        [message.extensions addRepeatedField:field value:value];
        return self;
    } else {
        return (PBGeneratedMessage_Builder*)[super addRepeatedField:field value:value];
    }
}

@end