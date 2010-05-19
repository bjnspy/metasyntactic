// Copyright 2010 Cyrus Najmabadi
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

#import "NowPlayingTabBarController.h"

#import "DVDNavigationController.h"
#import "Model.h"
#import "MoviesNavigationController.h"
#import "NetflixNavigationController.h"
#import "TheatersNavigationController.h"
#import "UpcomingMoviesNavigationController.h"

@interface NowPlayingTabBarController()
@property (retain) MoviesNavigationController* moviesNavigationControllerData;
@property (retain) TheatersNavigationController* theatersNavigationControllerData;
@property (retain) UpcomingMoviesNavigationController* upcomingMoviesNavigationControllerData;
@property (retain) DVDNavigationController* dvdNavigationControllerData;
@property (retain) NetflixNavigationController* netflixNavigationControllerData;
@end


@implementation NowPlayingTabBarController

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


- (id) init {
  if ((self = [super init])) {
    self.delegate = self;
  }

  return self;
}


- (void) loadView {
  [super loadView];

  [self resetTabs];

  if ([Model model].userAddress.length == 0) {
    self.selectedViewController = [self moviesNavigationController];
    [self performSelector:@selector(pushInfoControllerAnimated) withObject:nil afterDelay:0];
  } else {
    CommonNavigationController* controller;
    if ([Model model].selectedTabBarViewControllerIndex >= self.viewControllers.count) {
      controller = self.viewControllers.firstObject;
    } else {
      controller = [self.viewControllers objectAtIndex:[Model model].selectedTabBarViewControllerIndex];
    }

    self.selectedViewController = controller;
    [controller navigateToLastViewedPage];
  }
}


- (void) pushInfoControllerAnimated {
  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    [self.moviesNavigationController pushInfoControllerAnimated:NO];
  } else {
    [self.moviesNavigationController pushInfoControllerAnimated:YES];
  }
}


- (void)     tabBarController:(UITabBarController*) tabBarController
      didSelectViewController:(UIViewController*) viewController {
  [Model model].selectedTabBarViewControllerIndex = self.selectedIndex;

  if ([viewController isKindOfClass:[UINavigationController class]]) {
    [[Model model] saveNavigationStack:(UINavigationController*) viewController];
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
  if ([Model model].upcomingCacheEnabled) {
    [controllers addObject:[self upcomingMoviesNavigationController]];
  }
  if ([Model model].dvdBlurayCacheEnabled) {
    [controllers addObject:[self dvdNavigationController]];
  }
  if ([Model model].netflixCacheEnabled) {
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


- (void) rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  for (id controller in self.viewControllers) {
    if ([controller respondsToSelector:@selector(rotateToInterfaceOrientation:duration:)]) {
      [controller rotateToInterfaceOrientation:interfaceOrientation duration:duration];
    }
  }
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  [self rotateToInterfaceOrientation:interfaceOrientation duration:duration];
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
