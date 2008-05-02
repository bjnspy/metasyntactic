//
//  TheatersNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllTheatersViewController.h"
#import "TheaterDetailsViewController.h"

@class ApplicationTabBarController;

@interface TheatersNavigationController : UINavigationController {
    ApplicationTabBarController* tabBarController;
    AllTheatersViewController* allTheatersViewController;
    TheaterDetailsViewController* theaterDetailsViewController;
}

@property (assign) ApplicationTabBarController* tabBarController;
@property (retain) AllTheatersViewController* allTheatersViewController;
@property (retain) TheaterDetailsViewController* theaterDetailsViewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

@end
