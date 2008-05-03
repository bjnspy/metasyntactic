//
//  TheatersNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TheatersNavigationController.h"
#import "ApplicationTabBarController.h"

@implementation TheatersNavigationController

@synthesize allTheatersViewController;
@synthesize theaterDetailsViewController;
@synthesize tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super init])
    {   
        self.tabBarController = controller;
        self.allTheatersViewController = [[[AllTheatersViewController alloc] initWithNavigationController:self] autorelease];
        
        [self pushViewController:allTheatersViewController animated:NO];
        
        self.title = @"Theaters";
    }
    
    return self;
}

- (void) dealloc
{
    self.allTheatersViewController = nil;
    self.theaterDetailsViewController = nil;
    self.tabBarController = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model
{
    return [self.tabBarController model];
}

- (void) refresh
{
    [self.allTheatersViewController refresh];
    [self.theaterDetailsViewController refresh];
}

- (void) pushTheaterDetails:(Theater*) theater
{
    self.theaterDetailsViewController = [[[TheaterDetailsViewController alloc] initWithNavigationController:self theater:theater] autorelease];

    [self pushViewController:theaterDetailsViewController animated:YES];
}

@end
