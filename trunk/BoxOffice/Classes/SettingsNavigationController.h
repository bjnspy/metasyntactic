//
//  SettingsNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "AbstractNavigationController.h"

@interface SettingsNavigationController : AbstractNavigationController {
    SettingsViewController* viewController;
}

@property (retain) SettingsViewController* viewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

- (void) refresh;

- (void) navigateToLastViewedPage;

@end
