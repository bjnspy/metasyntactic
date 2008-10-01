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

@interface ExtensionRegistry : NSObject {
    NSMutableDictionary* extensionsByName;
    NSMutableDictionary* extensionsByNumber;
}


@property (retain) NSMutableDictionary* extensionsByName;
@property (retain) NSMutableDictionary* extensionsByNumber;

+ (ExtensionRegistry*) getEmptyRegistry;

- (id) initWithExtensionsByName:(NSMutableDictionary*) extensionsByName
             extensionsByNumber:(NSMutableDictionary*) extensionsByNumber;

- (void) addExtensionInfo:(ExtensionRegistry_ExtensionInfo*) extension;

- (ExtensionRegistry_ExtensionInfo*) findExtensionByNumber:(Descriptor*) containingType
                                               fieldNumber:(int32_t) fieldNumber;

#if 0


+ (ExtensionRegistry*) newInstance;
+ (ExtensionRegistry*) emptyRegistry;

- (ExtensionRegistry*) unmodifiable;

- (ExtensionRegistry_ExtensionInfo*) findExtensionByName:(NSString*) fullName;
- (ExtensionRegistry_ExtensionInfo*) findExtensionByContainingType:(Descriptors_Descriptor*) containingType fieldNumber:(int32_t) fieldNumber;

- (void) add:(GeneratedExtension*) extension;
- (void) add:(FieldDescriptor*) type;
- (void) add:(FieldDescriptor*) type defaultInstance:(Message*) defaultInstance;

+ (ExtensionRegistry*) registryWithExtensionsByName:(NSDictionary*) extensionsByName extensionsByNumber:(NSDictionary*) extensionsByNumber;
#endif

@end
