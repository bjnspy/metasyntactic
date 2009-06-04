//
//  ConcreteExtensionField.h
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ExtensionField.h"

typedef enum {
  PBExtensionTypeBool,
  PBExtensionTypeFixed32,
  PBExtensionTypeSFixed32,
  PBExtensionTypeFloat,
  PBExtensionTypeFixed64,
  PBExtensionTypeSFixed64,
  PBExtensionTypeDouble,
  PBExtensionTypeInt32,
  PBExtensionTypeInt64,
  PBExtensionTypeSInt32,
  PBExtensionTypeSInt64,
  PBExtensionTypeUInt32,
  PBExtensionTypeUInt64,
  PBExtensionTypeBytes,
  PBExtensionTypeString,
  PBExtensionTypeMessage,
  PBExtensionTypeGroup,
  PBExtensionTypeEnum
} PBExtensionType;

@interface PBConcreteExtensionField : NSObject<PBExtensionField> {
@private
  PBExtensionType type;
  
  Class extendedClass;
  int32_t fieldNumber;
  id defaultValue;
  
  Class messageOrGroupOrEnumClass;
  
  BOOL isRepeated;
  BOOL isPacked;
  BOOL isMessageSetWireFormat;  
}

+ (PBConcreteExtensionField*) extensionWithType:(PBExtensionType) type
                                extendedClass:(Class) extendedClass
                                  fieldNumber:(int32_t) fieldNumber
                                 defaultValue:(id) defaultValue
                    messageOrGroupOrEnumClass:(Class) messageOrGroupOrEnumClass
                                   isRepeated:(BOOL) isRepeated
                                     isPacked:(BOOL) isPacked
                       isMessageSetWireFormat:(BOOL) isMessageSetWireFormat;

@end