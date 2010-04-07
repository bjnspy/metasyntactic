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
#import "AutorotatingViewController.h"
#import "FileUtilities.h"
#import "OperationQueue.h"

@interface ViewControllerState()
@property BOOL onBeforeViewControllerPushedCalled;
@property BOOL onAfterViewControllerPushedCalled;
@property (retain) MPMoviePlayerController* moviePlayer;
@property (retain) UIView* movieContainerView;
@property (retain) UIViewController* owningController;
@end


@implementation ViewControllerState

static const NSInteger ACTIVITY_INDICATOR_TAG = 1;
static NSString* MoviePlayerLoadStateDidChangeNotification = @"MPMoviePlayerLoadStateDidChangeNotification";

@synthesize onBeforeViewControllerPushedCalled;
@synthesize onAfterViewControllerPushedCalled;
@synthesize moviePlayer;
@synthesize movieContainerView;
@synthesize owningController;

- (void) dealloc {
  self.onBeforeViewControllerPushedCalled = NO;
  self.onAfterViewControllerPushedCalled = NO;
  self.moviePlayer = nil;
  self.movieContainerView = nil;
  self.owningController = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
  }
  
  return self;
}


- (void) playIPadMovie {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(movieLoadStateChanged:)
                                               name:MoviePlayerLoadStateDidChangeNotification
                                             object:moviePlayer];
  
  UIViewController* movieViewController = [[[AutorotatingViewController alloc] init] autorelease];
  self.movieContainerView = movieViewController.view;
  
  CGRect formFrame = CGRectMake(0, 0, 540, 620);
  movieContainerView.frame = formFrame;
  
  CGRect movieFrame = CGRectMake(30, 30, 480, 560);
  moviePlayer.view.frame = movieFrame; 
  
  UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
  CGRect activityIndicatorFrame = activityIndicator.frame;
  activityIndicator.frame = CGRectMake((formFrame.size.width - activityIndicatorFrame.size.width) / 2,
                                       (formFrame.size.height - activityIndicatorFrame.size.height) / 2,
                                       activityIndicatorFrame.size.width, 
                                       activityIndicatorFrame.size.height);
  activityIndicator.tag = ACTIVITY_INDICATOR_TAG;
  [activityIndicator startAnimating];
  
  [movieContainerView addSubview:moviePlayer.view];
  [movieContainerView addSubview:activityIndicator];
  [movieContainerView bringSubviewToFront:activityIndicator];
  
  moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
  moviePlayer.shouldAutoplay = NO;
  
  movieViewController.modalPresentationStyle = UIModalPresentationFormSheet;
  movieViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  
  [owningController presentModalViewController:movieViewController animated:YES];
}


- (void) playMovie:(NSString*) address
      inController:(UIViewController*) controller {
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
  self.moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
  self.owningController = controller;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(movieFinishedPlaying:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:moviePlayer];
  
  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    [self playIPadMovie];
  } else {
    [moviePlayer play];
  }
}


- (void) movieLoadStateChanged:(NSNotification*) notification {
  if (moviePlayer.loadState == MPMovieLoadStatePlayable &&
      moviePlayer.playbackState == MPMoviePlaybackStateStopped) {
    UIView* activityIndicator = [movieContainerView viewWithTag:ACTIVITY_INDICATOR_TAG];
    [UIView beginAnimations:nil context:NULL];
    {
      activityIndicator.alpha = 0;
    }
    [UIView commitAnimations];
    [moviePlayer play];
  }
}


- (void) movieFinishedPlaying:(NSNotification*) notification {
  [moviePlayer stop];
  [[moviePlayer retain] autorelease];
  
  [owningController dismissModalViewControllerAnimated:YES];
  self.moviePlayer = nil;
  self.movieContainerView = nil;
  self.owningController = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MoviePlayerLoadStateDidChangeNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:nil];

  [[OperationQueue operationQueue] resume];
}


- (void) viewController:(UIViewController*) controller willAppear:(BOOL) animated {
  if (!onBeforeViewControllerPushedCalled) {
    onBeforeViewControllerPushedCalled = YES;
    [(id)controller onBeforeViewControllerPushed];
  }
}


- (void) viewController:(UIViewController*) controller didAppear:(BOOL) animated {
  if (!onAfterViewControllerPushedCalled) {
    onAfterViewControllerPushedCalled = YES;
    [(id)controller onAfterViewControllerPushed];
  }
}


- (void) viewController:(UIViewController*) controller willDisappear:(BOOL) animated {
  if (![controller.navigationController.viewControllers containsObject:controller]) {
    [(id)controller onBeforeViewControllerPopped];
  }
}


- (void) viewController:(UIViewController*) controller didDisappear:(BOOL) animated {
  if (controller.navigationController == nil) {
    [(id)controller onAfterViewControllerPopped];
  }
}

@end
