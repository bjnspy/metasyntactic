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

#import "FieldDescriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"

@interface PBFieldDescriptor()
    @property int32_t index;
    @property (retain) PBFieldDescriptorProto* proto;
    @property (copy) NSString* fullName;
    @property (retain) PBFileDescriptor* file;
    @property (retain) PBDescriptor* extensionScope;
    @property PBFieldDescriptorType type;
    @property (retain) PBDescriptor* containingType;
    @property (retain) PBDescriptor* messageType;
    @property (retain) PBEnumDescriptor* enumType;
    @property (retain) id defaultValue;
@end


@implementation PBFieldDescriptor

@synthesize index;
@synthesize proto;
@synthesize fullName;
@synthesize file;
@synthesize extensionScope;
@synthesize type;
@synthesize containingType;
@synthesize messageType;
@synthesize enumType;
@synthesize defaultValue;

- (void) dealloc {
    self.index = 0;
    self.proto = nil;
    self.fullName = nil;
    self.file = nil;
    self.extensionScope = nil;
    self.type = 0;
    self.containingType = nil;
    self.messageType = nil;
    self.enumType = nil;
    self.defaultValue = nil;

    [super dealloc];
}


- (id) initWithProto:(PBFieldDescriptorProto*) proto_
                file:(PBFileDescriptor*) file_
              parent:(PBDescriptor*) parent_
               index:(int32_t) index_
         isExtension:(BOOL) isExtension_ {
    if (self = [super init]) {
        self.index = index_;
        self.proto = proto_;
        self.fullName = [PBDescriptor computeFullName:file_ parent:parent_ name:proto.name];
        self.file = file_;
        
        if (proto.hasType) {
            self.type = PBFieldDescriptorTypeValueOf(proto.type);
        }
        
        if (self.number <= 0) {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Field numbers must be positive integers." userInfo:nil];
        }
        
        if (isExtension_) {
            if (!proto.hasExtendee) {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"FieldDescriptorProto.extendee not set for extension field." userInfo:nil];
            }
            self.containingType = nil;  // Will be filled in when cross-linking
            if (parent_ != nil) {
                self.extensionScope = parent_;
            } else {
                self.extensionScope = nil;
            }
        } else {
            if (proto.hasExtendee) {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"FieldDescriptorProto.extendee set for non-extension field." userInfo:nil];
            }
            self.containingType = parent_;
            self.extensionScope = nil;
        }
        
        [file.pool addSymbol:self];
    }
    
    return self;
}


+ (PBFieldDescriptor*) descriptorWithProto:(PBFieldDescriptorProto*) proto
                                      file:(PBFileDescriptor*) file
                                    parent:(PBDescriptor*) parent
                                     index:(int32_t) index
                               isExtension:(BOOL) isExtension {
    return [[[PBFieldDescriptor alloc] initWithProto:proto file:file parent:parent index:index isExtension:isExtension] autorelease];
}


- (BOOL) isRequired {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isRepeated {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isExtension {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (BOOL) isOptional {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBObjectiveCType) objectiveCType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBDescriptor*) containingType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBDescriptor*) extensionScope {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBDescriptor*) messageType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBEnumDescriptor*) enumType {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (id) defaultValue {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (int32_t) index {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (int32_t) number {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (PBFieldDescriptorType) type {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
}


- (id<PBMessage>) toProto {
    return proto;
}


- (NSString*) name {
    return proto.name;
}

@end
