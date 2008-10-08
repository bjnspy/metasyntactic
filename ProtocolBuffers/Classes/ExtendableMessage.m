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


@interface PBExtendableMessage ()
@property (retain) PBFieldSet* extensions;
@end



@implementation PBExtendableMessage

@synthesize extensions;

- (void) dealloc {
    self.extensions = nil;
    
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.extensions = [PBFieldSet set];
    }
    
    return self;
}


- (void) verifyExtensionContainingType:(PBGeneratedExtension*) extension {
    if (extension.descriptor.containingType != [self descriptorForType]) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
}


- (BOOL) hasExtension:(PBGeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    return [extensions hasField:extension.descriptor];
}


/** Get the number of elements in a repeated extension. */
- (int32_t) getExtensionCount:(PBGeneratedExtension*) extension {
    [self verifyExtensionContainingType:extension];
    return [extensions getRepeatedFieldCount:extension.descriptor];
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


- (PBExtensionWriter*) newExtensionWriter {
    return [[[PBExtensionWriter alloc] init] autorelease];
}


/** Called by subclasses to compute the size of extensions. */
- (int32_t) extensionsSerializedSize {
    return extensions.serializedSize;
}


// ---------------------------------------------------------------
// Reflection

- (NSMutableDictionary*) allFieldsMutable {
    NSMutableDictionary* result = [super allFieldsMutable];
    [result addEntriesFromDictionary:extensions.allFields];
    return result;
}


- (void) verifyContainingType:(PBFieldDescriptor*) field {
    if (field.containingType != [self descriptorForType]) {
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
            return [PBDynamicMessage defaultInstance:field.messageType];
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
