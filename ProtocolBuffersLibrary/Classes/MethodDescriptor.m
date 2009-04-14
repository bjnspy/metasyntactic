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

#import "MethodDescriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"

@interface PBMethodDescriptor()
    @property int32_t index;
    @property (retain) PBMethodDescriptorProto* proto;
    @property (copy) NSString* fullName;
    @property (retain) PBFileDescriptor* file;
    @property (retain) PBServiceDescriptor* service;
    @property (retain) PBDescriptor* inputType;
    @property (retain) PBDescriptor* outputType;
@end


@implementation PBMethodDescriptor

@synthesize index;
@synthesize proto;
@synthesize fullName;
@synthesize file;
@synthesize service;
@synthesize inputType;
@synthesize outputType;

- (void) dealloc {
    self.index = 0;
    self.proto = nil;
    self.fullName = nil;
    self.file = nil;
    self.service = nil;
    self.inputType = nil;
    self.outputType = nil;

    [super dealloc];
}


- (id) initWithProto:(PBMethodDescriptorProto*) proto_
                file:(PBFileDescriptor*) file_
              parent:(PBServiceDescriptor*) parent_
               index:(int32_t) index_ {
    if (self = [super init]) {
        self.index = index_;
        self.proto = proto_;
        self.file = file_;
        self.service = parent_;

        self.fullName = [NSString stringWithFormat:@"%@.%@", parent_.fullName, proto.name];

        [file.pool addSymbol:self];
    }

    return self;
}


+ (PBMethodDescriptor*) descriptorWithProto:(PBMethodDescriptorProto*) proto
                                       file:(PBFileDescriptor*) file
                                     parent:(PBServiceDescriptor*) parent
                                      index:(int32_t) index {
    return [[[PBMethodDescriptor alloc] initWithProto:proto file:file parent:parent index:index] autorelease];
}


- (id<PBMessage>) toProto {
    return proto;
}


- (NSString*) name {
    return proto.name;
}


- (void) crossLink {
    id inputType_ = [file.pool lookupSymbol:proto.inputType relativeTo:self];
    if (![inputType_ isKindOfClass:[PBDescriptor class]]) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    }
    self.inputType = inputType_;

    id outputType_ = [file.pool lookupSymbol:proto.outputType relativeTo:self];
    if (![outputType_ isKindOfClass:[PBDescriptor class]]) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    }
    self.outputType = outputType_;
}


@end