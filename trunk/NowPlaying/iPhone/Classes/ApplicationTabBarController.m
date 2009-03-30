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
#import "Controller.h"
#import "DVDNavigationController.h"
#import "Model.h"
#import "MoviesNavigationController.h"
#import "NetflixNavigationController.h"
#import "NetworkUtilities.h"
#import "NotificationCenter.h"
#import "SettingsViewController.h"
#import "TheatersNavigationController.h"
#import "UpcomingMoviesNavigationController.h"

@interface ApplicationTabBarController()
@property (retain) MoviesNavigationController* moviesNavigationControllerData;
@property (retain) TheatersNavigationController* theatersNavigationControllerData;
@property (retain) UpcomingMoviesNavigationController* upcomingMoviesNavigationControllerData;
@property (retain) DVDNavigationController* dvdNavigationControllerData;
@property (retain) NetflixNavigationController* netflixNavigationControllerData;
@end


@implementation ApplicationTabBarController

@synthesize moviesNavigationControllerData;
@synthesize theatersNavigationControllerData;
@synthesize upcomingMoviesNavigationControllerData;
@synthesize dvdNavigationControllerData;
@synthesize netflixNavigationControllerData;

- (void) dealloc {
    self.moviesNavigationControllerData = nil;
    self.theatersNavigationControllerData = nil;
    self.upcomingMoviesNavigationControllerData = nil;
    self.dvdNavigationControllerData = nil;
    self.netflixNavigationControllerData = nil;

    [super dealloc];
}


- (UINavigationController*) moviesNavigationController {
    if (moviesNavigationControllerData == nil) {
        self.moviesNavigationControllerData = [[[MoviesNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return moviesNavigationControllerData;
}


- (UINavigationController*) theatersNavigationController {
    if (theatersNavigationControllerData == nil) {
        self.theatersNavigationControllerData = [[[TheatersNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return theatersNavigationControllerData;
}


- (UINavigationController*) upcomingMoviesNavigationController {
    if (upcomingMoviesNavigationControllerData == nil) {
        self.upcomingMoviesNavigationControllerData = [[[UpcomingMoviesNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return upcomingMoviesNavigationControllerData;
}


- (UINavigationController*) dvdNavigationController {
    if (dvdNavigationControllerData == nil) {
        self.dvdNavigationControllerData = [[[DVDNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return dvdNavigationControllerData;
}


- (UINavigationController*) netflixNavigationController {
    if (netflixNavigationControllerData == nil) {
        self.netflixNavigationControllerData = [[[NetflixNavigationController alloc] initWithTabBarController:self] autorelease];
    }

    return netflixNavigationControllerData;
}


- (Model*) model {
    return [Model model];
}


- (Controller*) controller {
    return [Controller controller];
}


- (id) init {
    if (self = [super init]) {
        [self resetTabs];

        if (self.model.userAddress.length == 0) {
            self.selectedViewController = [self moviesNavigationController];
            [moviesNavigationControllerData pushInfoControllerAnimated:NO];
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


- (void) loadView {
    [super loadView];
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
    self.selectedViewController = [self moviesNavigationController];
}


- (void) switchToTheaters {
    self.selectedViewController = [self theatersNavigationController];
}


- (void) switchToUpcoming {
    self.selectedViewController = [self upcomingMoviesNavigationController];
}


- (void) switchToDVD {
    self.selectedViewController = [self dvdNavigationController];
}


- (AbstractNavigationController*) selectedNavigationController {
    return (id)self.selectedViewController;
}


- (void) resetTabs {
    NSMutableArray* controllers = [NSMutableArray array];

    [controllers addObject:[self moviesNavigationController]];
    [controllers addObject:[self theatersNavigationController]];
    if (self.model.upcomingEnabled) {
        [controllers addObject:[self upcomingMoviesNavigationController]];
    }
    if (self.model.dvdBlurayEnabled) {
        [controllers addObject:[self dvdNavigationController]];
    }
    if (self.model.netflixEnabled) {
        [controllers addObject:[self netflixNavigationController]];
    }

    if (![controllers containsObject:self.selectedNavigationController]) {
        [self.selectedNavigationController popToRootViewControllerAnimated:NO];
    }

    [self setViewControllers:controllers animated:NO];
    /*
     // Such an awful hack.  For some reason, changing the view controllers
     // causes the tab bar to be 'stuck' selecting the current view controller.
     // in that case, we switch to another tab and back to unstick it.
     NSInteger index = selectedIndex;
     NSInteger tabCount = viewControllers.count;
     selectedIndex = (index + 1) % tabCount;
     selectedIndex = MAX(MIN(index, tabCount - 1), 0);
     */
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
                                 duration:(NSTimeInterval) duration {
    [NotificationCenter willChangeInterfaceOrientation];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [NotificationCenter didChangeInterfaceOrientation];
}

@end
