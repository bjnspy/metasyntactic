//
//  AbstractCurlingTableViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractCurlableTableViewController.h"


@implementation AbstractCurlableTableViewController

- (BOOL) cacheTableViews {
  return YES;
}

- (void) moveTo:(UITableView*) newTableView withTransition:(UIViewAnimationTransition) transition {
  [UIView beginAnimations:nil context:NULL];
  {
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:transition forView:self.tableView.superview cache:YES];
    
    self.tableView = newTableView;
  }
  [UIView commitAnimations];
}


- (void) moveBackward:(UITableView*) previousTableView {
  [self moveTo:previousTableView withTransition:UIViewAnimationTransitionCurlDown];
}


- (void) moveForward:(UITableView*) nextTableView {
  [self moveTo:nextTableView withTransition:UIViewAnimationTransitionCurlUp];
}

@end
