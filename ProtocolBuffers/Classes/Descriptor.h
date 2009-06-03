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

#import "GenericDescriptor.h"

#if 0
/**
 * Contains a collection of classes which describe protocol message types.
 *
 * Every message type has a {@link PbDescriptor}, which lists all
 * its fields and other information about a type.  You can get a message
 * type's descriptor by calling {@code [MessageType descriptor]}, or
 * (given a message object of the type) {@code message.descriptor}.
 *
 * Descriptors are built from DescriptorProtos, as defined in
 * {@code net/proto2/proto/descriptor.proto}.
 *
 * @author Cyrus Najmabadi
 */
@interface PBDescriptor : NSObject<PBGenericDescriptor> {
  @private
    int32_t index;
    PBDescriptorProto* proto;
    NSString* fullName;
    PBFileDescriptor* file;
    // TODO(cyrusn): circularity between us and our containing type
    PBDescriptor* containingType;
    NSMutableArray* mutableNestedTypes;
    NSMutableArray* mutableEnumTypes;
    NSMutableArray* mutableFields;
    NSMutableArray* mutableExtensions;
}

/**
 * Get the index of this descriptor within its parent.  In other words,
 * given a {@link FileDescriptor} {@code file}, the following is true:
 * <pre>
 *   for all i in [0, file.getMessageTypeCount()):
 *     file.getMessageType(i).getIndex() == i
 * </pre>
 * Similarly, for a {@link Descriptor} {@code messageType}:
 * <pre>
 *   for all i in [0, messageType.getNestedTypeCount()):
 *     messageType.getNestedType(i).getIndex() == i
 * </pre>
 */
@property (readonly) int32_t index;
@property (readonly, retain) PBDescriptorProto* proto;

/**
 * Get the type's fully-qualified name, within the proto language's
 * namespace.  This differs from the Java name.  For example, given this
 * {@code .proto}:
 * <pre>
 *   package foo.bar;
 *   option java_package = "com.example.protos"
 *   message Baz {}
 * </pre>
 * {@code Baz}'s full name is "foo.bar.Baz".
 */
@property (readonly, copy) NSString* fullName;
@property (readonly, retain) PBFileDescriptor* file;

/** If this is a nested type, get the outer descriptor, otherwise null. */
@property (readonly, retain) PBDescriptor* containingType;

- (NSArray*) nestedTypes;
- (NSArray*) enumTypes;
- (NSArray*) fields;
- (NSArray*) extensions;

+ (PBDescriptor*) descriptorWithProto:(PBDescriptorProto*) proto
                                 file:(PBFileDescriptor*) file
                               parent:(PBDescriptor*) parent
                                index:(int32_t) index;

+ (NSString*) computeFullName:(PBFileDescriptor*) file
                       parent:(PBDescriptor*) parent
                         name:(NSString*) name;

- (NSArray*) fields;
- (PBMessageOptions*) options;
- (NSString*) fullName;
- (NSArray*) enumTypes;
- (NSArray*) extensions;

- (BOOL) isExtensionNumber:(int32_t) number;

/**
 * Finds a field by name.
 * @param name The unqualified name of the field (e.g. "foo").
 * @return The field's descriptor, or {@code nil} if not found.
 */
- (PBFieldDescriptor*) findFieldByName:(NSString*) name;

/**
 * Finds a field by field number.
 * @param number The field number within this message type.
 * @return The field's descriptor, or {@code nil} if not found.
 */
- (PBFieldDescriptor*) findFieldByNumber:(int32_t) number;

/**
 * Finds a nested message type by name.
 * @param name The unqualified name of the nested type (e.g. "Foo").
 * @return The types's descriptor, or {@code nil} if not found.
 */
- (PBDescriptor*) findNestedTypeByName:(NSString*) name;

/**
 * Finds a nested enum type by name.
 * @param name The unqualified name of the nested type (e.g. "Foo").
 * @return The types's descriptor, or {@code nil} if not found.
 */
- (PBEnumDescriptor*) findEnumTypeByName:(NSString*) name;

// @internal
- (void) crossLink;

@end

#endif