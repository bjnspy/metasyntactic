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

#import "GenericDescriptor.h"

#import "FieldDescriptorType.h"
#import "ObjectiveCType.h"

@interface PBFieldDescriptor : NSObject<PBGenericDescriptor,NSCopying> {
@private
    int32_t index;
    
    PBFieldDescriptorProto* proto;
    NSString* fullName;
    
    // TODO(cyrusn): circularity between us and our containing file
    PBFileDescriptor* file;
    PBDescriptor* extensionScope;
    
    // Possibly initialized during cross-linking.
    PBFieldDescriptorType type;
    
    // TODO(cyrusn): circularity between us and our containing type
    PBDescriptor* containingType;
    PBDescriptor* messageType;
    PBEnumDescriptor* enumType;
    id defaultValue;
}

@property (readonly) int32_t index;
@property (readonly, retain) PBFieldDescriptorProto* proto;
@property (readonly, copy) NSString* fullName;
@property (readonly, retain) PBFileDescriptor* file;
@property (readonly, retain) PBDescriptor* extensionScope;
@property (readonly) PBFieldDescriptorType type;
@property (readonly, retain) PBDescriptor* containingType;
@property (readonly, retain) PBDescriptor* messageType;
@property (readonly, retain) PBEnumDescriptor* enumType;
@property (readonly, retain) id defaultValue;

+ (PBFieldDescriptor*) descriptorWithProto:(PBFieldDescriptorProto*) proto
                                      file:(PBFileDescriptor*) file
                                    parent:(PBDescriptor*) parent
                                     index:(int32_t) index
                               isExtension:(BOOL) isExtension;

- (BOOL) isRequired;
- (BOOL) isRepeated;
- (BOOL) isExtension;
- (BOOL) isOptional;
- (PBObjectiveCType) objectiveCType;

- (int32_t) number;

- (PBFieldOptions*) options;

- (BOOL) hasDefaultValue;
- (id) defaultValue;

// @internal
- (void) crossLink;

@end