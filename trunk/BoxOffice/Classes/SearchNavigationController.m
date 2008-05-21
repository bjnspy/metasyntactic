//
//  SearchNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchNavigationController.h"


@implementation SearchNavigationController

@synthesize startPageViewController;

- (void) dealloc
{
    self.startPageViewController = nil;
    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super initWithTabBarController:controller])
    {        
        self.startPageViewController = [[[SearchStartPageViewController alloc] initWithNavigationController:self] autorelease];
        
        [self pushViewController:startPageViewController animated:NO];
        
        self.title = @"Search";
        self.tabBarItem.image = [UIImage imageNamed:@"Search.png"];
    }
    
    return self;
}

@end
