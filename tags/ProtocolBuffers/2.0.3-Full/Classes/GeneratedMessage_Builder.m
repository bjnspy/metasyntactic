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

#import "GeneratedMessage_Builder.h"

#import "FieldAccessor.h"
#import "FieldAccessorTable.h"
#import "FieldDescriptor.h"
#import "GeneratedMessage.h"
#import "Message.h"
#import "Message_Builder.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"


@interface PBGeneratedMessage ()
@property (retain) PBUnknownFieldSet* unknownFields;
@end


@implementation PBGeneratedMessage_Builder

/**
 * Get the message being built.  We don't just pass this to the
 * constructor because it becomes null when build() is called.
 */
- (PBGeneratedMessage*) internalGetResult {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


/**
 * Get the PBFieldAccessorTable for this type.  We can't have the message
 * class pass this in to the constructor because of bootstrapping trouble
 * with DescriptorProtos.
 */
- (PBFieldAccessorTable*) fieldAccessorTable {
    return [(id)self.internalGetResult fieldAccessorTable];
}


- (id<PBMessage_Builder>) mergeFromMessage:(id<PBMessage>) other {
    if ([other descriptor] !=
        self.fieldAccessorTable.descriptor) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }

    NSDictionary* allFields = [other allFields];
    for (PBFieldDescriptor* field in allFields) {
        id newValue = [allFields objectForKey:field];

        if (field.isRepeated) {
            // Concatenate repeated fields.
            for (id element in newValue) {
                [self addRepeatedField:field value:element];
            }
        } else if (field.objectiveCType == PBObjectiveCTypeMessage &&
                   [self hasField:field]) {
            // Merge singular embedded messages.
            id<PBMessage> oldValue = [self getField:field];
            [self setField:field
                     value:[[[[oldValue builder] mergeFromMessage:oldValue] mergeFromMessage:newValue] buildPartial]];
        } else {
            // Just overwrite.
            [self setField:field value:newValue];
        }
    }

    return self;
}


- (PBDescriptor*) descriptor {
    return self.fieldAccessorTable.descriptor;
}


- (NSDictionary*) allFields {
    return self.internalGetResult.allFields;
}


- (id<PBMessage_Builder>) createBuilder:(PBFieldDescriptor*) field {
    return [[self.fieldAccessorTable getField:field] createBuilder];
}


- (BOOL) hasField:(PBFieldDescriptor*) field {
    return [self.internalGetResult hasField:field];
}


- (id) getField:(PBFieldDescriptor*) field {
    return [self.internalGetResult getField:field];
}


- (id<PBMessage_Builder>) setField:(PBFieldDescriptor*) field value:(id) value {
    [[self.fieldAccessorTable getField:field] set:self value:value];
    return self;
}


- (id<PBMessage_Builder>) clearField:(PBFieldDescriptor*) field {
    [[self.fieldAccessorTable getField:field] clear:self];
    return self;
}


- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field {
    return [self.internalGetResult getRepeatedField:field];
}


- (id<PBMessage_Builder>) setRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index value:(id) value {
    [[self.fieldAccessorTable getField:field] setRepeated:self index:index value:value];
    return self;
}


- (id<PBMessage_Builder>) addRepeatedField:(PBFieldDescriptor*) field value:(id) value {
    [[self.fieldAccessorTable getField:field] addRepeated:self value:value];
    return self;
}


- (PBUnknownFieldSet*) unknownFields {
    return self.internalGetResult.unknownFields;
}


- (id<PBMessage_Builder>) setUnknownFields:(PBUnknownFieldSet*) unknownFields {
    self.internalGetResult.unknownFields = unknownFields;
    return self;
}


- (id<PBMessage_Builder>) mergeUnknownFields:(PBUnknownFieldSet*) unknownFields {
    PBGeneratedMessage* result = self.internalGetResult;
    result.unknownFields =
    [[[PBUnknownFieldSet builderWithUnknownFields:result.unknownFields]
                               mergeUnknownFields:unknownFields] build];
    return self;
}


- (BOOL) isInitialized {
    return self.internalGetResult.isInitialized;
}


/**
 * Called by subclasses to parse an unknown field.
 * @return {@code YES} unless the tag is an end-group tag.
 */
- (BOOL) parseUnknownField:(PBCodedInputStream*) input
             unknownFields:(PBUnknownFieldSet_Builder*) unknownFields
         extensionRegistry:(PBExtensionRegistry*) extensionRegistry
                       tag:(int32_t) tag {
    return [unknownFields mergeFieldFrom:tag input:input];
}


@end