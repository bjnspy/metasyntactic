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

#import "DescriptorPool.h"

#import "DescriptorPool_DescriptorIntPair.h"
#import "EnumDescriptor.h"
#import "EnumValueDescriptor.h"
#import "FieldDescriptor.h"
#import "PackageDescriptor.h"

@interface PBDescriptorPool()
    @property (retain) NSMutableArray* mutableDependencies;
    @property (retain) NSMutableDictionary* mutableDescriptorsByName;
    @property (retain) NSMutableDictionary* mutableFieldsByNumber;
    @property (retain) NSMutableDictionary* mutableEnumValuesByNumber;
@end


@implementation PBDescriptorPool

@synthesize mutableDependencies;
@synthesize mutableDescriptorsByName;
@synthesize mutableFieldsByNumber;
@synthesize mutableEnumValuesByNumber;

- (void) dealloc {
    self.mutableDependencies = nil;
    self.mutableDescriptorsByName = nil;
    self.mutableFieldsByNumber = nil;
    self.mutableEnumValuesByNumber = nil;
    [super dealloc];
}


- (id) initWithDependencies:(NSArray*) dependencies_ {
    if (self = [super init]) {
        self.mutableDependencies = [NSMutableArray array];
        self.mutableDescriptorsByName = [NSMutableDictionary dictionary];
        self.mutableFieldsByNumber = [NSMutableDictionary dictionary];
        self.mutableEnumValuesByNumber = [NSMutableDictionary dictionary];

        for (PBFileDescriptor* dependency in dependencies_) {
            [mutableDependencies addObject:dependency.pool];
        }

        for (PBFileDescriptor* dependency in dependencies_) {
            [self addPackage:dependency.package file:dependency];
        }
    }

    return self;
}


+ (PBDescriptorPool*) poolWithDependencies:(NSArray*) dependencies {
    return [[[PBDescriptorPool alloc] initWithDependencies:dependencies] autorelease];
}


- (NSArray*) dependencies {
    return mutableDependencies;
}


- (NSDictionary*) descriptorsByName {
    return mutableDescriptorsByName;
}


- (NSDictionary*) fieldsByNumber {
    return mutableFieldsByNumber;
}


- (NSDictionary*) enumValuesByNumber {
    return mutableEnumValuesByNumber;
}


- (void) addPackage:(NSString*) fullName file:(PBFileDescriptor*) file {
    NSRange dotpos = [fullName rangeOfString:@"." options:NSBackwardsSearch];

    NSString* name = fullName;
    if (dotpos.length > 0) {
        [self addPackage:[fullName substringToIndex:dotpos.location] file:file];
        name = [fullName substringFromIndex:(dotpos.location + 1)];
    }

    PBPackageDescriptor* packageDescriptor = [PBPackageDescriptor descriptorWithFullName:fullName name:name file:file];
    [mutableDescriptorsByName setObject:packageDescriptor forKey:fullName];
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

    if ([mutableDescriptorsByName objectForKey:fullName] != nil) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    }

    [mutableDescriptorsByName setObject:descriptor forKey:fullName];

#if 0
    if (old != null) {
        mutableDescriptorsByName.put(fullName, old);

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

    if ([mutableEnumValuesByNumber objectForKey:key] == nil) {
        [mutableEnumValuesByNumber setObject:value forKey:key];
        // Not an error:  Multiple enum values may have the same number, but
        // we only want the first one in the map.
    }
}


/** Find a generic descriptor by fully-qualified name. */
- (id<PBGenericDescriptor>) findSymbol:(NSString*) fullName {
    id<PBGenericDescriptor> result = [mutableDescriptorsByName objectForKey:fullName];
    if (result != nil) {
        return result;
    }

    for (PBDescriptorPool* p in mutableDependencies) {
        result = [p.mutableDescriptorsByName objectForKey:fullName];
        if (result != nil) {
            return result;
        }
    }

    return nil;
}


- (id<PBGenericDescriptor>) lookupSymbol:(NSString*) name
                              relativeTo:(id<PBGenericDescriptor>) relativeTo {
    id<PBGenericDescriptor> result = nil;
    if ([name hasPrefix:@"."]) {
        // Fully-qualified name.
        result = [self findSymbol:[name substringFromIndex:1]];
    } else {
        // If "name" is a compound identifier, we want to search for the
        // first component of it, then search within it for the rest.
        NSRange firstPartLength = [name rangeOfString:@"."];
        NSString* firstPart = name;
        if (firstPartLength.length > 0) {
            firstPart = [name substringToIndex:firstPartLength.location];
        }

        // We will search each parent scope of "relativeTo" looking for the
        // symbol.
        NSMutableString* scopeToTry = [NSMutableString stringWithString:[relativeTo fullName]];

        while (YES) {
            // Chop off the last component of the scope.
            NSRange dotpos = [scopeToTry rangeOfString:@"." options:NSBackwardsSearch];
            if (dotpos.length <= 0) {
                result = [self findSymbol:name];
                break;
            } else {
                [scopeToTry setString:[scopeToTry substringToIndex:(dotpos.location + 1)]];

                // Append firstPart and try to find.
                [scopeToTry appendString:firstPart];
                result = [self findSymbol:scopeToTry];

                if (result != nil) {
                    if (firstPartLength.length > 0) {
                        // We only found the first part of the symbol.  Now look for
                        // the whole thing.  If this fails, we *don't* want to keep
                        // searching parent scopes.
                        [scopeToTry setString:[scopeToTry substringToIndex:(dotpos.location + 1)]];
                        [scopeToTry appendString:name];
                        result = [self findSymbol:scopeToTry];
                    }
                    break;
                }

                // Not found.  Remove the name so we can try again.
                [scopeToTry setString:[scopeToTry substringToIndex:dotpos.location]];
            }
        }
    }

    if (result == nil) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    } else {
        return result;
    }
}


- (void) addFieldByNumber:(PBFieldDescriptor*) field {
    PBDescriptorPool_DescriptorIntPair* key = [PBDescriptorPool_DescriptorIntPair pairWithDescriptor:field.containingType number:field.number];

    if ([mutableFieldsByNumber objectForKey:key] != nil) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    }

    [mutableFieldsByNumber setObject:field forKey:key];
}

@end