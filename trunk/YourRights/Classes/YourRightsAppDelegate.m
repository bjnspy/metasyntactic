//
//  YourRightsAppDelegate.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "YourRightsAppDelegate.h"

#import "YourRightsNavigationController.h"

@interface YourRightsAppDelegate()
@property (retain) YourRightsNavigationController* navigationController;
@end

@implementation YourRightsAppDelegate

@synthesize window;
@synthesize navigationController;

- (void) dealloc {
    self.window = nil;
    self.navigationController = nil;
    [super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication*) application {  
    self.navigationController = [[[YourRightsNavigationController alloc] init] autorelease];
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}


@end
