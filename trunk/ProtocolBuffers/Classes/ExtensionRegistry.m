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

#if 0
/**
 * Find an extension by fully-qualified field name, in the proto namespace.
 * I.e. {@code result.descriptor.fullName()} will match {@code fullName} if
 * a match is found.
 *
 * @return Information about the extension if found, or {@code null}
 *         otherwise.
 */
public ExtensionInfo findExtensionByName(String fullName) {
    return extensionsByName.get(fullName);
}

/**
 * Find an extension by containing type and field number.
 *
 * @return Information about the extension if found, or {@code null}
 *         otherwise.
 */
public ExtensionInfo findExtensionByNumber(Descriptor containingType,
                                           int fieldNumber) {
    return extensionsByNumber.get(
                                  new DescriptorIntPair(containingType, fieldNumber));
}

/** Add an extension from a generated file to the registry. */
public void add(GeneratedMessage.GeneratedExtension<?, ?> extension) {
    if (extension.getDescriptor().getJavaType() ==
        FieldDescriptor.JavaType.MESSAGE) {
        add(new ExtensionInfo(extension.getDescriptor(),
                              extension.getMessageDefaultInstance()));
    } else {
        add(new ExtensionInfo(extension.getDescriptor(), null));
    }
}

/** Add a non-message-type extension to the registry by descriptor. */
public void add(FieldDescriptor type) {
    if (type.getJavaType() == FieldDescriptor.JavaType.MESSAGE) {
        throw new IllegalArgumentException(
                                           "ExtensionRegistry.add() must be provided a default instance when " +
                                           "adding an embedded message extension.");
    }
    add(new ExtensionInfo(type, null));
}

/** Add a message-type extension to the registry by descriptor. */
public void add(FieldDescriptor type, Message defaultInstance) {
    if (type.getJavaType() != FieldDescriptor.JavaType.MESSAGE) {
        throw new IllegalArgumentException(
                                           "ExtensionRegistry.add() provided a default instance for a " +
                                           "non-message extension.");
    }
    add(new ExtensionInfo(type, defaultInstance));
}

// =================================================================
// Private stuff.

private ExtensionRegistry(
                          Map<String, ExtensionInfo> extensionsByName,
                          Map<DescriptorIntPair, ExtensionInfo> extensionsByNumber) {
    this.extensionsByName = extensionsByName;
    this.extensionsByNumber = extensionsByNumber;
}

private final Map<String, ExtensionInfo> extensionsByName;
private final Map<DescriptorIntPair, ExtensionInfo> extensionsByNumber;

private static final ExtensionRegistry EMPTY =
new ExtensionRegistry(
                      Collections.<String, ExtensionInfo>emptyMap(),
                      Collections.<DescriptorIntPair, ExtensionInfo>emptyMap());

private void add(ExtensionInfo extension) {
    if (!extension.descriptor.isExtension()) {
        throw new IllegalArgumentException(
                                           "ExtensionRegistry.add() was given a FieldDescriptor for a regular " +
                                           "(non-extension) field.");
    }
    
    extensionsByName.put(extension.descriptor.getFullName(), extension);
    extensionsByNumber.put(
                           new DescriptorIntPair(extension.descriptor.getContainingType(),
                                                 extension.descriptor.getNumber()),
                           extension);
    
    FieldDescriptor field = extension.descriptor;
    if (field.getContainingType().getOptions().getMessageSetWireFormat() &&
        field.getType() == FieldDescriptor.Type.MESSAGE &&
        field.isOptional() &&
        field.getExtensionScope() == field.getMessageType()) {
        // This is an extension of a MessageSet type defined within the extension
        // type's own scope.  For backwards-compatibility, allow it to be looked
        // up by type name.
        extensionsByName.put(field.getMessageType().getFullName(), extension);
    }
}

/** A (GenericDescriptor, int) pair, used as a map key. */
private static final class DescriptorIntPair {
    final Descriptor descriptor;
    final int number;
    
    DescriptorIntPair(Descriptor descriptor, int number) {
        this.descriptor = descriptor;
        this.number = number;
    }
    
    public int hashCode() {
        return descriptor.hashCode() * ((1 << 16) - 1) + number;
    }
    public boolean equals(Object obj) {
        if (!(obj instanceof DescriptorIntPair)) return false;
        DescriptorIntPair other = (DescriptorIntPair)obj;
        return descriptor == other.descriptor && number == other.number;
    }
}
}
#endif

@end
