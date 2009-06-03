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

#if 0
/**
 * Type used to represent generated extensions.  The protocol compiler
 * generates a static singleton instance of this class for each extension.
 *
 * <p>For example, imagine you have the {@code .proto} file:
 *
 * <pre>
 * option java_class = "MyProto";
 *
 * message Foo {
 *   extensions 1000 to max;
 * }
 *
 * extend Foo {
 *   optional int32 bar;
 * }
 * </pre>
 *
 * <p>Then, {@code MyProto.Foo.bar} has type
 * {@code GeneratedExtension<MyProto.Foo, Integer>}.
 *
 * <p>In general, users should ignore the details of this type, and simply use
 * these static singletons as parameters to the extension accessors defined
 * in {@link ExtendableMessage} and {@link ExtendableBuilder}.
 */
@interface PBGeneratedExtension : NSObject {
  @private
    PBFieldDescriptor* descriptor;
    Class type;
    SEL enumValueOf;
    SEL enumGetValueDescriptor;
    id<PBMessage> messageDefaultInstance;
}

@property (readonly, retain) PBFieldDescriptor* descriptor;

/**
 * If the extension is an embedded message or group, returns the default
 * instance of the message.
 */
@property (readonly, retain) id<PBMessage> messageDefaultInstance;

+ (PBGeneratedExtension*) extensionWithDescriptor:(PBFieldDescriptor*) descriptor
                                             type:(Class) type;

/**
 * Convert from the type used by the native accessors to the type used
 * by reflection accessors.  E.g., for enums, the reflection accessors use
 * EnumValueDescriptors but the native accessors use the generated enum
 * type.
 */
- (id) toReflectionType:(id) value;

/**
 * Like {@link #toReflectionType(Object)}, but if the type is a repeated
 * type, this converts a single element.
 */
- (id) singularToReflectionType:(id) value;

/**
 * Convert from the type used by the reflection accessors to the type used
 * by native accessors.  E.g., for enums, the reflection accessors use
 * EnumValueDescriptors but the native accessors use the generated enum
 * type.
 */
- (id) fromReflectionType:(id) value;

/**
 * Like {@link #fromReflectionType(Object)}, but if the type is a repeated
 * type, this converts a single element.
 */
- (id) singularFromReflectionType:(id) value;

@end
#endif