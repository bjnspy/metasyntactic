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

/** Describes a field of a message type. */
@interface PBFieldDescriptor : NSObject<PBGenericDescriptor,NSCopying> {
  @private
    int32_t index;

    PBFieldDescriptorProto* proto;
    NSString* fullName;

    // TODO(cyrusn): circularity between us and our containing file
    PBFileDescriptor* file;
    PBDescriptor* extensionScope;

    // Possibly initialized during cross-linking.
    PBFieldDescriptorType type;

    // TODO(cyrusn): circularity between us and our containing type
    PBDescriptor* containingType;
    PBDescriptor* messageType;
    PBEnumDescriptor* enumType;
    id defaultValue;
}

@property (readonly) int32_t index;
@property (readonly, retain) PBFieldDescriptorProto* proto;
@property (readonly, copy) NSString* fullName;
@property (readonly, retain) PBFileDescriptor* file;
@property (readonly) PBFieldDescriptorType type;
@property (readonly, retain) PBDescriptor* messageType;
@property (readonly, retain) PBEnumDescriptor* enumType;


/**
 * For extensions defined nested within message types, gets the outer
 * type.  Not valid for non-extension fields.  For example, consider
 * this {@code .proto} file:
 * <pre>
 *   message Foo {
 *     extensions 1000 to max;
 *   }
 *   extend Foo {
 *     optional int32 baz = 1234;
 *   }
 *   message Bar {
 *     extend Foo {
 *       optional int32 qux = 4321;
 *     }
 *   }
 * </pre>
 * Both {@code baz}'s and {@code qux}'s containing type is {@code Foo}.
 * However, {@code baz}'s extension scope is {@code nil} while
 * {@code qux}'s extension scope is {@code Bar}.
 */
@property (readonly, retain) PBDescriptor* extensionScope;

/**
 * Get the field's containing type. For extensions, this is the type being
 * extended, not the location where the extension was defined.  See
 * {@link #getExtensionScope()}.
 */
@property (readonly, retain) PBDescriptor* containingType;


/**
 * Returns the field's default value.  Valid for all types except for
 * messages and groups.  For all other types, the object returned is of
 * the same class that would returned by Message.getField(this).
 */
@property (readonly, retain) id defaultValue;

+ (PBFieldDescriptor*) descriptorWithProto:(PBFieldDescriptorProto*) proto
                                      file:(PBFileDescriptor*) file
                                    parent:(PBDescriptor*) parent
                                     index:(int32_t) index
                               isExtension:(BOOL) isExtension;

- (BOOL) isRequired;
- (BOOL) isRepeated;
- (BOOL) isExtension;
- (BOOL) isOptional;
- (PBObjectiveCType) objectiveCType;

- (int32_t) number;

- (PBFieldOptions*) options;

- (BOOL) hasDefaultValue;
- (id) defaultValue;

// @internal
- (void) crossLink;

@end