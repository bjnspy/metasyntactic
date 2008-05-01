//
//  TheatersNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllTheatersViewController.h"
#import "TheaterDetailsViewController.h"

@interface TheatersNavigationController : UINavigationController {
    AllTheatersViewController* allTheatersViewController;
    TheaterDetailsViewController* theaterDetailsViewController;
}

@property (retain) AllTheatersViewController* allTheatersViewController;
@property (retain) TheaterDetailsViewController* theaterDetailsViewController;

- (id) init;
- (void) dealloc;

@end
