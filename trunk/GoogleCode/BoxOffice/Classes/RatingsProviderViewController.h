//
//  RatingsProviderViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsNavigationController;

@interface RatingsProviderViewController : UITableViewController {
    SettingsNavigationController* navigationController;
}

@property (assign) SettingsNavigationController* navigationController;

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController;

@end
