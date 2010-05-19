// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
