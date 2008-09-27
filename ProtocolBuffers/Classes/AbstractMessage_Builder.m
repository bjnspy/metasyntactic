// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "AbstractMessage_Builder.h"

#import "ExtensionRegistry.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "Message.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"


@implementation AbstractMessage_Builder


- (UnknownFieldSet*) getUnknownFields {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) clone {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (id<Message_Builder>) clear {
    for (FieldDescriptor* key in self.getAllFields) {
        [self clearField:key];
    }
    
    return self;
}


- (id<Message>) buildParsed {
    if (![self isInitialized]) {
        @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
    }
    return [self buildPartial];
}


- (id<Message_Builder>) mergeFrom:(id<Message>) other {
    if ([other getDescriptorForType] != self.getDescriptorForType) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"" userInfo:nil];
    }
        
    // Note:  We don't attempt to verify that other's fields have valid
    //   types.  Doing so would be a losing battle.  We'd have to verify
    //   all sub-messages as well, and we'd have to make copies of all of
    //   them to insure that they don't change after verification (since
    //   the Message interface itself cannot enforce immutability of
    //   implementations).
    // TODO(kenton):  Provide a function somewhere called makeDeepCopy()
    //   which allows people to make secure deep copies of messages.
    NSDictionary* allFields = self.getAllFields;
    for (FieldDescriptor* field in allFields) {
        id value = [allFields objectForKey:field];

        if (field.isRepeated) {
            for (id element in value) {
                [self addRepeatedField:field value:element];
            }
        } else if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            id<Message> existingValue = [self getField:field];
            
            if (existingValue == [existingValue getDefaultInstanceForType]) {
                [self setField:field value:value];
            } else {
                id value1 = [[[[existingValue newBuilderForType] mergeFrom:existingValue] mergeFrom:value] build];
                [self setField:field value:value1];
            }
        } else {
            [self setField:field value:value];
        }
    }
    
    return self;
}


- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input {
    return [self mergeFrom:input extensionRegistry:[ExtensionRegistry getEmptyRegistry]];
}


- (id<Message_Builder>) mergeFrom:(CodedInputStream*) input
                     extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    UnknownFieldSet_Builder* unknownFields = [UnknownFieldSet newBuilder:self.getUnknownFields];
    [FieldSet mergeFromCodedInputStream:input unknownFields:unknownFields extensionRegistry:extensionRegistry builder:self];
    [self setUnknownFields:[unknownFields build]];

    return self;
}


- (id<Message_Builder>) mergeUnknownFields:(UnknownFieldSet*) unknownFields {
    UnknownFieldSet* merged = [[[UnknownFieldSet newBuilder:self.getUnknownFields] mergeFrom:unknownFields] build];
    [self setUnknownFields:merged];
    
    return self;
}

/*
    
    public BuilderType mergeFrom(ByteString data)
    throws InvalidProtocolBufferException {
        try {
            CodedInputStream input = data.newCodedInput();
            mergeFrom(input);
            input.checkLastTagWas(0);
            return (BuilderType) this;
        } catch (InvalidProtocolBufferException e) {
            throw e;
        } catch (IOException e) {
            throw new RuntimeException(
                                       "Reading from a ByteString threw an IOException (should " +
                                       "never happen).", e);
        }
    }
    
    public BuilderType mergeFrom(ByteString data,
                                 ExtensionRegistry extensionRegistry)
    throws InvalidProtocolBufferException {
        try {
            CodedInputStream input = data.newCodedInput();
            mergeFrom(input, extensionRegistry);
            input.checkLastTagWas(0);
            return (BuilderType) this;
        } catch (InvalidProtocolBufferException e) {
            throw e;
        } catch (IOException e) {
            throw new RuntimeException(
                                       "Reading from a ByteString threw an IOException (should " +
                                       "never happen).", e);
        }
    }
    
    public BuilderType mergeFrom(byte[] data)
    throws InvalidProtocolBufferException {
        try {
            CodedInputStream input = CodedInputStream.newInstance(data);
            mergeFrom(input);
            input.checkLastTagWas(0);
            return (BuilderType) this;
        } catch (InvalidProtocolBufferException e) {
            throw e;
        } catch (IOException e) {
            throw new RuntimeException(
                                       "Reading from a byte array threw an IOException (should " +
                                       "never happen).", e);
        }
    }
    
    public BuilderType mergeFrom(
                                 byte[] data, ExtensionRegistry extensionRegistry)
    throws InvalidProtocolBufferException {
        try {
            CodedInputStream input = CodedInputStream.newInstance(data);
            mergeFrom(input, extensionRegistry);
            input.checkLastTagWas(0);
            return (BuilderType) this;
        } catch (InvalidProtocolBufferException e) {
            throw e;
        } catch (IOException e) {
            throw new RuntimeException(
                                       "Reading from a byte array threw an IOException (should " +
                                       "never happen).", e);
        }
    }
    
    public BuilderType mergeFrom(InputStream input) throws IOException {
        CodedInputStream codedInput = CodedInputStream.newInstance(input);
        mergeFrom(codedInput);
        codedInput.checkLastTagWas(0);
        return (BuilderType) this;
    }
    
    public BuilderType mergeFrom(InputStream input,
                                 ExtensionRegistry extensionRegistry)
    throws IOException {
        CodedInputStream codedInput = CodedInputStream.newInstance(input);
        mergeFrom(codedInput, extensionRegistry);
        codedInput.checkLastTagWas(0);
        return (BuilderType) this;
    }
}
}
#endif
*/
- (id<Message>) build {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message>) buildPartial {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (BOOL) isInitialized {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (Descriptor*) getDescriptorForType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message>) getDefaultInstanceForType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (NSDictionary*) getAllFields {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) newBuilderForField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (BOOL) hasField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id) getField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) setField:(FieldDescriptor*) field value:(id) value {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) clearField:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) setRepeatedField:(FieldDescriptor*) field index:(int32_t) index value:(id) value {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) addRepeatedField:(FieldDescriptor*) field value:(id) value {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (UnknownFieldSet*) unknownFields {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) setUnknownFields:(UnknownFieldSet*) unknownFields {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) mergeFromCodedInputStream:(CodedInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) mergeFromData:(NSData*) data {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) mergeFromData:(NSData*) data extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}
- (id<Message_Builder>) mergeFromInputStream:(NSInputStream*) input extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}

@end
