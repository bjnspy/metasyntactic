// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
@synthesize searchNavigationController;
@synthesize settingsNavigationController;
@synthesize appDelegate;

- (void) dealloc {
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.searchNavigationController = nil;
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
