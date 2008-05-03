//
//  AllTheatersViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeModel.h"

@class TheatersNavigationController;

@interface AllTheatersViewController : UITableViewController {
    TheatersNavigationController* navigationController;
}

@property (assign) TheatersNavigationController* navigationController;

- (id) initWithNavigationController:(TheatersNavigationController*) navigationController;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
