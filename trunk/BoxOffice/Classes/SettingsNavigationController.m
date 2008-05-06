//
//  SettingsNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingsNavigationController.h"
#import "ApplicationTabBarController.h"
#import "EditorViewController.h"

@implementation SettingsNavigationController

@synthesize tabBarController;
@synthesize viewController;

- (void) dealloc
{
    self.viewController = nil;
    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super initWithTabBarController:controller])
    {
        self.viewController = [[[SettingsViewController alloc] initWithNavigationController:self] autorelease];
        
        [self pushViewController:viewController animated:NO];
        
        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"More.png"];
    }
    
    return self;
}

- (void) refresh
{
    [self.viewController refresh];
}

@end
