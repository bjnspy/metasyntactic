//
//  AbstractNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractNavigationController.h"
#import "ApplicationTabBarController.h"
#import "TicketsViewController.h"

@implementation AbstractNavigationController

@synthesize tabBarController;

- (void) dealloc {
    self.tabBarController = nil;
    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super init]) {   
        self.tabBarController = controller;
    }
    
    return self;
}

- (BoxOfficeModel*) model {
    return [self.tabBarController model];
}

- (BoxOfficeController*) controller {
    return [self.tabBarController controller];
}

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
           linkToTheater:(BOOL) linkToTheater
                animated:(BOOL) animated {
    TicketsViewController* controller = 
    [[[TicketsViewController alloc] initWithController:self
                                               theater:theater
                                                 movie:movie
                                                 title:title
                                         linkToTheater:linkToTheater] autorelease];
    
    [self pushViewController:controller animated:animated];    
}

- (void) navigateToLastViewedPage {
}

@end
