//
//  ApplicationTabBarController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"

@implementation ApplicationTabBarController

@synthesize moviesNavigationController;
@synthesize theatersNavigationController;
@synthesize settingsNavigationController;
@synthesize appDelegate;

- (id) initWithAppDelegate:(BoxOfficeAppDelegate*) appDel
{
    if (self = [super init])
    {
        self.appDelegate = appDel;
        self.moviesNavigationController = [[[MoviesNavigationController alloc] initWithTabBarController:self] autorelease];
        self.theatersNavigationController = [[[TheatersNavigationController alloc] initWithTabBarController:self] autorelease];
        self.settingsNavigationController = [[[SettingsNavigationController alloc] initWithTabBarController:self] autorelease];

        self.viewControllers =
            [NSArray arrayWithObjects:moviesNavigationController,
                                      theatersNavigationController,
                                      settingsNavigationController, nil];
    }
    
    return self;
}

- (void) dealloc
{
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.settingsNavigationController = nil;
    self.appDelegate = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model
{
    return [self.appDelegate model];
}

- (void) refresh
{
    [self.moviesNavigationController refresh];
    [self.theatersNavigationController refresh];
    [self.settingsNavigationController refresh];
}

@end
