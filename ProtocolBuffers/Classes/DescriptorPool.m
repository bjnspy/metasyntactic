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

#import "DescriptorPool_DescriptorIntPair.h"
#import "EnumDescriptor.h"
#import "EnumValueDescriptor.h"
#import "PBPackageDescriptor.h"

@implementation PBDescriptorPool

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


+ (PBDescriptorPool*) poolWithDependencies:(NSArray*) dependencies {
    return [[[PBDescriptorPool alloc] initWithDependencies:dependencies] autorelease];
}


- (void) addPackage:(NSString*) fullName file:(PBFileDescriptor*) file {
    NSRange dotpos = [fullName rangeOfString:@"." options:NSBackwardsSearch];
    
    NSString* name = fullName;
    if (dotpos.length > 0) {
        [self addPackage:[fullName substringToIndex:dotpos.location] file:file];
        name = [fullName substringFromIndex:(dotpos.location + 1)];
    }
    
    PBPackageDescriptor* packageDescriptor = [PBPackageDescriptor descriptorWithFullName:fullName name:name file:file];
    [descriptorsByName setObject:packageDescriptor forKey:fullName];
}


BOOL isLetter(unichar c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c<= 'Z');
}


BOOL isDigit(unichar c) {
    return (c >= '0' && c <= '9');
}


/**
 * Verifies that the descriptor's name is valid (i.e. it contains only
 * letters, digits, and underscores, and does not start with a digit).
 */
- (void) validateSymbolName:(id<PBGenericDescriptor>) descriptor {
    NSString* name = [descriptor name];
    if (name.length == 0) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Missing name." userInfo:nil];
    } else {
        for (int i = 0; i < name.length; i++) {
            unichar c = [name characterAtIndex:i];
            
            // Non-ASCII characters are not valid in protobuf identifiers, even
            // if they are letters or digits.
            if (c >= 128) {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
            }
            
            // First character must be letter or _.  Subsequent characters may
            // be letters, numbers, or digits.
            if (isLetter(c) || c == '_' ||
                (isDigit(c) && i > 0)) {
                // Valid
            } else {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
            }
        }
    }
}


/**
 * Adds a symbol to the symbol table.  If a symbol with the same name
 * already exists, throws an error.
 */
- (void) addSymbol:(id<PBGenericDescriptor>) descriptor {
    [self validateSymbolName:descriptor];
    
    NSString* fullName = [descriptor fullName];

    if ([descriptorsByName objectForKey:fullName] != nil) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    }
    
    [descriptorsByName setObject:descriptor forKey:fullName];

#if 0
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
#endif
}


- (void) addEnumValueByNumber:(PBEnumValueDescriptor*) value {
    PBDescriptorPool_DescriptorIntPair* key = [PBDescriptorPool_DescriptorIntPair pairWithDescriptor:value.type
                                                                                              number:value.number];
    
    if ([enumValuesByNumber objectForKey:key] == nil) {
        [enumValuesByNumber setObject:value forKey:key];
        // Not an error:  Multiple enum values may have the same number, but
        // we only want the first one in the map.
    }
}


#if 0
private static final class PBDescriptorPool {
    PBDescriptorPool(PBFileDescriptor[] dependencies) {
        this.dependencies = new PBDescriptorPool[dependencies.length];

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
    PBGenericDescriptor findSymbol(String fullName) {
        PBGenericDescriptor result = descriptorsByName.get(fullName);
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
    PBGenericDescriptor lookupSymbol(String name,
                                   PBGenericDescriptor relativeTo)
    throws DescriptorValidationException {
        // TODO(kenton):  This could be optimized in a number of ways.

        PBGenericDescriptor result;
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
#endif

@end
