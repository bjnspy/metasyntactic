//
//  Application.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Application.h"

#import "Model.h"

@implementation Application

+ (NSString*) name {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}


+ (NSString*) nameAndVersion {
    NSString* appName = [self name];
    NSString* appVersion = [Model version];
    appVersion = [appVersion substringToIndex:[appVersion rangeOfString:@"." options:NSBackwardsSearch].location];
    
    return [NSString stringWithFormat:@"%@ v%@", appName, appVersion];
}

@end
