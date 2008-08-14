// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "ApplicationTabBarController.h"

#import "BoxOfficeAppDelegate.h"
#import "BoxOfficeModel.h"
#import "MoviesNavigationController.h"
#import "SettingsNavigationController.h"
#import "TheatersNavigationController.h"
#import "Utilities.h"

@implementation ApplicationTabBarController

@synthesize moviesNavigationController;
@synthesize theatersNavigationController;
@synthesize settingsNavigationController;
@synthesize appDelegate;

- (void) dealloc {
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.settingsNavigationController = nil;
    self.appDelegate = nil;
    [super dealloc];
}


- (id) initWithAppDelegate:(BoxOfficeAppDelegate*) appDel {
    if (self = [super init]) {
        self.appDelegate = appDel;
        self.moviesNavigationController   = [[[MoviesNavigationController alloc] initWithTabBarController:self] autorelease];
        self.theatersNavigationController = [[[TheatersNavigationController alloc] initWithTabBarController:self] autorelease];
        //self.searchNavigationController   = [[[SearchNavigationController alloc] initWithTabBarController:self] autorelease];
        self.settingsNavigationController = [[[SettingsNavigationController alloc] initWithTabBarController:self] autorelease];

        self.viewControllers =
        [NSArray arrayWithObjects:
         moviesNavigationController,
         theatersNavigationController,
         //searchNavigationController,
         settingsNavigationController, nil];

        if ([Utilities isNilOrEmpty:[self.model postalCode]]) {
            self.selectedViewController = self.settingsNavigationController;
        } else {
            AbstractNavigationController* controller = [self.viewControllers objectAtIndex:[self.model selectedTabBarViewControllerIndex]];
            self.selectedViewController = controller;
            [controller navigateToLastViewedPage];
        }

        self.delegate = self;
    }

    return self;
}


+ (ApplicationTabBarController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate {
    return [[[ApplicationTabBarController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (void)       tabBarController:(UITabBarController*) tabBarController
        didSelectViewController:(UIViewController*) viewController {
    [self.model setSelectedTabBarViewControllerIndex:self.selectedIndex];
}


- (BoxOfficeModel*) model {
    return [self.appDelegate model];
}


- (BoxOfficeController*) controller {
    return [self.appDelegate controller];
}


- (void) refresh {
    [self.moviesNavigationController refresh];
    [self.theatersNavigationController refresh];
    [self.settingsNavigationController refresh];
}


- (void) showTheaterDetails:(Theater*) theater {
    self.selectedViewController = self.theatersNavigationController;
    [self.theatersNavigationController pushTheaterDetails:theater animated:YES];
}


- (void) showMovieDetails:(Movie*) movie {
    self.selectedViewController = self.moviesNavigationController;
    [self.moviesNavigationController pushMovieDetails:movie animated:YES];
}


- (void) popNavigationControllersToRoot {
    [self.moviesNavigationController popToRootViewControllerAnimated:YES];
    [self.theatersNavigationController popToRootViewControllerAnimated:YES];
}


@end
