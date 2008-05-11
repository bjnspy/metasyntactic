//
//  BoxOfficeAppDelegate.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "BoxOfficeAppDelegate.h"
#import "BoxOfficeController.h"
#import "Application.h"

@implementation BoxOfficeAppDelegate

@synthesize window;
@synthesize controller;
@synthesize model;
@synthesize tabBarController;

- (void) dealloc {
    self.controller = nil;
    self.window = nil;
    self.tabBarController = nil;
    self.model = nil;
    [super dealloc];
} 

- (void) applicationDidFinishLaunching:(UIApplication*) app {
    NSLog(@"BoxOfficeAppDelegate.applicationDidFinishLaunching");
    
    self.model = [BoxOfficeModel model];
    self.tabBarController = [ApplicationTabBarController controllerWithAppDelegate:self];
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    self.controller = [BoxOfficeController controllerWithAppDelegate:self];
    [self.tabBarController refresh];
}

- (void) applicationWillTerminate:(UIApplication*) application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
