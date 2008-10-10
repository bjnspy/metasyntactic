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

@interface PBFileDescriptor : NSObject {
@private
    PBFileDescriptorProto* proto;
    NSMutableArray* mutableMessageTypes;
    NSMutableArray* mutableExtensions;
    NSMutableArray* mutableEnumTypes;
    NSMutableArray* mutableServices;
    NSMutableArray* mutableDependencies;
    
    // TODO(cyrusn): circularity betwen us and the pool.
    PBDescriptorPool* pool;
}

@property (retain) PBFileDescriptorProto* proto;
@property (retain) PBDescriptorPool* pool;

+ (PBFileDescriptor*) buildFrom:(PBFileDescriptorProto*) proto dependencies:(NSArray*) dependencies;

- (NSArray*) messageTypes;
- (NSArray*) extensions;
- (NSArray*) enumTypes;
- (NSArray*) services;
- (NSArray*) dependencies;

- (NSString*) package;
- (NSString*) name;

- (PBFileOptions*) options;

- (void) crossLink;

- (PBDescriptor*) findMessageTypeByName:(NSString*) name;
- (PBEnumDescriptor*) findEnumTypeByName:(NSString*) name;
- (PBServiceDescriptor*) findServiceByName:(NSString*) name;
- (PBFieldDescriptor*) findExtensionByName:(NSString*) name;

@end