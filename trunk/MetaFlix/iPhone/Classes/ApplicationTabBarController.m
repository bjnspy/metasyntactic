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
#import "NetflixNavigationController.h"
#import "MetaFlixAppDelegate.h"
#import "MetaFlixModel.h"
#import "SettingsNavigationController.h"
#import "TheatersNavigationController.h"
#import "UpcomingMoviesNavigationController.h"
#import "UpcomingMoviesAndDVDNavigationController.h"

@interface ApplicationTabBarController()
@property (assign) MetaFlixAppDelegate* appDelegate;
@property (retain) MoviesNavigationController* moviesNavigationController;
@property (retain) TheatersNavigationController* theatersNavigationController;
@property (retain) UpcomingMoviesNavigationController* upcomingMoviesNavigationController;
@property (retain) UpcomingMoviesAndDVDNavigationController* upcomingMoviesAndDVDNavigationController;
@property (retain) DVDNavigationController* dvdNavigationController;
@property (retain) NetflixNavigationController* netflixNavigationController;
@property (retain) SettingsNavigationController* settingsNavigationController;
@end


@implementation ApplicationTabBarController

@synthesize moviesNavigationController;
@synthesize theatersNavigationController;
@synthesize upcomingMoviesNavigationController;
@synthesize upcomingMoviesAndDVDNavigationController;
@synthesize dvdNavigationController;
@synthesize netflixNavigationController;
@synthesize settingsNavigationController;
@synthesize appDelegate;

- (void) dealloc {
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.upcomingMoviesNavigationController = nil;
    self.upcomingMoviesAndDVDNavigationController = nil;
    self.dvdNavigationController = nil;
    self.netflixNavigationController = nil;
    self.settingsNavigationController = nil;
    self.appDelegate = nil;

    [super dealloc];
}


- (UINavigationController*) loadMoviesNavigationController {
    if (moviesNavigationController == nil) {
        self.moviesNavigationController = [[[MoviesNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return moviesNavigationController;
}


- (UINavigationController*) loadTheatersNavigationController {
    if (theatersNavigationController == nil) {
        self.theatersNavigationController = [[[TheatersNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return theatersNavigationController;
}


- (UINavigationController*) loadUpcomingMoviesNavigationController {
    if (upcomingMoviesNavigationController == nil) {
        self.upcomingMoviesNavigationController = [[[UpcomingMoviesNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return upcomingMoviesNavigationController;
}


- (UINavigationController*) loadUpcomingMoviesAndDVDNavigationController {
    if (upcomingMoviesAndDVDNavigationController == nil) {
        self.upcomingMoviesAndDVDNavigationController = [[[UpcomingMoviesAndDVDNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return upcomingMoviesAndDVDNavigationController;
}


- (UINavigationController*) loadDVDNavigationController {
    if (dvdNavigationController == nil) {
        self.dvdNavigationController = [[[DVDNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return dvdNavigationController;
}


- (UINavigationController*) loadNetflixNavigationController {
    if (netflixNavigationController == nil) {
        self.netflixNavigationController = [[[NetflixNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return netflixNavigationController;
}


- (UINavigationController*) loadSettingsNavigationController {
    if (settingsNavigationController == nil) {
        self.settingsNavigationController = [[[SettingsNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return settingsNavigationController;
}


- (id) initWithAppDelegate:(MetaFlixAppDelegate*) appDel {
    if (self = [super init]) {
        self.appDelegate = appDel;

        [self resetTabs:NO];

        if (self.model.userAddress.length == 0) {
            self.selectedViewController = [self loadSettingsNavigationController];
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


+ (ApplicationTabBarController*) controllerWithAppDelegate:(MetaFlixAppDelegate*) appDelegate {
    return [[[ApplicationTabBarController alloc] initWithAppDelegate:appDelegate] autorelease];
}


- (void)     tabBarController:(UITabBarController*) tabBarController
      didSelectViewController:(UIViewController*) viewController {
    [self.model setSelectedTabBarViewControllerIndex:self.selectedIndex];
}


- (MetaFlixModel*) model {
    return appDelegate.model;
}


- (MetaFlixController*) controller {
    return appDelegate.controller;
}


- (void) majorRefresh {
    for (id viewController in self.viewControllers) {
        if ([viewController respondsToSelector:@selector(majorRefresh)]) {
            [viewController majorRefresh];
        }
    }
}


- (void) minorRefresh {
    for (id viewController in self.viewControllers) {
        if ([viewController respondsToSelector:@selector(minorRefresh)]) {
            [viewController minorRefresh];
        }
    }
}


- (void) popNavigationControllersToRoot {
    [moviesNavigationController popToRootViewControllerAnimated:YES];
    [theatersNavigationController popToRootViewControllerAnimated:YES];
}


- (void) switchToMovies {
    self.selectedViewController = [self loadMoviesNavigationController];
}


- (void) switchToTheaters {
    self.selectedViewController = [self loadTheatersNavigationController];
}


- (void) switchToUpcoming {
    if (self.model.netflixEnabled) {
        self.selectedViewController = [self loadUpcomingMoviesAndDVDNavigationController];
    } else {
        self.selectedViewController = [self loadUpcomingMoviesNavigationController];
    }
}


- (void) switchToDVD {
    if (self.model.netflixEnabled) {
        self.selectedViewController = [self loadUpcomingMoviesAndDVDNavigationController];
    } else {
        self.selectedViewController = [self loadDVDNavigationController];
    }
}


- (AbstractNavigationController*) selectedNavigationController {
    return (id)self.selectedViewController;
}


- (void) setTabs:(NSNumber*) animated {
    NSArray* controllers;

    if (self.model.netflixEnabled) {
        controllers =
        [NSArray arrayWithObjects:
         [self loadMoviesNavigationController],
         [self loadTheatersNavigationController],
         [self loadUpcomingMoviesAndDVDNavigationController],
         [self loadNetflixNavigationController],
         [self loadSettingsNavigationController], nil];
    } else {
        controllers =
        [NSArray arrayWithObjects:
         [self loadMoviesNavigationController],
         [self loadTheatersNavigationController],
         [self loadUpcomingMoviesNavigationController],
         [self loadDVDNavigationController],
         [self loadSettingsNavigationController], nil];
    }

    [self setViewControllers:controllers animated:animated.boolValue];

    // Such an awful hack.  For some reason, changing the view controllers
    // causes the tab bar to be 'stuck' selecting the settings view controller.
    // in that case, we switch to another tab and back to unstick it.
    if (self.selectedIndex == 4) {
        self.selectedIndex = 1;
        self.selectedIndex = 4;
    }
}


- (void) resetTabs:(BOOL) animated {
    if (animated) {
        NSArray* currentControllers = self.viewControllers;
        [self setTabs:[NSNumber numberWithBool:NO]];
        self.viewControllers = currentControllers;

        // fade out, then fade in
        [self setViewControllers:[NSArray array] animated:YES];
        [self performSelector:@selector(setTabs:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];
    } else {
        [self setTabs:[NSNumber numberWithBool:animated]];
    }
}

@end