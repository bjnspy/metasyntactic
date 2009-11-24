//
//  UIViewController+Utilities.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController(Utilities)

- (void) showActionSheet:(UIActionSheet*) actionSheet {
  if (!self.navigationController.toolbarHidden) {
    [actionSheet showFromToolbar:self.navigationController.toolbar];
  } else if (self.tabBarController != nil) {
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
  } else {
    [actionSheet showInView:self.view];
  }
}

@end
