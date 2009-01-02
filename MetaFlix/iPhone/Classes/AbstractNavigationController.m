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

#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "MetaFlixAppDelegate.h"
#import "MetaFlixModel.h"
#import "PostersViewController.h"
#import "WebViewController.h"

@interface AbstractNavigationController()
@property (assign) MetaFlixAppDelegate* appDelegate;
@property (retain) PostersViewController* postersViewController;
@property BOOL visible;
@end


@implementation AbstractNavigationController

@synthesize appDelegate;
@synthesize postersViewController;
@synthesize visible;

- (void) dealloc {
    self.appDelegate = nil;
    self.postersViewController = nil;

    [super dealloc];
}


- (id) initWithAppDelegate:(MetaFlixAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        self.appDelegate = appDelegate_;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    viewLoaded = YES;
    self.view.autoresizesSubviews = YES;
}


- (void) refreshWithSelector:(SEL) selector {
    if (!viewLoaded || !visible) {
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
    visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (visible || postersViewController != nil) {
        return;
    }

    [self popToRootViewControllerAnimated:NO];
    [super didReceiveMemoryWarning];
}


- (MetaFlixModel*) model {
    return appDelegate.model;
}


- (MetaFlixController*) controller {
    return appDelegate.controller;
}


- (void) pushMovieDetails:(Movie*) movie
                 animated:(BOOL) animated {
    if (movie == nil) {
        return;
    }

    UIViewController* viewController = [[[MovieDetailsViewController alloc] initWithNavigationController:self
                                                                                                   movie:movie] autorelease];

    [self pushViewController:viewController animated:animated];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return postersViewController == nil;
}


- (void) hidePostersView {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self dismissModalViewControllerAnimated:YES];
    self.postersViewController = nil;
}


- (void) showPostersView:(Movie*) movie posterCount:(NSInteger) posterCount {
    if (postersViewController != nil) {
        [self hidePostersView];
    }

    self.postersViewController =
    [[[PostersViewController alloc] initWithNavigationController:self
                                                          movie:movie
                                                    posterCount:posterCount] autorelease];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [self presentModalViewController:postersViewController animated:YES];
}


- (void) pushBrowser:(NSString*) address showSafariButton:(BOOL) showSafariButton animated:(BOOL) animated {
    WebViewController* controller = [[[WebViewController alloc] initWithNavigationController:self
                                                                                     address:address
                                                                            showSafariButton:showSafariButton] autorelease];
    [self pushViewController:controller animated:animated];
}


- (void) pushBrowser:(NSString*) address animated:(BOOL) animated {
    [self pushBrowser:address showSafariButton:YES animated:animated];
}

@end