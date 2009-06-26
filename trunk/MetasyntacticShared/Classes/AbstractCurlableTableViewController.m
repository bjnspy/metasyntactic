// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
