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

#import "ViewControllerState.h"

#import "AbstractViewController.h"
#import "FileUtilities.h"
#import "OperationQueue.h"

@interface ViewControllerState()
@property BOOL onBeforeViewControllerPushedCalled;
@property BOOL onAfterViewControllerPushedCalled;
@property (retain) MPMoviePlayerViewController* moviePlayerViewController;
@property (retain) UIViewController* viewController;
@end


@implementation ViewControllerState

static const NSInteger ACTIVITY_INDICATOR_TAG = 1;

@synthesize onBeforeViewControllerPushedCalled;
@synthesize onAfterViewControllerPushedCalled;
@synthesize moviePlayerViewController;
@synthesize viewController;

- (void) dealloc {
  self.onBeforeViewControllerPushedCalled = NO;
  self.onAfterViewControllerPushedCalled = NO;
  self.moviePlayerViewController = nil;
  self.viewController = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
  }
  
  return self;
}


- (void) playMovie:(NSString*) address
    viewController:(UIViewController*) _viewController {
  if (address.length == 0) {
    return;
  }

  // check if it's a local address or a web address.
  NSString* path = [[NSBundle mainBundle] pathForResource:address ofType:nil];
  if ([FileUtilities fileExists:path]) {
    address = path;
  }

  NSURL* url = [NSURL URLWithString:address];
  if (url == nil) {
    return;
  }

  [[OperationQueue operationQueue] temporarilySuspend:90];
  
  self.viewController = _viewController;
  self.moviePlayerViewController = [[[MPMoviePlayerViewController alloc] initWithContentURL:url] autorelease];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(movieFinishedPlaying:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:nil];
  
  [moviePlayerViewController.moviePlayer play];  
  [_viewController presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}


- (void) movieFinishedPlaying:(NSNotification*) notification {
  [moviePlayerViewController.moviePlayer stop];
  [[moviePlayerViewController retain] autorelease];
  
  [viewController dismissMoviePlayerViewControllerAnimated];
  self.moviePlayerViewController = nil;
  self.viewController = nil;

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:nil];

  [[OperationQueue operationQueue] resume];
}


- (void) viewController:(UIViewController*) controller willAppear:(BOOL) animated {
  if (!onBeforeViewControllerPushedCalled) {
    NSLog(@"%d \"%@\" onBeforeViewControllerPushed", controller, controller.title);
    onBeforeViewControllerPushedCalled = YES;
    [(id)controller onBeforeViewControllerPushed];
  }
}


- (void) viewController:(UIViewController*) controller didAppear:(BOOL) animated {
  if (!onAfterViewControllerPushedCalled) {
    NSLog(@"%d \"%@\" onAfterViewControllerPushed", controller, controller.title);
    onAfterViewControllerPushedCalled = YES;
    [(id)controller onAfterViewControllerPushed];
  }
}


- (void) viewController:(UIViewController*) controller willDisappear:(BOOL) animated {
  if (![controller.navigationController.viewControllers containsObject:controller]) {
    NSLog(@"%d \"%@\" onBeforeViewControllerPopped", controller, controller.title);
    [(id)controller onBeforeViewControllerPopped];
  }
}


- (void) viewController:(UIViewController*) controller didDisappear:(BOOL) animated {
  if (controller.navigationController == nil) {
    NSLog(@"%d \"%@\" onAfterViewControllerPopped", controller, controller.title);
    [(id)controller onAfterViewControllerPopped];
  }
}

@end
