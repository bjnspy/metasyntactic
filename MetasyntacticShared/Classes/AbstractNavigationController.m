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

#import "AbstractNavigationController.h"

@interface AbstractNavigationController()
@property BOOL visible;
#ifndef IPHONE_OS_VERSION_3
@property BOOL isViewLoaded;
#endif
@end


@implementation AbstractNavigationController

@synthesize visible;
#ifndef IPHONE_OS_VERSION_3
@synthesize isViewLoaded;
#endif

- (void) dealloc {
  self.visible = NO;

#ifndef IPHONE_OS_VERSION_3
  self.isViewLoaded = NO;
#endif

  [super dealloc];
}


- (void) loadView {
  [super loadView];

#ifndef IPHONE_OS_VERSION_3
  self.isViewLoaded = YES;
#endif

  self.view.autoresizesSubviews = YES;
}


- (void) refreshWithSelector:(SEL) selector {
  if (!self.isViewLoaded) {
    return;
  }

  if (self.modalViewController != nil) {
    if ([self.modalViewController respondsToSelector:selector]) {
      [self.modalViewController performSelector:selector];
    }
  }

  if (!visible) {
    return;
  }

  for (id controller in self.viewControllers) {
    if ([controller respondsToSelector:selector]) {
      [controller performSelector:selector];
    }
  }
}


- (void) majorRefresh {
  [self refreshWithSelector:@selector(majorRefresh)];
}


- (void) minorRefresh {
  [self refreshWithSelector:@selector(minorRefresh)];
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  self.visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
  [super viewDidDisappear:animated];
  self.visible = NO;
}


- (void) didReceiveMemoryWarning {
  if (visible) {
    return;
  }

  [self popToRootViewControllerAnimated:NO];
  [super didReceiveMemoryWarning];
}

@end