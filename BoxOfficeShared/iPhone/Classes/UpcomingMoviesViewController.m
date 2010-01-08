// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "UpcomingMoviesViewController.h"

#import "BoxOfficeStockImages.h"
#import "Model.h"
#import "UpcomingCache.h"
#import "UpcomingMovieCell.h"

@interface UpcomingMoviesViewController()
@end


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
