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

- (NSArray*) movies {
  NSMutableArray* result = [NSMutableArray array];

  if ([Model model].dvdMoviesShowDVDs) {
    [result addObjectsFromArray:[[DVDCache cache] movies]];
  }

  if ([Model model].dvdMoviesShowBluray) {
    [result addObjectsFromArray:[[BlurayCache cache] movies]];
  }

  return result;
}


- (BOOL) sortingByTitle {
  return [Model model].dvdMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
  return [Model model].dvdMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
  return NO;
}


- (BOOL) sortingByFavorite {
  return [Model model].dvdMoviesSortingByFavorite;
}


- (NSInteger(*)(id,id,void*)) sortByReleaseDateFunction {
  return compareMoviesByReleaseDateAscending;
}


- (void) onSortOrderChanged:(id) sender {
  scrollToCurrentDateOnRefresh = YES;
  [Model model].dvdMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
  [self majorRefresh];
}


- (void) setupTitle {
  if ([Model model].dvdMoviesShowOnlyBluray) {
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
  control.selectedSegmentIndex = [Model model].dvdMoviesSelectedSegmentIndex;

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
