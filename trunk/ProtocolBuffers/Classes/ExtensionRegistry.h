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

@interface PBExtensionRegistry : NSObject {
@private
    NSMutableDictionary* extensionsByName;
    NSMutableDictionary* extensionsByNumber;
}


@property (retain, readonly) NSMutableDictionary* extensionsByName;
@property (retain, readonly) NSMutableDictionary* extensionsByNumber;

+ (PBExtensionRegistry*) getEmptyRegistry;

- (id) initWithExtensionsByName:(NSMutableDictionary*) extensionsByName
             extensionsByNumber:(NSMutableDictionary*) extensionsByNumber;

- (void) addExtensionInfo:(PBExtensionInfo*) extension;

- (PBExtensionInfo*) findExtensionByNumber:(PBDescriptor*) containingType
                                               fieldNumber:(int32_t) fieldNumber;

#if 0


+ (PBExtensionRegistry*) newInstance;
+ (PBExtensionRegistry*) emptyRegistry;

- (PBExtensionRegistry*) unmodifiable;

- (PBExtensionInfo*) findExtensionByName:(NSString*) fullName;
- (PBExtensionInfo*) findExtensionByContainingType:(Descriptors_Descriptor*) containingType fieldNumber:(int32_t) fieldNumber;

- (void) add:(PBGeneratedExtension*) extension;
- (void) add:(PBFieldDescriptor*) type;
- (void) add:(PBFieldDescriptor*) type defaultInstance:(PBMessage*) defaultInstance;

+ (PBExtensionRegistry*) registryWithExtensionsByName:(NSDictionary*) extensionsByName extensionsByNumber:(NSDictionary*) extensionsByNumber;
#endif

@end
