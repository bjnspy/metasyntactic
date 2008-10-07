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
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (BOOL) isRepeated {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (BOOL) isExtension {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (BOOL) isOptional {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBObjectiveCType) objectiveCType {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBDescriptor*) containingType {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBDescriptor*) extensionScope {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBDescriptor*) messageType {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (PBEnumDescriptor*) enumType {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (id) defaultValue {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (int32_t) index {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (int32_t) number {
    return proto.number;
}


- (PBFieldDescriptorType) type {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
}


- (id<PBMessage>) toProto {
    return proto;
}


- (NSString*) name {
    return proto.name;
}


- (void) crossLink {
    @throw [NSException exceptionWithName:@"NYI" reason:@"" userInfo:nil];
#if 0

if (proto.hasExtendee()) {
    GenericDescriptor extendee =
    file.pool.lookupSymbol(proto.getExtendee(), this);
    if (!(extendee instanceof Descriptor)) {
        throw new DescriptorValidationException(this,
                                                "\"" + proto.getExtendee() + "\" is not a message type.");
    }
    this.containingType = (Descriptor)extendee;
    
    if (!getContainingType().isExtensionNumber(getNumber())) {
        throw new DescriptorValidationException(this,
                                                "\"" + getContainingType().getFullName() + "\" does not declare " +
                                                getNumber() + " as an extension number.");
    }
}

if (proto.hasTypeName()) {
    GenericDescriptor typeDescriptor =
    file.pool.lookupSymbol(proto.getTypeName(), this);
    
    if (!proto.hasType()) {
        // Choose field type based on symbol.
        if (typeDescriptor instanceof Descriptor) {
            this.type = Type.MESSAGE;
        } else if (typeDescriptor instanceof EnumDescriptor) {
            this.type = Type.ENUM;
        } else {
            throw new DescriptorValidationException(this,
                                                    "\"" + proto.getTypeName() + "\" is not a type.");
        }
    }
    
    if (getJavaType() == JavaType.MESSAGE) {
        if (!(typeDescriptor instanceof Descriptor)) {
            throw new DescriptorValidationException(this,
                                                    "\"" + proto.getTypeName() + "\" is not a message type.");
        }
        this.messageType = (Descriptor)typeDescriptor;
        
        if (proto.hasDefaultValue()) {
            throw new DescriptorValidationException(this,
                                                    "Messages can't have default values.");
        }
    } else if (getJavaType() == JavaType.ENUM) {
        if (!(typeDescriptor instanceof EnumDescriptor)) {
            throw new DescriptorValidationException(this,
                                                    "\"" + proto.getTypeName() + "\" is not an enum type.");
        }
        this.enumType = (EnumDescriptor)typeDescriptor;
    } else {
        throw new DescriptorValidationException(this,
                                                "Field with primitive type has type_name.");
    }
} else {
    if (getJavaType() == JavaType.MESSAGE ||
        getJavaType() == JavaType.ENUM) {
        throw new DescriptorValidationException(this,
                                                "Field with message or enum type missing type_name.");
    }
}

// We don't attempt to parse the default value until here because for
// enums we need the enum type's descriptor.
if (proto.hasDefaultValue()) {
    if (isRepeated()) {
        throw new DescriptorValidationException(this,
                                                "Repeated fields cannot have default values.");
    }
    
    try {
        switch (getType()) {
            case INT32:
            case SINT32:
            case SFIXED32:
                defaultValue = TextFormat.parseInt32(proto.getDefaultValue());
                break;
            case UINT32:
            case FIXED32: {
                defaultValue = TextFormat.parseUInt32(proto.getDefaultValue());
                break;
            }
            case INT64:
            case SINT64:
            case SFIXED64:
                defaultValue = TextFormat.parseInt64(proto.getDefaultValue());
                break;
            case UINT64:
            case FIXED64: {
                defaultValue = TextFormat.parseUInt64(proto.getDefaultValue());
                break;
            }
            case FLOAT:
                defaultValue = Float.valueOf(proto.getDefaultValue());
                break;
            case DOUBLE:
                defaultValue = Double.valueOf(proto.getDefaultValue());
                break;
            case BOOL:
                defaultValue = Boolean.valueOf(proto.getDefaultValue());
                break;
            case STRING:
                defaultValue = proto.getDefaultValue();
                break;
            case BYTES:
                try {
                    defaultValue =
                    TextFormat.unescapeBytes(proto.getDefaultValue());
                } catch (TextFormat.InvalidEscapeSequence e) {
                    throw new DescriptorValidationException(this,
                                                            "Couldn't parse default value: " + e.getMessage());
                }
                break;
            case ENUM:
                defaultValue = enumType.findValueByName(proto.getDefaultValue());
                if (defaultValue == null) {
                    throw new DescriptorValidationException(this,
                                                            "Unknown enum default value: \"" +
                                                            proto.getDefaultValue() + "\"");
                }
                break;
            case MESSAGE:
            case GROUP:
                throw new DescriptorValidationException(this,
                                                        "Message type had default value.");
        }
    } catch (NumberFormatException e) {
        DescriptorValidationException validationException =
        new DescriptorValidationException(this,
                                          "Could not parse default value: \"" +
                                          proto.getDefaultValue() + "\"");
        validationException.initCause(e);
        throw validationException;
    }
} else {
    // Determine the default default for this field.
    if (isRepeated()) {
        defaultValue = Collections.EMPTY_LIST;
    } else {
        switch (getJavaType()) {
            case ENUM:
                // We guarantee elsewhere that an enum type always has at least
                // one possible value.
                defaultValue = enumType.getValues().get(0);
                break;
            case MESSAGE:
                defaultValue = null;
                break;
            default:
                defaultValue = getJavaType().defaultDefault;
                break;
        }
    }
}

if (!isExtension()) {
    file.pool.addFieldByNumber(this);
}

if (containingType != null &&
    containingType.getOptions().getMessageSetWireFormat()) {
    if (isExtension()) {
        if (!isOptional() || getType() != Type.MESSAGE) {
            throw new DescriptorValidationException(this,
                                                    "Extensions of MessageSets must be optional messages.");
        }
    } else {
        throw new DescriptorValidationException(this,
                                                "MessageSets cannot have fields, only extensions.");
    }
}
}
#endif
}

@end
