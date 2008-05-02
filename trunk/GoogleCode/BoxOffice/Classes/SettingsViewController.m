//
//  SettingsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"

@implementation SettingsViewController

@synthesize tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super init])
    {
        self.title = @"Settings";
        self.tabBarController = controller;
        
        //UITabBarItem* item = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore target:nil action:nil] autorelease];
        
  //      self.tabBarItem.image = item.image;
        self.view = self.tabBarController.appDelegate.settingsView;
    }
    
    return self;
}

- (void) dealloc
{
    self.tabBarController = nil;
    self.view = nil;
    [super dealloc];
}

@end
