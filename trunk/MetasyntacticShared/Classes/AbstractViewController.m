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
