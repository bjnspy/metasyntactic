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

#import "FieldSet.h"

#import "CodedInputStream.h"
#import "CodedOutputStream.h"
#import "Descriptor.h"
#import "EnumValueDescriptor.h"
#import "Field.h"
#import "FieldDescriptor.h"
#import "Message.h"
#import "MessageOptions.h"
#import "Message_Builder.h"

@implementation FieldSet

static FieldSet* DEFAULT_INSTANCE = nil;

+ (void) initialize {
    if (self == [FieldSet class]) {
        DEFAULT_INSTANCE = [[FieldSet alloc] initWithFields:[NSMutableDictionary dictionary]];
    }
}


@synthesize fields;

- (void) dealloc {
    self.fields = nil;

    [super dealloc];
}


+ (FieldSet*) emptySet {
    return DEFAULT_INSTANCE;
}


+ (void) mergeFromCodedInputStream:(CodedInputStream*) input
                     unknownFields:(UnknownFieldSet_Builder*) unknownFields
                 extensionRegistry:(ExtensionRegistry*) extensionRegistry
                           builder:(id<Message_Builder>) builder {
    while (true) {
        int32_t tag = [input readTag];
        if (tag == 0) {
            break;
        }
        
        if (![self mergeFieldFromCodedInputStream:input
                                    unknownFields:unknownFields
                                extensionRegistry:extensionRegistry
                                          builder:builder
                                              tag:tag]) {
            // end group tag
            break;
        }
    }
}


- (id) initWithFields:(NSMutableDictionary*) fields_ {
    if (self = [super init]) {
        self.fields = fields_;
    }
    
    return self;
}


- (id) init {
    if (self = [super init]) {
        self.fields = [NSMutableDictionary dictionary];
    }
    
    return fields;
}


+ (FieldSet*) set {
    return [[[FieldSet alloc] init] autorelease];
}


- (void) clear {
    [fields removeAllObjects];
}


/** See {@link Message#getAllFields()}. */
- (NSDictionary*) getAllFields {
    return [NSDictionary dictionaryWithDictionary:fields];
}


/** See {@link Message#hasField(Descriptors.FieldDescriptor)}. */
- (BOOL) hasField:(FieldDescriptor*) field {
    if (field.isRepeated) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    return [fields objectForKey:field] != nil;
}

/**
 * See {@link Message#getField(Descriptors.FieldDescriptor)}.  This method
 * returns {@code null} if the field is a singular message type and is not
 * set; in this case it is up to the caller to fetch the message's default
 * instance.
 */
- (id) getField:(FieldDescriptor*) field {
    id result = [fields objectForKey:field];
    if (result == nil) {
        if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            if (field.isRepeated) {
                return [NSArray array];
            } else {
                return nil;
            }
        } else {
            return field.getDefaultValue;
        }
    } else {
        return result;
    }
}

/**
 * Verifies that the given object is of the correct type to be a valid
 * value for the given field.  (For repeated fields, this checks if the
 * object is the right type to be one element of the field.)
 *
 * @throws IllegalArgumentException The value is not of the right type.
 */
- (void) verifyType:(FieldDescriptor*) field value:(id) value {
    BOOL isValid = NO;
    switch (field.getObjectiveCType) {
        case ObjectiveCTypeInt32:   isValid = [value isKindOfClass:[NSNumber class]]; break;
        case ObjectiveCTypeInt64:   isValid = [value isKindOfClass:[NSNumber class]]; break;
        case ObjectiveCTypeFloat32: isValid = [value isKindOfClass:[NSNumber class]]; break;
        case ObjectiveCTypeFloat64: isValid = [value isKindOfClass:[NSNumber class]]; break;
        case ObjectiveCTypeBool:    isValid = [value isKindOfClass:[NSNumber class]]; break;
        case ObjectiveCTypeString:  isValid = [value isKindOfClass:[NSString class]]; break;
        case ObjectiveCTypeData:    isValid = [value isKindOfClass:[NSData class]]; break;
        case ObjectiveCTypeEnum:
            isValid = [value isKindOfClass:[EnumValueDescriptor class]] &&
            ((EnumValueDescriptor*)value).getType == field.getEnumType;
            break;
        case ObjectiveCTypeMessage:
            isValid = [value conformsToProtocol:@protocol(Message)] &&
            [value getDescriptorForType] == field.getMessageType;
            break;
    }
    
    if (!isValid) {
        // When chaining calls to setField(), it can be hard to tell from
        // the stack trace which exact call failed, since the whole chain is
        // considered one line of code.  So, let's make sure to include the
        // field name and other useful info in the exception.
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
        /*
         throw new IllegalArgumentException(
         "Wrong object type used with protocol message reflection.  " +
         "Message type \"" + field.getContainingType().getFullName() +
         "\", field \"" +
         (field.isExtension() ? field.getFullName() : field.getName()) +
         "\", value was type \"" + value.getClass().getName() + "\".");
         */
    }
}


/** See {@link Message.Builder#setField(Descriptors.FieldDescriptor,Object)}. */
- (void) setField:(FieldDescriptor*) field
            value:(id) value {
    if (field.isRepeated) {
        if (![value isKindOfClass:[NSArray class]]) {
            @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
        }
        
        // Wrap the contents in a new list so that the caller cannot change
        // the list's contents after setting it.
        NSMutableArray* newList = [NSMutableArray array];
        [newList addObjectsFromArray:value];
        for (id element in newList) {
            [self verifyType:field value:element];
        }
        value = newList;
    } else {
        [self verifyType:field value:value];
    }
    
    [fields setObject:value forKey:field];
}

/** See {@link Message.Builder#clearField(Descriptors.FieldDescriptor)}. */

- (void) clearField:(FieldDescriptor*) field {
    [fields removeObjectForKey:field];
}


/** See {@link Message#getRepeatedFieldCount(Descriptors.FieldDescriptor)}. */
- (int32_t) getRepeatedFieldCount:(FieldDescriptor*) field {
    if (!field.isRepeated) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    return [[self getField:field] count];
}


/** See {@link Message#getRepeatedField(Descriptors.FieldDescriptor,int)}. */
- (id) getRepeatedField:(FieldDescriptor*) field
                  index:(int32_t) index {
    if (!field.isRepeated) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    return [[self getField:field] objectAtIndex:index];
}


/** See {@link Message.Builder#setRepeatedField(Descriptors.FieldDescriptor,int,Object)}. */
- (void) setRepeatedField:(FieldDescriptor*) field
                    index:(int32_t) index
                    value:(id) value {
    if (!field.isRepeated) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    [self verifyType:field value:value];
    
    
    NSMutableArray* list = [fields objectForKey:field];
    if (list == nil) {
        @throw [NSException exceptionWithName:@"IndexOutOfBounds" reason:@"" userInfo:nil];
    }
    [list replaceObjectAtIndex:index withObject:value];
}


- (void) addRepeatedField:(FieldDescriptor*) field value:(id) value {
    if (!field.isRepeated) {
        @throw [NSException exceptionWithName:@"IllegalArgument" reason:@"" userInfo:nil];
    }
    
    [self verifyType:field value:value];
    
    NSMutableArray* list = [fields objectForKey:field];
    if (list == nil) {
        list = [NSMutableArray array];
        [fields setObject:list forKey:field];
    }
    [list addObject:value];
}


// =================================================================
// Parsing and serialization

/**
 * See {@link Message#isInitialized()}.  Note:  Since {@code FieldSet}
 * itself does not have any way of knowing about required fields that
 * aren't actually present in the set, it is up to the caller to check
 * that all required fields are present.
 */
- (BOOL) isInitialized {
    for (FieldDescriptor* field in fields) {
        id value = [fields objectForKey:field];
        
        if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            if (field.isRepeated) {
                for (id<Message> element in value) {
                    if (![element isInitialized]) {
                        return NO;
                    }
                }
            } else {
                if (![value isInitialized]) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}


/**
 * Like {@link #isInitialized()}, but also checks for the presence of
 * all required fields in the given type.
 */
- (BOOL) isInitialized:(Descriptor*) type {
    // Check that all required fields are present.
    for (FieldDescriptor* field in type.getFields) {
        if (field.isRequired) {
            if (![self hasField:field]) {
                return NO;
            }
        }
    }
    
    // Check that embedded messages are initialized.
    return [self isInitialized];
}


/** See {@link Message.Builder#mergeFrom(Message)}. */
- (void) mergeFromMessage:(id<Message>) other {
    // Note:  We don't attempt to verify that other's fields have valid
    //   types.  Doing so would be a losing battle.  We'd have to verify
    //   all sub-messages as well, and we'd have to make copies of all of
    //   them to insure that they don't change after verification (since
    //   the Message interface itself cannot enforce immutability of
    //   implementations).
    // TODO(kenton):  Provide a function somewhere called makeDeepCopy()
    //   which allows people to make secure deep copies of messages.
    
    NSDictionary* otherAllFields = [other getAllFields];
    for (FieldDescriptor* field in otherAllFields) {
        id otherValue = [otherAllFields objectForKey:field];
        
        if (field.isRepeated) {
            NSMutableArray* existingValue = [fields objectForKey:field];
            if (existingValue == nil) {
                existingValue = [NSMutableArray array];
                [fields setObject:existingValue forKey:field];
            }
            [existingValue addObjectsFromArray:otherValue];
        } else if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            id<Message> existingValue = [fields objectForKey:field];
            if (existingValue == nil) {
                [self setField:field value:otherValue];
            } else {
                [self setField:field
                         value:[[[[existingValue newBuilderForType] mergeFrom:existingValue] mergeFrom:otherValue] build]];
            }
        } else {
            [self setField:field value:otherValue];
        }
    }
}


/**
 * Like {@link #mergeFrom(Message)}, but merges from another {@link FieldSet}.
 */
- (void) mergeFromFieldSet:(FieldSet*) other {
    for (FieldDescriptor* field in other.fields) {
        id value = [other.fields objectForKey:field];
        
        if (field.isRepeated) {
            NSMutableArray* existingValue = [fields objectForKey:field];
            if (existingValue == nil) {
                existingValue = [NSMutableArray array];
                [fields setObject:existingValue forKey:field];
            }
            [existingValue addObjectsFromArray:value];
        } else if (field.getObjectiveCType == ObjectiveCTypeMessage) {
            id<Message> existingValue = [fields objectForKey:field];
            if (existingValue == nil) {
                [self setField:field value:value];
            } else {
                [self setField:field
                         value:[[[[existingValue newBuilderForType] mergeFrom:existingValue] mergeFrom:value] build]];
            }
        } else {
            [self setField:field value:value];
        }
    }
}

// TODO(kenton):  Move parsing code into AbstractMessage, since it no longer
//   uses any special knowledge from FieldSet.


/**
 * Like {@link #mergeFrom(CodedInputStream, UnknownFieldSet.Builder,
 * ExtensionRegistry, Message.Builder)}, but parses a single field.
 * @param tag The tag, which should have already been read.
 * @return {@code true} unless the tag is an end-group tag.
 */
+ (BOOL) mergeFieldFromCodedInputStream:(CodedInputStream*) input 
                          unknownFields:(UnknownFieldSet_Builder*) unknownFields
                      extensionRegistry:(ExtensionRegistry*) extensionRegistry
                                builder:(id<Message_Builder>) builder
                                    tag:(int32_t) tag {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    /*
    Descriptor* type = builder.getDescriptorForType;
    
    if (type.getOptions.getMessageSetWireFormat &&
        tag == WireFormatMessageSetItemTag) {
        mergeMessageSetExtensionFromCodedStream(
                                                input, unknownFields, extensionRegistry, builder);
        return true;
    }
    
    int wireType = WireFormat.getTagWireType(tag);
    int fieldNumber = WireFormat.getTagFieldNumber(tag);
    
    FieldDescriptor field;
    Message defaultInstance = null;
    
    if (type.isExtensionNumber(fieldNumber)) {
        ExtensionRegistry.ExtensionInfo extension =
        extensionRegistry.findExtensionByNumber(type, fieldNumber);
        if (extension == null) {
            field = null;
        } else {
            field = extension.descriptor;
            defaultInstance = extension.defaultInstance;
        }
    } else {
        field = type.findFieldByNumber(fieldNumber);
    }
    
    if (field == null ||
        wireType != WireFormat.getWireFormatForFieldType(field.getType())) {
        // Unknown field or wrong wire type.  Skip.
        return unknownFields.mergeFieldFrom(tag, input);
    } else {
        Object value;
        switch (field.getType()) {
            case GROUP: {
                Message.Builder subBuilder;
                if (defaultInstance != null) {
                    subBuilder = defaultInstance.newBuilderForType();
                } else {
                    subBuilder = builder.newBuilderForField(field);
                }
                if (!field.isRepeated()) {
                    subBuilder.mergeFrom((Message) builder.getField(field));
                }
                input.readGroup(field.getNumber(), subBuilder, extensionRegistry);
                value = subBuilder.build();
                break;
            }
            case MESSAGE: {
                Message.Builder subBuilder;
                if (defaultInstance != null) {
                    subBuilder = defaultInstance.newBuilderForType();
                } else {
                    subBuilder = builder.newBuilderForField(field);
                }
                if (!field.isRepeated()) {
                    subBuilder.mergeFrom((Message) builder.getField(field));
                }
                input.readMessage(subBuilder, extensionRegistry);
                value = subBuilder.build();
                break;
            }
            case ENUM: {
                int rawValue = input.readEnum();
                value = field.getEnumType().findValueByNumber(rawValue);
                // If the number isn't recognized as a valid value for this enum,
                // drop it.
                if (value == null) {
                    unknownFields.mergeVarintField(fieldNumber, rawValue);
                    return true;
                }
                break;
            }
            default:
                value = input.readPrimitiveField(field.getType());
                break;
        }
        
        if (field.isRepeated()) {
            builder.addRepeatedField(field, value);
        } else {
            builder.setField(field, value);
        }
    }
    
    return true;
     */
}

/** Called by {@code #mergeFieldFrom()} to parse a MessageSet extension. */
+ (void) mergeMessageSetExtensionFromCodedStream:(CodedInputStream*) input
                                   unknownFields:(UnknownFieldSet_Builder*) unknownFields
                               extensionRegistry:(ExtensionRegistry*) extensionRegistry
                                         builder:(id<Message_Builder>) builder {
    @throw [NSException exceptionWithName:@"" reason:@"" userInfo:nil];
    /*
    Descriptor type = builder.getDescriptorForType();
    
    // The wire format for MessageSet is:
    //   message MessageSet {
    //     repeated group Item = 1 {
    //       required int32 typeId = 2;
    //       required bytes message = 3;
    //     }
    //   }
    // "typeId" is the extension's field number.  The extension can only be
    // a message type, where "message" contains the encoded bytes of that
    // message.
    //
    // In practice, we will probably never see a MessageSet item in which
    // the message appears before the type ID, or where either field does not
    // appear exactly once.  However, in theory such cases are valid, so we
    // should be prepared to accept them.
    
    int typeId = 0;
    ByteString rawBytes = null;  // If we encounter "message" before "typeId"
    Message.Builder subBuilder = null;
    FieldDescriptor field = null;
    
    while (true) {
        int tag = input.readTag();
        if (tag == 0) {
            break;
        }
        
        if (tag == WireFormat.MESSAGE_SET_TYPE_ID_TAG) {
            typeId = input.readUInt32();
            // Zero is not a valid type ID.
            if (typeId != 0) {
                ExtensionRegistry.ExtensionInfo extension =
                extensionRegistry.findExtensionByNumber(type, typeId);
                if (extension != null) {
                    field = extension.descriptor;
                    subBuilder = extension.defaultInstance.newBuilderForType();
                    Message originalMessage = (Message)builder.getField(field);
                    if (originalMessage != null) {
                        subBuilder.mergeFrom(originalMessage);
                    }
                    if (rawBytes != null) {
                        // We already encountered the message.  Parse it now.
                        subBuilder.mergeFrom(
                                             CodedInputStream.newInstance(rawBytes.newInput()));
                        rawBytes = null;
                    }
                } else {
                    // Unknown extension number.  If we already saw data, put it
                    // in rawBytes.
                    if (rawBytes != null) {
                        unknownFields.mergeField(typeId,
                                                 UnknownFieldSet.Field.newBuilder()
                                                 .addLengthDelimited(rawBytes)
                                                 .build());
                        rawBytes = null;
                    }
                }
            }
        } else if (tag == WireFormat.MESSAGE_SET_MESSAGE_TAG) {
            if (typeId == 0) {
                // We haven't seen a type ID yet, so we have to store the raw bytes
                // for now.
                rawBytes = input.readBytes();
            } else if (subBuilder == null) {
                // We don't know how to parse this.  Ignore it.
                unknownFields.mergeField(typeId,
                                         UnknownFieldSet.Field.newBuilder()
                                         .addLengthDelimited(input.readBytes())
                                         .build());
            } else {
                // We already know the type, so we can parse directly from the input
                // with no copying.  Hooray!
                input.readMessage(subBuilder, extensionRegistry);
            }
        } else {
            // Unknown tag.  Skip it.
            if (!input.skipField(tag)) {
                break;  // end of group
            }
        }
    }
    
    input.checkLastTagWas(WireFormat.MESSAGE_SET_ITEM_END_TAG);
    
    if (subBuilder != null) {
        builder.setField(field, subBuilder.build());
    }
     */
}

/** See {@link Message#writeTo(CodedOutputStream)}. */
- (void) writeToCodedOutputStream:(CodedOutputStream*) output {
    for (FieldDescriptor* field in fields) {
        id value = [fields objectForKey:field];
        [self writeField:field value:value output:output];
    }
}


/** Write a single field. */
- (void) writeField:(FieldDescriptor*) field value:(id) value output:(CodedOutputStream*) output {
    if (field.isExtension &&
        field.getContainingType.getOptions.getMessageSetWireFormat) {
        [output writeMessageSetExtension:field.getNumber value:value];
    } else {
        if (field.isRepeated) {
            for (id element in value) {
                [output writeField:field.getType number:field.getNumber value:element];
            }
        } else {
            [output writeField:field.getType number:field.getNumber value:value];
        }
    }
}

/**
 * See {@link Message#getSerializedSize()}.  It's up to the caller to cache
 * the resulting size if desired.
 */
- (int32_t) getSerializedSize {
    int size = 0;
    for (FieldDescriptor* field in fields) {
        id value = [fields objectForKey:field];
        
        if (field.isExtension &&
            field.getContainingType.getOptions.getMessageSetWireFormat) {
            size += computeMessageSetExtensionSize(field.getNumber, value);
        } else {
            if (field.isRepeated) {
                for (id element in value) {
                    size += computeFieldSize(field.getType, field.getNumber, element);
                }
            } else {
                size += computeFieldSize(field.getType, field.getNumber, value);
            }
        }
    }
    return size;
}


@end
