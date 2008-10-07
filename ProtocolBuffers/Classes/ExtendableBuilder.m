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

#import "ExtendableBuilder.h"


@implementation PBExtendableBuilder


- (PBExtendableMessage*) internalGetResult {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (PBGeneratedMessage_Builder*) setExtension:(PBGeneratedExtension*) extension
                                       value:(id) value {
    PBExtendableMessage* message = [self internalGetResult];
    [message verifyExtensionContainingType:extension];
    [message.extensions setField:extension.descriptor value:[extension toReflectionType:value]];

    return self;
}



#if 0
public abstract static class ExtendableBuilder<
MessageType extends ExtendableMessage,
BuilderType extends ExtendableBuilder>
extends GeneratedMessage.Builder<BuilderType> {
    protected ExtendableBuilder() {}
    protected abstract ExtendableMessage<MessageType> internalGetResult();
    
    /** Check if a singular extension is present. */
    public final boolean hasExtension(
                                      GeneratedExtension<MessageType, ?> extension) {
        return internalGetResult().hasExtension(extension);
    }
    
    /** Get the number of elements in a repeated extension. */
    public final <Type> int getExtensionCount(
                                              GeneratedExtension<MessageType, List<Type>> extension) {
        return internalGetResult().getExtensionCount(extension);
    }
    
    /** Get the value of an extension. */
    public final <Type> Type getExtension(
                                          GeneratedExtension<MessageType, Type> extension) {
        return internalGetResult().getExtension(extension);
    }
    
    /** Get one element of a repeated extension. */
    public final <Type> Type getExtension(
                                          GeneratedExtension<MessageType, List<Type>> extension, int index) {
        return internalGetResult().getExtension(extension, index);
    }
    
    /** Set the value of an extension. */
    public final <Type> BuilderType setExtension(
                                                 GeneratedExtension<MessageType, Type> extension, Type value) {
        ExtendableMessage<MessageType> message = internalGetResult();
        message.verifyExtensionContainingType(extension);
        message.extensions.setField(extension.getDescriptor(),
                                    extension.toReflectionType(value));
        return (BuilderType)this;
    }
    
    /** Set the value of one element of a repeated extension. */
    public final <Type> BuilderType setExtension(
                                                 GeneratedExtension<MessageType, List<Type>> extension,
                                                 int index, Type value) {
        ExtendableMessage<MessageType> message = internalGetResult();
        message.verifyExtensionContainingType(extension);
        message.extensions.setRepeatedField(
                                            extension.getDescriptor(), index,
                                            extension.singularToReflectionType(value));
        return (BuilderType)this;
    }
    
    /** Append a value to a repeated extension. */
    public final <Type> BuilderType addExtension(
                                                 GeneratedExtension<MessageType, List<Type>> extension, Type value) {
        ExtendableMessage<MessageType> message = internalGetResult();
        message.verifyExtensionContainingType(extension);
        message.extensions.addRepeatedField(
                                            extension.getDescriptor(), extension.singularToReflectionType(value));
        return (BuilderType)this;
    }
    
    /** Clear an extension. */
    public final <Type> BuilderType clearExtension(
                                                   GeneratedExtension<MessageType, ?> extension) {
        ExtendableMessage<MessageType> message = internalGetResult();
        message.verifyExtensionContainingType(extension);
        message.extensions.clearField(extension.getDescriptor());
        return (BuilderType)this;
    }
    
    /**
     * Called by subclasses to parse an unknown field or an extension.
     * @return {@code true} unless the tag is an end-group tag.
     */
    protected boolean parseUnknownField(CodedInputStream input,
                                        UnknownFieldSet.Builder unknownFields,
                                        ExtensionRegistry extensionRegistry,
                                        int tag)
    throws IOException {
        ExtendableMessage<MessageType> message = internalGetResult();
        return message.extensions.mergeFieldFrom(
                                                 input, unknownFields, extensionRegistry, this, tag);
    }
    
    // ---------------------------------------------------------------
    // Reflection
    
    // We don't have to override the get*() methods here because they already
    // just forward to the underlying message.
    
    public BuilderType setField(FieldDescriptor field, Object value) {
        if (field.isExtension()) {
            ExtendableMessage<MessageType> message = internalGetResult();
            message.verifyContainingType(field);
            message.extensions.setField(field, value);
            return (BuilderType)this;
        } else {
            return super.setField(field, value);
        }
    }
    
    public BuilderType clearField(Descriptors.FieldDescriptor field) {
        if (field.isExtension()) {
            ExtendableMessage<MessageType> message = internalGetResult();
            message.verifyContainingType(field);
            message.extensions.clearField(field);
            return (BuilderType)this;
        } else {
            return super.clearField(field);
        }
    }
    
    public BuilderType setRepeatedField(Descriptors.FieldDescriptor field,
                                        int index, Object value) {
        if (field.isExtension()) {
            ExtendableMessage<MessageType> message = internalGetResult();
            message.verifyContainingType(field);
            message.extensions.setRepeatedField(field, index, value);
            return (BuilderType)this;
        } else {
            return super.setRepeatedField(field, index, value);
        }
    }
    
    public BuilderType addRepeatedField(Descriptors.FieldDescriptor field,
                                        Object value) {
        if (field.isExtension()) {
            ExtendableMessage<MessageType> message = internalGetResult();
            message.verifyContainingType(field);
            message.extensions.addRepeatedField(field, value);
            return (BuilderType)this;
        } else {
            return super.addRepeatedField(field, value);
        }
    }
}
#endif

@end
