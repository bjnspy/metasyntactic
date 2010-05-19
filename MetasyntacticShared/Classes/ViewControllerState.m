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

#import "ViewControllerState.h"

#import "AbstractViewController.h"
#import "FileUtilities.h"
#import "OperationQueue.h"

@interface ViewControllerState()
@property BOOL onBeforeViewControllerPushedCalled;
@property BOOL onAfterViewControllerPushedCalled;
@property (retain) MPMoviePlayerController* moviePlayerController;
@property (retain) id moviePlayerViewController;
@property (retain) UIViewController* viewController;
@end


@implementation ViewControllerState

static const NSInteger ACTIVITY_INDICATOR_TAG = 1;

@synthesize onBeforeViewControllerPushedCalled;
@synthesize onAfterViewControllerPushedCalled;
@synthesize moviePlayerController;
@synthesize moviePlayerViewController;
@synthesize viewController;

- (void) dealloc {
  self.onBeforeViewControllerPushedCalled = NO;
  self.onAfterViewControllerPushedCalled = NO;
  self.moviePlayerController = nil;
  self.moviePlayerViewController = nil;
  self.viewController = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
  }

  return self;
}


- (void) moviePlaybackCleanup {
  self.moviePlayerController = nil;
  self.moviePlayerViewController = nil;
  self.viewController = nil;

  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:nil];

  [[OperationQueue operationQueue] resume];
}


- (void) playMovieUsingMoviePlayer:(NSURL*) url {
  self.moviePlayerController = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayerFinishedPlaying:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:nil];

  [moviePlayerController play];
}


- (void) moviePlayerFinishedPlaying:(NSNotification*) notification {
  [moviePlayerController stop];
  [[moviePlayerController retain] autorelease];

  [self moviePlaybackCleanup];
}


- (MPMoviePlayerController*) moviePlayer {
  return nil;
}


- (void) presentMoviePlayerViewControllerAnimated:(id) player {
}


- (void) dismissMoviePlayerViewControllerAnimated {
}


- (void) playMovieUsingMoviePlayerView:(NSURL*) url {
	Class class = NSClassFromString(@"MPMoviePlayerViewController");
  self.moviePlayerViewController = [[[class alloc] initWithContentURL:url] autorelease];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayerViewFinishedPlaying:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:nil];

  [[(id)moviePlayerViewController moviePlayer] play];
  [(id)viewController presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}


- (void) moviePlayerViewFinishedPlaying:(NSNotification*) notification {
  [[(id)moviePlayerViewController moviePlayer] stop];
  [[moviePlayerViewController retain] autorelease];

  [(id)viewController dismissMoviePlayerViewControllerAnimated];
  [self moviePlaybackCleanup];
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

	Class class = NSClassFromString(@"MPMoviePlayerViewController");
  if (class != nil && [class instancesRespondToSelector:@selector(moviePlayer)]) {
    [self playMovieUsingMoviePlayerView:url];
  } else {
    [self playMovieUsingMoviePlayer:url];
  }
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
