//
//  MoviesNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MoviesNavigationController.h"
#import "ApplicationTabBarController.h"

@implementation MoviesNavigationController

@synthesize allMoviesViewController;
@synthesize movieDetailsViewController;
@synthesize tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) controller
{
    if (self = [super initWithTabBarController:controller])
    {
        self.allMoviesViewController = [[[AllMoviesViewController alloc] initWithNavigationController:self] autorelease];
        self.movieDetailsViewController = [[[MovieDetailsViewController alloc] initWithNavigationController:self] autorelease];
        
        [self pushViewController:allMoviesViewController animated:NO];
        
        self.title = @"Movies";
    }
    
    return self;
}

- (void) dealloc
{
    self.allMoviesViewController = nil;
    self.movieDetailsViewController = nil;
    [super dealloc];
}

- (void) refresh
{
    [self.allMoviesViewController refresh];
    [self.movieDetailsViewController refresh];
}

- (void) pushMovieDetails:(Movie*) movie
{
    [self pushViewController:movieDetailsViewController animated:YES];
}

@end
