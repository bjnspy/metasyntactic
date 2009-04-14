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

#import "ExtensionRegistry.h"

#import "Descriptor.h"
#import "Descriptor.pb.h"
#import "ExtensionInfo.h"
#import "ExtensionRegistry_DescriptorIntPair.h"
#import "FieldDescriptor.h"


@interface PBExtensionRegistry ()
    @property (retain) NSMutableDictionary* extensionsByName;
    @property (retain) NSMutableDictionary* extensionsByNumber;
@end


@implementation PBExtensionRegistry


static PBExtensionRegistry* EMPTY = nil;


+ (void) initialize {
    if (self = [PBExtensionRegistry class]) {
        EMPTY = [[PBExtensionRegistry registryWithExtensionsByName:[NSMutableDictionary dictionary]
                                                extensionsByNumber:[NSMutableDictionary dictionary]] retain];
    }
}


@synthesize extensionsByName;
@synthesize extensionsByNumber;


- (void) dealloc {
    self.extensionsByName = nil;
    self.extensionsByNumber = nil;

    [super dealloc];
}


+ (PBExtensionRegistry*) emptyRegistry {
    return EMPTY;
}


- (id) initWithExtensionsByName:(NSMutableDictionary*) extensionsByName_
             extensionsByNumber:(NSMutableDictionary*) extensionsByNumber_ {
    if (self = [super init]) {
        self.extensionsByName = extensionsByName_;
        self.extensionsByNumber = extensionsByNumber_;
    }

    return self;
}


+ (PBExtensionRegistry*) registryWithExtensionsByName:(NSMutableDictionary*) extensionsByName
                                   extensionsByNumber:(NSMutableDictionary*) extensionsByNumber {
    return [[[PBExtensionRegistry alloc] initWithExtensionsByName:extensionsByName
                                               extensionsByNumber:extensionsByNumber] autorelease];
}


+ (PBExtensionRegistry*) registry {
    return [[[PBExtensionRegistry alloc] initWithExtensionsByName:[NSMutableDictionary dictionary]
                                               extensionsByNumber:[NSMutableDictionary dictionary]] autorelease];
}


- (PBExtensionInfo*) findExtensionByName:(NSString*) fullName {
    return [extensionsByName objectForKey:fullName];
}


- (PBExtensionInfo*) findExtensionByNumber:(PBDescriptor*) containingType
                               fieldNumber:(int32_t) fieldNumber {
    return [extensionsByNumber objectForKey:[PBExtensionRegistry_DescriptorIntPair pairWithDescriptor:containingType number:fieldNumber]];
}


- (void) addExtension:(PBGeneratedExtension*) extension {
    if (extension.descriptor.objectiveCType == PBObjectiveCTypeMessage) {
        [self addExtensionInfo:[PBExtensionInfo infoWithDescriptor:extension.descriptor defaultInstance:extension.messageDefaultInstance]];
    } else {
        [self addExtensionInfo:[PBExtensionInfo infoWithDescriptor:extension.descriptor defaultInstance:nil]];
    }
}


- (void) addFieldDescriptor:(PBFieldDescriptor*) type {
    if (type.objectiveCType == PBObjectiveCTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"ExtensionRegistry.add() must be provided a default instance when adding an embedded message extension." userInfo:nil];
    }

    [self addExtensionInfo:[PBExtensionInfo infoWithDescriptor:type defaultInstance:nil]];
}


- (void) addFieldDescriptor:(PBFieldDescriptor*) type
            defaultInstance:(id<PBMessage>) defaultInstance {
    if (type.objectiveCType != PBFieldDescriptorTypeMessage) {
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
                         forKey:extension.descriptor.fullName];
    [extensionsByNumber setObject:extension
                           forKey:[PBExtensionRegistry_DescriptorIntPair pairWithDescriptor:extension.descriptor.containingType
                           number:extension.descriptor.number]];

    PBFieldDescriptor* field = extension.descriptor;

    if (field.containingType.options.messageSetWireFormat &&
        field.type == PBFieldDescriptorTypeMessage &&
        field.isOptional &&
        field.extensionScope == field.messageType) {
        // This is an extension of a MessageSet type defined within the extension
        // type's own scope.  For backwards-compatibility, allow it to be looked
        // up by type name.
        [extensionsByName setObject:extension forKey:field.messageType.fullName];
    }
}

@end