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

#import "FileDescriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"
#import "FileDescriptor.h"


@interface PBFileDescriptor ()
@property (retain) NSArray* messageTypes;
@end


@implementation PBFileDescriptor

@synthesize messageTypes;

- (void) dealloc {
    self.messageTypes = nil;

    [super dealloc];
}

- (id) initWithProto:(PBFileDescriptorProto*) proto
                           dependencies:(NSArray*) dependencies
                                   pool:(PBDescriptorPool*) pool {
    if (self = [super init]) {
        @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
    }

    return self;
}


+ (PBFileDescriptor*) descriptorWithProto:(PBFileDescriptorProto*) proto
                           dependencies:(NSArray*) dependencies
                                   pool:(PBDescriptorPool*) pool {
    return [[[PBFileDescriptor alloc] initWithProto:proto
                                     dependencies:dependencies
                                             pool:pool] autorelease];
}



+ (PBFileDescriptor*) internalBuildGeneratedFileFrom:(NSString*) descriptorData dependencies:(NSArray*) dependencies {
    PBFileDescriptorProto* proto = [PBFileDescriptorProto parseFromData:[descriptorData dataUsingEncoding:NSISOLatin1StringEncoding]];
    // Hack:  We can't embed a raw byte array inside generated Java code
    //   (at least, not efficiently), but we can embed Strings.  So, the
    //   protocol compiler embeds the FileDescriptorProto as a giant
    //   string literal which is passed to this function to construct the
    //   file's PBFileDescriptor.  The string literal contains only 8-bit
    //   characters, each one representing a byte of the FileDescriptorProto's
    //   serialized form.  So, if we convert it to bytes in ISO-8859-1, we
    //   should get the original bytes that we want.
    return [self buildFrom:proto dependencies:dependencies];
}


+ (PBFileDescriptor*) buildFrom:(PBFileDescriptorProto*) proto dependencies:(NSArray*) dependencies {
    // Building decsriptors involves two steps:  translating and linking.
    // In the translation step (implemented by PBFileDescriptor's
    // constructor), we build an object tree mirroring the
    // FileDescriptorProto's tree and put all of the descriptors into the
    // PBDescriptorPool's lookup tables.  In the linking step, we look up all
    // type references in the PBDescriptorPool, so that, for example, a
    // PBFieldDescriptor for an embedded message contains a pointer directly
    // to the PBDescriptor for that message's type.  We also detect undefined
    // types in the linking step.
    PBDescriptorPool* pool = [PBDescriptorPool poolWithDependencies:dependencies];
    PBFileDescriptor* result = [PBFileDescriptor descriptorWithProto:proto dependencies:dependencies pool:pool];

    if (dependencies.count != proto.getDependencyCount) {
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
    }

    for (int i = 0; i < proto.getDependencyCount; i++) {
        if (![[[dependencies objectAtIndex:i] getName] isEqual:[proto getDependency:i]]) {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
        }
    }

    [result crossLink];
    return result;
}


- (NSArray*) getMessageTypes {
    return messageTypes;
}


- (void) crossLink {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}

@end
