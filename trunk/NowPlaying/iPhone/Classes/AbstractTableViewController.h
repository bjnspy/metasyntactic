//
//  AbstractTableViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AbstractTableViewController : UITableViewController {
@protected
    AbstractNavigationController* navigationController;

    BOOL visible;
    NSArray* visibleIndexPaths;
}

- (id) initWithStyle:(UITableViewStyle) style navigationController:(AbstractNavigationController*) navigationController;

- (Model*) model;
- (Controller*) controller;

/* @protected */
- (void) reloadTableViewData;
- (void) didReceiveMemoryWarningWorker;

@end
