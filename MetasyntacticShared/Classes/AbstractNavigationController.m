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

#import "AbstractNavigationController.h"

#import "AbstractFullScreenImageListViewController.h"
#import "MapViewController.h"
#import "MetasyntacticStockImages.h"
#import "NotificationCenter.h"
#import "StyleSheet.h"
#import "TweetViewController.h"
#import "WebViewController.h"

@interface AbstractNavigationController()
@property BOOL visible;
@property (retain) AbstractFullScreenImageListViewController* fullScreenImageListController;
@end


@implementation AbstractNavigationController

@synthesize visible;
@synthesize fullScreenImageListController;

- (void) dealloc {
  self.visible = NO;
  self.fullScreenImageListController = nil;

  [super dealloc];
}


- (UIImage*) backgroundImage {
  return MetasyntacticStockImage(@"UINavigationControllerBackgroundPattern.png");
}


- (void) setupStyle {
  self.navigationBar.barStyle = [StyleSheet navigationBarStyle];
  self.navigationBar.tintColor = [StyleSheet navigationBarTintColor];
}


- (void) loadView {
  [super loadView];

  self.view.autoresizesSubviews = YES;
  [self setupStyle];

  UIImage* image = self.backgroundImage;
  if (image != nil) {
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
  }
}


- (void) refreshWithSelector:(SEL) selector {
  if (!self.isViewLoaded) {
    return;
  }

  if (self.modalViewController != nil) {
    if ([self.modalViewController respondsToSelector:selector]) {
      [self.modalViewController performSelector:selector];
    }
  }

  if (!visible) {
    return;
  }

  for (id controller in self.viewControllers) {
    if ([controller respondsToSelector:selector]) {
      [controller performSelector:selector];
    }
  }
}


- (void) majorRefresh {
  [self setupStyle];
  [self refreshWithSelector:@selector(majorRefresh)];
}


- (void) minorRefresh {
  [self refreshWithSelector:@selector(minorRefresh)];
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  self.visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
  [super viewDidDisappear:animated];
  self.visible = NO;
}


- (void) didReceiveMemoryWarning {
  if (visible) {
    return;
  }

  if (fullScreenImageListController != nil) {
    return;
  }

  [self popToRootViewControllerAnimated:NO];
  [super didReceiveMemoryWarning];
}


- (void) pushBrowser:(NSString*) address showSafariButton:(BOOL) showSafariButton animated:(BOOL) animated {
  WebViewController* controller = [[[WebViewController alloc] initWithAddress:address
                                                             showSafariButton:showSafariButton] autorelease];
  [self pushViewController:controller animated:animated];
}


- (void) pushBrowser:(NSString*) address animated:(BOOL) animated {
  [self pushBrowser:address showSafariButton:YES animated:animated];
}


- (void) pushFullScreenImageList:(AbstractFullScreenImageListViewController*) controller {
  if (fullScreenImageListController != nil) {
    [self popFullScreenImageList];
  }

  self.fullScreenImageListController = controller;
  [self pushViewController:controller animated:YES];
}


- (void) popFullScreenImageList {
  [self popViewControllerAnimated:YES];
  self.fullScreenImageListController = nil;;
}


- (void) pushMapWithCenter:(id<MapPoint>) center animated:(BOOL) animated {
  [self pushMapWithCenter:center locations:[NSArray array] animated:YES];
}


- (void) pushMapWithCenter:(id<MapPoint>) center locations:(NSArray*) locations animated:(BOOL) animated {
  [self pushMapWithCenter:center locations:locations delegate:nil animated:YES];
}


- (void) pushMapWithCenter:(id<MapPoint>) center locations:(NSArray*) locations delegate:(id<MapViewControllerDelegate>) delegate animated:(BOOL) animated {
  MapViewController* controller = [MapViewController controllerWithCenter:center locations:locations];
  controller.mapDelegate = delegate;
  [self pushViewController:controller animated:YES];
}


- (void) rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  for (id controller in self.viewControllers) {
    if ([controller respondsToSelector:@selector(rotateToInterfaceOrientation:duration:)]) {
      [controller rotateToInterfaceOrientation:interfaceOrientation duration:duration];
    }
  }
}


- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
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


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  NSLog(@"%d \"%@\" pushViewController", viewController, viewController.title);
  [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
  UIViewController* viewController = [super popViewControllerAnimated:animated];
  NSLog(@"%d \"%@\" popViewControllerAnimated", viewController, viewController.title);
  return viewController;
}


- (void) pushTweetController:(NSString*) tweet account:(AbstractTwitterAccount*) account {
  UIViewController* controller = [[[TweetViewController alloc] initWithTweet:tweet account:account] autorelease];
  [self pushViewController:controller animated:YES];
}

@end
