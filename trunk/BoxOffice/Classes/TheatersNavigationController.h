//
//  TheatersNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "AllTheatersViewController.h"
#import "TheaterDetailsViewController.h"
#import "Theater.h"
#import "AbstractNavigationController.h"

@interface TheatersNavigationController : AbstractNavigationController {
    AllTheatersViewController* allTheatersViewController;
    TheaterDetailsViewController* theaterDetailsViewController;
}

@property (retain) AllTheatersViewController* allTheatersViewController;
@property (retain) TheaterDetailsViewController* theaterDetailsViewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

- (void) refresh;

- (void) pushTheaterDetails:(Theater*) theater
                   animated:(BOOL) animated;

- (void) pushTicketsView:(Theater*) theater
                   movie:(Movie*) movie
                animated:(BOOL) animated;

- (void) navigateToLastViewedPage;

@end
