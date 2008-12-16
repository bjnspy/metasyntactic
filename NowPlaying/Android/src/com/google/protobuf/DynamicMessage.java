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

package com.google.protobuf;

import com.google.protobuf.Descriptors.Descriptor;
import com.google.protobuf.Descriptors.FieldDescriptor;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

/**
 * An implementation of {@link Message} that can represent arbitrary types, given a {@link Descriptors.Descriptor}.
 *
 * @author kenton@google.com Kenton Varda
 */
public final class DynamicMessage extends AbstractMessage {
  private final Descriptor type;
  private final FieldSet fields;
  private final UnknownFieldSet unknownFields;
  private int memoizedSize = -1;

  /**
   * Construct a {@code DynamicMessage} using the given {@code FieldSet}.
   */
  private DynamicMessage(final Descriptor type, final FieldSet fields, final UnknownFieldSet unknownFields) {
    this.type = type;
    this.fields = fields;
    this.unknownFields = unknownFields;
  }

  /**
   * Get a {@code DynamicMessage} representing the default instance of the given type.
   */
  public static DynamicMessage getDefaultInstance(final Descriptor type) {
    return new DynamicMessage(type, FieldSet.emptySet(), UnknownFieldSet.getDefaultInstance());
  }

  /**
   * Parse a message of the given type from the given input stream.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final CodedInputStream input) throws IOException {
    return newBuilder(type).mergeFrom(input).buildParsed();
  }

  /**
   * Parse a message of the given type from the given input stream.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final CodedInputStream input,
                                         final ExtensionRegistry extensionRegistry) throws IOException {
    return newBuilder(type).mergeFrom(input, extensionRegistry).buildParsed();
  }

  /**
   * Parse {@code data} as a message of the given type and return it.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final ByteString data)
      throws InvalidProtocolBufferException {
    return newBuilder(type).mergeFrom(data).buildParsed();
  }

  /**
   * Parse {@code data} as a message of the given type and return it.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final ByteString data,
                                         final ExtensionRegistry extensionRegistry)
      throws InvalidProtocolBufferException {
    return newBuilder(type).mergeFrom(data, extensionRegistry).buildParsed();
  }

  /**
   * Parse {@code data} as a message of the given type and return it.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final byte[] data)
      throws InvalidProtocolBufferException {
    return newBuilder(type).mergeFrom(data).buildParsed();
  }

  /**
   * Parse {@code data} as a message of the given type and return it.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final byte[] data,
                                         final ExtensionRegistry extensionRegistry)
      throws InvalidProtocolBufferException {
    return newBuilder(type).mergeFrom(data, extensionRegistry).buildParsed();
  }

  /**
   * Parse a message of the given type from {@code input} and return it.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final InputStream input) throws IOException {
    return newBuilder(type).mergeFrom(input).buildParsed();
  }

  /**
   * Parse a message of the given type from {@code input} and return it.
   */
  public static DynamicMessage parseFrom(final Descriptor type, final InputStream input,
                                         final ExtensionRegistry extensionRegistry) throws IOException {
    return newBuilder(type).mergeFrom(input, extensionRegistry).buildParsed();
  }

  /**
   * Construct a {@link Message.Builder} for the given type.
   */
  public static Builder newBuilder(final Descriptor type) {
    return new Builder(type);
  }

  /**
   * Construct a {@link Message.Builder} for a message of the same type as {@code prototype}, and initialize it with
   * {@code prototype}'s contents.
   */
  public static Builder newBuilder(final Message prototype) {
    return new Builder(prototype.getDescriptorForType()).mergeFrom(prototype);
  }

  // -----------------------------------------------------------------
  // Implementation of Message interface.

  public Descriptor getDescriptorForType() {
    return this.type;
  }

  public DynamicMessage getDefaultInstanceForType() {
    return getDefaultInstance(this.type);
  }

  public Map<FieldDescriptor, Object> getAllFields() {
    return this.fields.getAllFields();
  }

  public boolean hasField(final FieldDescriptor field) {
    verifyContainingType(field);
    return this.fields.hasField(field);
  }

  public Object getField(final FieldDescriptor field) {
    verifyContainingType(field);
    Object result = this.fields.getField(field);
    if (result == null) {
      result = getDefaultInstance(field.getMessageType());
    }
    return result;
  }

  public int getRepeatedFieldCount(final FieldDescriptor field) {
    verifyContainingType(field);
    return this.fields.getRepeatedFieldCount(field);
  }

  public Object getRepeatedField(final FieldDescriptor field, final int index) {
    verifyContainingType(field);
    return this.fields.getRepeatedField(field, index);
  }

  public UnknownFieldSet getUnknownFields() {
    return this.unknownFields;
  }

  @Override
  public boolean isInitialized() {
    return this.fields.isInitialized(this.type);
  }

  @Override
  public void writeTo(final CodedOutputStream output) throws IOException {
    this.fields.writeTo(output);
    if (this.type.getOptions().getMessageSetWireFormat()) {
      this.unknownFields.writeAsMessageSetTo(output);
    } else {
      this.unknownFields.writeTo(output);
    }
  }

  @Override
  public int getSerializedSize() {
    int size = this.memoizedSize;
    if (size != -1) {
      return size;
    }

    size = this.fields.getSerializedSize();
    if (this.type.getOptions().getMessageSetWireFormat()) {
      size += this.unknownFields.getSerializedSizeAsMessageSet();
    } else {
      size += this.unknownFields.getSerializedSize();
    }

    this.memoizedSize = size;
    return size;
  }

  public Builder newBuilderForType() {
    return new Builder(this.type);
  }

  /**
   * Verifies that the field is a field of this message.
   */
  private void verifyContainingType(final FieldDescriptor field) {
    if (field.getContainingType() != this.type) {
      throw new IllegalArgumentException("FieldDescriptor does not match message type.");
    }
  }

  // =================================================================

  /**
   * Builder for {@link DynamicMessage}s.
   */
  public static final class Builder extends AbstractMessage.Builder<Builder> {
    private final Descriptor type;
    private FieldSet fields;
    private UnknownFieldSet unknownFields;

    /**
     * Construct a {@code Builder} for the given type.
     */
    private Builder(final Descriptor type) {
      this.type = type;
      this.fields = FieldSet.newFieldSet();
      this.unknownFields = UnknownFieldSet.getDefaultInstance();
    }

    // ---------------------------------------------------------------
    // Implementation of Message.Builder interface.

    @Override
    public Builder clear() {
      this.fields.clear();
      return this;
    }

    @Override
    public Builder mergeFrom(final Message other) {
      if (other.getDescriptorForType() != this.type) {
        throw new IllegalArgumentException("mergeFrom(Message) can only merge messages of the same type.");
      }

      this.fields.mergeFrom(other);
      return this;
    }

    public DynamicMessage build() {
      if (!isInitialized()) {
        throw new UninitializedMessageException(new DynamicMessage(this.type, this.fields, this.unknownFields));
      }
      return buildPartial();
    }

    /**
     * Helper for DynamicMessage.parseFrom() methods to call.  Throws {@link InvalidProtocolBufferException} instead of
     * {@link UninitializedMessageException}.
     */
    private DynamicMessage buildParsed() throws InvalidProtocolBufferException {
      if (!isInitialized()) {
        throw new UninitializedMessageException(new DynamicMessage(this.type, this.fields, this.unknownFields))
            .asInvalidProtocolBufferException();
      }
      return buildPartial();
    }

    public DynamicMessage buildPartial() {
      this.fields.makeImmutable();
      final DynamicMessage result = new DynamicMessage(this.type, this.fields, this.unknownFields);
      this.fields = null;
      this.unknownFields = null;
      return result;
    }

    @Override
    public Builder clone() {
      final Builder result = new Builder(this.type);
      result.fields.mergeFrom(this.fields);
      return result;
    }

    public boolean isInitialized() {
      return this.fields.isInitialized(this.type);
    }

    @Override
    public Builder mergeFrom(final CodedInputStream input, final ExtensionRegistry extensionRegistry)
        throws IOException {
      final UnknownFieldSet.Builder unknownFieldsBuilder = UnknownFieldSet.newBuilder(this.unknownFields);
      FieldSet.mergeFrom(input, unknownFieldsBuilder, extensionRegistry, this);
      this.unknownFields = unknownFieldsBuilder.build();
      return this;
    }

    public Descriptor getDescriptorForType() {
      return this.type;
    }

    public DynamicMessage getDefaultInstanceForType() {
      return getDefaultInstance(this.type);
    }

    public Map<FieldDescriptor, Object> getAllFields() {
      return this.fields.getAllFields();
    }

    public Builder newBuilderForField(final FieldDescriptor field) {
      verifyContainingType(field);

      if (field.getJavaType() != FieldDescriptor.JavaType.MESSAGE) {
        throw new IllegalArgumentException("newBuilderForField is only valid for fields with message type.");
      }

      return new Builder(field.getMessageType());
    }

    public boolean hasField(final FieldDescriptor field) {
      verifyContainingType(field);
      return this.fields.hasField(field);
    }

    public Object getField(final FieldDescriptor field) {
      verifyContainingType(field);
      Object result = this.fields.getField(field);
      if (result == null) {
        result = getDefaultInstance(field.getMessageType());
      }
      return result;
    }

    public Builder setField(final FieldDescriptor field, final Object value) {
      verifyContainingType(field);
      this.fields.setField(field, value);
      return this;
    }

    public Builder clearField(final FieldDescriptor field) {
      verifyContainingType(field);
      this.fields.clearField(field);
      return this;
    }

    public int getRepeatedFieldCount(final FieldDescriptor field) {
      verifyContainingType(field);
      return this.fields.getRepeatedFieldCount(field);
    }

    public Object getRepeatedField(final FieldDescriptor field, final int index) {
      verifyContainingType(field);
      return this.fields.getRepeatedField(field, index);
    }

    public Builder setRepeatedField(final FieldDescriptor field, final int index, final Object value) {
      verifyContainingType(field);
      this.fields.setRepeatedField(field, index, value);
      return this;
    }

    public Builder addRepeatedField(final FieldDescriptor field, final Object value) {
      verifyContainingType(field);
      this.fields.addRepeatedField(field, value);
      return this;
    }

    public UnknownFieldSet getUnknownFields() {
      return this.unknownFields;
    }

    public Builder setUnknownFields(final UnknownFieldSet unknownFields) {
      this.unknownFields = unknownFields;
      return this;
    }

    @Override
    public Builder mergeUnknownFields(final UnknownFieldSet unknownFields) {
      this.unknownFields = UnknownFieldSet.newBuilder(this.unknownFields)
          .mergeFrom(unknownFields)
          .build();
      return this;
    }

    /**
     * Verifies that the field is a field of this message.
     */
    private void verifyContainingType(final FieldDescriptor field) {
      if (field.getContainingType() != this.type) {
        throw new IllegalArgumentException("FieldDescriptor does not match message type.");
      }
    }
  }
}
