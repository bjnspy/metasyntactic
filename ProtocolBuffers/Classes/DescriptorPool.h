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
 * A private helper class which contains lookup tables containing all the
 * descriptors defined in a particular file.
 */
@interface PBDescriptorPool : NSObject {
  @private
    NSMutableArray* mutableDependencies;
    NSMutableDictionary* mutableDescriptorsByName;
    NSMutableDictionary* mutableFieldsByNumber;
    NSMutableDictionary* mutableEnumValuesByNumber;
}

- (NSArray*) dependencies;
- (NSDictionary*) descriptorsByName;
- (NSDictionary*) fieldsByNumber;
- (NSDictionary*) enumValuesByNumber;

+ (PBDescriptorPool*) poolWithDependencies:(NSArray*) dependencies;

/**
 * Adds a package to the symbol tables.  If a package by the same name
 * already exists, that is fine, but if some other kind of symbol exists
 * under the same name, an exception is thrown.  If the package has
 * multiple components, this also adds the parent package(s).
 */
- (void) addPackage:(NSString*) fullName file:(PBFileDescriptor*) file;

/**
 * Adds a symbol to the symbol table.  If a symbol with the same name
 * already exists, throws an error.
 */
- (void) addSymbol:(id<PBGenericDescriptor>) descriptor;

/**
 * Adds an enum value to the enumValuesByNumber table.  If an enum value
 * with the same type and number already exists, does nothing.  (This is
 * allowed; the first value define with the number takes precedence.)
 */
- (void) addEnumValueByNumber:(PBEnumValueDescriptor*) value;

/**
 * Adds a field to the fieldsByNumber table.  Throws an exception if a
 * field with hte same containing type and number already exists.
 */
- (void) addFieldByNumber:(PBFieldDescriptor*) field;

/** Find a generic descriptor by fully-qualified name. */
- (id<PBGenericDescriptor>) findSymbol:(NSString*) fullName;

/**
 * Look up a descriptor by name, relative to some other descriptor.
 * The name may be fully-qualified (with a leading '.'),
 * partially-qualified, or unqualified.  C++-like name lookup semantics
 * are used to search for the matching descriptor.
 */
- (id<PBGenericDescriptor>) lookupSymbol:(NSString*) name
                              relativeTo:(id<PBGenericDescriptor>) relativeTo;

@end

#endif