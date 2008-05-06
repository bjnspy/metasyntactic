//
//  SettingsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "ActivityIndicator.h"

@class SettingsNavigationController;

@interface SettingsViewController : UITableViewController {
    SettingsNavigationController* navigationController;
    UIBarButtonItem* currentLocationItem;
    ActivityIndicator* activityIndicator;
}

@property (assign) SettingsNavigationController* navigationController;
@property (retain) UIBarButtonItem* currentLocationItem;
@property (retain) ActivityIndicator* activityIndicator;

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
