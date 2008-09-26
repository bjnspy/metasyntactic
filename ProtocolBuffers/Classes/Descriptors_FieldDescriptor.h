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

@interface Descriptors_FieldDescriptor : NSObject {

}

#if 0
public static final class FileDescriptor {
    /** Convert the descriptor to its protocol message representation. */
    public FileDescriptorProto toProto() { return proto; }
    
    /** Get the file name. */
    public String getName() { return proto.getName(); }
    
    /**
     * Get the proto package name.  This is the package name given by the
     * {@code package} statement in the {@code .proto} file, which differs
     * from the Java package.
     */
    public String getPackage() { return proto.getPackage(); }
    
    /** Get the {@code FileOptions}, defined in {@code descriptor.proto}. */
    public FileOptions getOptions() { return proto.getOptions(); }
    
    /** Get a list of top-level message types declared in this file. */
    public List<Descriptor> getMessageTypes() {
        return Collections.unmodifiableList(Arrays.asList(messageTypes));
    }
    
    /** Get a list of top-level enum types declared in this file. */
    public List<EnumDescriptor> getEnumTypes() {
        return Collections.unmodifiableList(Arrays.asList(enumTypes));
    }
    
    /** Get a list of top-level services declared in this file. */
    public List<ServiceDescriptor> getServices() {
        return Collections.unmodifiableList(Arrays.asList(services));
    }
    
    /** Get a list of top-level extensions declared in this file. */
    public List<FieldDescriptor> getExtensions() {
        return Collections.unmodifiableList(Arrays.asList(extensions));
    }
    
    /** Get a list of this file's dependencies (imports). */
    public List<FileDescriptor> getDependencies() {
        return Collections.unmodifiableList(Arrays.asList(dependencies));
    }
    
    /**
     * Find a message type in the file by name.  Does not find nested types.
     *
     * @param name The unqualified type name to look for.
     * @return The message type's descriptor, or {@code null} if not found.
     */
    public Descriptor findMessageTypeByName(String name) {
        // Don't allow looking up nested types.  This will make optimization
        // easier later.
        if (name.indexOf('.') != -1) return null;
        if (getPackage().length() > 0) {
            name = getPackage() + "." + name;
        }
        GenericDescriptor result = pool.findSymbol(name);
        if (result != null && result instanceof Descriptor &&
            result.getFile() == this) {
            return (Descriptor)result;
        } else {
            return null;
        }
    }
    
    /**
     * Find an enum type in the file by name.  Does not find nested types.
     *
     * @param name The unqualified type name to look for.
     * @return The enum type's descriptor, or {@code null} if not found.
     */
    public EnumDescriptor findEnumTypeByName(String name) {
        // Don't allow looking up nested types.  This will make optimization
        // easier later.
        if (name.indexOf('.') != -1) return null;
        if (getPackage().length() > 0) {
            name = getPackage() + "." + name;
        }
        GenericDescriptor result = pool.findSymbol(name);
        if (result != null && result instanceof EnumDescriptor &&
            result.getFile() == this) {
            return (EnumDescriptor)result;
        } else {
            return null;
        }
    }
    
    /**
     * Find a service type in the file by name.
     *
     * @param name The unqualified type name to look for.
     * @return The service type's descriptor, or {@code null} if not found.
     */
    public ServiceDescriptor findServiceByName(String name) {
        // Don't allow looking up nested types.  This will make optimization
        // easier later.
        if (name.indexOf('.') != -1) return null;
        if (getPackage().length() > 0) {
            name = getPackage() + "." + name;
        }
        GenericDescriptor result = pool.findSymbol(name);
        if (result != null && result instanceof ServiceDescriptor &&
            result.getFile() == this) {
            return (ServiceDescriptor)result;
        } else {
            return null;
        }
    }
    
    /**
     * Find an extension in the file by name.  Does not find extensions nested
     * inside message types.
     *
     * @param name The unqualified extension name to look for.
     * @return The extension's descriptor, or {@code null} if not found.
     */
    public FieldDescriptor findExtensionByName(String name) {
        if (name.indexOf('.') != -1) return null;
        if (getPackage().length() > 0) {
            name = getPackage() + "." + name;
        }
        GenericDescriptor result = pool.findSymbol(name);
        if (result != null && result instanceof FieldDescriptor &&
            result.getFile() == this) {
            return (FieldDescriptor)result;
        } else {
            return null;
        }
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
    public static FileDescriptor buildFrom(FileDescriptorProto proto,
                                           FileDescriptor[] dependencies)
    throws DescriptorValidationException {
        // Building decsriptors involves two steps:  translating and linking.
        // In the translation step (implemented by FileDescriptor's
        // constructor), we build an object tree mirroring the
        // FileDescriptorProto's tree and put all of the descriptors into the
        // DescriptorPool's lookup tables.  In the linking step, we look up all
        // type references in the DescriptorPool, so that, for example, a
        // FieldDescriptor for an embedded message contains a pointer directly
        // to the Descriptor for that message's type.  We also detect undefined
        // types in the linking step.
        DescriptorPool pool = new DescriptorPool(dependencies);
        FileDescriptor result = new FileDescriptor(proto, dependencies, pool);
        
        if (dependencies.length != proto.getDependencyCount()) {
            throw new DescriptorValidationException(result,
                                                    "Dependencies passed to FileDescriptor.buildFrom() don't match " +
                                                    "those listed in the FileDescriptorProto.");
        }
        for (int i = 0; i < proto.getDependencyCount(); i++) {
            if (!dependencies[i].getName().equals(proto.getDependency(i))) {
                throw new DescriptorValidationException(result,
                                                        "Dependencies passed to FileDescriptor.buildFrom() don't match " +
                                                        "those listed in the FileDescriptorProto.");
            }
        }
        
        result.crossLink();
        return result;
    }
    
    /**
     * This method is to be called by generated code only.  It is equivalent
     * to {@code buildFrom} except that the {@code FileDescriptorProto} is
     * encoded in protocol buffer wire format.
     */
    public static FileDescriptor internalBuildGeneratedFileFrom(
                                                                String descriptorData, FileDescriptor[] dependencies)
    throws DescriptorValidationException,
    InvalidProtocolBufferException {
        // Hack:  We can't embed a raw byte array inside generated Java code
        //   (at least, not efficiently), but we can embed Strings.  So, the
        //   protocol compiler embeds the FileDescriptorProto as a giant
        //   string literal which is passed to this function to construct the
        //   file's FileDescriptor.  The string literal contains only 8-bit
        //   characters, each one representing a byte of the FileDescriptorProto's
        //   serialized form.  So, if we convert it to bytes in ISO-8859-1, we
        //   should get the original bytes that we want.
        try {
            FileDescriptorProto proto =
            FileDescriptorProto.parseFrom(descriptorData.getBytes("ISO-8859-1"));
            return buildFrom(proto, dependencies);
        } catch (java.io.UnsupportedEncodingException e) {
            throw new RuntimeException(
                                       "Standard encoding ISO-8859-1 not supported by JVM.", e);
        }
    }
    
    private final FileDescriptorProto proto;
    private final Descriptor[] messageTypes;
    private final EnumDescriptor[] enumTypes;
    private final ServiceDescriptor[] services;
    private final FieldDescriptor[] extensions;
    private final FileDescriptor[] dependencies;
    private final DescriptorPool pool;
    
    private FileDescriptor(FileDescriptorProto proto,
                           FileDescriptor[] dependencies,
                           DescriptorPool pool)
    throws DescriptorValidationException {
        this.pool = pool;
        this.proto = proto;
        this.dependencies = dependencies.clone();
        
        pool.addPackage(getPackage(), this);
        
        messageTypes = new Descriptor[proto.getMessageTypeCount()];
        for (int i = 0; i < proto.getMessageTypeCount(); i++) {
            messageTypes[i] =
            new Descriptor(proto.getMessageType(i), this, null, i);
        }
        
        enumTypes = new EnumDescriptor[proto.getEnumTypeCount()];
        for (int i = 0; i < proto.getEnumTypeCount(); i++) {
            enumTypes[i] = new EnumDescriptor(proto.getEnumType(i), this, null, i);
        }
        
        services = new ServiceDescriptor[proto.getServiceCount()];
        for (int i = 0; i < proto.getServiceCount(); i++) {
            services[i] = new ServiceDescriptor(proto.getService(i), this, i);
        }
        
        extensions = new FieldDescriptor[proto.getExtensionCount()];
        for (int i = 0; i < proto.getExtensionCount(); i++) {
            extensions[i] = new FieldDescriptor(
                                                proto.getExtension(i), this, null, i, true);
        }
    }
    
    /** Look up and cross-link all field types, etc. */
    private void crossLink() throws DescriptorValidationException {
        for (int i = 0; i < messageTypes.length; i++) {
            messageTypes[i].crossLink();
        }
        
        for (int i = 0; i < services.length; i++) {
            services[i].crossLink();
        }
        
        for (int i = 0; i < extensions.length; i++) {
            extensions[i].crossLink();
        }
    }
}
#endif
@end
