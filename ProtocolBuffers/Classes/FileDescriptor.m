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

#import "FileDescriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"
#import "FieldDescriptor.h"
#import "ServiceDescriptor.h"

@interface PBFileDescriptor ()
    @property (retain) NSMutableArray* mutableMessageTypes;
    @property (retain) NSMutableArray* mutableExtensions;
    @property (retain) NSMutableArray* mutableEnumTypes;
    @property (retain) NSMutableArray* mutableServices;
    @property (retain) NSMutableArray* mutableDependencies;
    @property (retain) PBFileDescriptorProto* proto;
    @property (retain) PBDescriptorPool* pool;
@end


@implementation PBFileDescriptor

@synthesize proto;
@synthesize mutableMessageTypes;
@synthesize mutableExtensions;
@synthesize mutableEnumTypes;
@synthesize mutableServices;
@synthesize mutableDependencies;
@synthesize pool;

- (void) dealloc {
    self.proto;
    self.mutableMessageTypes = nil;
    self.mutableExtensions = nil;
    self.mutableEnumTypes = nil;
    self.mutableServices = nil;
    self.mutableDependencies = nil;
    self.pool = nil;

    [super dealloc];
}


- (NSString*) package {
    return proto.package;
}


- (NSString*) name {
    return proto.name;
}


- (PBFileOptions*) options {
    return proto.options;
}


- (id) initWithProto:(PBFileDescriptorProto*) proto_
        dependencies:(NSArray*) dependencies_
                pool:(PBDescriptorPool*) pool_ {
    if (self = [super init]) {
        self.pool = pool_;
        self.proto = proto_;
        self.mutableDependencies = [NSMutableArray arrayWithArray:dependencies_];

        [pool addPackage:self.package file:self];

        self.mutableMessageTypes = [NSMutableArray array];
        for (PBDescriptorProto* m in proto.messageTypeList) {
            [mutableMessageTypes addObject:[PBDescriptor descriptorWithProto:m file:self parent:nil index:mutableMessageTypes.count]];
        }

        self.mutableEnumTypes = [NSMutableArray array];
        for (PBEnumDescriptorProto* e in proto.enumTypeList) {
            [mutableEnumTypes addObject:[PBEnumDescriptor descriptorWithProto:e file:self parent:nil index:mutableEnumTypes.count]];
        }

        self.mutableServices = [NSMutableArray array];
        for (PBServiceDescriptorProto* s in proto.serviceList) {
            [mutableServices addObject:[PBServiceDescriptor descriptorWithProto:s file:self index:mutableServices.count]];
        }

        self.mutableExtensions = [NSMutableArray array];
        for (PBFieldDescriptorProto* f in proto.extensionList) {
            [mutableExtensions addObject:[PBFieldDescriptor descriptorWithProto:f
                                                                           file:self
                                                                         parent:nil
                                                                          index:mutableExtensions.count
                                                                    isExtension:YES]];
        }
    }

    return self;
}


- (NSArray*) messageTypes {
    return mutableMessageTypes;
}


- (NSArray*) extensions {
    return mutableExtensions;
}


- (NSArray*) enumTypes {
    return mutableEnumTypes;
}


- (NSArray*) services {
    return mutableServices;
}


- (NSArray*) dependencies {
    return mutableDependencies;
}


+ (PBFileDescriptor*) descriptorWithProto:(PBFileDescriptorProto*) proto
                           dependencies:(NSArray*) dependencies
                                   pool:(PBDescriptorPool*) pool {
    return [[[PBFileDescriptor alloc] initWithProto:proto
                                     dependencies:dependencies
                                             pool:pool] autorelease];
}



/**
 * Construct a {@code FileDescriptor}.
 *
 * @param proto The protocol message form of the FileDescriptor.
 * @param dependencies {@code FileDescriptor}s corresponding to all of
 *                     the file's dependencies, in the exact order listed
 *                     in {@code proto}.
 * @throws DescriptorValidationException {@code proto} is not a valid
 *           descriptor.  This can occur for a number of reasons, e.g.
 *           because a field has an undefined type or because two messages
 *           were defined with the same name.
 */
+ (PBFileDescriptor*) buildFrom:(PBFileDescriptorProto*) proto dependencies:(NSArray*) dependencies {
    // Building decsriptors involves two steps:  translating and linking.
    // In the translation step (implemented by PBFileDescriptor's
    // constructor), we build an object tree mirroring the
    // FileDescriptorProto's tree and put all of the descriptors into the
    // PBDescriptorPool's lookup tables.  In the linking step, we look up all
    // type references in the PBDescriptorPool, so that, for example, a
    // PBFieldDescriptor for an embedded message contains a pointer directly
    // to the PBDescriptor for that message's type.  We also detect undefined
    // types in the linking step.
    PBDescriptorPool* pool = [PBDescriptorPool poolWithDependencies:dependencies];
    PBFileDescriptor* result = [PBFileDescriptor descriptorWithProto:proto dependencies:dependencies pool:pool];

    if (dependencies.count != proto.dependencyList.count) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    }

    for (int i = 0; i < proto.dependencyList.count; i++) {
        if (![[[dependencies objectAtIndex:i] name] isEqual:[proto dependencyAtIndex:i]]) {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
        }
    }

    [result crossLink];
    return result;
}


/** Look up and cross-link all field types, etc. */
- (void) crossLink {
    for (PBDescriptor* d in self.messageTypes) {
        [d crossLink];
    }

    for (PBServiceDescriptor* s in self.services) {
        [s crossLink];
    }

    for (PBFieldDescriptor* f in self.extensions) {
        [f crossLink];
    }
}


/**
 * Find a message type in the file by name.  Does not find nested types.
 *
 * @param name The unqualified type name to look for.
 * @return The message type's descriptor, or {@code nil} if not found.
 */
- (PBDescriptor*) findMessageTypeByName:(NSString*) name {
    // Don't allow looking up nested types.  This will make optimization
    // easier later.
    if ([name rangeOfString:@"."].length > 0) {
        return nil;
    }

    if (self.package.length > 0) {
        name = [NSString stringWithFormat:@"%@.%@", self.package, name];
    }
    id result = [pool findSymbol:name];
    if (result != nil &&
        [result isKindOfClass:[PBDescriptor class]] &&
        [result file] == self) {
        return result;
    } else {
        return nil;
    }
}

/**
 * Find an enum type in the file by name.  Does not find nested types.
 *
 * @param name The unqualified type name to look for.
 * @return The enum type's descriptor, or {@code nil} if not found.
 */
- (PBEnumDescriptor*) findEnumTypeByName:(NSString*) name {
    // Don't allow looking up nested types.  This will make optimization
    // easier later.
    if ([name rangeOfString:@"."].length > 0) {
        return nil;
    }

    if (self.package.length > 0) {
        name = [NSString stringWithFormat:@"%@.%@", self.package, name];
    }
    id result = [pool findSymbol:name];
    if (result != nil &&
        [result isKindOfClass:[PBEnumDescriptor class]] &&
        [result file] == self) {
        return result;
    } else {
        return nil;
    }
}


/**
 * Find a service type in the file by name.
 *
 * @param name The unqualified type name to look for.
 * @return The service type's descriptor, or {@code nil} if not found.
 */
- (PBServiceDescriptor*) findServiceByName:(NSString*) name {
    // Don't allow looking up nested types.  This will make optimization
    // easier later.
    if ([name rangeOfString:@"."].length > 0) {
        return nil;
    }

    if (self.package.length > 0) {
        name = [NSString stringWithFormat:@"%@.%@", self.package, name];
    }
    id result = [pool findSymbol:name];
    if (result != nil &&
        [result isKindOfClass:[PBServiceDescriptor class]] &&
        [result file] == self) {
        return result;
    } else {
        return nil;
    }
}


/**
 * Find an extension in the file by name.  Does not find extensions nested
 * inside message types.
 *
 * @param name The unqualified extension name to look for.
 * @return The extension's descriptor, or {@code nil} if not found.
 */
- (PBFieldDescriptor*) findExtensionByName:(NSString*) name {
    // Don't allow looking up nested types.  This will make optimization
    // easier later.
    if ([name rangeOfString:@"."].length > 0) {
        return nil;
    }

    if (self.package.length > 0) {
        name = [NSString stringWithFormat:@"%@.%@", self.package, name];
    }
    id result = [pool findSymbol:name];
    if (result != nil &&
        [result isKindOfClass:[PBFieldDescriptor class]] &&
        [result file] == self) {
        return result;
    } else {
        return nil;
    }
}

@end