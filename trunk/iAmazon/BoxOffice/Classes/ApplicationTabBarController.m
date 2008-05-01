//
//  ApplicationTabBarController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ApplicationTabBarController.h"


@implementation ApplicationTabBarController

@synthesize moviesNavigationController;
@synthesize theatersNavigationController;
@synthesize settingsViewController;

- (id) initWithSettingsView:(UIView*) settingsView
{
    if (self = [super init])
    {
        self.moviesNavigationController = [[MoviesNavigationController alloc] init];
        self.theatersNavigationController = [[TheatersNavigationController alloc] init];
        self.settingsViewController = [[SettingsViewController alloc] initWithSettingsView:settingsView];

        self.allowsCustomizing = NO;
        self.viewControllers =
            [NSArray arrayWithObjects:moviesNavigationController,
                                      theatersNavigationController,
                                      settingsViewController, nil];
    }
    
    return self;
}

- (void) dealloc
{
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.settingsViewController = nil;
    [super dealloc];
}

@end
