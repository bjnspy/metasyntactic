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

#import "Descriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"
#import "DescriptorPool_DescriptorIntPair.h"
#import "EnumDescriptor.h"
#import "FieldDescriptor.h"
#import "FileDescriptor.h"

@interface PBDescriptor ()
    @property int32_t index;
    @property (retain) PBDescriptorProto* proto;
    @property (copy) NSString* fullName;
    @property (retain) PBFileDescriptor* file;
    @property (retain) PBDescriptor* containingType;
    @property (retain) NSMutableArray* mutableNestedTypes;
    @property (retain) NSMutableArray* mutableEnumTypes;
    @property (retain) NSMutableArray* mutableFields;
    @property (retain) NSMutableArray* mutableExtensions;
@end


@implementation PBDescriptor

@synthesize index;
@synthesize proto;
@synthesize fullName;
@synthesize file;
@synthesize containingType;
@synthesize mutableNestedTypes;
@synthesize mutableEnumTypes;
@synthesize mutableFields;
@synthesize mutableExtensions;

- (void) dealloc {
    self.index = 0;
    self.proto = nil;
    self.fullName = nil;
    self.file = nil;
    self.containingType = nil;
    self.mutableNestedTypes = nil;
    self.mutableEnumTypes = nil;
    self.mutableFields = nil;
    self.mutableExtensions = nil;

    [super dealloc];
}


+ (NSString*) computeFullName:(PBFileDescriptor*) file
                       parent:(PBDescriptor*) parent
                         name:(NSString*) name {
    if (parent != nil) {
        return [NSString stringWithFormat:@"%@.%@", parent.fullName, name];
    } else if (file.package.length > 0) {
        return [NSString stringWithFormat:@"%@.%@", file.package, name];
    } else {
        return name;
    }
}


- (id) initWithProto:(PBDescriptorProto*) proto_
                file:(PBFileDescriptor*) file_
              parent:(PBDescriptor*) parent_
               index:(int32_t) index_ {
    if (self = [super init]) {
        self.index = index_;
        self.proto = proto_;
        self.file = file_;
        self.containingType = parent_;

        self.fullName = [PBDescriptor computeFullName:file parent:parent_ name:proto.name];

        if ([self.fullName hasPrefix:@"."]) {
            @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
        }

        self.mutableNestedTypes = [NSMutableArray array];
        for (PBDescriptorProto* p in proto.nestedTypeList) {
            [mutableNestedTypes addObject:[PBDescriptor descriptorWithProto:p
                                     file:file
                                   parent:self
                                    index:mutableNestedTypes.count]];
        }

        self.mutableEnumTypes = [NSMutableArray array];
        for (PBEnumDescriptorProto* e in proto.enumTypeList) {
            [mutableEnumTypes addObject:[PBEnumDescriptor descriptorWithProto:e file:file parent:self index:mutableEnumTypes.count]];
        }

        self.mutableFields = [NSMutableArray array];
        for (PBFieldDescriptorProto* f in proto.fieldList) {
            [mutableFields addObject:[PBFieldDescriptor descriptorWithProto:f
                                file:file
                              parent:self
                               index:mutableFields.count
                         isExtension:NO]];
        }

        self.mutableExtensions = [NSMutableArray array];
        for (PBFieldDescriptorProto* e in proto.extensionList) {
            [mutableExtensions addObject:[PBFieldDescriptor descriptorWithProto:e
                                    file:file
                                  parent:self
                                   index:mutableExtensions.count
                             isExtension:YES]];
        }

        [file.pool addSymbol:self];
    }

    return self;
}


+ (PBDescriptor*) descriptorWithProto:(PBDescriptorProto*) proto
                                 file:(PBFileDescriptor*) file
                               parent:(PBDescriptor*) parent
                                index:(int32_t) index {
    return [[[PBDescriptor alloc] initWithProto:proto file:file parent:parent index:index] autorelease];
}


- (NSArray*) nestedTypes {
    return self.mutableNestedTypes;
}


- (NSArray*) enumTypes {
    return self.mutableEnumTypes;
}


- (NSArray*) fields {
    return self.mutableFields;
}


- (NSArray*) extensions {
    return self.mutableExtensions;
}


- (PBMessageOptions*) options {
    return proto.options;
}


/** Determines if the given field number is an extension. */
- (BOOL) isExtensionNumber:(int32_t) number {
    for (PBDescriptorProto_ExtensionRange* range in proto.extensionRangeList) {
        if (range.start <= number && number < range.end) {
            return YES;
        }
    }
    return NO;
}


/**
 * Finds a field by name.
 * @param name The unqualified name of the field (e.g. "foo").
 * @return The field's descriptor, or {@code nil} if not found.
 */
- (PBFieldDescriptor*) findFieldByName:(NSString*) name {
    id result = [file.pool findSymbol:[NSString stringWithFormat:@"%@.%@", fullName, name]];
    if (result != nil && [result isKindOfClass:[PBFieldDescriptor class]]) {
        return result;
    } else {
        return nil;
    }
}



/**
 * Finds a field by field number.
 * @param number The field number within this message type.
 * @return The field's descriptor, or {@code nil} if not found.
 */
- (PBFieldDescriptor*) findFieldByNumber:(int32_t) number {
    PBDescriptorPool_DescriptorIntPair* pair =
    [PBDescriptorPool_DescriptorIntPair pairWithDescriptor:self number:number];
    return [file.pool.fieldsByNumber objectForKey:pair];
}


/**
 * Finds a nested message type by name.
 * @param name The unqualified name of the nested type (e.g. "Foo").
 * @return The types's descriptor, or {@code nil} if not found.
 */
- (PBDescriptor*) findNestedTypeByName:(NSString*) name {
    id result = [file.pool findSymbol:[NSString stringWithFormat:@"%@.%@", self.fullName, name]];
    if (result != nil && [result isKindOfClass:[PBDescriptor class]]) {
        return result;
    } else {
        return nil;
    }
}


/**
 * Finds a nested enum type by name.
 * @param name The unqualified name of the nested type (e.g. "Foo").
 * @return The types's descriptor, or {@code nil} if not found.
 */
- (PBEnumDescriptor*) findEnumTypeByName:(NSString*) name {
    id result = [file.pool findSymbol:[NSString stringWithFormat:@"%@.%@", self.fullName, name]];
    if (result != nil && [result isKindOfClass:[PBEnumDescriptor class]]) {
        return result;
    } else {
        return nil;
    }
}


- (id<PBMessage>) toProto {
    return proto;
}


- (NSString*) name {
    return proto.name;
}


- (void) crossLink {
    for (PBDescriptor* d in self.nestedTypes) {
        [d crossLink];
    }

    for (PBFieldDescriptor* f in self.fields) {
        [f crossLink];
    }

    for (PBFieldDescriptor* f in self.extensions) {
        [f crossLink];
    }
}


@end