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

@interface PBDescriptor : NSObject<PBGenericDescriptor> {
@private
    int32_t index;
    PBDescriptorProto* proto;
    NSString* fullName;
    PBFileDescriptor* file;
    // TODO(cyrusn): circularity between us and our containing type
    PBDescriptor* containingType;
    NSMutableArray* mutableNestedTypes;
    NSMutableArray* mutableEnumTypes;
    NSMutableArray* mutableFields;
    NSMutableArray* mutableExtensions;
}

@property (readonly) int32_t index;
@property (readonly, retain) PBDescriptorProto* proto;
@property (readonly, copy) NSString* fullName;
@property (readonly, retain) PBFileDescriptor* file;
@property (readonly, retain) PBDescriptor* containingType;

- (NSArray*) nestedTypes;
- (NSArray*) enumTypes;
- (NSArray*) fields;
- (NSArray*) extensions;

+ (PBDescriptor*) descriptorWithProto:(PBDescriptorProto*) proto
                                 file:(PBFileDescriptor*) file
                               parent:(PBDescriptor*) parent
                                index:(int32_t) index;

+ (NSString*) computeFullName:(PBFileDescriptor*) file
                       parent:(PBDescriptor*) parent
                         name:(NSString*) name;

- (NSArray*) fields;
- (PBMessageOptions*) options;
- (NSString*) fullName;
- (NSArray*) enumTypes;
- (NSArray*) extensions;

- (BOOL) isExtensionNumber:(int32_t) number;

- (PBFieldDescriptor*) findFieldByNumber:(int32_t) number;
- (PBFieldDescriptor*) findFieldByName:(NSString*) name;
- (PBDescriptor*) findNestedTypeByName:(NSString*) name;
- (PBEnumDescriptor*) findEnumTypeByName:(NSString*) name;

// @internal
- (void) crossLink;

#if 0
NSArray* fields;
    int32_t index;
    DescriptorProto* proto;
    PBFileDescriptor* file;
    PBDescriptor* containingType;
    NSArray* nestedTypes;
    NSArray* enumTypes;
    NSArray* extensions;
}

@property int32_t index;
@property (retain) DescriptorProto* proto;
@property (retain) NSString* fullName;
@property (retain) PBFileDescriptor* file;
@property (retain) PBDescriptor* containingType;
@property (retain) NSArray* nestedTypes;
@property (retain) NSArray* enumTypes;
@property (retain) NSArray* extensions;
@property (retain) NSArray* fields;

- (NSString*) name;

- (PBDescriptor*) findNestedTypeByName:(NSString*) name;
- (PBEnumDescriptor*) findEnumTypeByName:(NSString*) name;


#endif

@end