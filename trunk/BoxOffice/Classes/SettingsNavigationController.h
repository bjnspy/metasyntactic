//
//  SettingsNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@class ApplicationTabBarController;

@interface SettingsNavigationController : UINavigationController {
    ApplicationTabBarController* tabBarController;
    SettingsViewController* viewController;
}

@property (assign) ApplicationTabBarController* tabBarController;
@property (retain) SettingsViewController* viewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

- (BoxOfficeModel*) model;

- (void) refresh;

@end
