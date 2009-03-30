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

#ifndef IPHONE_OS_VERSION_3
#import "SearchViewController.h"

#import "AbstractImageCell.h"
#import "AbstractNavigationController.h"
#import "ApplicationTabBarController.h"
#import "Controller.h"
#import "DVDCell.h"
#import "LocalSearchEngine.h"
#import "Model.h"
#import "MovieTitleCell.h"
#import "AppDelegate.h"
#import "AbstractSearchEngine.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"

@interface SearchViewController()
@property (retain) AbstractSearchEngine* searchEngine;
@property (retain) SearchResult* searchResult;
@property (retain) UISearchBar* searchBar;
@end


@implementation SearchViewController

@synthesize searchEngine;
@synthesize searchResult;
@synthesize searchBar;

- (void) dealloc {
    self.searchEngine = nil;
    self.searchResult = nil;
    self.searchBar = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.searchEngine = [LocalSearchEngine engineWithDelegate:self];
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (Controller*) controller {
    return [Controller controller];
}


- (void) loadView {
    [super loadView];

    self.searchBar = [[[UISearchBar alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    searchBar.delegate = self;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBar sizeToFit];

    self.navigationItem.titleView = searchBar;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    if (searchBar.text.length == 0) {
        [searchBar becomeFirstResponder];
    }
}


- (void) majorRefreshWorker {
    [self reloadTableViewData];
}


- (void) minorRefreshWorker {
    for (id cell in self.tableView.visibleCells) {
        if ([cell respondsToSelector:@selector(loadImage)]) {
            [cell loadImage];
        }
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return NO;
}


- (BOOL) noResults {
    return
    searchResult != nil &&
    searchResult.movies.count == 0 &&
    searchResult.theaters.count == 0 &&
    searchResult.upcomingMovies.count == 0 &&
    searchResult.dvds.count == 0 &&
    searchResult.bluray.count == 0;
}


- (BOOL) searching {
    NSString* searchText = searchBar.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return searchText.length > 0 && ![searchText isEqual:searchResult.value];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if (searchResult == nil) {
        return 1;
    }

    if ([self noResults]) {
        return 1;
    }

    return 5;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (searchResult == nil) {
        return 0;
    }

    if ([self noResults]) {
        return 0;
    }

    if (section == 0) {
        return searchResult.movies.count;
    } else if (section == 1) {
        return searchResult.theaters.count;
    } else if (section == 2) {
        return searchResult.upcomingMovies.count;
    } else if (section == 3) {
        return searchResult.dvds.count;
    } else {
        return searchResult.bluray.count;
    }
}


- (BOOL) sortingByTitle {
    return YES;
}


- (UITableViewCell*) movieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.movies objectAtIndex:row];

    MovieTitleCell* cell = [MovieTitleCell movieTitleCellForMovie:movie inTableView:self.tableView];
    return cell;
}


- (UITableViewCell*) theaterCellForRow:(NSInteger) row {
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    static NSString* reuseIdentifier = @"TheaterNameCellReuseIdentifier";

    TheaterNameCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[TheaterNameCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setTheater:theater];
    return cell;
}


- (UITableViewCell*) upcomingMovieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    static NSString* reuseIdentifier = @"UpcomingMovieCellReuseIdentifier";

    UpcomingMovieCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UpcomingMovieCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) dvdCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.dvds objectAtIndex:row];

    static NSString* reuseIdentifier = @"DvdCellReuseIdentifier";

    DVDCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) blurayCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.bluray objectAtIndex:row];

    static NSString* reuseIdentifier = @"BlurayCellReuseIdentifier";

    DVDCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) noResultsCell {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.text = [NSString stringWithFormat:NSLocalizedString(@"No results found for '%@'", nil), searchResult.value];
    return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if ([self noResults]) {
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


- (void) reportResult:(SearchResult*) result {
    NSAssert([NSThread isMainThread], nil);
    self.searchResult = result;
    [self reloadTableViewData];
}


- (void) searchBar:(UISearchBar*) searchBar
     textDidChange:(NSString*) searchText {
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (searchText.length == 0) {
        [self.searchEngine invalidateExistingRequests];
        self.searchResult = nil;
    } else {
        [self.searchEngine submitRequest:searchText];
    }

    [self reloadTableViewData];
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

    return self.tableView.rowHeight;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (searchResult == nil) {
        return nil;
    }

    if ([self noResults]) {
        return NSLocalizedString(@"No information found", nil);
    }

    if (section == 0) {
        if (searchResult.movies.count != 0) {
            return NSLocalizedString(@"Movies", nil);
        }
    } else if (section == 1) {
        if (searchResult.theaters.count != 0) {
            return NSLocalizedString(@"Theaters", nil);
        }
    } else if (section == 2) {
        if (searchResult.upcomingMovies.count != 0) {
            return NSLocalizedString(@"Upcoming", nil);
        }
    } else if (section == 3) {
        if (searchResult.dvds.count != 0) {
            return NSLocalizedString(@"DVD", nil);
        }
    } else if (section == 4) {
        if (searchResult.bluray.count != 0) {
            return NSLocalizedString(@"Blu-ray", nil);
        }
    }

    return nil;
}


- (void) searchBarSearchButtonClicked:(UISearchBar*) sender {
    [searchBar resignFirstResponder];
}

@end
#endif
