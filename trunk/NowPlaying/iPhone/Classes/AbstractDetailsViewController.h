//
//  AbstractDetailsViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DataProviderUpdateDelegate.h"

@interface AbstractDetailsViewController : UITableViewController<DataProviderUpdateDelegate> {
@protected
    AbstractNavigationController* navigationController;
    NSInteger updateId;
}

- (id) initWithNavigationController:(AbstractNavigationController*) navigationController;

- (NowPlayingModel*) model;
- (NowPlayingController*) controller;

// @protected
- (void) changeDate;

@end