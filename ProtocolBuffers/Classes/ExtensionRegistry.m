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

#import "ExtensionRegistry.h"

#import "Descriptor.pb.h"
#import "Descriptor.h"
#import "DescriptorIntPair.h"
#import "ExtensionInfo.h"
#import "FieldDescriptor.h"

@implementation PBExtensionRegistry


static PBExtensionRegistry* EMPTY = nil;


+ (void) initialize {
    if (self = [PBExtensionRegistry class]) {
        EMPTY = [[PBExtensionRegistry alloc] initWithExtensionsByName:[NSMutableDictionary dictionary]
                                                 extensionsByNumber:[NSMutableDictionary dictionary]];
    }
}


@synthesize extensionsByName;
@synthesize extensionsByNumber;


- (void) dealloc {
    self.extensionsByName = nil;
    self.extensionsByNumber = nil;

    [super dealloc];
}


+ (PBExtensionRegistry*) getEmptyRegistry {
    return EMPTY;
}


+ (PBExtensionRegistry*) newInstance {
    return [[[PBExtensionRegistry alloc] initWithExtensionsByName:[NSMutableDictionary dictionary]
                                             extensionsByNumber:[NSMutableDictionary dictionary]] autorelease];
}


- (id) initWithExtensionsByName:(NSMutableDictionary*) extensionsByName_
             extensionsByNumber:(NSMutableDictionary*) extensionsByNumber_ {
    if (self = [super init]) {
        self.extensionsByName = extensionsByName_;
        self.extensionsByNumber = extensionsByNumber_;
    }

    return self;
}


- (PBExtensionInfo*) findExtensionByName:(NSString*) fullName {
    return [extensionsByName objectForKey:fullName];
}


- (PBExtensionInfo*) findExtensionByNumber:(PBDescriptor*) containingType
                                               fieldNumber:(int32_t) fieldNumber {
    return [extensionsByNumber objectForKey:[PBDescriptorIntPair pairWithDescriptor:containingType number:fieldNumber]];
}

#if 0
- (void) addExtension:(PBGeneratedExtension*) extension {
    if (extension.getDescriptor.getObjectiveCType == PBFieldDescriptorTypeMessage) {
        [self addExtensionInfo:[PBExtensionInfo infoWithDescriptor:extension.getDescriptor defaultInstance:extension.getMessageDefaultInstance]];
    } else {
        [self addExtensionInfo:[PBExtensionInfo infoWithDescriptor:extension.getDescriptor defaultInstance:nil]];
    }
}
#endif


- (void) addFieldDescriptor:(PBFieldDescriptor*) type {
    if (type.getObjectiveCType == PBFieldDescriptorTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"ExtensionRegistry.add() must be provided a default instance when adding an embedded message extension." userInfo:nil];
    }

    [self addExtensionInfo:[PBExtensionInfo infoWithDescriptor:type defaultInstance:nil]];
}


- (void) addFieldDescriptor:(PBFieldDescriptor*) type
            defaultInstance:(id<PBMessage>) defaultInstance {
    if (type.getObjectiveCType != PBFieldDescriptorTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"ExtensionRegistry.add() provided a default instance for a non-message extension."
                                     userInfo:nil];
    }

    [self addExtensionInfo:[PBExtensionInfo infoWithDescriptor:type defaultInstance:defaultInstance]];
}


- (void) addExtensionInfo:(PBExtensionInfo*) extension {
    if (!extension.descriptor.isExtension) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"ExtensionRegistry.add() was given a PBFieldDescriptor for a regular (non-extension) field."
                                     userInfo:nil];
    }

    [extensionsByName setObject:extension
                         forKey:extension.descriptor.getFullName];
    [extensionsByNumber setObject:extension
                           forKey:[PBDescriptorIntPair pairWithDescriptor:extension.descriptor.getContainingType
                                                                                   number:extension.descriptor.getNumber]];

    PBFieldDescriptor* field = extension.descriptor;

    if (field.getContainingType.getOptions.getMessageSetWireFormat &&
        field.getType == PBFieldDescriptorTypeMessage &&
        field.isOptional &&
        field.getExtensionScope == field.getMessageType) {
        // This is an extension of a MessageSet type defined within the extension
        // type's own scope.  For backwards-compatibility, allow it to be looked
        // up by type name.
        [extensionsByName setObject:extension forKey:field.getMessageType.getFullName];
    }
}

@end
