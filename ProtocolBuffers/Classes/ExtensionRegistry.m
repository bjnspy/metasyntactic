// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ExtensionRegistry.h"

#import "Descriptor.h"
#import "ExtensionRegistry_DescriptorIntPair.h"
#import "ExtensionRegistry_ExtensionInfo.h"
#import "FieldDescriptor.h"
#import "MessageOptions.h"

@implementation ExtensionRegistry


static ExtensionRegistry* EMPTY = nil;


+ (void) initialize {
    if (self = [ExtensionRegistry class]) {
        EMPTY = [[ExtensionRegistry alloc] initWithExtensionsByName:[NSMutableDictionary dictionary]
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


+ (ExtensionRegistry*) getEmptyRegistry {
    return EMPTY;
}


+ (ExtensionRegistry*) newInstance {
    return [[[ExtensionRegistry alloc] initWithExtensionsByName:[NSMutableDictionary dictionary]
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


- (ExtensionRegistry_ExtensionInfo*) findExtensionByName:(NSString*) fullName {
    return [extensionsByName objectForKey:fullName];
}


- (ExtensionRegistry_ExtensionInfo*) findExtensionByNumber:(Descriptor*) containingType
                                               fieldNumber:(int32_t) fieldNumber {
    return [extensionsByNumber objectForKey:[ExtensionRegistry_DescriptorIntPair pairWithDescriptor:containingType number:fieldNumber]];
}

/*
- (void) addExtension:(GeneratedMessage_GeneratedExtension*) extension {
    if (extension.getDescriptor.getObjectiveCType == FieldDescriptorTypeMessage) {
        [self addExtensionInfo:[ExtensionRegistry_ExtensionInfo infoWithDescriptor:extension.getDescriptor defaultInstance:extension.getMessageDefaultInstance]];
    } else {
        [self addExtensionInfo:[ExtensionRegistry_ExtensionInfo infoWithDescriptor:extension.getDescriptor defaultInstance:nil]];
    }
}
 */


- (void) addFieldDescriptor:(FieldDescriptor*) type {
    if (type.getObjectiveCType == FieldDescriptorTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    [self addExtensionInfo:[ExtensionRegistry_ExtensionInfo infoWithDescriptor:type defaultInstance:nil]];
}


- (void) addFieldDescriptor:(FieldDescriptor*) type defaultInstance:(id<Message>) defaultInstance {
    if (type.getObjectiveCType != FieldDescriptorTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    [self addExtensionInfo:[ExtensionRegistry_ExtensionInfo infoWithDescriptor:type defaultInstance:defaultInstance]];
}


- (void) addExtensionInfo:(ExtensionRegistry_ExtensionInfo*) extension {
    if (!extension.descriptor.isExtension) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    [extensionsByName setObject:extension
                         forKey:extension.descriptor.getFullName];
    [extensionsByNumber setObject:extension
                           forKey:[ExtensionRegistry_DescriptorIntPair pairWithDescriptor:extension.descriptor.getContainingType
                                                                                   number:extension.descriptor.getNumber]];
    
    FieldDescriptor* field = extension.descriptor;
    
    if (field.getContainingType.getOptions.getMessageSetWireFormat &&
        field.getType == FieldDescriptorTypeMessage &&
        field.isOptional &&
        field.getExtensionScope == field.getMessageType) {
        // This is an extension of a MessageSet type defined within the extension
        // type's own scope.  For backwards-compatibility, allow it to be looked
        // up by type name.
        [extensionsByName setObject:extension forKey:field.getMessageType.getFullName];
    }
}

@end
