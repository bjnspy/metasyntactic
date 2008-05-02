//
//  SettingsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@class ApplicationTabBarController;

@interface SettingsViewController : UIViewController {
    ApplicationTabBarController* tabBarController;
}

@property (assign) ApplicationTabBarController* tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

@end
