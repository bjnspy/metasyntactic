// Copyright 2010 Cyrus Najmabadi
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

@interface CommonNavigationController : AbstractNavigationController {
}

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated;

- (void) pushTheaterDetails:(Theater*) theater animated:(BOOL) animated;
- (void) pushPersonDetails:(Person*) person animated:(BOOL) animated;
- (void) pushMovieDetails:(Movie*) movie animated:(BOOL) animated;
- (void) pushReviews:(Movie*) movie animated:(BOOL) animated;

- (void) pushInfoControllerAnimated:(BOOL) animated;

- (void) navigateToLastViewedPage;

- (void) showPostersView:(Movie*) movie posterCount:(NSInteger) posterCount;

- (void) onTabBarItemSelected;

// @protected
- (Movie*) movieForTitle:(NSString*) canonicalTitle;

@end
