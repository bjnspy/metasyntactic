//
//  MoviesNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "MoviesNavigationController.h"
#import "ApplicationTabBarController.h"

@implementation MoviesNavigationController

@synthesize allMoviesViewController;
@synthesize movieDetailsViewController;
@synthesize tabBarController;

- (void) dealloc
{
    self.allMoviesViewController = nil;
    self.movieDetailsViewController = nil;
    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super initWithTabBarController:controller])
    {
        self.allMoviesViewController = [[[AllMoviesViewController alloc] initWithNavigationController:self] autorelease];
        
        [self pushViewController:allMoviesViewController animated:NO];
        
        self.title = @"Movies";
        self.tabBarItem.image = [UIImage imageNamed:@"Featured.png"];
    }
    
    return self;
}

- (void) navigateToLastViewedPage {
    Movie* currentMovie = [[self model] currentlySelectedMovie];
    if (currentMovie != nil) {
        [self pushMovieDetails:currentMovie animated:NO];
        
        Theater* currentTheater = [[self model] currentlySelectedTheater];
        if (currentTheater != nil) {
            [self pushTicketsView:currentMovie
                          theater:currentTheater
                         animated:NO];
        }
    }    
}

- (void) refresh
{
    [self.allMoviesViewController refresh];
    [self.movieDetailsViewController refresh];
}

- (void) pushMovieDetails:(Movie*) movie
                 animated:(BOOL) animated
{
    [self popToRootViewControllerAnimated:NO];
    
    self.movieDetailsViewController = [[[MovieDetailsViewController alloc] initWithNavigationController:self movie:movie] autorelease];
    
    [self pushViewController:movieDetailsViewController animated:animated];
}

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                animated:(BOOL) animated {
    
    return [self pushTicketsView:movie
                         theater:theater
                           title:theater.name
                   linkToTheater:YES
                        animated:animated];
}

@end
