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

#import "DVDViewController.h"

#import "BlurayCache.h"
#import "BoxOfficeStockImages.h"
#import "DVDCache.h"
#import "DVDCell.h"
#import "Model.h"

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
    cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier
                                 tableViewController:self] autorelease];
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
