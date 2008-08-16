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

@interface ApplicationTabBarController : UITabBarController<UITabBarControllerDelegate> {
    BoxOfficeAppDelegate* appDelegate;
    MoviesNavigationController* moviesNavigationController;
    TheatersNavigationController* theatersNavigationController;
    NumbersNavigationController* numbersNavigationController;
    SettingsNavigationController* settingsNavigationController;
}

@property (assign) BoxOfficeAppDelegate* appDelegate;
@property (retain) MoviesNavigationController* moviesNavigationController;
@property (retain) TheatersNavigationController* theatersNavigationController;
@property (retain) NumbersNavigationController* numbersNavigationController;
@property (retain) SettingsNavigationController* settingsNavigationController;

+ (ApplicationTabBarController*) controllerWithAppDelegate:(BoxOfficeAppDelegate*) appDelegate;

- (BoxOfficeModel*) model;
- (BoxOfficeController*) controller;

- (void) refresh;

- (void) showTheaterDetails:(Theater*) theater;
- (void) showMovieDetails:(Movie*) movie;

- (void) popNavigationControllersToRoot;

@end
