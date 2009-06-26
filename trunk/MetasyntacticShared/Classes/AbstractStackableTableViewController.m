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
