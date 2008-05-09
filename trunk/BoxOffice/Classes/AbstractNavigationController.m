//
//  AbstractNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractNavigationController.h"
#import "ApplicationTabBarController.h"

@implementation AbstractNavigationController

@synthesize tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super init])
    {   
        self.tabBarController = controller;
    }
    
    return self;
}

- (void) dealloc
{
    self.tabBarController = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model
{
    return [self.tabBarController model];
}

- (BoxOfficeController*) controller
{
    return [self.tabBarController controller];
}

@end
