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
        
        [self pushViewController:allMoviesViewController animated:NO];
        
        self.title = @"Movies";
        self.tabBarItem.image = [UIImage imageNamed:@"Featured.png"];
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
    self.movieDetailsViewController = [[[MovieDetailsViewController alloc] initWithNavigationController:self movie:movie] autorelease];
    
    [self pushViewController:movieDetailsViewController animated:YES];
}

@end
