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

#import "AbstractSlidableTableViewController.h"


@implementation AbstractSlidableTableViewController

- (BOOL) cacheTableViews {
  return NO;
}


- (void) moveTo:(UITableView*) newTableView finalFrame:(CGRect) finalFrame {
  UITableView* currentTableView = self.tableView;
  CGRect currentTableFrame = currentTableView.frame;
  CGRect newTableFrame = currentTableFrame;

  if (finalFrame.origin.x < 0) {
    // we're moving to the right
    newTableFrame.origin.x = newTableFrame.size.width;
  } else {
    // we're moving to the left
    newTableFrame.origin.x = -newTableFrame.size.width;
  }

  newTableView.frame = newTableFrame;
  [self.tableView.superview addSubview:newTableView];

  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [UIView beginAnimations:nil context:newTableView];
  {
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

    currentTableView.frame = finalFrame;
    newTableView.frame = currentTableFrame;
  }
  [UIView commitAnimations];
}


- (void) animationDidStop:(NSString*) animationID finished:(NSNumber*) finished context:(void*) context {
  UITableView* newTableView = context;
  CGRect frame = newTableView.frame;
  self.tableView = newTableView;
  newTableView.frame = frame;
  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void) moveBackward:(UITableView*) previousTableView {
  CGRect finalFrame = self.tableView.frame;
  finalFrame.origin.x = finalFrame.size.width;

  [self moveTo:previousTableView finalFrame:finalFrame];
}


- (void) moveForward:(UITableView*) nextTableView {
  CGRect finalFrame = self.tableView.frame;
  finalFrame.origin.x = -finalFrame.size.width;

  [self moveTo:nextTableView finalFrame:finalFrame];
}

@end
