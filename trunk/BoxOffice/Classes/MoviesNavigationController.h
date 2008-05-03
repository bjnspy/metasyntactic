//
//  MoviesNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AbstractNavigationController.h"
#import "AllMoviesViewController.h"
#import "MovieDetailsViewController.h"
#import "Movie.h"

@interface MoviesNavigationController : AbstractNavigationController {
    AllMoviesViewController* allMoviesViewController;
    MovieDetailsViewController* movieDetailsViewController;
}

@property (retain) AllMoviesViewController* allMoviesViewController;
@property (retain) MovieDetailsViewController* movieDetailsViewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

- (void) refresh;

- (void) pushMovieDetails:(Movie*) movie;

@end
