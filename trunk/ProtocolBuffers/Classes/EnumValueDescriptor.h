//
//  EnumValueDescriptor.h
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 9/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface EnumValueDescriptor : NSObject/*<GenericDescriptor>*/ {
    int32_t index;
    //EnumValueDescriptorProto proto;
    NSString* fullName;
    FileDescriptor* file;
    EnumDescriptor* type;
}

@property int32_t index;
@property (retain) NSString* fullName;
@property (retain) FileDescriptor* file;
@property (retain) EnumDescriptor* type;

- (EnumDescriptor*) getType;
- (int32_t) getNumber;

@end
