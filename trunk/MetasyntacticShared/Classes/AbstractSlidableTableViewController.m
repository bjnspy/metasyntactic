//
//  AbstractSlidableTableViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
     
     
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
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
