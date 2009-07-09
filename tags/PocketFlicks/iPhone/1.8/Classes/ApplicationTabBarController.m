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

#import "Application.h"
#import "Controller.h"
#import "DVDNavigationController.h"
#import "Model.h"
#import "MoviesNavigationController.h"
#import "NetflixNavigationController.h"
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


- (MoviesNavigationController*) moviesNavigationController {
  if (moviesNavigationControllerData == nil) {
    self.moviesNavigationControllerData = [[[MoviesNavigationController alloc] init] autorelease];
  }

  return moviesNavigationControllerData;
}


- (TheatersNavigationController*) theatersNavigationController {
  if (theatersNavigationControllerData == nil) {
    self.theatersNavigationControllerData = [[[TheatersNavigationController alloc] init] autorelease];
  }

  return theatersNavigationControllerData;
}


- (UpcomingMoviesNavigationController*) upcomingMoviesNavigationController {
  if (upcomingMoviesNavigationControllerData == nil) {
    self.upcomingMoviesNavigationControllerData = [[[UpcomingMoviesNavigationController alloc] init] autorelease];
  }

  return upcomingMoviesNavigationControllerData;
}


- (DVDNavigationController*) dvdNavigationController {
  if (dvdNavigationControllerData == nil) {
    self.dvdNavigationControllerData = [[[DVDNavigationController alloc] init] autorelease];
  }

  return dvdNavigationControllerData;
}


- (NetflixNavigationController*) netflixNavigationController {
  if (netflixNavigationControllerData == nil) {
    self.netflixNavigationControllerData = [[[NetflixNavigationController alloc] init] autorelease];
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
  if ((self = [super initWithNibName:nil bundle:nil])) {
    self.delegate = self;
  }

  return self;
}


- (void) loadView {
  [super loadView];

  [self resetTabs];

  if (self.model.userAddress.length == 0) {
    self.selectedViewController = [self moviesNavigationController];
    [self performSelector:@selector(pushInfoControllerAnimated) withObject:nil afterDelay:0];
  } else {
    CommonNavigationController* controller;
    if (self.model.selectedTabBarViewControllerIndex >= self.viewControllers.count) {
      controller = [self.viewControllers objectAtIndex:0];
    } else {
      controller = [self.viewControllers objectAtIndex:self.model.selectedTabBarViewControllerIndex];
    }

    self.selectedViewController = controller;
    [controller navigateToLastViewedPage];
    /*
     if ([NetworkUtilities isNetworkAvailable]) {
     if (!self.model.votedForIcon) {
     [self.model setVotedForIcon];

     [self performSelector:@selector(pushVoteBrowser) withObject:nil afterDelay:0];
     }
     }
     */
  }
}


- (void) pushVoteBrowser {
  CommonNavigationController* controller = self.selectedNavigationController;
  NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/IconVote?q=start", [Application host]];
  [controller pushBrowser:url showSafariButton:NO animated:YES];
}


- (void) pushInfoControllerAnimated {
  [self.moviesNavigationController pushInfoControllerAnimated:YES];
}


+ (ApplicationTabBarController*) controller {
  return [[[ApplicationTabBarController alloc] init] autorelease];
}


- (void)     tabBarController:(UITabBarController*) tabBarController
      didSelectViewController:(UIViewController*) viewController {
  self.model.selectedTabBarViewControllerIndex = self.selectedIndex;

  if ([viewController isKindOfClass:[UINavigationController class]]) {
    [self.model saveNavigationStack:(UINavigationController*) viewController];
  }

  for (id viewController in self.viewControllers) {
    [viewController onTabBarItemSelected];
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


- (CommonNavigationController*) selectedNavigationController {
  return (id) self.selectedViewController;
}


- (void) resetTabs {
  NSMutableArray* controllers = [NSMutableArray array];

  [controllers addObject:[self moviesNavigationController]];
  [controllers addObject:[self theatersNavigationController]];
  if (self.model.upcomingCacheEnabled) {
    [controllers addObject:[self upcomingMoviesNavigationController]];
  }
  if (self.model.dvdBlurayCacheEnabled) {
    [controllers addObject:[self dvdNavigationController]];
  }
  if (self.model.netflixCacheEnabled) {
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


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
                                 duration:(NSTimeInterval) duration {
  [NotificationCenter willChangeInterfaceOrientation];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
  [NotificationCenter didChangeInterfaceOrientation];
  [self majorRefresh];
}

@end
