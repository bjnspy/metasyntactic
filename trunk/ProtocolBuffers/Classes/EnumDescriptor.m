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

#import "EnumDescriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"
#import "DescriptorPool_DescriptorIntPair.h"

@interface PBEnumDescriptor()
    @property int32_t index;
    @property (retain) PBEnumDescriptorProto* proto;
    @property (copy) NSString* fullName;
    @property (retain) PBFileDescriptor* file;
    @property (retain) PBDescriptor* containingType;
    @property (retain) NSMutableArray* mutableValues;
@end


@implementation PBEnumDescriptor

@synthesize index;
@synthesize proto;
@synthesize fullName;
@synthesize file;
@synthesize containingType;
@synthesize mutableValues;

- (void) dealloc {
    self.index = 0;
    self.proto = nil;
    self.fullName = nil;
    self.file = nil;
    self.containingType = nil;
    self.mutableValues = nil;

    [super dealloc];
}


- (id) initWithProto:(PBEnumDescriptorProto*) proto_
                file:(PBFileDescriptor*) file_
              parent:(PBDescriptor*) parent_
               index:(int32_t) index_ {
    if (self = [super init]) {
        self.index = index_;
        self.proto = proto_;
        self.file = file_;
        self.containingType = parent_;

        self.fullName = [PBDescriptor computeFullName:file_ parent:parent_ name:proto.name];

        if (proto.valueList.count == 0) {
            // We cannot allow enums with no values because this would mean there
            // would be no valid default value for fields of this type.
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Enums must contain at least one value." userInfo:nil];
        }

        self.mutableValues = [NSMutableArray array];
        for (PBEnumValueDescriptorProto* v in proto.valueList) {
            [mutableValues addObject:[PBEnumValueDescriptor descriptorWithProto:v file:file parent:self index:mutableValues.count]];
        }

        [file.pool addSymbol:self];
    }

    return self;
}


+ (PBEnumDescriptor*) descriptorWithProto:(PBEnumDescriptorProto*) proto
                                     file:(PBFileDescriptor*) file
                                   parent:(PBDescriptor*) parent
                                    index:(int32_t) index {
    return [[[PBEnumDescriptor alloc] initWithProto:proto file:file parent:parent index:index] autorelease];
}


- (NSArray*) values {
    return mutableValues;
}


- (PBEnumValueDescriptor*) findValueByNumber:(int32_t) number {
    PBDescriptorPool_DescriptorIntPair* key = [PBDescriptorPool_DescriptorIntPair pairWithDescriptor:self number:number];
    return [file.pool.enumValuesByNumber objectForKey:key];
}


/**
 * Find an enum value by name.
 * @param name The unqualified name of the value (e.g. "FOO").
 * @return the value's decsriptor, or {@code nil} if not found.
 */
- (PBEnumValueDescriptor*) findValueByName:(NSString*) name {
    id result = [file.pool findSymbol:[NSString stringWithFormat:@"%@.%@", fullName, name]];

    if (result != nil && [result isKindOfClass:[PBEnumValueDescriptor class]]) {
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


- (PBEnumOptions*) options {
    return proto.options;
}

@end