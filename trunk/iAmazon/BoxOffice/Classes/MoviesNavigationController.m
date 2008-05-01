//
//  MoviesNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MoviesNavigationController.h"

@implementation MoviesNavigationController

@synthesize allMoviesViewController;
@synthesize movieDetailsViewController;

- (id) init
{
    if (self = [super init])
    {
        self.title = @"Movies";
        
        self.allMoviesViewController = [[AllMoviesViewController alloc] init];
        self.movieDetailsViewController = [[MovieDetailsViewController alloc] init];
        
        [self pushViewController:allMoviesViewController animated:NO];
    }
    
    return self;
}

- (void) dealloc
{
    self.allMoviesViewController = nil;
    self.movieDetailsViewController = nil;
    [super dealloc];
}

@end
