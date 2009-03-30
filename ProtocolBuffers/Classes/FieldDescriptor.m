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

#import "FieldDescriptor.h"

#import "Descriptor.pb.h"
#import "DescriptorPool.h"
#import "TextFormat.h"

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
        self.file = file_;

        self.fullName = [PBDescriptor computeFullName:file_ parent:parent_ name:proto.name];

        if (proto.hasType) {
            self.type = PBFieldDescriptorTypeFrom(proto.type);
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


- (PBFieldOptions*) options {
    return proto.options;
}


- (BOOL) isExtension {
    return proto.hasExtendee;
}


/** Is this field declared required? */
- (BOOL) isRequired {
    return proto.label == [PBFieldDescriptorProto_Label LABEL_REQUIRED];
}


/** Is this field declared optional? */
- (BOOL) isOptional {
    return proto.label == [PBFieldDescriptorProto_Label LABEL_OPTIONAL];
}


/** Is this field declared repeated? */
- (BOOL) isRepeated {
    return proto.label == [PBFieldDescriptorProto_Label LABEL_REPEATED];
}


- (PBObjectiveCType) objectiveCType {
    return PBObjectiveCTypeFromFieldDescriptorType(self.type);
}


- (PBDescriptor*) extensionScope {
    if (!self.isExtension) {
        @throw [NSException exceptionWithName:@"UnsupportedOperation"
                                       reason:@"This field is not an extension." userInfo:nil];
    }

    return extensionScope;
}


- (PBDescriptor*) messageType {
    if (self.objectiveCType != PBObjectiveCTypeMessage) {
        @throw [NSException exceptionWithName:@"UnsupportedOperation"
                                       reason:@"This field is not of message type." userInfo:nil];
    }

    return messageType;
}


- (BOOL) hasDefaultValue {
    return proto.hasDefaultValue;
}


- (id) defaultValue {
    if (self.objectiveCType == PBObjectiveCTypeMessage) {
        @throw [NSException exceptionWithName:@"UnsupportedOperation"
                                       reason:@"FieldDescriptor.getDefaultValue() called on an embedded message field."
                                     userInfo:nil];
    }

    return defaultValue;
}


- (int32_t) number {
    return proto.number;
}


- (id<PBMessage>) toProto {
    return proto;
}


- (NSString*) name {
    return proto.name;
}


- (void) crossLink {
    if (proto.hasExtendee) {
        id extendee = [file.pool lookupSymbol:proto.extendee relativeTo:self];
        if (![extendee isKindOfClass:[PBDescriptor class]]) {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
        }
        self.containingType = extendee;

        if (![self.containingType isExtensionNumber:self.number]) {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
        }
    }

    if (proto.hasTypeName) {
        id typeDescriptor = [file.pool lookupSymbol:proto.typeName relativeTo:self];

        if (!proto.hasType) {
            // Choose field type based on symbol.
            if ([typeDescriptor isKindOfClass:[PBDescriptor class]]) {
                self.type = PBFieldDescriptorTypeMessage;
            } else if ([typeDescriptor isKindOfClass:[PBEnumDescriptor class]]) {
                self.type = PBFieldDescriptorTypeEnum;
            } else {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
            }
        }

        if (self.objectiveCType == PBObjectiveCTypeMessage) {
            if (![typeDescriptor isKindOfClass:[PBDescriptor class]]) {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
            }
            self.messageType = typeDescriptor;

            if (proto.hasDefaultValue) {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Messages can't have default values." userInfo:nil];
            }
        } else if (self.objectiveCType == PBObjectiveCTypeEnum) {
            if (![typeDescriptor isKindOfClass:[PBEnumDescriptor class]]) {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"" userInfo:nil];
            }
            self.enumType = typeDescriptor;
        } else {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Field with primitive type has type_name." userInfo:nil];
        }
    } else {
        if (self.objectiveCType == PBObjectiveCTypeMessage ||
            self.objectiveCType == PBObjectiveCTypeEnum) {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Field with message or enum type missing type_name." userInfo:nil];
        }
    }

    // We don't attempt to parse the default value until here because for
    // enums we need the enum type's descriptor.
    if (proto.hasDefaultValue) {
        if (self.isRepeated) {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Repeated fields cannot have default values." userInfo:nil];
        }

        switch (self.type) {
            case PBFieldDescriptorTypeInt32:
           case PBFieldDescriptorTypeSInt32:
         case PBFieldDescriptorTypeSFixed32:
self.defaultValue = [NSNumber numberWithInt:[PBTextFormat parseInt32:proto.defaultValue]];
                break;
            case PBFieldDescriptorTypeUInt32:
           case PBFieldDescriptorTypeFixed32: {
                self.defaultValue = [NSNumber numberWithInt:[PBTextFormat parseUInt32:proto.defaultValue]];
                break;
            }
            case PBFieldDescriptorTypeInt64:
           case PBFieldDescriptorTypeSInt64:
         case PBFieldDescriptorTypeSFixed64:
self.defaultValue = [NSNumber numberWithLongLong:[PBTextFormat parseInt64:proto.defaultValue]];
                break;
            case PBFieldDescriptorTypeUInt64:
           case PBFieldDescriptorTypeFixed64: {
                self.defaultValue = [NSNumber numberWithLongLong:[PBTextFormat parseUInt64:proto.defaultValue]];
                break;
            }
            case PBFieldDescriptorTypeFloat:
self.defaultValue = [NSNumber numberWithFloat:[proto.defaultValue floatValue]];
                break;
            case PBFieldDescriptorTypeDouble:
self.defaultValue = [NSNumber numberWithDouble:[proto.defaultValue doubleValue]];
                break;
            case PBFieldDescriptorTypeBool:
self.defaultValue = [NSNumber numberWithBool:[@"true" isEqual:proto.defaultValue]];
                break;
            case PBFieldDescriptorTypeString:
                self.defaultValue = proto.defaultValue;
                break;
            case PBFieldDescriptorTypeData:
self.defaultValue = [PBTextFormat unescapeBytes:proto.defaultValue];
                break;
            case PBFieldDescriptorTypeEnum:
self.defaultValue = [enumType findValueByName:proto.defaultValue];
                if (defaultValue == nil) {
                    @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Unknown enum default value:" userInfo:nil];
                }
                break;
            case PBFieldDescriptorTypeMessage:
              case PBFieldDescriptorTypeGroup:
        @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Message type had default value." userInfo:nil];
        }
    } else {
        // Determine the default default for this field.
        if (self.isRepeated) {
            self.defaultValue = [NSArray array];
        } else {
            switch (self.objectiveCType) {
                case PBObjectiveCTypeEnum:
                    // We guarantee elsewhere that an enum type always has at least
                    // one possible value.
                    self.defaultValue = [self.enumType.values objectAtIndex:0];
                    break;
                case PBObjectiveCTypeMessage:
                    self.defaultValue = nil;
                    break;
                default:
                    self.defaultValue = PBObjectiveCTypeDefault(self.objectiveCType);
                    break;
            }
        }
    }

    if (!self.isExtension) {
        [file.pool addFieldByNumber:self];
    }

    if (containingType != nil &&
        containingType.options.messageSetWireFormat) {
        if (self.isExtension) {
            if (!self.isOptional || self.type != PBFieldDescriptorTypeMessage) {
                @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"Extensions of MessageSets must be optional messages." userInfo:nil];
            }
        } else {
            @throw [NSException exceptionWithName:@"DescriptorValidation" reason:@"MessageSets cannot have fields, only extensions." userInfo:nil];
        }
    }
}


/**
 * Compare with another {@code FieldDescriptor}.  This orders fields in
 * "canonical" order, which simply means ascending order by field number.
 * {@code other} must be a field of the same type -- i.e.
 * {@code getContainingType()} must return the same {@code Descriptor} for
 * both fields.
 *
 * @return negative, zero, or positive if {@code this} is less than,
 *         equal to, or greater than {@code other}, respectively.
 */
- (NSComparisonResult) compare:(PBFieldDescriptor*) other {
    if (other.containingType != containingType) {
        @throw [NSException exceptionWithName:@"IllegalArgument"
                                       reason:@"FieldDescriptors can only be compared to other FieldDescriptors for fields of the same message type."
                                     userInfo:nil];
    }

    if (self.number < other.number) {
        return NSOrderedAscending;
    } else if (self.number > other.number) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}


- (id) copyWithZone:(NSZone*) zone {
    return [self retain];
}

@end