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

#import "BoxOfficeModel.h"
#import "MultiDictionary.h"
#import "PosterView.h"

@class MoviesNavigationController;

@interface AllMoviesViewController : UITableViewController {
    MoviesNavigationController* navigationController;
    UISegmentedControl* segmentedControl;

    NSArray* sortedMovies;
    NSMutableArray* sectionTitles;
    MultiDictionary* sectionTitleToContentsMap;

    NSArray* alphabeticSectionTitles;

    PosterView* posterView;
}

@property (assign) MoviesNavigationController* navigationController;
@property (retain) NSArray* sortedMovies;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) NSMutableArray* sectionTitles;
@property (retain) MultiDictionary* sectionTitleToContentsMap;
@property (retain) NSArray* alphabeticSectionTitles;
@property (retain) PosterView* posterView;

- (id) initWithNavigationController:(MoviesNavigationController*) navigationController;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
