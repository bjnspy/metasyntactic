// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

@interface FileDescriptor : NSObject {
}
#if 0
    FileDescriptorProto* proto;
    NSArray* messageTypes;
    NSArray* enumTypes;
    NSArray* services;
    NSArray* extensions;
    NSArray* dependencies;
    NSArray* DescriptorPool* pool;
}

@property (retain) FileDescriptorProto* proto;
@property (retain) NSArray* messageTypes;
@property (retain) NSArray* enumTypes;
@property (retain) NSArray* services;
@property (retain) NSArray* extensions;
@property (retain) NSArray* dependencies;
@property (retain) NSArray* DescriptorPool* pool;

+ (FileDescriptor*) descriptorWithProto:(FileDescriptorProto*) proto
                           dependencies:(NSArray*) dependencies
                                   pool:(DescriptorPool*) pool;

- (FieldDescriptorProto*) toProto;
- (NSString*) name;
- (NSString*) package;
- (FileOptions*) options; 
- (NSArray*) messageTypes;
- (NSArray*) enumTypes;
- (NSArray*) services;
- (NSArray*) extensions;
- (NSArray*) dependencies;

- (Descriptor*) findMessageTypeByName:(NSString*) name;
- (EnumDescriptor*) findEnumTypeByName:(NSString*) name;
- (ServiceDescriptor*) findServiceByName:(NSString*) name;
- (FieldDescriptor*) findExtensionByName:(NSString*) name;

+ (FileDescriptor*) buildFrom:(FileDescriptorProto*) proto dependencies:(NSArray*) dependencies;
+ (FileDescriptor*) internalBuildGeneratedFileFrom:(NSString*) descriptorData dependencies:(NSArray*) dependencies;
#endif

@end
