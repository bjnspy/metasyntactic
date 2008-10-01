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

#import "GeneratedMessage_Builder.h"

#import "FieldDescriptor.h"
#import "GeneratedMessage.h"
#import "FieldAccessor.h"
#import "FieldAccessorTable.h"
#import "Message.h"
#import "Message_Builder.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"

@implementation GeneratedMessage_Builder

/**
 * Get the message being built.  We don't just pass this to the
 * constructor because it becomes null when build() is called.
 */
- (GeneratedMessage*) internalGetResult {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}

/**
 * Get the FieldAccessorTable for this type.  We can't have the message
 * class pass this in to the constructor because of bootstrapping trouble
 * with DescriptorProtos.
 */
- (FieldAccessorTable*) internalGetFieldAccessorTable {
    return self.internalGetResult.internalGetFieldAccessorTable;
}


- (id<Message_Builder>) mergeFromMessage:(id<Message>) other {
    if ([other getDescriptorForType] !=
        self.internalGetFieldAccessorTable.descriptor) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }

    NSDictionary* allFields = [other getAllFields];
    for (FieldDescriptor* field in allFields) {
        id newValue = [allFields objectForKey:field];

        if (field.isRepeated) {
            // Concatenate repeated fields.
            for (id element in newValue) {
                [self addRepeatedField:field value:element];
            }
        } else if (field.getObjectiveCType == FieldDescriptorTypeMessage &&
                   [self hasField:field]) {
            // Merge singular embedded messages.
            id<Message> oldValue = [self getField:field];
            [self setField:field
                     value:[[[[oldValue newBuilderForType] mergeFromMessage:oldValue] mergeFromMessage:newValue] buildPartial]];
        } else {
            // Just overwrite.
            [self setField:field value:newValue];
        }
    }

    return self;
}


- (Descriptor*) getDescriptorForType {
    return self.internalGetFieldAccessorTable.descriptor;
}


- (NSDictionary*) getAllFields {
    return self.internalGetResult.getAllFields;
}


- (id<Message_Builder>) newBuilderForField:(FieldDescriptor*) field {
    return [[self.internalGetFieldAccessorTable getField:field] newBuilder];
}


- (BOOL) hasField:(FieldDescriptor*) field {
    return [self.internalGetResult hasField:field];
}


- (id) getField:(FieldDescriptor*) field {
    return [self.internalGetResult getField:field];
}


- (id<Message_Builder>) setField:(FieldDescriptor*) field value:(id) value {
    [[self.internalGetFieldAccessorTable getField:field] set:self value:value];
    return self;
}


- (id<Message_Builder>) clearField:(FieldDescriptor*) field {
    [[self.internalGetFieldAccessorTable getField:field] clear:self];
    return self;
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    return [self.internalGetResult getRepeatedFieldCount:field];
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    return [self.internalGetResult getRepeatedField:field index:index];
}


- (id<Message_Builder>) setRepeatedField:(FieldDescriptor*) field index:(int32_t) index value:(id) value {
    [[self.internalGetFieldAccessorTable getField:field] setRepeated:self index:index value:value];
    return self;
}


- (id<Message_Builder>) addRepeatedField:(FieldDescriptor*) field value:(id) value {
    [[self.internalGetFieldAccessorTable getField:field] addRepeated:self value:value];
    return self;
}


- (UnknownFieldSet*) getUnknownFields {
    return self.internalGetResult.unknownFields;
}


- (id<Message_Builder>) setUnknownFields:(UnknownFieldSet*) unknownFields {
    self.internalGetResult.unknownFields = unknownFields;
    return self;
}


- (id<Message_Builder>) mergeUnknownFields:(UnknownFieldSet*) unknownFields {
    GeneratedMessage* result = self.internalGetResult;
    result.unknownFields = [[[UnknownFieldSet newBuilder:result.unknownFields] mergeUnknownFields:unknownFields] build];
    return self;
}


- (BOOL) isInitialized {
    return self.internalGetResult.isInitialized;
}


/**
 * Called by subclasses to parse an unknown field.
 * @return {@code true} unless the tag is an end-group tag.
 */
- (BOOL) parseUnknownField:(CodedInputStream*) input
             unknownFields:(UnknownFieldSet_Builder*) unknownFields
         extensionRegistry:(ExtensionRegistry*) extensionRegistry
                       tag:(int32_t) tag {
    return [unknownFields mergeFieldFrom:tag input:input];
}


@end
