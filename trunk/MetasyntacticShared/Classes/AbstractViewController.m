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

#import "ViewControllerState.h"
#import "ViewControllerUtilities.h"

@interface AbstractViewController()
@property (retain) ViewControllerState* state;
@end

@implementation AbstractViewController

@synthesize state;

- (void) dealloc {
  self.state = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.state = [[[ViewControllerState alloc] init] autorelease];
  }
  
  return self;
}

- (void) onBeforeViewControllerPushed { 
}


- (void) onAfterViewControllerPushed { 
}


- (void) onAfterViewControllerPopped {
}


- (void) onBeforeViewControllerPopped {
}


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];
  [state viewController:self willAppear:animated];
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  [state viewController:self didAppear:animated];
}


- (void) viewWillDisappear:(BOOL) animated {
  [super viewWillDisappear:animated];
  [state viewController:self willDisappear:animated];
}


- (void) viewDidDisappear:(BOOL) animated {
  [super viewDidDisappear:animated];
  [state viewController:self didDisappear:animated];
}


- (void) setupTitleLabel {
  [ViewControllerUtilities setupTitleLabel:self];
}


- (void) loadView {
  [super loadView];
  [self setupTitleLabel];
}


- (void) setTitle:(NSString*) text {
  BOOL changed = text.length == 0 || ![text isEqual:self.title];
  [super setTitle:text];

  if (changed) {
    [self setupTitleLabel];
  }
}


- (void) onRotate {
  [self setupTitleLabel];
}


- (void) playMovie:(NSString*) address {
  [state playMovie:address];
}

@end
