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

#import "DynamicMessage.h"

#import "DynamicMessage_Builder.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "Message.h"
#import "UnknownFieldSet.h"

@implementation DynamicMessage


@synthesize type;
@synthesize fields;
@synthesize unknownFields;
@synthesize memoizedSize;

- (void) dealloc {
    self.type = nil;
    self.fields = nil;
    self.unknownFields = nil;
    self.memoizedSize = 0;
    
    [super dealloc];
}



- (id) initWithType:(Descriptor*) type_
             fields:(FieldSet*) fields_
      unknownFields:(UnknownFieldSet*) unknownFields_ {
    if (self = [super init]) {
        self.type = type;
        self.fields = fields;
        self.unknownFields = unknownFields_;
        self.memoizedSize = -1;
    }
    
    return self;
}


+ (DynamicMessage*) getDefaultInstance:(Descriptor*) type {
    return [[[DynamicMessage alloc] initWithType:type
                                          fields:[FieldSet emptySet]
                                   unknownFields:[UnknownFieldSet getDefaultInstance]] autorelease];
}


+ (id<Message>) parseFrom:(Descriptor*) type
             codedInputStream:(CodedInputStream*) input {
    return [[[DynamicMessage builderWithType:type] mergeFromCodedInputStream:input] buildParsed];
}


+ (id<Message>) parseFrom:(Descriptor*) type
             codedInputStream:(CodedInputStream*) input
            extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    return [[[DynamicMessage builderWithType:type] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] buildParsed];
}


+ (id<Message>) parseFrom:(Descriptor*) type
                         data:(NSData*) data {
    return [[[DynamicMessage builderWithType:type] mergeFromData:data] buildParsed];
}


+ (id<Message>) parseFrom:(Descriptor*) type
                         data:(NSData*) data
            extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    return [[[DynamicMessage builderWithType:type] mergeFromData:data extensionRegistry:extensionRegistry] buildParsed];
}


+ (id<Message>) parseFrom:(Descriptor*) type
                  inputStream:(NSInputStream*) input {
    return [[[DynamicMessage builderWithType:type] mergeFromInputStream:input] buildParsed];
}


+ (id<Message>) parseFrom:(Descriptor*) type
                  inputStream:(NSInputStream*) input
            extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    return [[[DynamicMessage builderWithType:type] mergeFromInputStream:input extensionRegistry:extensionRegistry] buildParsed];
}


+ (DynamicMessage_Builder*) bulderWithType:(Descriptor*) type {
    return [DynamicMessage_Builder builderWithType:type];
}


+ (DynamicMessage_Builder*) builderWithMessage:(id<Message>) prototype {
    return [[DynamicMessage_Builder builderWithType:[prototype getDescriptorForType]] mergeFrom:prototype];
}


- (Descriptor*) getDescriptorForType {
    return type;
}


- (DynamicMessage*) getDefaultInstanceForType {
    return [DynamicMessage getDefaultInstance:type];
}


- (NSDictionary*) getAllFields {
    return fields.getAllFields;
}


- (void) verifyContainingType:(FieldDescriptor*) field {
    if (field.getContainingType != type) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
}


- (BOOL) hasField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields hasField:field];
}


- (id) getField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    id result = [fields getField:field];
    if (result == nil) {
        result = [DynamicMessage getDefaultInstance:field.getMessageType];
    }
    return result;
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields getRepeatedFieldCount:field];
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    [self verifyContainingType:field];
    return [fields getRepeatedField:field index:index];
}


- (UnknownFieldSet*) getUnknownFields {
    return unknownFields;
}


- (BOOL) isInitialized {
    return [fields isInitialized:type];
}


- (void) writeToCodedOutputStream:(CodedOutputStream*) output {
    [fields writeToCodedOutputStream:output];
    
    if (type.getOptions.getMessageSetWireFormat) {
        [unknownFields writeAsMessageSetTo:output];
    } else {
        [unknownFields writeToCodedOutputStream:output];
    }
}


- (int32_t) getSerializedSize {
    int size = memoizedSize;
    if (size != -1) return size;
    
    size = fields.getSerializedSize;
    if (type.getOptions.getMessageSetWireFormat) {
        size += unknownFields.getSerializedSizeAsMessageSet;
    } else {
        size += unknownFields.getSerializedSize;
    }
    
    memoizedSize = size;
    return size;
}


- (DynamicMessage_Builder*) newBuilderForType {
    return [DynamicMessage_Builder builderWithType:type];
}


+ (DynamicMessage_Builder*) builderWithType:(Descriptor*) type {
    return [DynamicMessage_Builder builderWithType:type];
}


@end
