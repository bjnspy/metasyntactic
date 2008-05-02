//
//  TheatersNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TheatersNavigationController.h"


@implementation TheatersNavigationController

@synthesize allTheatersViewController;
@synthesize theaterDetailsViewController;
@synthesize tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super init])
    {   
        self.tabBarController = controller;
        self.allTheatersViewController = [[[AllTheatersViewController alloc] init] autorelease];
        self.theaterDetailsViewController = [[[TheaterDetailsViewController alloc] init] autorelease];
        
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

@end
