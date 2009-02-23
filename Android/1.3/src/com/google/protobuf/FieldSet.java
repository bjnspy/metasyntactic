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
import com.google.protobuf.Descriptors.EnumValueDescriptor;
import com.google.protobuf.Descriptors.FieldDescriptor;

import java.util.*;

/**
 * A class which represents an arbitrary set of fields of some message type. This is used to implement {@link
 * DynamicMessage}, and also to represent extensions in {@link GeneratedMessage}.  This class is package-private, since
 * outside users should probably be using {@link DynamicMessage}.
 *
 * @author kenton@google.com Kenton Varda
 */
final class FieldSet {
  private Map<FieldDescriptor, Object> fields;

  /**
   * Construct a new FieldSet.
   */
  private FieldSet() {
    // Use a TreeMap because fields need to be in canonical order when
    // serializing.
    this.fields = new TreeMap<FieldDescriptor, Object>();
  }

  /**
   * Construct a new FieldSet with the given map.  This is only used by DEFAULT_INSTANCE, to pass in an immutable empty
   * map.
   */
  private FieldSet(final Map<FieldDescriptor, Object> fields) {
    this.fields = fields;
  }

  /**
   * Construct a new FieldSet.
   */
  public static FieldSet newFieldSet() {
    return new FieldSet();
  }

  /**
   * Get an immutable empty FieldSet.
   */
  public static FieldSet emptySet() {
    return DEFAULT_INSTANCE;
  }

  private static final FieldSet DEFAULT_INSTANCE = new FieldSet(Collections.<FieldDescriptor, Object>emptyMap());

  /**
   * Make this FieldSet immutable from this point forward.
   */
  @SuppressWarnings("unchecked")
  public void makeImmutable() {
    for (final Map.Entry<FieldDescriptor, Object> entry : this.fields.entrySet()) {
      if (entry.getKey().isRepeated()) {
        final List value = (List) entry.getValue();
        entry.setValue(Collections.unmodifiableList(value));
      }
    }
    this.fields = Collections.unmodifiableMap(this.fields);
  }

  // =================================================================

  /**
   * See {@link Message.Builder#clear()}.
   */
  public void clear() {
    this.fields.clear();
  }

  /**
   * See {@link Message#getAllFields()}.
   */
  public Map<Descriptors.FieldDescriptor, Object> getAllFields() {
    return Collections.unmodifiableMap(this.fields);
  }

  /**
   * Get an interator to the field map.  This iterator should not be leaked out of the protobuf library as it is not
   * protected from mutation.
   */
  public Iterator<Map.Entry<Descriptors.FieldDescriptor, Object>> iterator() {
    return this.fields.entrySet().iterator();
  }

  /**
   * See {@link Message#hasField(Descriptors.FieldDescriptor)}.
   */
  public boolean hasField(final Descriptors.FieldDescriptor field) {
    if (field.isRepeated()) {
      throw new IllegalArgumentException("hasField() can only be called on non-repeated fields.");
    }

    return this.fields.containsKey(field);
  }

  /**
   * See {@link Message#getField(Descriptors.FieldDescriptor)}.  This method returns {@code null} if the field is a
   * singular message type and is not set; in this case it is up to the caller to fetch the message's default instance.
   */
  public Object getField(final Descriptors.FieldDescriptor field) {
    final Object result = this.fields.get(field);
    if (result == null) {
      if (field.getJavaType() == FieldDescriptor.JavaType.MESSAGE) {
        if (field.isRepeated()) {
          return Collections.emptyList();
        } else {
          return null;
        }
      } else {
        return field.getDefaultValue();
      }
    } else {
      return result;
    }
  }

  /**
   * See {@link Message.Builder#setField(Descriptors.FieldDescriptor,Object)}.
   */
  @SuppressWarnings("unchecked")
  public void setField(final Descriptors.FieldDescriptor field, Object value) {
    if (field.isRepeated()) {
      if (!(value instanceof List)) {
        throw new IllegalArgumentException("Wrong object type used with protocol message reflection.");
      }

      // Wrap the contents in a new list so that the caller cannot change
      // the list's contents after setting it.
      final List newList = new ArrayList();
      newList.addAll((List) value);
      for (final Object element : newList) {
        verifyType(field, element);
      }
      value = newList;
    } else {
      verifyType(field, value);
    }

    this.fields.put(field, value);
  }

  /**
   * See {@link Message.Builder#clearField(Descriptors.FieldDescriptor)}.
   */
  public void clearField(final Descriptors.FieldDescriptor field) {
    this.fields.remove(field);
  }

  /**
   * See {@link Message#getRepeatedFieldCount(Descriptors.FieldDescriptor)}.
   */
  @SuppressWarnings("unchecked")
  public int getRepeatedFieldCount(final Descriptors.FieldDescriptor field) {
    if (!field.isRepeated()) {
      throw new IllegalArgumentException("getRepeatedFieldCount() can only be called on repeated fields.");
    }

    return ((List<Object>) getField(field)).size();
  }

  /**
   * See {@link Message#getRepeatedField(Descriptors.FieldDescriptor,int)}.
   */
  @SuppressWarnings("unchecked")
  public Object getRepeatedField(final Descriptors.FieldDescriptor field, final int index) {
    if (!field.isRepeated()) {
      throw new IllegalArgumentException("getRepeatedField() can only be called on repeated fields.");
    }

    return ((List<Object>) getField(field)).get(index);
  }

  /**
   * See {@link Message.Builder#setRepeatedField(Descriptors.FieldDescriptor,int,Object)}.
   */
  @SuppressWarnings("unchecked")
  public void setRepeatedField(final Descriptors.FieldDescriptor field, final int index, final Object value) {
    if (!field.isRepeated()) {
      throw new IllegalArgumentException("setRepeatedField() can only be called on repeated fields.");
    }

    verifyType(field, value);

    final List list = (List) this.fields.get(field);
    if (list == null) {
      throw new IndexOutOfBoundsException();
    }

    list.set(index, value);
  }

  /**
   * See {@link Message.Builder#addRepeatedField(Descriptors.FieldDescriptor,Object)}.
   */
  @SuppressWarnings("unchecked")
  public void addRepeatedField(final Descriptors.FieldDescriptor field, final Object value) {
    if (!field.isRepeated()) {
      throw new IllegalArgumentException("setRepeatedField() can only be called on repeated fields.");
    }

    verifyType(field, value);

    List list = (List) this.fields.get(field);
    if (list == null) {
      list = new ArrayList();
      this.fields.put(field, list);
    }

    list.add(value);
  }

  /**
   * Verifies that the given object is of the correct type to be a valid value for the given field.  (For repeated
   * fields, this checks if the object is the right type to be one element of the field.)
   *
   * @throws IllegalArgumentException The value is not of the right type.
   */
  private void verifyType(final FieldDescriptor field, final Object value) {
    boolean isValid = false;
    switch (field.getJavaType()) {
      case INT:
        isValid = value instanceof Integer;
        break;
      case LONG:
        isValid = value instanceof Long;
        break;
      case FLOAT:
        isValid = value instanceof Float;
        break;
      case DOUBLE:
        isValid = value instanceof Double;
        break;
      case BOOLEAN:
        isValid = value instanceof Boolean;
        break;
      case STRING:
        isValid = value instanceof String;
        break;
      case BYTE_STRING:
        isValid = value instanceof ByteString;
        break;
      case ENUM:
        isValid = value instanceof EnumValueDescriptor &&
                  ((EnumValueDescriptor) value).getType() == field.getEnumType();
        break;
      case MESSAGE:
        isValid = value instanceof Message && ((Message) value).getDescriptorForType() == field.getMessageType();
        break;
    }

    if (!isValid) {
      // When chaining calls to setField(), it can be hard to tell from
      // the stack trace which exact call failed, since the whole chain is
      // considered one line of code.  So, let's make sure to include the
      // field name and other useful info in the exception.
      throw new IllegalArgumentException(
          "Wrong object type used with protocol message reflection.  " +
          "Message type \"" +
          field.getContainingType()
              .getFullName() +
          "\", field \"" +
          (field.isExtension() ? field.getFullName() : field.getName()) +
          "\", value was type \"" +
          value.getClass()
              .getName() +
          "\".");
    }
  }

  // =================================================================
  // Parsing and serialization

  /**
   * See {@link Message#isInitialized()}.  Note:  Since {@code FieldSet} itself does not have any way of knowing about
   * required fields that aren't actually present in the set, it is up to the caller to check that all required fields
   * are present.
   */
  @SuppressWarnings("unchecked")
  public boolean isInitialized() {
    for (final Map.Entry<FieldDescriptor, Object> entry : this.fields.entrySet()) {
      final FieldDescriptor field = entry.getKey();
      if (field.getJavaType() == FieldDescriptor.JavaType.MESSAGE) {
        if (field.isRepeated()) {
          for (final Message element : (List<Message>) entry.getValue()) {
            if (!element.isInitialized()) {
              return false;
            }
          }
        } else {
          if (!((Message) entry.getValue()).isInitialized()) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /**
   * Like {@link #isInitialized()}, but also checks for the presence of all required fields in the given type.
   */
  public boolean isInitialized(final Descriptor type) {
    // Check that all required fields are present.
    for (final FieldDescriptor field : type.getFields()) {
      if (field.isRequired()) {
        if (!hasField(field)) {
          return false;
        }
      }
    }

    // Check that embedded messages are initialized.
    return isInitialized();
  }

  /**
   * See {@link Message.Builder#mergeFrom(Message)}.
   */
  @SuppressWarnings("unchecked")
  public void mergeFrom(final Message other) {
    // Note:  We don't attempt to verify that other's fields have valid
    //   types.  Doing so would be a losing battle.  We'd have to verify
    //   all sub-messages as well, and we'd have to make copies of all of
    //   them to insure that they don't change after verification (since
    //   the Message interface itself cannot enforce immutability of
    //   implementations).
    // TODO(kenton):  Provide a function somewhere called makeDeepCopy()
    //   which allows people to make secure deep copies of messages.

    for (final Map.Entry<FieldDescriptor, Object> entry : other.getAllFields().entrySet()) {
      final FieldDescriptor field = entry.getKey();
      if (field.isRepeated()) {
        List existingValue = (List) this.fields.get(field);
        if (existingValue == null) {
          existingValue = new ArrayList();
          this.fields.put(field, existingValue);
        }
        existingValue.addAll((List) entry.getValue());
      } else if (field.getJavaType() == FieldDescriptor.JavaType.MESSAGE) {
        final Message existingValue = (Message) this.fields.get(field);
        if (existingValue == null) {
          setField(field, entry.getValue());
        } else {
          setField(field, existingValue.newBuilderForType()
              .mergeFrom(existingValue)
              .mergeFrom((Message) entry.getValue())
              .build());
        }
      } else {
        setField(field, entry.getValue());
      }
    }
  }

  /**
   * Like {@link #mergeFrom(Message)}, but merges from another {@link FieldSet}.
   */
  @SuppressWarnings("unchecked")
  public void mergeFrom(final FieldSet other) {
    for (final Map.Entry<FieldDescriptor, Object> entry : other.fields.entrySet()) {
      final FieldDescriptor field = entry.getKey();
      final Object value = entry.getValue();

      if (field.isRepeated()) {
        List existingValue = (List) this.fields.get(field);
        if (existingValue == null) {
          existingValue = new ArrayList();
          this.fields.put(field, existingValue);
        }
        existingValue.addAll((List) value);
      } else if (field.getJavaType() == FieldDescriptor.JavaType.MESSAGE) {
        final Message existingValue = (Message) this.fields.get(field);
        if (existingValue == null) {
          setField(field, value);
        } else {
          setField(field, existingValue.newBuilderForType()
              .mergeFrom(existingValue)
              .mergeFrom((Message) value)
              .build());
        }
      } else {
        setField(field, value);
      }
    }
  }

  // TODO(kenton):  Move parsing code into AbstractMessage, since it no longer
  //   uses any special knowledge from FieldSet.

  /**
   * See {@link Message.Builder#mergeFrom(CodedInputStream)}.
   *
   * @param builder The {@code Builder} for the target message.
   */
  public static void mergeFrom(final CodedInputStream input, final UnknownFieldSet.Builder unknownFields,
                               final ExtensionRegistry extensionRegistry, final Message.Builder builder)
      throws java.io.IOException {
    while (true) {
      final int tag = input.readTag();
      if (tag == 0) {
        break;
      }

      if (!mergeFieldFrom(input, unknownFields, extensionRegistry, builder, tag)) {
        // end group tag
        break;
      }
    }
  }

  /**
   * Like {@link #mergeFrom(CodedInputStream, UnknownFieldSet.Builder, ExtensionRegistry, Message.Builder)}, but parses
   * a single field.
   *
   * @param tag The tag, which should have already been read.
   * @return {@code true} unless the tag is an end-group tag.
   */
  public static boolean mergeFieldFrom(final CodedInputStream input, final UnknownFieldSet.Builder unknownFields,
                                       final ExtensionRegistry extensionRegistry, final Message.Builder builder,
                                       final int tag) throws java.io.IOException {
    final Descriptor type = builder.getDescriptorForType();

    if (type.getOptions().getMessageSetWireFormat() && tag == WireFormat.MESSAGE_SET_ITEM_TAG) {
      mergeMessageSetExtensionFromCodedStream(input, unknownFields, extensionRegistry, builder);
      return true;
    }

    final int wireType = WireFormat.getTagWireType(tag);
    final int fieldNumber = WireFormat.getTagFieldNumber(tag);

    FieldDescriptor field;
    Message defaultInstance = null;

    if (type.isExtensionNumber(fieldNumber)) {
      final ExtensionRegistry.ExtensionInfo extension = extensionRegistry.findExtensionByNumber(type, fieldNumber);
      if (extension == null) {
        field = null;
      } else {
        field = extension.descriptor;
        defaultInstance = extension.defaultInstance;
      }
    } else {
      field = type.findFieldByNumber(fieldNumber);
    }

    if (field == null || wireType != WireFormat.getWireFormatForFieldType(field.getType())) {
      // Unknown field or wrong wire type.  Skip.
      return unknownFields.mergeFieldFrom(tag, input);
    } else {
      Object value;
      switch (field.getType()) {
        case GROUP: {
          Message.Builder subBuilder;
          if (defaultInstance != null) {
            subBuilder = defaultInstance.newBuilderForType();
          } else {
            subBuilder = builder.newBuilderForField(field);
          }
          if (!field.isRepeated()) {
            subBuilder.mergeFrom((Message) builder.getField(field));
          }
          input.readGroup(field.getNumber(), subBuilder, extensionRegistry);
          value = subBuilder.build();
          break;
        }
        case MESSAGE: {
          Message.Builder subBuilder;
          if (defaultInstance != null) {
            subBuilder = defaultInstance.newBuilderForType();
          } else {
            subBuilder = builder.newBuilderForField(field);
          }
          if (!field.isRepeated()) {
            subBuilder.mergeFrom((Message) builder.getField(field));
          }
          input.readMessage(subBuilder, extensionRegistry);
          value = subBuilder.build();
          break;
        }
        case ENUM: {
          final int rawValue = input.readEnum();
          value = field.getEnumType().findValueByNumber(rawValue);
          // If the number isn't recognized as a valid value for this enum,
          // drop it.
          if (value == null) {
            unknownFields.mergeVarintField(fieldNumber, rawValue);
            return true;
          }
          break;
        }
        default:
          value = input.readPrimitiveField(field.getType());
          break;
      }

      if (field.isRepeated()) {
        builder.addRepeatedField(field, value);
      } else {
        builder.setField(field, value);
      }
    }

    return true;
  }

  /**
   * Called by {@code #mergeFieldFrom()} to parse a MessageSet extension.
   */
  private static void mergeMessageSetExtensionFromCodedStream(final CodedInputStream input,
                                                              final UnknownFieldSet.Builder unknownFields,
                                                              final ExtensionRegistry extensionRegistry,
                                                              final Message.Builder builder)
      throws java.io.IOException {
    final Descriptor type = builder.getDescriptorForType();

    // The wire format for MessageSet is:
    //   message MessageSet {
    //     repeated group Item = 1 {
    //       required int32 typeId = 2;
    //       required bytes message = 3;
    //     }
    //   }
    // "typeId" is the extension's field number.  The extension can only be
    // a message type, where "message" contains the encoded bytes of that
    // message.
    //
    // In practice, we will probably never see a MessageSet item in which
    // the message appears before the type ID, or where either field does not
    // appear exactly once.  However, in theory such cases are valid, so we
    // should be prepared to accept them.

    int typeId = 0;
    ByteString rawBytes = null;  // If we encounter "message" before "typeId"
    Message.Builder subBuilder = null;
    FieldDescriptor field = null;

    while (true) {
      final int tag = input.readTag();
      if (tag == 0) {
        break;
      }

      if (tag == WireFormat.MESSAGE_SET_TYPE_ID_TAG) {
        typeId = input.readUInt32();
        // Zero is not a valid type ID.
        if (typeId != 0) {
          final ExtensionRegistry.ExtensionInfo extension = extensionRegistry.findExtensionByNumber(type, typeId);
          if (extension != null) {
            field = extension.descriptor;
            subBuilder = extension.defaultInstance.newBuilderForType();
            final Message originalMessage = (Message) builder.getField(field);
            if (originalMessage != null) {
              subBuilder.mergeFrom(originalMessage);
            }
            if (rawBytes != null) {
              // We already encountered the message.  Parse it now.
              subBuilder.mergeFrom(CodedInputStream.newInstance(rawBytes.newInput()));
              rawBytes = null;
            }
          } else {
            // Unknown extension number.  If we already saw data, put it
            // in rawBytes.
            if (rawBytes != null) {
              unknownFields.mergeField(typeId, UnknownFieldSet.Field.newBuilder()
                  .addLengthDelimited(rawBytes)
                  .build());
              rawBytes = null;
            }
          }
        }
      } else if (tag == WireFormat.MESSAGE_SET_MESSAGE_TAG) {
        if (typeId == 0) {
          // We haven't seen a type ID yet, so we have to store the raw bytes
          // for now.
          rawBytes = input.readBytes();
        } else if (subBuilder == null) {
          // We don't know how to parse this.  Ignore it.
          unknownFields.mergeField(typeId, UnknownFieldSet.Field.newBuilder()
              .addLengthDelimited(input.readBytes())
              .build());
        } else {
          // We already know the type, so we can parse directly from the input
          // with no copying.  Hooray!
          input.readMessage(subBuilder, extensionRegistry);
        }
      } else {
        // Unknown tag.  Skip it.
        if (!input.skipField(tag)) {
          break;  // end of group
        }
      }
    }

    input.checkLastTagWas(WireFormat.MESSAGE_SET_ITEM_END_TAG);

    if (subBuilder != null) {
      builder.setField(field, subBuilder.build());
    }
  }

  /**
   * See {@link Message#writeTo(CodedOutputStream)}.
   */
  public void writeTo(final CodedOutputStream output) throws java.io.IOException {
    for (final Map.Entry<FieldDescriptor, Object> entry : this.fields.entrySet()) {
      writeField(entry.getKey(), entry.getValue(), output);
    }
  }

  /**
   * Write a single field.
   */
  @SuppressWarnings("unchecked")
  public void writeField(final FieldDescriptor field, final Object value, final CodedOutputStream output)
      throws java.io.IOException {
    if (field.isExtension() && field.getContainingType().getOptions().getMessageSetWireFormat()) {
      output.writeMessageSetExtension(field.getNumber(), (Message) value);
    } else {
      if (field.isRepeated()) {
        for (final Object element : (List<Object>) value) {
          output.writeField(field.getType(), field.getNumber(), element);
        }
      } else {
        output.writeField(field.getType(), field.getNumber(), value);
      }
    }
  }

  /**
   * See {@link Message#getSerializedSize()}.  It's up to the caller to cache the resulting size if desired.
   */
  @SuppressWarnings("unchecked")
  public int getSerializedSize() {
    int size = 0;
    for (final Map.Entry<FieldDescriptor, Object> entry : this.fields.entrySet()) {
      final FieldDescriptor field = entry.getKey();
      final Object value = entry.getValue();

      if (field.isExtension() && field.getContainingType().getOptions().getMessageSetWireFormat()) {
        size += CodedOutputStream.computeMessageSetExtensionSize(field.getNumber(), (Message) value);
      } else {
        if (field.isRepeated()) {
          for (final Object element : (List<Object>) value) {
            size += CodedOutputStream.computeFieldSize(field.getType(), field.getNumber(), element);
          }
        } else {
          size += CodedOutputStream.computeFieldSize(field.getType(), field.getNumber(), value);
        }
      }
    }
    return size;
  }
}
