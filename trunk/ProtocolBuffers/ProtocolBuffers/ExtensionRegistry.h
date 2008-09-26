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

@interface ExtensionRegistry : NSObject {
    NSDictionary* extensionsByName;
    NSDictionary* extensionsByNumber;
}


@property (retain) NSDictionary* extensionsByName;
@property (retain) NSDictionary* extensionsByNumber;


+ (ExtensionRegistry*) newInstance;
+ (ExtensionRegistry*) emptyRegistry;

- (ExtensionRegistry*) unmodifiable;

- (ExtensionRegistry_ExtensionInfo*) findExtensionByName:(NSString*) fullName;
- (ExtensionRegistry_ExtensionInfo*) findExtensionByContainingType:(Descriptors_Descriptor*) containingType fieldNumber:(int32_t) fieldNumber;

- (void) add:(GeneratedMessage_GeneratedExtension*) extension;
- (void) add:(FieldDescriptor*) type;
- (void) add:(FieldDescriptor*) type defaultInstance:(Message*) defaultInstance;

+ (ExtensionRegistry*) registryWithExtensionsByName:(NSDictionary*) extensionsByName extensionsByNumber:(NSDictionary*) extensionsByNumber;

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


@end
