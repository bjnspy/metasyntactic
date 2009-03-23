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

#import "SearchDisplayController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "ApplicationTabBarController.h"
#import "DVDCell.h"
#import "Model.h"
#import "MovieTitleCell.h"
#import "LocalSearchEngine.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"

@interface SearchDisplayController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) AbstractSearchEngine* searchEngineData;
@property (retain) SearchResult* searchResult;
@end

@implementation SearchDisplayController

@synthesize navigationController;
@synthesize searchEngineData;
@synthesize searchResult;

- (void) dealloc {
    self.navigationController = nil;
    self.searchEngineData = nil;
    self.searchResult = nil;

    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
    return navigationController.controller;
}


- (id)initNavigationController:(AbstractNavigationController*) navigationController_
                     searchBar:(UISearchBar *)searchBar_
            contentsController:(UIViewController *)viewController_ {
    if (self = [super initWithSearchBar:searchBar_ contentsController:viewController_]) {
        self.navigationController = navigationController_;
        
        self.delegate = self;
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;

        self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.searchBar.showsScopeBar = YES;
        self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Movies", nil), NSLocalizedString(@"Theaters", nil), NSLocalizedString(@"Upcoming", nil), NSLocalizedString(@"DVD", nil), nil];
        self.searchBar.selectedScopeButtonIndex = self.model.searchSelectedScopeButtonIndex;
    }

    return self;
}


- (AbstractSearchEngine*) createSearchEngine {
    return [LocalSearchEngine engineWithModel:navigationController.model
                                delegate:self];
}


- (AbstractSearchEngine*) searchEngine {
    if (searchEngineData == nil) {
        self.searchEngineData = [self createSearchEngine];
    }
    
    return searchEngineData;
}


- (BOOL) shouldShowMovies {
    return self.searchBar.selectedScopeButtonIndex == 0;
}


- (BOOL) shouldShowTheaters {
    return self.searchBar.selectedScopeButtonIndex == 1;
}


- (BOOL) shouldShowUpcoming {
    return self.searchBar.selectedScopeButtonIndex == 2;
}


- (BOOL) shouldShowDVDBluray {
    return self.searchBar.selectedScopeButtonIndex == 3;
}


- (BOOL) noResults {
    return
    searchResult != nil &&
    (searchResult.movies.count == 0 || ![self shouldShowMovies]) &&
    (searchResult.theaters.count == 0 || ![self shouldShowTheaters]) &&
    (searchResult.upcomingMovies.count == 0 || ![self shouldShowUpcoming]) &&
    (searchResult.dvds.count == 0 || ![self shouldShowDVDBluray]) &&
    (searchResult.bluray.count == 0 || ![self shouldShowDVDBluray]);
}


- (BOOL) searching {
    NSString* searchText = self.searchBar.text;
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

    if (section == 0 && [self shouldShowMovies]) {
        return searchResult.movies.count;
    } else if (section == 1 && [self shouldShowTheaters]) {
        return searchResult.theaters.count;
    } else if (section == 2 && [self shouldShowUpcoming]) {
        return searchResult.upcomingMovies.count;
    } else if (section == 3 && [self shouldShowDVDBluray]) {
        return searchResult.dvds.count;
    } else if (section == 4 && [self shouldShowDVDBluray]) {
        return searchResult.bluray.count;
    } else {
        return 0;
    }
}


- (BOOL) sortingByTitle {
    return YES;
}


- (UITableViewCell*) movieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.movies objectAtIndex:row];

    static NSString* reuseIdentifier = @"MovieTitleCellReuseIdentifier";
    MovieTitleCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[MovieTitleCell alloc] initWithReuseIdentifier:reuseIdentifier
                                                          model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) theaterCellForRow:(NSInteger) row {
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    static NSString* reuseIdentifier = @"TheaterNameCellReuseIdentifier";

    TheaterNameCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[TheaterNameCell alloc] initWithReuseIdentifier:reuseIdentifier
                                                           model:self.model] autorelease];
    }

    [cell setTheater:theater];
    return cell;
}


- (UITableViewCell*) upcomingMovieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    static NSString* reuseIdentifier = @"UpcomingMovieCellReuseIdentifier";

    UpcomingMovieCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UpcomingMovieCell alloc] initWithReuseIdentifier:reuseIdentifier
                                                   model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) dvdCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.dvds objectAtIndex:row];

    static NSString* reuseIdentifier = @"DvdCellReuseIdentifier";

    DVDCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) blurayCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.bluray objectAtIndex:row];

    static NSString* reuseIdentifier = @"BlurayCellReuseIdentifier";

    DVDCell* cell = (id)[self.searchResultsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithReuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
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


- (ApplicationTabBarController*) applicationTabBarController {
    return navigationController.tabBarController;
}


- (void) didSelectMovieRow:(NSInteger) row {
    [self.applicationTabBarController switchToMovies];
    Movie* movie = [searchResult.movies objectAtIndex:row];

    [self.applicationTabBarController.selectedNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectTheaterRow:(NSInteger) row {
    [self.applicationTabBarController switchToTheaters];
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    [self.applicationTabBarController.selectedNavigationController pushTheaterDetails:theater animated:YES];
}


- (void) didSelectUpcomingMovieRow:(NSInteger) row {
    [self.applicationTabBarController switchToUpcoming];
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    [self.applicationTabBarController.selectedNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectDvdRow:(NSInteger) row {
    [self.applicationTabBarController switchToDVD];
    Movie* movie = [searchResult.dvds objectAtIndex:row];

    [self.applicationTabBarController.selectedNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectBlurayRow:(NSInteger) row {
    [self.applicationTabBarController switchToDVD];
    Movie* movie = [searchResult.bluray objectAtIndex:row];

    [self.applicationTabBarController.selectedNavigationController pushMovieDetails:movie animated:YES];
}


- (void)            tableView:(UITableView*) tableView_
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    [self.searchResultsTableView deselectRowAtIndexPath:indexPath animated:YES];

    [self setActive:NO animated:YES];

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
    [self.searchResultsTableView reloadData];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchText {
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (searchText.length == 0) {
        [self.searchEngine invalidateExistingRequests];
        self.searchResult = nil;
        [self.searchResultsTableView reloadData];
        return YES;
    } else {
        [self.searchEngine submitRequest:searchText];
        return NO;
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

    if ([self noResults]) {
        return NSLocalizedString(@"No information found", nil);
    }

    if (section == 0 && [self shouldShowMovies]) {
        if (searchResult.movies.count != 0) {
            return NSLocalizedString(@"Movies", nil);
        }
    } else if (section == 1 && [self shouldShowTheaters]) {
        if (searchResult.theaters.count != 0) {
            return NSLocalizedString(@"Theaters", nil);
        }
    } else if (section == 2 && [self shouldShowUpcoming]) {
        if (searchResult.upcomingMovies.count != 0) {
            return NSLocalizedString(@"Upcoming", nil);
        }
    } else if (section == 3 && [self shouldShowDVDBluray]) {
        if (searchResult.dvds.count != 0) {
            return NSLocalizedString(@"DVD", nil);
        }
    } else if (section == 4 && [self shouldShowDVDBluray]) {
        if (searchResult.bluray.count != 0) {
            return NSLocalizedString(@"Blu-ray", nil);
        }
    }

    return nil;
}


- (void) searchBar:(UISearchBar*) searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    self.model.searchSelectedScopeButtonIndex = selectedScope;
    [self.searchResultsTableView reloadData];
}

@end