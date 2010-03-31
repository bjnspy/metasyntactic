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

#import "LocalSearchDisplayController.h"

#import "CommonNavigationController.h"
#import "DVDCell.h"
#import "LocalSearchEngine.h"
#import "Model.h"
#import "MovieTitleCell.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"

@implementation LocalSearchDisplayController

- (void) setupDefaultScopeButtonTitles {
  self.searchBar.scopeButtonTitles =
    [NSArray arrayWithObjects:
     LocalizedString(@"All", nil),
     LocalizedString(@"Movies", nil),
     LocalizedString(@"Theaters", nil), nil];
}


- (id) initWithSearchBar:(UISearchBar*) searchBar_
      contentsController:(UITableViewController*) viewController_ {
  if ((self = [super initWithSearchBar:searchBar_
                    contentsController:viewController_])) {
    self.searchBar.selectedScopeButtonIndex = [Model model].localSearchSelectedScopeButtonIndex;
  }

  return self;
}


- (AbstractSearchEngine*) createSearchEngine {
  return [LocalSearchEngine engineWithDelegate:self];
}


- (BOOL) shouldShowAll {
  return self.searchBar.selectedScopeButtonIndex == 0;
}


- (BOOL) shouldShowMovies {
  return self.searchBar.selectedScopeButtonIndex == 1;
}


- (BOOL) shouldShowTheaters {
  return self.searchBar.selectedScopeButtonIndex == 2;
}


- (SearchResult*) searchResult {
  return (id)abstractSearchResult;
}


- (BOOL) foundMatches {
  if ([self shouldShowTheaters]) {
    return self.searchResult.theaters.count > 0;
  }

  if ([self shouldShowMovies]) {
    return
    self.searchResult.movies.count > 0 ||
    self.searchResult.upcomingMovies.count > 0 ||
    self.searchResult.dvds.count > 0 ||
    self.searchResult.bluray.count > 0;
  }

  if ([self shouldShowAll]) {
    return
    self.searchResult.theaters.count > 0 ||
    self.searchResult.movies.count > 0 ||
    self.searchResult.upcomingMovies.count > 0 ||
    self.searchResult.dvds.count > 0 ||
    self.searchResult.bluray.count > 0;
  }

  return NO;
}


- (NSInteger) numberOfSectionsInTableViewWorker {
  return 5;
}


- (NSInteger) numberOfRowsInSectionWorker:(NSInteger) section {
  if (section == 0 && ([self shouldShowMovies] || [self shouldShowAll])) {
    return self.searchResult.movies.count;
  } else if (section == 1 && ([self shouldShowTheaters] || [self shouldShowAll])) {
    return self.searchResult.theaters.count;
  } else if (section == 2 && ([self shouldShowMovies] || [self shouldShowAll])) {
    return self.searchResult.upcomingMovies.count;
  } else if (section == 3 && ([self shouldShowMovies] || [self shouldShowAll])) {
    return self.searchResult.dvds.count;
  } else if (section == 4 && ([self shouldShowMovies] || [self shouldShowAll])) {
    return self.searchResult.bluray.count;
  }

  return 0;
}


- (UITableViewCell*) movieCellForRow:(NSInteger) row {
  Movie* movie = [self.searchResult.movies objectAtIndex:row];

  return [MovieTitleCell movieTitleCellForMovie:movie inTableView:self.searchResultsTableView];
}


- (UITableViewCell*) theaterCellForRow:(NSInteger) row {
  Theater* theater = [self.searchResult.theaters objectAtIndex:row];

  static NSString* reuseIdentifier = @"TheaterNameCellReuseIdentifier";

  TheaterNameCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[TheaterNameCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
  }

  [cell setTheater:theater];
  return cell;
}


- (UITableViewCell*) upcomingMovieCellForRow:(NSInteger) row {
  Movie* movie = [self.searchResult.upcomingMovies objectAtIndex:row];

  static NSString* reuseIdentifier = @"UpcomingMovieCellReuseIdentifier";

  UpcomingMovieCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UpcomingMovieCell alloc] initWithReuseIdentifier:reuseIdentifier
                                           tableViewController:(id)self.searchContentsController] autorelease];
  }

  [cell setMovie:movie owner:self];
  return cell;
}


- (UITableViewCell*) dvdCellForRow:(NSInteger) row {
  Movie* movie = [self.searchResult.dvds objectAtIndex:row];

  static NSString* reuseIdentifier = @"DvdCellReuseIdentifier";

  DVDCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier
                                 tableViewController:(id)self.searchContentsController] autorelease];
  }

  [cell setMovie:movie owner:self];
  return cell;
}


- (UITableViewCell*) blurayCellForRow:(NSInteger) row {
  Movie* movie = [self.searchResult.bluray objectAtIndex:row];

  static NSString* reuseIdentifier = @"BlurayCellReuseIdentifier";

  DVDCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier
                                 tableViewController:(id)self.searchContentsController] autorelease];
  }

  [cell setMovie:movie owner:self];
  return cell;
}


- (UITableViewCell*) cellForRowAtIndexPathWorker:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    return [self movieCellForRow:indexPath.row];
  } else if (indexPath.section == 1) {
    return [self theaterCellForRow:indexPath.row];
  } else if (indexPath.section == 2) {
    return [self upcomingMovieCellForRow:indexPath.row];
  } else if (indexPath.section == 3) {
    return [self dvdCellForRow:indexPath.row];
  } else {
    return [self blurayCellForRow:indexPath.row];
  }
}


- (CommonNavigationController*) commonNavigationController {
  return (id)self.searchContentsController.navigationController;
}


- (void) didSelectMovieRow:(NSInteger) row {
  Movie* movie = [self.searchResult.movies objectAtIndex:row];

  [self.commonNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectTheaterRow:(NSInteger) row {
  Theater* theater = [self.searchResult.theaters objectAtIndex:row];

  [self.commonNavigationController pushTheaterDetails:theater animated:YES];
}


- (void) didSelectUpcomingMovieRow:(NSInteger) row {
  Movie* movie = [self.searchResult.upcomingMovies objectAtIndex:row];

  [self.commonNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectDvdRow:(NSInteger) row {
  Movie* movie = [self.searchResult.dvds objectAtIndex:row];

  [self.commonNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectBlurayRow:(NSInteger) row {
  Movie* movie = [self.searchResult.bluray objectAtIndex:row];

  [self.commonNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectRowAtIndexPathWorker:(NSIndexPath*) indexPath {
  if ([Portability userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    [self setActive:NO animated:YES];
  }
  
  if (indexPath.section == 0) {
    [self didSelectMovieRow:indexPath.row];
  } else if (indexPath.section == 1) {
    [self didSelectTheaterRow:indexPath.row];
  } else if (indexPath.section == 2) {
    [self didSelectUpcomingMovieRow:indexPath.row];
  } else if (indexPath.section == 3) {
    [self didSelectDvdRow:indexPath.row];
  } else if (indexPath.section == 4) {
    [self didSelectBlurayRow:indexPath.row];
  }
}


- (CGFloat) heightForRowAtIndexPathWorker:(NSIndexPath*) indexPath {
  if (indexPath.section == 2 ||
      indexPath.section == 3 ||
      indexPath.section == 4) {
    return 100;
  }

  return self.searchResultsTableView.rowHeight;
}


- (NSString*) titleForHeaderInSectionWorker:(NSInteger) section {
  if (section == 0 && ([self shouldShowMovies] || [self shouldShowAll])) {
    if (self.searchResult.movies.count > 0) {
      return LocalizedString(@"Movies", nil);
    }
  } else if (section == 1 && ([self shouldShowTheaters] || [self shouldShowAll])) {
    if (self.searchResult.theaters.count > 0) {
      return LocalizedString(@"Theaters", nil);
    }
  } else if (section == 2 && ([self shouldShowMovies] || [self shouldShowAll])) {
    if (self.searchResult.upcomingMovies.count > 0) {
      return LocalizedString(@"Upcoming", nil);
    }
  } else if (section == 3 && ([self shouldShowMovies] || [self shouldShowAll])) {
    if (self.searchResult.dvds.count > 0) {
      return LocalizedString(@"DVD", nil);
    }
  } else if (section == 4 && ([self shouldShowMovies] || [self shouldShowAll])) {
    if (self.searchResult.bluray.count > 0) {
      return LocalizedString(@"Blu-ray", nil);
    }
  }

  return nil;
}


- (void) searchBar:(UISearchBar*) searchBar selectedScopeButtonIndexDidChange:(NSInteger) selectedScope {
  [Model model].localSearchSelectedScopeButtonIndex = selectedScope;
  [self reloadTableViewData];
}


- (void) initializeData:(SearchResult*) result {
  NSInteger theaters = result.theaters.count;
  NSInteger movies = result.movies.count + result.upcomingMovies.count + result.dvds.count + result.bluray.count;

  self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                                        [NSString stringWithFormat:LocalizedString(@"All (%d)", nil), movies + theaters],
                                        [NSString stringWithFormat:LocalizedString(@"Movies (%d)", @"Used to display the count of all movie search results.  i.e.: Movies (15)"), movies],
                                        [NSString stringWithFormat:LocalizedString(@"Theaters (%d)", @"Used to display the count of all theater search results.  i.e.: Theaters (15)"), theaters],
                                         nil];
}


- (void) reportResult:(SearchResult*) result {
  [self initializeData:result];
  [super reportResult:result];
}

@end
