//
//  MoviesNavigationController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllMoviesViewController.h"
#import "MovieDetailsViewController.h"
#import "Movie.h"

@class ApplicationTabBarController;

@interface MoviesNavigationController : UINavigationController {
    ApplicationTabBarController* tabBarController;
    AllMoviesViewController* allMoviesViewController;
    MovieDetailsViewController* movieDetailsViewController;
}

@property (assign) ApplicationTabBarController* tabBarController;
@property (retain) AllMoviesViewController* allMoviesViewController;
@property (retain) MovieDetailsViewController* movieDetailsViewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;
- (void) dealloc;

- (void) refresh;

- (BoxOfficeModel*) model;

- (void) pushMovieDetails:(Movie*) movie;

@end
