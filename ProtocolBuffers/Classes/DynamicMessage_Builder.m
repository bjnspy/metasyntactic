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

#import "DynamicMessage_Builder.h"

#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "Message.h"
#import "ObjectiveCType.h"
#import "UnknownFieldSet.h"
#import "UnknownFieldSet_Builder.h"

@implementation DynamicMessage_Builder

@synthesize type;
@synthesize fields;
@synthesize unknownFields;

- (void) dealloc {
    self.type = nil;
    self.fields = nil;
    self.unknownFields = nil;
    
    [super dealloc];
}


- (id) initWithType:(Descriptor*) type_
             fields:(FieldSet*) fields_
      unknownFields:(UnknownFieldSet*) unknownFields_ {
    if (self = [super init]) {
        self.type = type_;
        self.fields = fields_;
        self.unknownFields = unknownFields_;
    }
    
    return self;
}


- (DynamicMessage_Builder*) clear {
    [fields clear];
    return self;
}


- (DynamicMessage_Builder*) mergeFrom:(id<Message>) other {
    if ([other getDescriptorForType] != type) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    [fields mergeFromMessage:other];
    return self;
}


- (id<Message>) build {
    if (![self isInitialized]) {
        @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
    }
    return [self buildPartial];
}


- (DynamicMessage*) buildPartial {
    //[fields makeImmutable];
    DynamicMessage* result = [DynamicMessage messageWithType:type fields:fields unknownFields:unknownFields];
    self.fields = nil;
    self.unknownFields = nil;
    return result;
}


- (DynamicMessage_Builder*) clone {
    DynamicMessage_Builder* result = [DynamicMessage_Builder builderWithType:type];
    [result.fields mergeFromFieldSet:fields];
    return result;
}


- (BOOL) isInitialized {
    return [fields isInitialized:type];
}


- (DynamicMessage_Builder*) mergeFromCodedInputStream:(CodedInputStream*) input
                                    extensionRegistry:(ExtensionRegistry*) extensionRegistry {
    UnknownFieldSet_Builder* unknownFieldsBuilder = [UnknownFieldSet newBuilder:unknownFields];
    [FieldSet mergeFromCodedInputStream:input unknownFields:unknownFieldsBuilder extensionRegistry:extensionRegistry builder:self];
    self.unknownFields = [unknownFieldsBuilder build];
    return self;
}


- (Descriptor*) getDescriptorForType {
    return type;
}


- (DynamicMessage*) getDefaultInstanceForType {
    return [self getDefaultInstance:type];
}


- (NSDictionary*) getAllFields {
    return fields.getAllFields;
}


- (void) verifyContainingType:(FieldDescriptor*) field {
    if (field.getContainingType != type) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
}


- (DynamicMessage_Builder*) newBuilderForField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    
    if (field.getObjectiveCType != ObjectiveCTypeMessage) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    return [DynamicMessage_Builder builderWithType:field.getMessageType];
}


- (BOOL) hasField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields hasField:field];
}


- (id) getField:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    id result = [fields getField:field];
    if (result == nil) {
        result = [self getDefaultInstance:field.getMessageType];
    }
    return result;
}


- (DynamicMessage_Builder*) setField:(FieldDescriptor*) field value:(id) value {
    [self verifyContainingType:field];
    [fields setField:field value:value];
    return self;
}


- (DynamicMessage_Builder*) clearField:(FieldDescriptor*) field { 
    [self verifyContainingType:field];
    [fields clearField:field];
    return self;
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    [self verifyContainingType:field];
    return [fields getRepeatedFieldCount:field];
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    [self verifyContainingType:field];
    return [fields getRepeatedField:field index:index];
}


- (DynamicMessage_Builder*) setRepeatedField:(FieldDescriptor*) field
                                       index:(int32_t) index
                                       value:(id) value {
    [self verifyContainingType:field];
    [fields setRepeatedField:field index:index value:value];
    return self;
}


- (DynamicMessage_Builder*) addRepeatedField:(FieldDescriptor*) field
                                       value:(id) value {
    [self verifyContainingType:field];
    [fields addRepeatedField:field value:value];
    return self;
}


- (DynamicMessage_Builder*) mergeUnknownFields:(UnknownFieldSet*) unknownFields_ {
    self.unknownFields = [[[UnknownFieldSet newBuilder:unknownFields] mergeFrom:unknownFields_] build];
    return self;
}


@end
