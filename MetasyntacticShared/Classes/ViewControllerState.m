//
//  ViewControllerState.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerState.h"

#import "AbstractViewController.h"
#import "OperationQueue.h"

@interface ViewControllerState()
@property BOOL onBeforeViewControllerPushedCalled;
@property BOOL onAfterViewControllerPushedCalled;
@property (retain) MPMoviePlayerController* moviePlayer;
@end


@implementation ViewControllerState

@synthesize onBeforeViewControllerPushedCalled;
@synthesize onAfterViewControllerPushedCalled;
@synthesize moviePlayer;

- (void) dealloc {
  self.onBeforeViewControllerPushedCalled = NO;
  self.onAfterViewControllerPushedCalled = NO;
  self.moviePlayer = nil;

  [super dealloc];
}


- (void) playMovie:(NSString*) address {
  if (address.length == 0) {
    return;
  }
  
  NSURL* url = [NSURL URLWithString:address];
  if (url == nil) {
    return;
  }
  
  [[OperationQueue operationQueue] temporarilySuspend:90];
  self.moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(movieFinishedPlaying:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:moviePlayer];
  
  [moviePlayer play];
}


- (void) movieFinishedPlaying:(NSNotification*) notification {
  [moviePlayer stop];
  [[moviePlayer retain] autorelease];
  self.moviePlayer = nil;
  
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
