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
 * Describes a {@code .proto} file, including everything defined within.
 */
@interface PBFileDescriptor : NSObject {
  @private
    PBFileDescriptorProto* proto;
    NSMutableArray* mutableMessageTypes;
    NSMutableArray* mutableExtensions;
    NSMutableArray* mutableEnumTypes;
    NSMutableArray* mutableServices;
    NSMutableArray* mutableDependencies;

    // TODO(cyrusn): circularity betwen us and the pool.
    PBDescriptorPool* pool;
}

@property (readonly, retain) PBFileDescriptorProto* proto;
@property (readonly, retain) PBDescriptorPool* pool;

/**
 * Construct a {@code FileDescriptor}.
 *
 * @param proto The protocol message form of the FileDescriptor.
 * @param dependencies {@code FileDescriptor}s corresponding to all of
 *                     the file's dependencies, in the exact order listed
 *                     in {@code proto}.
 * @throws DescriptorValidation {@code proto} is not a valid
 *           descriptor.  This can occur for a number of reasons, e.g.
 *           because a field has an undefined type or because two messages
 *           were defined with the same name.
 */
+ (PBFileDescriptor*) buildFrom:(PBFileDescriptorProto*) proto
                   dependencies:(NSArray*) dependencies;

- (NSArray*) messageTypes;
- (NSArray*) extensions;
- (NSArray*) enumTypes;
- (NSArray*) services;
- (NSArray*) dependencies;

- (NSString*) package;
- (NSString*) name;

- (PBFileOptions*) options;

- (void) crossLink;

/**
 * Find a message type in the file by name.  Does not find nested types.
 *
 * @param name The unqualified type name to look for.
 * @return The message type's descriptor, or {@code nil} if not found.
 */
- (PBDescriptor*) findMessageTypeByName:(NSString*) name;

/**
 * Find an enum type in the file by name.  Does not find nested types.
 *
 * @param name The unqualified type name to look for.
 * @return The enum type's descriptor, or {@code nil} if not found.
 */
- (PBEnumDescriptor*) findEnumTypeByName:(NSString*) name;

/**
 * Find a service type in the file by name.
 *
 * @param name The unqualified type name to look for.
 * @return The service type's descriptor, or {@code nil} if not found.
 */
- (PBServiceDescriptor*) findServiceByName:(NSString*) name;

/**
 * Find an extension in the file by name.  Does not find extensions nested
 * inside message types.
 *
 * @param name The unqualified extension name to look for.
 * @return The extension's descriptor, or {@code nil} if not found.
 */
- (PBFieldDescriptor*) findExtensionByName:(NSString*) name;

@end

#endif