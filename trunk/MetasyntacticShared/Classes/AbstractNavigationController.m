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

#import "AbstractNavigationController.h"

#import "AbstractFullScreenImageListViewController.h"
#import "MapViewController.h"
#import "NotificationCenter.h"
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


- (void) loadView {
  [super loadView];

  self.view.autoresizesSubviews = YES;
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


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation
                                 duration:(NSTimeInterval) duration {
  [NotificationCenter willChangeInterfaceOrientation];
}


- (void) onRotate {
  for (id controller in self.viewControllers) {
    if ([controller respondsToSelector:@selector(onRotate)]) {
      [controller onRotate];
    }
  }
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
  [NotificationCenter didChangeInterfaceOrientation];
  [self majorRefresh];
  
  [self onRotate];
}

@end
