//
//  AbstractNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "AbstractNavigationController.h"
#import "ApplicationTabBarController.h"
#import "TicketsViewController.h"

@implementation AbstractNavigationController

@synthesize tabBarController;
@synthesize ticketsViewController;

- (void) dealloc {
    self.tabBarController = nil;
    self.ticketsViewController = nil;
    
    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super init]) {   
        self.tabBarController = controller;
    }
    
    return self;
}

- (void) refresh {
    [self.ticketsViewController refresh];
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
                animated:(BOOL) animated {
    self.ticketsViewController = 
    [[[TicketsViewController alloc] initWithController:self
                                               theater:theater
                                                 movie:movie
                                                 title:title] autorelease];
    
    [self pushViewController:ticketsViewController animated:animated];    
}

- (void) navigateToLastViewedPage {
}

@end
