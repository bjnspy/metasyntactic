//
//  AllTheatersViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"

@class TheatersNavigationController;

@interface AllTheatersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    TheatersNavigationController* navigationController;
    UITableView* tableView;
}

@property (assign) TheatersNavigationController* navigationController;
@property (retain) UITableView* tableView;

- (id) initWithNavigationController:(TheatersNavigationController*) navigationController;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
