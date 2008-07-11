//
//  BoxOfficeAppDelegate.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright Metasyntactic 2008. All rights reserved.
//

#import "BoxOfficeAppDelegate.h"
#import "BoxOfficeController.h"
#import "Application.h"

@implementation BoxOfficeAppDelegate

@synthesize window;
@synthesize controller;
@synthesize model;
@synthesize tabBarController;
@synthesize notificationCenter;
 
- (void) dealloc {
    self.window = nil;
    self.controller = nil;
    self.model = nil;
    self.tabBarController = nil;
    self.notificationCenter = nil;
    [super dealloc];
} 

- (void) applicationDidFinishLaunching:(UIApplication*) app {
    self.notificationCenter = [NotificationCenter centerWithWindow:window];
    self.model = [BoxOfficeModel modelWithCenter:notificationCenter];
    self.tabBarController = [ApplicationTabBarController controllerWithAppDelegate:self];   
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    [self.notificationCenter addToWindow];
        
    self.controller = [BoxOfficeController controllerWithAppDelegate:self];
    [self.tabBarController refresh];
}

- (void) applicationWillTerminate:(UIApplication*) application {
    [self.model applicationWillTerminate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
