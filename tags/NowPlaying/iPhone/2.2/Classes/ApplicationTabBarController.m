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

#import "ApplicationTabBarController.h"

#import "DVDNavigationController.h"
#import "MoviesNavigationController.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
//#import "NumbersNavigationController.h"
#import "SettingsNavigationController.h"
#import "TheatersNavigationController.h"
#import "UpcomingMoviesNavigationController.h"
#import "Utilities.h"

@implementation ApplicationTabBarController

@synthesize moviesNavigationController;
@synthesize theatersNavigationController;
@synthesize upcomingMoviesNavigationController;
@synthesize numbersNavigationController;
@synthesize dvdNavigationController;
@synthesize settingsNavigationController;
@synthesize appDelegate;
@synthesize lastRefreshDate;

- (void) dealloc {
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.upcomingMoviesNavigationController = nil;
    self.numbersNavigationController = nil;
    self.dvdNavigationController = nil;
    self.settingsNavigationController = nil;
    self.appDelegate = nil;
    self.lastRefreshDate = nil;

    [super dealloc];
}


- (id) initWithAppDelegate:(NowPlayingAppDelegate*) appDel {
    if (self = [super init]) {
        self.appDelegate = appDel;
        self.lastRefreshDate = nil;

        self.moviesNavigationController   = [[[MoviesNavigationController alloc] initWithTabBarController:self] autorelease];
        self.theatersNavigationController = [[[TheatersNavigationController alloc] initWithTabBarController:self] autorelease];
        self.upcomingMoviesNavigationController = [[[UpcomingMoviesNavigationController alloc] initWithTabBarController:self] autorelease];
        self.dvdNavigationController = [[[DVDNavigationController alloc] initWithTabBarController:self] autorelease];
        //self.numbersNavigationController   = [[[NumbersNavigationController alloc] initWithTabBarController:self] autorelease];
        self.settingsNavigationController = [[[SettingsNavigationController alloc] initWithTabBarController:self] autorelease];

        self.viewControllers =
        [NSArray arrayWithObjects:
         moviesNavigationController,
         theatersNavigationController,
         upcomingMoviesNavigationController,
         //numbersNavigationController,
         dvdNavigationController,
         settingsNavigationController, nil];

        if (self.model.userAddress.length == 0) {
            self.selectedViewController = settingsNavigationController;
        } else {
            AbstractNavigationController* controller;
            if (self.model.selectedTabBarViewControllerIndex >= self.viewControllers.count) {
                controller = [self.viewControllers objectAtIndex:0];
            } else {
                controller = [self.viewControllers objectAtIndex:self.model.selectedTabBarViewControllerIndex];
            }

            self.selectedViewController = controller;
            [controller navigateToLastViewedPage];
        }

        self.delegate = self;
    }

    return self;
}


+ (ApplicationTabBarController*) controllerWithAppDelegate:(NowPlayingAppDelegate*) appDelegate {
    return [[[ApplicationTabBarController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (void)     tabBarController:(UITabBarController*) tabBarController
      didSelectViewController:(UIViewController*) viewController {
    [self.model setSelectedTabBarViewControllerIndex:self.selectedIndex];
}


- (NowPlayingModel*) model {
    return appDelegate.model;
}


- (NowPlayingController*) controller {
    return appDelegate.controller;
}


- (void) refresh {
    for (id viewController in self.viewControllers) {
        [viewController refresh];
    }
}


- (void) popNavigationControllersToRoot {
    [moviesNavigationController popToRootViewControllerAnimated:YES];
    [theatersNavigationController popToRootViewControllerAnimated:YES];
    [numbersNavigationController popToRootViewControllerAnimated:YES];
}


- (void) switchToMovies {
    self.selectedViewController = moviesNavigationController;
}


- (void) switchToTheaters {
    self.selectedViewController = theatersNavigationController;
}


- (void) switchToUpcoming {
    self.selectedViewController = upcomingMoviesNavigationController;
}


- (void) switchToDVD {
    self.selectedViewController = dvdNavigationController;
}


- (AbstractNavigationController*) selectedNavigationController {
    return (id)self.selectedViewController;
}


@end