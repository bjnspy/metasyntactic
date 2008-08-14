// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE..

#import "MoviesNavigationController.h"

#import "AllMoviesViewController.h"
#import "BoxOfficeModel.h"
#import "MovieDetailsViewController.h"
#import "ReviewsViewController.h"
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
