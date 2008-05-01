//
//  SettingsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (id) initWithSettingsView:(UIView*) settingsView
{
    if (self = [super init])
    {
        self.title = @"Settings";
        
        [self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemMore target:nil action:nil];
        self.tabBarItem.
        self.view = settingsView;
    }
    
    return self;
}

- (void) dealloc
{
    self.view = nil;
    [super dealloc];
}

@end
