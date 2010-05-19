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

#import "UpcomingMoviesViewController.h"

#import "BoxOfficeStockImages.h"
#import "Model.h"
#import "UpcomingCache.h"
#import "UpcomingMovieCell.h"

@implementation UpcomingMoviesViewController

- (NSArray*) movies {
  return [[UpcomingCache cache] movies];
}


- (BOOL) sortingByTitle {
  return [Model model].upcomingMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
  return [Model model].upcomingMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
  return NO;
}


- (BOOL) sortingByFavorite {
  return [Model model].upcomingMoviesSortingByFavorite;
}


- (NSInteger(*)(id,id,void*)) sortByReleaseDateFunction {
  return compareMoviesByReleaseDateAscending;
}


- (UISegmentedControl*) createSegmentedControl {
  UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   LocalizedString(@"Release", nil),
                                   LocalizedString(@"Title", nil),
                                   [BoxOfficeStockImages whiteStar],
                                   nil]] autorelease];

  control.segmentedControlStyle = UISegmentedControlStyleBar;
  control.selectedSegmentIndex = [Model model].upcomingMoviesSelectedSegmentIndex;

  [control addTarget:self
              action:@selector(onSortOrderChanged:)
    forControlEvents:UIControlEventValueChanged];

  CGRect rect = control.frame;
  rect.size.width = 310;
  control.frame = rect;

  return control;
}


- (void) onSortOrderChanged:(id) sender {
  scrollToCurrentDateOnRefresh = YES;
  [Model model].upcomingMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
  [self majorRefresh];
}


- (id) init {
  if ((self = [super init])) {
    self.title = LocalizedString(@"Upcoming", nil);
  }

  return self;
}


- (void) loadView {
  [super loadView];

  scrollToCurrentDateOnRefresh = YES;

  self.title = LocalizedString(@"Upcoming", nil);
  self.tableView.rowHeight = 100;
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
}


- (UITableViewCell*) createCell:(Movie*) movie {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UpcomingMovieCell alloc] initWithReuseIdentifier:reuseIdentifier
                                           tableViewController:self] autorelease];
  }

  [cell setMovie:movie owner:self];
  return cell;
}


- (void) onBeforeReloadTableViewData {
  self.tableView.rowHeight = 100;
  [super onBeforeReloadTableViewData];
}

@end
