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

@implementation FileDescriptor

@synthesize messageTypes;

- (void) dealloc {
    self.messageTypes = nil;

    [super dealloc];
}

- (id) initWithProto:(FileDescriptorProto*) proto
                           dependencies:(NSArray*) dependencies
                                   pool:(DescriptorPool*) pool {
    if (self = [super init]) {
        @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
    }

    return self;
}


+ (FileDescriptor*) descriptorWithProto:(FileDescriptorProto*) proto
                           dependencies:(NSArray*) dependencies
                                   pool:(DescriptorPool*) pool {
    return [[[FileDescriptor alloc] initWithProto:proto
                                     dependencies:dependencies
                                             pool:pool] autorelease];
}



+ (FileDescriptor*) internalBuildGeneratedFileFrom:(NSString*) descriptorData dependencies:(NSArray*) dependencies {
    FileDescriptorProto* proto = [FileDescriptorProto parseFromData:[descriptorData dataUsingEncoding:NSISOLatin1StringEncoding]];
    // Hack:  We can't embed a raw byte array inside generated Java code
    //   (at least, not efficiently), but we can embed Strings.  So, the
    //   protocol compiler embeds the FileDescriptorProto as a giant
    //   string literal which is passed to this function to construct the
    //   file's FileDescriptor.  The string literal contains only 8-bit
    //   characters, each one representing a byte of the FileDescriptorProto's
    //   serialized form.  So, if we convert it to bytes in ISO-8859-1, we
    //   should get the original bytes that we want.
    return [self buildFrom:proto dependencies:dependencies];
}


+ (FileDescriptor*) buildFrom:(FileDescriptorProto*) proto dependencies:(NSArray*) dependencies {
    // Building decsriptors involves two steps:  translating and linking.
    // In the translation step (implemented by FileDescriptor's
    // constructor), we build an object tree mirroring the
    // FileDescriptorProto's tree and put all of the descriptors into the
    // DescriptorPool's lookup tables.  In the linking step, we look up all
    // type references in the DescriptorPool, so that, for example, a
    // FieldDescriptor for an embedded message contains a pointer directly
    // to the Descriptor for that message's type.  We also detect undefined
    // types in the linking step.
    DescriptorPool* pool = [DescriptorPool poolWithDependencies:dependencies];
    FileDescriptor* result = [FileDescriptor descriptorWithProto:proto dependencies:dependencies pool:pool];

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
