// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

@interface AbstractNavigationController : UINavigationController {
    ApplicationTabBarController* tabBarController;
}

@property (assign) ApplicationTabBarController* tabBarController;

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;

- (void) refresh;

- (BoxOfficeModel*) model;
- (BoxOfficeController*) controller;

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated;

- (void) pushTheaterDetails:(Theater*) theater animated:(BOOL) animated;
- (void) pushMovieDetails:(Movie*) movie animated:(BOOL) animated;
- (void) pushReviewsView:(Movie*) movie animated:(BOOL) animated;

- (void) navigateToLastViewedPage;

@end