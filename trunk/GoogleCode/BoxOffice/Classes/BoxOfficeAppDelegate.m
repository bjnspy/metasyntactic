//
//  BoxOfficeAppDelegate.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "BoxOfficeAppDelegate.h"
#import "BoxOfficeController.h"

@implementation BoxOfficeAppDelegate

@synthesize window;
@synthesize application;
@synthesize controller;
@synthesize model;
@synthesize settingsView;
@synthesize tabBarController;

- (void) applicationDidFinishLaunching:(UIApplication*) app {
    NSLog(@"BoxOfficeAppDelegate.applicationDidFinishLaunching");
    self.application = app;
    
    self.model = [[[BoxOfficeModel alloc] init] autorelease];
    
    self.tabBarController = [[[ApplicationTabBarController alloc] initWithAppDelegate:self] autorelease];
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    self.controller = [[[BoxOfficeController alloc] initWithAppDelegate:self] autorelease];
}

- (void) dealloc {
    self.controller = nil;
    self.window = nil;
    self.tabBarController = nil;
    self.model = nil;
    self.application = nil;
    
	[super dealloc];
}

@end
