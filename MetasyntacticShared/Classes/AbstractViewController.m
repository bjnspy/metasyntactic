//
//  AbstractViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 7/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractViewController.h"


@implementation AbstractViewController

- (void) onBeforeViewControllerPushed { }
- (void) onAfterViewControllerPushed { }
- (void) onBeforeViewControllerPopped { }
- (void) onAfterViewControllerPopped { }


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];
  if (!onBeforeViewControllerPushedCalled) {
    onBeforeViewControllerPushedCalled = YES;
    [self onBeforeViewControllerPushed];
  }
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  if (!onAfterViewControllerPushedCalled) {
    onAfterViewControllerPushedCalled = YES;
    [self onAfterViewControllerPushed];
  }
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  if (![self.navigationController.viewControllers containsObject:self]) {
    [self onBeforeViewControllerPopped];
  }
}


- (void) viewDidDisappear:(BOOL) animated {
  [super viewDidDisappear:animated];
  if (self.navigationController == nil) {
    [self onAfterViewControllerPopped];
  }
}

@end
