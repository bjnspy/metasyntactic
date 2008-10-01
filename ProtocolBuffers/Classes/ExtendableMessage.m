//
//  ExtendableMessage.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ExtendableMessage.h"

#import "DynamicMessage.h"
#import "FieldDescriptor.h"
#import "FieldSet.h"
#import "ExtensionWriter.h"
#import "GeneratedExtension.h"

@implementation ExtendableMessage

@synthesize extensions;

- (void) dealloc {
    self.extensions = nil;
    
    [super dealloc];
}


- (id) init {
    if (self == [super init]) {
        self.extensions = [PBFieldSet set];
    }
    
    return self;
}


- (void) verifyExtensionContainingType:(PBGeneratedExtension*) extension {
    if (extension.getDescriptor.getContainingType != [self getDescriptorForType]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
}


- (BOOL) hasExtension:(PBGeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    return [extensions hasField:extension.getDescriptor];
}


/** Get the number of elements in a repeated extension. */
- (int32_t) getExtensionCount:(PBGeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    return [extensions getRepeatedFieldCount:extension.getDescriptor];
}


/** Get the value of an extension. */
- (id) getExtension:(PBGeneratedExtension*) extension {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


/** Get one element of a repeated extension. */
- (id) getExtension:(PBGeneratedExtension*) extension index:(int32_t) index {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


/** Called by subclasses to check if all extensions are initialized. */
- (BOOL) extensionsAreInitialized {
    return extensions.isInitialized;
}


- (ExtensionWriter*) newExtensionWriter {
    return [[[ExtensionWriter alloc] init] autorelease];
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


- (void) verifyContainingType:(PBFieldDescriptor*) field {
    if (field.getContainingType != [self getDescriptorForType]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"PBFieldDescriptor does not match message type." userInfo:nil];
    }
}


- (BOOL) hasField:(PBFieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions hasField:field];
    } else {
        return [super hasField:field];
    }
}


- (id) getField:(PBFieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        id value = [extensions getField:field];
        if (value == nil) {
            // Lacking an PBExtensionRegistry, we have no way to determine the
            // extension's real type, so we return a DynamicMessage.
            return [PBDynamicMessage getDefaultInstance:field.getMessageType];
        } else {
            return value;
        }
    } else {
        return [super getField:field];
    }
}


- (int32_t) getRepeatedFieldCount:(PBFieldDescriptor*) field {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions getRepeatedFieldCount:field];
    } else {
        return [super getRepeatedFieldCount:field];
    }
}


- (id) getRepeatedField:(PBFieldDescriptor*) field index:(int32_t) index {
    if (field.isExtension) {
        [self verifyContainingType:field];
        return [extensions getRepeatedField:field index:index];
    } else {
        return [super getRepeatedField:field index:index];
    }
}

@end
