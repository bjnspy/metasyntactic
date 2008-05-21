//
//  SearchNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractNavigationController.h"
#import "SearchStartPageViewController.h"

@interface SearchNavigationController : AbstractNavigationController {
    SearchStartPageViewController* startPageViewController;
}

@property (retain) SearchStartPageViewController* startPageViewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;

@end
