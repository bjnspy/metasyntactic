//
//  AbstractNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"
#import "TicketsViewController.h"

@class ApplicationTabBarController;

@interface AbstractNavigationController : UINavigationController {
    ApplicationTabBarController* tabBarController;
    TicketsViewController* ticketsViewController;
}

@property (assign) ApplicationTabBarController* tabBarController;
@property (retain) TicketsViewController* ticketsViewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;

- (void) refresh;

- (BoxOfficeModel*) model;
- (BoxOfficeController*) controller;

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated;

- (void) navigateToLastViewedPage;

@end
