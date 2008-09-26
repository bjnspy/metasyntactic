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

@Override
public boolean equals(Object other) {
    if (other == this) {
        return true;
    }
    if (!(other instanceof Message)) {
        return false;
    }
    Message otherMessage = (Message) other;
    if (getDescriptorForType() != otherMessage.getDescriptorForType()) {
        return false;
    }
    return getAllFields().equals(otherMessage.getAllFields());
}

@Override
public int hashCode() {
    int hash = 41;
    hash = (19 * hash) + getDescriptorForType().hashCode();
    hash = (53 * hash) + getAllFields().hashCode();
    return hash;
}

// =================================================================

/**
 * A partial implementation of the {@link Message.Builder} interface which
 * implements as many methods of that interface as possible in terms of
 * other methods.
 */
@SuppressWarnings("unchecked")
public static abstract class Builder<BuilderType extends Builder>
implements Message.Builder {
    // The compiler produces an error if this is not declared explicitly.
    public abstract BuilderType clone();
    
    public BuilderType clear() {
        for (Map.Entry<FieldDescriptor, Object> entry :
             getAllFields().entrySet()) {
            clearField(entry.getKey());
        }
        return (BuilderType) this;
    }
    
    public BuilderType mergeFrom(Message other) {
        if (other.getDescriptorForType() != getDescriptorForType()) {
            throw new IllegalArgumentException(
                                               "mergeFrom(Message) can only merge messages of the same type.");
        }
        
        // Note:  We don't attempt to verify that other's fields have valid
        //   types.  Doing so would be a losing battle.  We'd have to verify
        //   all sub-messages as well, and we'd have to make copies of all of
        //   them to insure that they don't change after verification (since
        //   the Message interface itself cannot enforce immutability of
        //   implementations).
        // TODO(kenton):  Provide a function somewhere called makeDeepCopy()
        //   which allows people to make secure deep copies of messages.
        
        for (Map.Entry<FieldDescriptor, Object> entry :
             other.getAllFields().entrySet()) {
            FieldDescriptor field = entry.getKey();
            if (field.isRepeated()) {
                for (Object element : (List)entry.getValue()) {
                    addRepeatedField(field, element);
                }
            } else if (field.getJavaType() == FieldDescriptor.JavaType.MESSAGE) {
                Message existingValue = (Message)getField(field);
                if (existingValue == existingValue.getDefaultInstanceForType()) {
                    setField(field, entry.getValue());
                } else {
                    setField(field,
                             existingValue.newBuilderForType()
                             .mergeFrom(existingValue)
                             .mergeFrom((Message)entry.getValue())
                             .build());
                }
            } else {
                setField(field, entry.getValue());
            }
        }
        
        return (BuilderType) this;
    }
    
    public BuilderType mergeFrom(CodedInputStream input) throws IOException {
        return mergeFrom(input, ExtensionRegistry.getEmptyRegistry());
    }
    
    public BuilderType mergeFrom(CodedInputStream input,
                                 ExtensionRegistry extensionRegistry)
    throws IOException {
        UnknownFieldSet.Builder unknownFields =
        UnknownFieldSet.newBuilder(getUnknownFields());
        FieldSet.mergeFrom(input, unknownFields, extensionRegistry, this);
        setUnknownFields(unknownFields.build());
        return (BuilderType) this;
    }
    
    public BuilderType mergeUnknownFields(UnknownFieldSet unknownFields) {
        setUnknownFields(
                         UnknownFieldSet.newBuilder(getUnknownFields())
                         .mergeFrom(unknownFields)
                         .build());
        return (BuilderType) this;
    }
    
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

- (Descriptor*) getDescriptorForType {
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
