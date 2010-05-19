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

#import "AbstractStackableTableViewController.h"


@implementation AbstractStackableTableViewController

- (BOOL) cacheTableViews {
  return YES;
}


- (CGRect) shrinkFrame:(CGRect) finalFrame {
  CGFloat newHeight = finalFrame.size.height / 2;
  CGFloat newWidth = finalFrame.size.width / 2;
  finalFrame.origin.x = (finalFrame.size.width - newWidth) / 2;
  finalFrame.origin.y = (finalFrame.size.height - newHeight) / 2;
  finalFrame.size.height = newHeight;
  finalFrame.size.width = newWidth;
  return finalFrame;
}


- (CGRect) growFrame:(CGRect) finalFrame {
  CGFloat newHeight = finalFrame.size.height * 1.5f;
  CGFloat newWidth = finalFrame.size.width * 1.5f;
  finalFrame.origin.x = (finalFrame.size.width - newWidth) / 2;
  finalFrame.origin.y = (finalFrame.size.height - newHeight) / 2;
  finalFrame.size.height = newHeight;
  finalFrame.size.width = newWidth;
  return finalFrame;
}


- (void) animationDidStop:(NSString*) animationID finished:(NSNumber*) finished context:(void*) context {
  UITableView* newTableView = context;
  CGRect frame = newTableView.frame;
  self.tableView = newTableView;
  newTableView.frame = frame;
  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


const CGFloat SCALE_FACTOR = 2;


- (void) moveBackward:(UITableView*) previousTableView {
  UITableView* currentTableView = self.tableView;
  //CGRect currentTableFrame = currentTableView.frame;

  previousTableView.frame = currentTableView.frame;
  [self.tableView.superview insertSubview:previousTableView belowSubview:currentTableView];

  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [UIView beginAnimations:nil context:previousTableView];
  {
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

    currentTableView.transform = CGAffineTransformMakeScale(SCALE_FACTOR, SCALE_FACTOR);
    currentTableView.alpha = 0;
  }
  [UIView commitAnimations];
}


- (void) moveForward:(UITableView*) nextTableView {
  nextTableView.alpha = 0;
  nextTableView.transform = CGAffineTransformMakeScale(SCALE_FACTOR, SCALE_FACTOR);
  [self.tableView.superview addSubview:nextTableView];

  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [UIView beginAnimations:nil context:nextTableView];
  {
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

    nextTableView.transform = CGAffineTransformIdentity;
    nextTableView.alpha = 1;
  }
  [UIView commitAnimations];
}

@end
