//
//  GeneratedMessage_ExtendableMessage.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GeneratedMessage_ExtendableMessage.h"

#import "DynamicMessage.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "GeneratedMessage_ExtendableMessage_ExtensionWriter.h"
#import "GeneratedMessage_GeneratedExtension.h"

@implementation GeneratedMessage_ExtendableMessage

@synthesize extensions;

- (void) dealloc {
    self.extensions = nil;
    
    [super dealloc];
}


- (id) init {
    if (self == [super init]) {
        self.extensions = [FieldSet set];
    }
    
    return self;
}


- (void) verifyExtensionContainingType:(GeneratedMessage_GeneratedExtension*) extension {
    if (extension.getDescriptor.getContainingType != [self getDescriptorForType]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
}


- (BOOL) hasExtension:(GeneratedMessage_GeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    return [extensions hasField:extension.getDescriptor];
}


/** Get the number of elements in a repeated extension. */
- (int32_t) getExtensionCount:(GeneratedMessage_GeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    return [extensions getRepeatedFieldCount:extension.getDescriptor];
}


/** Get the value of an extension. */
- (id) getExtension:(GeneratedMessage_GeneratedExtension*) extension {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


/** Get one element of a repeated extension. */
- (id) getExtension:(GeneratedMessage_GeneratedExtension*) extension index:(int32_t) index {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


/** Called by subclasses to check if all extensions are initialized. */
- (BOOL) extensionsAreInitialized {
    return extensions.isInitialized;
}


- (GeneratedMessage_ExtendableMessage_ExtensionWriter*) newExtensionWriter {
    return [[[GeneratedMessage_ExtendableMessage_ExtensionWriter alloc] init] autorelease];
}


/** Called by subclasses to compute the size of extensions. */
- (int32_t) extensionsSerializedSize {
    return extensions.getSerializedSize;
}


// ---------------------------------------------------------------
// Reflection

- (NSMutableDictionary*) getAllFieldsMutable {
    NSMutableDictionary* result = [super getAllFieldsMutable];
    [result addEntriesFromDictionary:extensions.getAllFields];
    return result;
}


- (void) verifyContainingType:(FieldDescriptor*) field {
    if (field.getContainingType != [self getDescriptorForType]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"FieldDescriptor does not match message type." userInfo:nil];
    }
}


- (BOOL) hasField:(FieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions hasField:field];
    } else {
        return [super hasField:field];
    }
}


- (id) getField:(FieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        id value = [extensions getField:field];
        if (value == nil) {
            // Lacking an ExtensionRegistry, we have no way to determine the
            // extension's real type, so we return a DynamicMessage.
            return [DynamicMessage getDefaultInstance:field.getMessageType];
        } else {
            return value;
        }
    } else {
        return [super getField:field];
    }
}


- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions getRepeatedFieldCount:field];
    } else {
        return [super getRepeatedFieldCount:field];
    }
}


- (id) getRepeatedField:(FieldDescriptor*) field index:(int32_t) index {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions getRepeatedField:field index:index];
    } else {
        return [super getRepeatedField:field index:index];
    }
}

@end
