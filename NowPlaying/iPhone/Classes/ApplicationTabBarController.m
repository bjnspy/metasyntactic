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

#import "AllMoviesViewController.h"
#import "AppDelegate.h"
#import "Application.h"
#import "DVDNavigationController.h"
#import "Model.h"
#import "MoviesNavigationController.h"
#import "NetflixNavigationController.h"
#import "NetworkUtilities.h"
#import "SettingsNavigationController.h"
#import "SettingsViewController.h"
#import "TheatersNavigationController.h"
#import "UpcomingMoviesNavigationController.h"

@interface ApplicationTabBarController()
@property (retain) MoviesNavigationController* moviesNavigationController;
@property (retain) TheatersNavigationController* theatersNavigationController;
@property (retain) UpcomingMoviesNavigationController* upcomingMoviesNavigationController;
@property (retain) DVDNavigationController* dvdNavigationController;
@property (retain) NetflixNavigationController* netflixNavigationController;
@end


@implementation ApplicationTabBarController

@synthesize moviesNavigationController;
@synthesize theatersNavigationController;
@synthesize upcomingMoviesNavigationController;
@synthesize dvdNavigationController;
@synthesize netflixNavigationController;

- (void) dealloc {
    self.moviesNavigationController = nil;
    self.theatersNavigationController = nil;
    self.upcomingMoviesNavigationController = nil;
    self.dvdNavigationController = nil;
    self.netflixNavigationController = nil;

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


- (Model*) model {
    return [[AppDelegate appDelegate] model];
}


- (Controller*) controller {
    return [[AppDelegate appDelegate] controller];
}


- (id) init {
    if (self = [super init]) {
        [self resetTabs];

        if (self.model.userAddress.length == 0) {
            self.selectedViewController = [self loadMoviesNavigationController];
            [moviesNavigationController pushInfoControllerAnimated:NO];
        } else {
            AbstractNavigationController* controller;
            if (self.model.selectedTabBarViewControllerIndex >= self.viewControllers.count) {
                controller = [self.viewControllers objectAtIndex:0];
            } else {
                controller = [self.viewControllers objectAtIndex:self.model.selectedTabBarViewControllerIndex];
            }

            self.selectedViewController = controller;
            [controller navigateToLastViewedPage];

            if ([NetworkUtilities isNetworkAvailable]) {
                if (!self.model.votedForIcon) {
                    [self.model setVotedForIcon];

                    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/IconVote?q=start", [Application host]];
                    [controller pushBrowser:url showSafariButton:NO animated:YES];
                }
            }
        }

        self.delegate = self;
    }

    return self;
}


+ (ApplicationTabBarController*) controller {
    return [[[ApplicationTabBarController alloc] init] autorelease];
}


- (void)     tabBarController:(UITabBarController*) tabBarController
      didSelectViewController:(UIViewController*) viewController {
    self.model.selectedTabBarViewControllerIndex = self.selectedIndex;

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        [self.model saveNavigationStack:(UINavigationController*)viewController];
    }
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


- (void) switchToMovies {
    self.selectedViewController = [self loadMoviesNavigationController];
}


- (void) switchToTheaters {
    self.selectedViewController = [self loadTheatersNavigationController];
}


- (void) switchToUpcoming {
    self.selectedViewController = [self loadUpcomingMoviesNavigationController];
}


- (void) switchToDVD {
    self.selectedViewController = [self loadDVDNavigationController];
}


- (AbstractNavigationController*) selectedNavigationController {
    return (id)self.selectedViewController;
}


- (void) resetTabs {
    NSMutableArray* controllers = [NSMutableArray array];

    [controllers addObject:[self loadMoviesNavigationController]];
    [controllers addObject:[self loadTheatersNavigationController]];
    if (self.model.upcomingEnabled) {
        [controllers addObject:[self loadUpcomingMoviesNavigationController]];
    }
    if (self.model.dvdBlurayEnabled) {
        [controllers addObject:[self loadDVDNavigationController]];
    }
    if (self.model.netflixEnabled) {
        [controllers addObject:[self loadNetflixNavigationController]];
    }

    if ([self.selectedViewController isKindOfClass:[UINavigationController class]] &&
        ![controllers containsObject:self.selectedViewController]) {
        [(UINavigationController*)self.selectedViewController popToRootViewControllerAnimated:NO];
    }

    [self setViewControllers:controllers animated:NO];
    /*
    // Such an awful hack.  For some reason, changing the view controllers
    // causes the tab bar to be 'stuck' selecting the current view controller.
    // in that case, we switch to another tab and back to unstick it.
    NSInteger index = self.selectedIndex;
    NSInteger tabCount = self.viewControllers.count;
    self.selectedIndex = (index + 1) % tabCount;
    self.selectedIndex = MAX(MIN(index, tabCount - 1), 0);
     */
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}

@end