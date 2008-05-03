//
//  SettingsNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingsNavigationController.h"
#import "ApplicationTabBarController.h"

@implementation SettingsNavigationController

@synthesize tabBarController;
@synthesize viewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super initWithTabBarController:controller])
    {
        self.viewController = [[[SettingsViewController alloc] initWithNavigationController:self] autorelease];
        
        [self pushViewController:viewController animated:NO];
        
        self.title = @"Settings";
    }
    
    return self;
}

- (void) dealloc
{
    self.viewController = nil;
    [super dealloc];
}

- (void) refresh
{
    [self.viewController refresh];
}

@end
