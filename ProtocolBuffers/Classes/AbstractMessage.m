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

#import "AbstractMessage.h"

#import "CodedOutputStream.h"
#import "Descriptor.h"
#import "FieldDescriptor.h"
#import "ObjectiveCType.h"

@implementation AbstractMessage

- (BOOL) isInitialized {
    for (FieldDescriptor* field in self.getDescriptorForType.getFields) {
        if (field.isRequired) {
            if (![self hasField:field]) {
                return NO;
            }
        }
    }
    
    NSDictionary* allFields = self.getAllFields;
    for (FieldDescriptor* field in allFields) {
        if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            id value = [allFields objectForKey:field];

            if (field.isRepeated) {
                for (id<Message> element in value) {
                    if (![element isInitialized]) {
                        return NO;
                    }
                }
            } else {
                if (![value isInitialized]) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

/*
- (void) writeToCodedOutputStream:(CodedOutputStream*) output {
    NSDictionary* allFields = self.getAllFields;
    for (FieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];
        if (field.isRepeated) {
            for (id element in value) {
                [output writeField:field.getType number:field.getNumber value:element];
            }
        } else {
            [output writeField:field.getType number:field.getNumber value:value];
        }
    }
    
    UnknownFieldSet* unknownFields = self.getUnknownFields;
    if (self.getDescriptorForType.getOptions.getMessageSetWireFormat) {
        [unknownFields writeAsMessageSetTo:output];
    } else {
        [unknownFields writeTo:output];
    }
}
 */

- (void) writeTo:(NSOutputStream*) output {
    CodedOutputStream* codedOutput = [CodedOutputStream newInstance:output];
    [self writeToCodedOutputStream:codedOutput];
    [codedOutput flush];
}


- (BOOL) isEqual:(id) other {
    if (other == self) {
        return YES;
    }
    
    if (![other conformsToProtocol:@protocol(Message)]) {
        return NO;
    }
    
    if (self.getDescriptorForType != [other getDescriptorForType]) {
        return NO;
    }
    
    return [self.getAllFields isEqual:[other getAllFields]];
}


- (NSUInteger) hash {
    NSUInteger hash = 41;
    hash = (19 * hash) + self.getDescriptorForType.hash;
    hash = (53 * hash) + self.getAllFields.hash;
    return hash;
}

#if 0

public ByteString toByteString() {
    try {
        ByteString.CodedBuilder out =
        ByteString.newCodedBuilder(getSerializedSize());
        writeTo(out.getCodedOutput());
        return out.build();
    } catch (IOException e) {
        throw new RuntimeException(
                                   "Serializing to a ByteString threw an IOException (should " +
                                   "never happen).", e);
    }
}

private int memoizedSize = -1;

public int getSerializedSize() {
    int size = memoizedSize;
    if (size != -1) return size;
    
    size = 0;
    for (Map.Entry<FieldDescriptor, Object> entry : getAllFields().entrySet()) {
        FieldDescriptor field = entry.getKey();
        if (field.isRepeated()) {
            for (Object element : (List) entry.getValue()) {
                size += CodedOutputStream.computeFieldSize(
                                                           field.getType(), field.getNumber(), element);
            }
        } else {
            size += CodedOutputStream.computeFieldSize(
                                                       field.getType(), field.getNumber(), entry.getValue());
        }
    }
    
    UnknownFieldSet unknownFields = getUnknownFields();
    if (getDescriptorForType().getOptions().getMessageSetWireFormat()) {
        size += unknownFields.getSerializedSizeAsMessageSet();
    } else {
        size += unknownFields.getSerializedSize();
    }
    
    memoizedSize = size;
    return size;
}
// =================================================================
#endif

- (ProtocolBufferDescriptor*) getDescriptorForType {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (id<Message>) getDefaultInstanceForType {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (NSDictionary*) getAllFields {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (BOOL) hasField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (id) getField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (UnknownFieldSet*) getUnknownFields {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (int32_t) getSerializedSize {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (void) writeToOuputStream:(NSOutputStream*) output {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (void) writeToCodedOutputStream:(CodedOutputStream*) output {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (NSData*) toData {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) newBuilderForType {
    @throw [NSException exceptionWithName:@"NotYetImplemented" reason:@"" userInfo:nil];
}


@end
