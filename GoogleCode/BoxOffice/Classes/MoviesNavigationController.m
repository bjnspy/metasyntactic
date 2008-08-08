// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "MoviesNavigationController.h"
#import "ApplicationTabBarController.h"
#import "ReviewsViewController.h"
#import "AbstractNavigationController.h"
#import "AllMoviesViewController.h"
#import "MovieDetailsViewController.h"
#import "TicketsViewController.h"
#import "Movie.h"
#import "BoxOfficeModel.h"
#import "Theater.h"

@implementation MoviesNavigationController

@synthesize allMoviesViewController;
@synthesize movieDetailsViewController;
@synthesize tabBarController;

- (void) dealloc {
    self.allMoviesViewController = nil;
    self.movieDetailsViewController = nil;
    self.tabBarController = nil;

    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.allMoviesViewController = [[[AllMoviesViewController alloc] initWithNavigationController:self] autorelease];

        [self pushViewController:allMoviesViewController animated:NO];

        self.title = NSLocalizedString(@"Movies", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"Featured.png"];
    }

    return self;
}

- (void) navigateToLastViewedPage {
    Movie* currentMovie = [self.model currentlySelectedMovie];
    if (currentMovie != nil) {
        [self pushMovieDetails:currentMovie animated:NO];

        Theater* currentTheater = [self.model currentlySelectedTheater];
        if (currentTheater != nil) {
            [self pushTicketsView:currentMovie
                          theater:currentTheater
                         animated:NO];
        }

        if ([self.model currentlyShowingReviews]) {
            [self pushReviewsView:[self.model reviewsForMovie:currentMovie]
                         animated:NO];
        }
    }
}

- (void) refresh {
    [super refresh];
    [self.allMoviesViewController refresh];
    [self.movieDetailsViewController refresh];
}

- (void) pushMovieDetails:(Movie*) movie
                 animated:(BOOL) animated {
    [self popToRootViewControllerAnimated:NO];

    self.movieDetailsViewController = [[[MovieDetailsViewController alloc] initWithNavigationController:self movie:movie] autorelease];

    [self pushViewController:movieDetailsViewController animated:animated];
}

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                animated:(BOOL) animated {
    [self pushTicketsView:movie
                         theater:theater
                           title:theater.name
                        animated:animated];
}

- (void) pushReviewsView:(NSArray*) reviews animated:(BOOL) animated {
    ReviewsViewController* controller = [[[ReviewsViewController alloc] initWithNavigationController:self
                                                                                             reviews:reviews] autorelease];
    [self pushViewController:controller animated:animated];
}

@end
