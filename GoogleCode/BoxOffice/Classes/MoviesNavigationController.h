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

#import "AbstractNavigationController.h"

@interface MoviesNavigationController : AbstractNavigationController {
    AllMoviesViewController* allMoviesViewController;
    MovieDetailsViewController* movieDetailsViewController;
}

@property (retain) AllMoviesViewController* allMoviesViewController;
@property (retain) MovieDetailsViewController* movieDetailsViewController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;

- (void) refresh;

- (void) pushMovieDetails:(Movie*) movie animated:(BOOL) animated;
- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                animated:(BOOL) animated;
- (void) pushReviewsView:(NSArray*) reviews animated:(BOOL) animated;

- (void) navigateToLastViewedPage;

@end
