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

/**
 * Abstract interface implemented by Protocol Message objects.
 *
 * @author Cyrus Najmabadi
 */
@protocol PBMessage<NSObject>
/**
 * Get the message's type's descriptor.  This differs from the
 * {@code getDescriptor()} method of generated message classes in that
 * this method is an abstract method of the {@code Message} interface
 * whereas {@code getDescriptor()} is a static method of a specific class.
 * They return the same thing.
 */
- (PBDescriptor*) descriptor;

/**
 * Get an instance of the type with all fields set to their default values.
 * This may or may not be a singleton.  This differs from the
 * {@code getDefaultInstance()} method of generated message classes in that
 * this method is an abstract method of the {@code Message} interface
 * whereas {@code getDefaultInstance()} is a static method of a specific
 * class.  They return the same thing.
 */
- (id<PBMessage>) defaultInstance;

/**
 * Returns a collection of all the fields in this message which are set
 * and their corresponding values.  A singular ("required" or "optional")
 * field is set iff hasField() returns true for that field.  A "repeated"
 * field is set iff getRepeatedFieldSize() is greater than zero.  The
 * values are exactly what would be returned by calling
 * {@link #getField(Descriptors.FieldDescriptor)} for each field.  The map
 * is guaranteed to be a sorted map, so iterating over it will return fields
 * in order by field number.
 */
- (NSDictionary*) allFields;

/**
 * Returns true if the given field is set.  This is exactly equivalent to
 * calling the generated "has" accessor method corresponding to the field.
 * @throws IllegalArgumentException The field is a repeated field, or
 *           {@code field.getContainingType() != getDescriptorForType()}.
 */
- (BOOL) hasField:(PBFieldDescriptor*) field;

/**
 * Obtains the value of the given field, or the default value if it is
 * not set.  For primitive fields, the boxed primitive value is returned.
 * For enum fields, the EnumValueDescriptor for the value is returend. For
 * embedded message fields, the sub-message is returned.  For repeated
 * fields, a java.util.List is returned.
 */
- (id) getField:(PBFieldDescriptor*) field;
- (NSArray*) getRepeatedField:(PBFieldDescriptor*) field;

- (PBUnknownFieldSet*) unknownFields;

/**
 * Returns true if all required fields in the message and all embedded
 * messages are set, false otherwise.
 */
- (BOOL) isInitialized;

/**
 * Get the number of bytes required to encode this message.  The result
 * is only computed on the first call and memoized after that.
 */
- (int32_t) serializedSize;

/**
 * Serializes the message and writes it to {@code output}.  This does not
 * flush or close the stream.
 */
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;

/**
 * Serializes the message and writes it to {@code output}.  This is just a
 * trivial wrapper around {@link #writeTo(CodedOutputStream)}.  This does
 * not flush or close the stream.
 */
- (void) writeToOutputStream:(NSOutputStream*) output;

/**
 * Serializes the message to a {@code ByteString} and returns it. This is
 * just a trivial wrapper around
 * {@link #writeTo(CodedOutputStream)}.
 */
- (NSData*) data;

/**
 * Constructs a new builder for a message of the same type as this message.
 */
- (id<PBMessage_Builder>) builder;
@end