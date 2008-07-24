//
//  RatingsProviderViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"

@class SettingsNavigationController;

@interface RatingsProviderViewController : UITableViewController {
    SettingsNavigationController* navigationController;
//    BoxOfficeController* controller;
//    BoxOfficeModel* model;
}

@property (assign) SettingsNavigationController* navigationController;
//@property (retain) BoxOfficeController* controller;
//@property (retain) BoxOfficeModel* model;

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController;

- (BoxOfficeController*) controller;
- (BoxOfficeModel*) model;

@end
