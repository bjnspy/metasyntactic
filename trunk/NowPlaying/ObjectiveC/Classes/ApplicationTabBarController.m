// Copyright (C) 2008 Cyrus Najmabadi
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

#import "ApplicationTabBarController.h"

#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "MoviesNavigationController.h"
#import "NumbersNavigationController.h"
#import "SettingsNavigationController.h"
#import "TheatersNavigationController.h"
#import "UpcomingMoviesNavigationController.h"
#import "Utilities.h"

@implementation ApplicationTabBarController

@synthesize moviesNavigationController;
@synthesize theatersNavigationController;
@synthesize upcomingMoviesNavigationController;
@synthesize numbersNavigationController;
@synthesize settingsNavigationController;
@synthesize appDelegate;

- (void) dealloc {
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.upcomingMoviesNavigationController = nil;
    self.numbersNavigationController = nil;
    self.settingsNavigationController = nil;
    self.appDelegate = nil;

    [super dealloc];
}


- (id) initWithAppDelegate:(NowPlayingAppDelegate*) appDel {
    if (self = [super init]) {
        self.appDelegate = appDel;
        self.moviesNavigationController   = [[[MoviesNavigationController alloc] initWithTabBarController:self] autorelease];
        self.theatersNavigationController = [[[TheatersNavigationController alloc] initWithTabBarController:self] autorelease];
        self.upcomingMoviesNavigationController = [[[UpcomingMoviesNavigationController alloc] initWithTabBarController:self] autorelease];
        self.numbersNavigationController   = [[[NumbersNavigationController alloc] initWithTabBarController:self] autorelease];
        self.settingsNavigationController = [[[SettingsNavigationController alloc] initWithTabBarController:self] autorelease];

        self.viewControllers =
        [NSArray arrayWithObjects:
         moviesNavigationController,
         theatersNavigationController,
         upcomingMoviesNavigationController,
         numbersNavigationController,
         settingsNavigationController, nil];

        if ([Utilities isNilOrEmpty:self.model.postalCode]) {
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


@end
