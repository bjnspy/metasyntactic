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

#import "AllMoviesViewController.h"

#import "BoxOfficeStockImages.h"
#import "Model.h"
#import "MovieTitleCell.h"

@implementation AllMoviesViewController

- (NSArray*) movies {
  return [Model model].movies;
}


- (BOOL) sortingByTitle {
  return [Model model].allMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
  return [Model model].allMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
  return [Model model].allMoviesSortingByScore;
}


- (BOOL) sortingByFavorite {
  return [Model model].allMoviesSortingByFavorite;
}


- (NSInteger(*)(id,id,void*)) sortByReleaseDateFunction {
  return compareMoviesByReleaseDateDescending;
}


- (UISegmentedControl*) createSegmentedControl {
  UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   LocalizedString(@"Release", @"Must be very short. 1 word max. This is on a button that allows the user to sort movies based on how recently they were released."),
                                   LocalizedString(@"Title", @"Must be very short. 1 word max. This is on a button that allows the user to sort movies based on their title."),
                                   LocalizedString(@"Score", @"Must be very short. 1 word max. This is on a button that allows users to sort movies by how well they were rated."),
                                   [BoxOfficeStockImages whiteStar],
                                   nil]] autorelease];

  control.segmentedControlStyle = UISegmentedControlStyleBar;
  control.selectedSegmentIndex = [Model model].allMoviesSelectedSegmentIndex;

  [control addTarget:self
              action:@selector(onSortOrderChanged:)
    forControlEvents:UIControlEventValueChanged];

  CGRect rect = control.frame;
  rect.size.width = 310;
  control.frame = rect;

  return control;
}


- (void) onSortOrderChanged:(id) sender {
  [Model model].allMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
  [self majorRefresh];
}


- (id) init {
  if ((self = [super init])) {
    self.title = LocalizedString(@"Movies", nil);
  }

  return self;
}


- (void) loadView {
  [super loadView];
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
}


- (UITableViewCell*) createCell:(Movie*) movie {
  return [MovieTitleCell movieTitleCellForMovie:movie inTableView:self.tableView];
}

@end
