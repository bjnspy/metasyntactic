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

#import "AbstractViewController.h"

#import "MetasyntacticSharedApplication.h"
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


- (void) rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  [self setupTitleLabel];
}


- (void) playMovie:(NSString*) address {
  [state playMovie:address viewController:self];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
  return [MetasyntacticSharedApplication shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
