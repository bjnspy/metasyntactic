//
//  ApplicationTabBarController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MoviesNavigationController.h"
#import "TheatersNavigationController.h"
#import "SettingsViewController.h"

@interface ApplicationTabBarController : UITabBarController {
    MoviesNavigationController* moviesNavigationController;
    TheatersNavigationController* theatersNavigationController;
    SettingsViewController* settingsViewController;
}

@property (retain) MoviesNavigationController* moviesNavigationController;
@property (retain) TheatersNavigationController* theatersNavigationController;
@property (retain) SettingsViewController* settingsViewController;

- (id) initWithSettingsView:(UIView*) settingsView;
- (void) dealloc;

@end
