//
//  AbstractNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"

@class ApplicationTabBarController;

@interface AbstractNavigationController : UINavigationController {
    ApplicationTabBarController* tabBarController;
}

@property (assign) ApplicationTabBarController* tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;

- (BoxOfficeModel*) model;
- (BoxOfficeController*) controller;

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated;

- (void) navigateToLastViewedPage;

@end
