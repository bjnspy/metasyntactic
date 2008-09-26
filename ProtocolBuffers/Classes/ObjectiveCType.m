//
//  ObjectiveCType.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 9/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveCType.h"

id ObjectiveCTypeDefault(ObjectiveCType type) {
    switch (type) {
        case ObjectiveCTypeInt32:
            return [NSNumber numberWithInt:0];
        case ObjectiveCTypeInt64:
            return [NSNumber numberWithLongLong:0];
        case ObjectiveCTypeFloat32:
            return [NSNumber numberWithFloat:0];
        case ObjectiveCTypeFloat64:
            return [NSNumber numberWithDouble:0];
        case ObjectiveCTypeBool:
            return [NSNumber numberWithBool:NO];
        case ObjectiveCTypeString:
            return @"";
        case ObjectiveCTypeData:
            return [NSData data];
        case ObjectiveCTypeEnum:
            return nil;
        case ObjectiveCTypeMessage:
            return nil;
        default:
            @throw [NSException exceptionWithName:@"InvalidArgument" reason:@"" userInfo:nil];
    }
}
