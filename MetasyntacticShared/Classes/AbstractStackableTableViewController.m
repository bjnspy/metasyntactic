//
//  AbstractStackableTableViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
  CGFloat newHeight = finalFrame.size.height * 1.5;
  CGFloat newWidth = finalFrame.size.width * 1.5;
  finalFrame.origin.x = (finalFrame.size.width - newWidth) / 2;
  finalFrame.origin.y = (finalFrame.size.height - newHeight) / 2;
  finalFrame.size.height = newHeight;
  finalFrame.size.width = newWidth;
  return finalFrame;
}


- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  UITableView* newTableView = context;
  CGRect frame = newTableView.frame;
  self.tableView = newTableView;
  newTableView.frame = frame;
  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void) moveBackward:(UITableView*) previousTableView {
  UITableView* currentTableView = self.tableView;
  //CGRect currentTableFrame = currentTableView.frame;
  
  previousTableView.frame = currentTableView.frame;
  [self.tableView.superview insertSubview:previousTableView belowSubview:currentTableView];
  
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [UIView beginAnimations:nil context:previousTableView];
  {
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    currentTableView.transform = CGAffineTransformMakeScale(2, 2);
    currentTableView.alpha = 0;
  }
  [UIView commitAnimations];
}


- (void) moveForward:(UITableView*) nextTableView {
  nextTableView.alpha = 0;
  nextTableView.transform = CGAffineTransformMakeScale(2, 2);
  [self.tableView.superview addSubview:nextTableView];
  
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [UIView beginAnimations:nil context:nextTableView];
  {
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

    nextTableView.transform = CGAffineTransformIdentity;
    nextTableView.alpha = 1;
  }
  [UIView commitAnimations];
}

@end
