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

#ifdef IPHONE_OS_VERSION_3
#import "LocalSearchDisplayController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "ApplicationTabBarController.h"
#import "DVDCell.h"
#import "LocalSearchEngine.h"
#import "Model.h"
#import "MovieTitleCell.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"


@implementation LocalSearchDisplayController

- (Model*) model {
    return [Model model];
}


- (void) setupDefaultScopeButtonTitles {
    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"All", nil), NSLocalizedString(@"Movies", nil), NSLocalizedString(@"Theaters", nil), nil];
}


- (id) initWithSearchBar:(UISearchBar*) searchBar__
            contentsController:(UIViewController*) viewController__ {
    if (self = [super initWithSearchBar:searchBar__
                            contentsController:viewController__]) {
        self.searchBar.selectedScopeButtonIndex = self.model.localSearchSelectedScopeButtonIndex;
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


- (BOOL) hasResults {
    if (searchResult == nil) {
        return NO;
    }

    if (searchResult.theaters.count > 0) {
        if ([self shouldShowTheaters] || [self shouldShowAll]) {
            return YES;
        }
    }

    if (searchResult.movies.count > 0 ||
        searchResult.upcomingMovies.count > 0 ||
        searchResult.dvds.count > 0 ||
        searchResult.bluray.count > 0) {
        if ([self shouldShowMovies] || [self shouldShowAll]) {
            return YES;
        }
    }

    return NO;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if (searchResult == nil) {
        return 1;
    }

    if (![self hasResults]) {
        return 1;
    }

    return 5;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (searchResult == nil) {
        return 0;
    }

    if (![self hasResults]) {
        return 0;
    }

    if (section == 0 && ([self shouldShowMovies] || [self shouldShowAll])) {
        return searchResult.movies.count;
    } else if (section == 1 && ([self shouldShowTheaters] || [self shouldShowAll])) {
        return searchResult.theaters.count;
    } else if (section == 2 && ([self shouldShowMovies] || [self shouldShowAll])) {
        return searchResult.upcomingMovies.count;
    } else if (section == 3 && ([self shouldShowMovies] || [self shouldShowAll])) {
        return searchResult.dvds.count;
    } else if (section == 4 && ([self shouldShowMovies] || [self shouldShowAll])) {
        return searchResult.bluray.count;
    } else {
        return 0;
    }
}


- (UITableViewCell*) movieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.movies objectAtIndex:row];

    return [MovieTitleCell movieTitleCellForMovie:movie inTableView:self.searchResultsTableView];
}


- (UITableViewCell*) theaterCellForRow:(NSInteger) row {
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    static NSString* reuseIdentifier = @"TheaterNameCellReuseIdentifier";

    TheaterNameCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[TheaterNameCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setTheater:theater];
    return cell;
}


- (UITableViewCell*) upcomingMovieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    static NSString* reuseIdentifier = @"UpcomingMovieCellReuseIdentifier";

    UpcomingMovieCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UpcomingMovieCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) dvdCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.dvds objectAtIndex:row];

    static NSString* reuseIdentifier = @"DvdCellReuseIdentifier";

    DVDCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) blurayCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.bluray objectAtIndex:row];

    static NSString* reuseIdentifier = @"BlurayCellReuseIdentifier";

    DVDCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) noResultsCell {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.text = [NSString stringWithFormat:NSLocalizedString(@"No results found for '%@'", nil), searchResult.value];
    return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (![self hasResults]) {
        return [self noResultsCell];
    }

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


- (void) didSelectMovieRow:(NSInteger) row {
    Movie* movie = [searchResult.movies objectAtIndex:row];

    [self.abstractNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectTheaterRow:(NSInteger) row {
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    [self.abstractNavigationController pushTheaterDetails:theater animated:YES];
}


- (void) didSelectUpcomingMovieRow:(NSInteger) row {
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    [self.abstractNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectDvdRow:(NSInteger) row {
    Movie* movie = [searchResult.dvds objectAtIndex:row];

    [self.abstractNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectBlurayRow:(NSInteger) row {
    Movie* movie = [searchResult.bluray objectAtIndex:row];

    [self.abstractNavigationController pushMovieDetails:movie animated:YES];
}


- (void)            tableView:(UITableView*) tableView_
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self didSelectMovieRow:indexPath.row];
    } else if (indexPath.section == 1) {
        return [self didSelectTheaterRow:indexPath.row];
    } else if (indexPath.section == 2) {
        return [self didSelectUpcomingMovieRow:indexPath.row];
    } else if (indexPath.section == 3) {
        return [self didSelectDvdRow:indexPath.row];
    } else if (indexPath.section == 4) {
        return [self didSelectBlurayRow:indexPath.row];
    }
}


- (CGFloat)         tableView:(UITableView*) tableView_
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (searchResult != nil) {
        if (indexPath.section == 2 ||
            indexPath.section == 3 ||
            indexPath.section == 4) {
            return 100;
        }
    }

    return self.searchResultsTableView.rowHeight;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (searchResult == nil) {
        return nil;
    }

    if (![self hasResults]) {
        return NSLocalizedString(@"No information found", nil);
    }

    if (section == 0 && ([self shouldShowMovies] || [self shouldShowAll])) {
        if (searchResult.movies.count != 0) {
            return NSLocalizedString(@"Movies", nil);
        }
    } else if (section == 1 && ([self shouldShowTheaters] || [self shouldShowAll])) {
        if (searchResult.theaters.count != 0) {
            return NSLocalizedString(@"Theaters", nil);
        }
    } else if (section == 2 && ([self shouldShowMovies] || [self shouldShowAll])) {
        if (searchResult.upcomingMovies.count != 0) {
            return NSLocalizedString(@"Upcoming", nil);
        }
    } else if (section == 3 && ([self shouldShowMovies] || [self shouldShowAll])) {
        if (searchResult.dvds.count != 0) {
            return NSLocalizedString(@"DVD", nil);
        }
    } else if (section == 4 && ([self shouldShowMovies] || [self shouldShowAll])) {
        if (searchResult.bluray.count != 0) {
            return NSLocalizedString(@"Blu-ray", nil);
        }
    }

    return nil;
}


- (void) searchBar:(UISearchBar*) searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    self.model.localSearchSelectedScopeButtonIndex = selectedScope;
    [self.searchResultsTableView reloadData];
}


- (void) initializeData:(SearchResult*) result {
    NSInteger theaters = result.theaters.count;
    NSInteger movies = result.movies.count + result.upcomingMovies.count + result.dvds.count + result.bluray.count;

    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                                        [NSString stringWithFormat:NSLocalizedString(@"All (%d)", nil), movies + theaters],
                                        [NSString stringWithFormat:NSLocalizedString(@"Movies (%d)", nil), movies],
                                        [NSString stringWithFormat:NSLocalizedString(@"Theaters (%d)", nil), theaters],
                                        nil];
}


- (void) reportResult:(SearchResult*) result {
    [self initializeData:result];
    [super reportResult:result];
}

@end
#endif