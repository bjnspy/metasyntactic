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
#import "ServiceDescriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"

@interface PBServiceDescriptor()
    @property int32_t index;
    @property (retain) PBServiceDescriptorProto* proto;
    @property (copy) NSString* fullName;
    @property (retain) PBFileDescriptor* file;
    @property (retain) NSMutableArray* mutableMethods;
@end

@implementation PBServiceDescriptor

@synthesize index;
@synthesize proto;
@synthesize fullName;
@synthesize file;
@synthesize mutableMethods;

- (void) dealloc {
    self.index = 0;
    self.proto = nil;
    self.fullName = nil;
    self.file = nil;
    self.mutableMethods = nil;

    [super dealloc];
}


- (id) initWithProto:(PBServiceDescriptorProto*) proto_
                file:(PBFileDescriptor*) file_
               index:(int32_t) index_ {
    if (self = [super init]) {
        self.index = index_;
        self.proto = proto_;
        self.file = file_;

        self.fullName = [PBDescriptor computeFullName:file parent:nil name:proto.name];

        self.mutableMethods = [NSMutableArray array];
        for (PBMethodDescriptorProto* m in proto.methodList) {
            [mutableMethods addObject:[PBMethodDescriptor descriptorWithProto:m file:file parent:self index:mutableMethods.count]];
        }

        [file.pool addSymbol:self];
    }

    return self;
}


+ (PBServiceDescriptor*) descriptorWithProto:(PBServiceDescriptorProto*) proto
                                        file:(PBFileDescriptor*) file
                                       index:(int32_t) index {
    return [[[PBServiceDescriptor alloc] initWithProto:proto file:file index:index] autorelease];
}


- (NSArray*) methods {
    return mutableMethods;
}


- (id<PBMessage>) toProto {
    return proto;
}


- (NSString*) name {
    return proto.name;
}


- (void) crossLink {
    for (PBMethodDescriptor* m in self.methods) {
        [m crossLink];
    }
}


/**
 * Find a method by name.
 * @param name The unqualified name of the method (e.g. "Foo").
 * @return the method's decsriptor, or {@code nil} if not found.
 */
- (PBMethodDescriptor*) findMethodByName:(NSString*) name {
    id result = [file.pool findSymbol:[NSString stringWithFormat:@"%@.%@", self.fullName, name]];
    if (result != nil && [result isKindOfClass:[PBMethodDescriptor class]]) {
        return result;
    } else {
        return nil;
    }
}

@end
#endif