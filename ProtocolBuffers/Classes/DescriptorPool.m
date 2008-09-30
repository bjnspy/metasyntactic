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

#import "DescriptorPool.h"


@implementation DescriptorPool

@synthesize dependencies;
@synthesize descriptorsByName;
@synthesize fieldsByNumber;
@synthesize enumValuesByNumber;

- (void) dealloc {
    self.dependencies = nil;
    self.descriptorsByName = nil;
    self.fieldsByNumber = nil;
    self.enumValuesByNumber = nil;
    [super dealloc];
}


- (id) initWithDependencies:(NSArray*) fileDescriptorDependencies {
    if (self = [super init]) {
        self.descriptorsByName = [NSMutableDictionary dictionary];
        self.fieldsByNumber = [NSMutableDictionary dictionary];
        self.enumValuesByNumber = [NSMutableDictionary dictionary];

    }

    return self;
}


+ (DescriptorPool*) poolWithDependencies:(NSArray*) dependencies {
    return [[[DescriptorPool alloc] initWithDependencies:dependencies] autorelease];
}

#if 0
private static final class DescriptorPool {
    DescriptorPool(FileDescriptor[] dependencies) {
        this.dependencies = new DescriptorPool[dependencies.length];

        for (int i = 0; i < dependencies.length; i++)  {
            this.dependencies[i] = dependencies[i].pool;
        }

        for (int i = 0; i < dependencies.length; i++)  {
            try {
                addPackage(dependencies[i].getPackage(), dependencies[i]);
            } catch (DescriptorValidationException e) {
                // Can't happen, because addPackage() only fails when the name
                // conflicts with a non-package, but we have not yet added any
                // non-packages at this point.
                assert false;
            }
        }
    }


    /** Find a generic descriptor by fully-qualified name. */
    GenericDescriptor findSymbol(String fullName) {
        GenericDescriptor result = descriptorsByName.get(fullName);
        if (result != null) return result;

        for (int i = 0; i < dependencies.length; i++) {
            result = dependencies[i].descriptorsByName.get(fullName);
            if (result != null) return result;
        }

        return null;
    }

    /**
     * Look up a descriptor by name, relative to some other descriptor.
     * The name may be fully-qualified (with a leading '.'),
     * partially-qualified, or unqualified.  C++-like name lookup semantics
     * are used to search for the matching descriptor.
     */
    GenericDescriptor lookupSymbol(String name,
                                   GenericDescriptor relativeTo)
    throws DescriptorValidationException {
        // TODO(kenton):  This could be optimized in a number of ways.

        GenericDescriptor result;
        if (name.startsWith(".")) {
            // Fully-qualified name.
            result = findSymbol(name.substring(1));
        } else {
            // If "name" is a compound identifier, we want to search for the
            // first component of it, then search within it for the rest.
            int firstPartLength = name.indexOf('.');
            String firstPart;
            if (firstPartLength == -1) {
                firstPart = name;
            } else {
                firstPart = name.substring(0, firstPartLength);
            }

            // We will search each parent scope of "relativeTo" looking for the
            // symbol.
            StringBuilder scopeToTry = new StringBuilder(relativeTo.getFullName());

            while (true) {
                // Chop off the last component of the scope.
                int dotpos = scopeToTry.lastIndexOf(".");
                if (dotpos == -1) {
                    result = findSymbol(name);
                    break;
                } else {
                    scopeToTry.setLength(dotpos + 1);

                    // Append firstPart and try to find.
                    scopeToTry.append(firstPart);
                    result = findSymbol(scopeToTry.toString());

                    if (result != null) {
                        if (firstPartLength != -1) {
                            // We only found the first part of the symbol.  Now look for
                            // the whole thing.  If this fails, we *don't* want to keep
                            // searching parent scopes.
                            scopeToTry.setLength(dotpos + 1);
                            scopeToTry.append(name);
                            result = findSymbol(scopeToTry.toString());
                        }
                        break;
                    }

                    // Not found.  Remove the name so we can try again.
                    scopeToTry.setLength(dotpos);
                }
            }
        }

        if (result == null) {
            throw new DescriptorValidationException(relativeTo,
                                                    "\"" + name + "\" is not defined.");
        } else {
            return result;
        }
    }

    /**
     * Adds a symbol to the symbol table.  If a symbol with the same name
     * already exists, throws an error.
     */
    void addSymbol(GenericDescriptor descriptor)
    throws DescriptorValidationException {
        validateSymbolName(descriptor);

        String fullName = descriptor.getFullName();
        int dotpos = fullName.lastIndexOf('.');

        GenericDescriptor old = descriptorsByName.put(fullName, descriptor);
        if (old != null) {
            descriptorsByName.put(fullName, old);

            if (descriptor.getFile() == old.getFile()) {
                if (dotpos == -1) {
                    throw new DescriptorValidationException(descriptor,
                                                            "\"" + fullName + "\" is already defined.");
                } else {
                    throw new DescriptorValidationException(descriptor,
                                                            "\"" + fullName.substring(dotpos + 1) +
                                                            "\" is already defined in \"" +
                                                            fullName.substring(0, dotpos) + "\".");
                }
            } else {
                throw new DescriptorValidationException(descriptor,
                                                        "\"" + fullName + "\" is already defined in file \"" +
                                                        old.getFile().getName() + "\".");
            }
        }
    }
#endif

@end
