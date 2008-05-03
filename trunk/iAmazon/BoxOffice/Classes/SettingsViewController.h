//
//  SettingsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"

@class SettingsNavigationController;

@interface SettingsViewController : UITableViewController {
    SettingsNavigationController* navigationController;
}

@property (assign) SettingsNavigationController* navigationController;

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
