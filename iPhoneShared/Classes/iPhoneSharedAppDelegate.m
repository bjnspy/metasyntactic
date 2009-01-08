//
//  iPhoneSharedAppDelegate.m
//  iPhoneShared
//
//  Created by Cyrus Najmabadi on 1/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "iPhoneSharedAppDelegate.h"

@implementation iPhoneSharedAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
