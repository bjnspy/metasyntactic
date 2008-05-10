//
//  ApplicationTabBarController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MoviesNavigationController.h"
#import "TheatersNavigationController.h"
#import "SettingsNavigationController.h"
#import "BoxOfficeModel.h"

@class BoxOfficeAppDelegate;

@interface ApplicationTabBarController : UITabBarController {
    BoxOfficeAppDelegate* appDelegate;
    MoviesNavigationController* moviesNavigationController;
    TheatersNavigationController* theatersNavigationController;
    SettingsNavigationController* settingsNavigationController;
}

@property (assign) BoxOfficeAppDelegate* appDelegate;
@property (retain) MoviesNavigationController* moviesNavigationController;
@property (retain) TheatersNavigationController* theatersNavigationController;
@property (retain) SettingsNavigationController* settingsNavigationController;

+ (ApplicationTabBarController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate;

- (BoxOfficeModel*) model;
- (BoxOfficeController*) controller;

- (void) refresh;

@end
