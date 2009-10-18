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

#import "DVDViewController.h"

#import "BlurayCache.h"
#import "BoxOfficeStockImages.h"
#import "DVDCache.h"
#import "DVDCell.h"
#import "Model.h"

@interface DVDViewController()
@end


@implementation DVDViewController

- (void) dealloc {
  [super dealloc];
}


- (Model*) model {
  return [Model model];
}


- (NSArray*) movies {
  NSMutableArray* result = [NSMutableArray array];

  if (self.model.dvdMoviesShowDVDs) {
    [result addObjectsFromArray:self.model.dvdCache.movies];
  }

  if (self.model.dvdMoviesShowBluray) {
    [result addObjectsFromArray:self.model.blurayCache.movies];
  }

  return result;
}


- (BOOL) sortingByTitle {
  return self.model.dvdMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
  return self.model.dvdMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
  return NO;
}


- (BOOL) sortingByFavorite {
  return self.model.dvdMoviesSortingByFavorite;
}


- (int(*)(id,id,void*)) sortByReleaseDateFunction {
  return compareMoviesByReleaseDateAscending;
}


- (void) onSortOrderChanged:(id) sender {
  scrollToCurrentDateOnRefresh = YES;
  self.model.dvdMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
  [self majorRefresh];
}


- (void) setupTitle {
  if (self.model.dvdMoviesShowOnlyBluray) {
    self.title = LocalizedString(@"Blu-ray", nil);
  } else {
    self.title = LocalizedString(@"DVD", nil);
  }
}


- (id) init {
  if ((self = [super init])) {
    [self setupTitle];
  }

  return self;
}


- (UISegmentedControl*) createSegmentedControl {
  UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   LocalizedString(@"Release", nil),
                                   LocalizedString(@"Title", nil),
                                   [BoxOfficeStockImages whiteStar],
                                   nil]] autorelease];

  control.segmentedControlStyle = UISegmentedControlStyleBar;
  control.selectedSegmentIndex = self.model.dvdMoviesSelectedSegmentIndex;

  [control addTarget:self
              action:@selector(onSortOrderChanged:)
    forControlEvents:UIControlEventValueChanged];

  CGRect rect = control.frame;
  rect.size.width = 310;
  control.frame = rect;

  return control;
}


- (void) loadView {
  [super loadView];

  scrollToCurrentDateOnRefresh = YES;

  self.tableView.rowHeight = 100;
}


- (UITableViewCell*) createCell:(Movie*) movie {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  DVDCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
  }

  [cell setMovie:movie owner:self];
  return cell;
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  [self setupTitle];

  self.tableView.rowHeight = 100;
}

@end
