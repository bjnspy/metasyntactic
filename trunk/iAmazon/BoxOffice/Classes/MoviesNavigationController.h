//
//  MoviesNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllMoviesViewController.h"
#import "MovieDetailsViewController.h"

@interface MoviesNavigationController : UINavigationController {
    AllMoviesViewController* allMoviesViewController;
    MovieDetailsViewController* movieDetailsViewController;
}

@property (retain) AllMoviesViewController* allMoviesViewController;
@property (retain) MovieDetailsViewController* movieDetailsViewController;

- (id) init;
- (void) dealloc;

@end
