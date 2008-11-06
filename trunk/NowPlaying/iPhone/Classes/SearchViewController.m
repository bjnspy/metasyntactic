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

#import "SearchViewController.h"

#import "AbstractNavigationController.h"
#import "ApplicationTabBarController.h"
#import "DVDCell.h"
#import "MovieTitleCell.h"
#import "NowPlayingAppDelegate.h"
#import "SearchEngine.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"

@implementation SearchViewController

@synthesize navigationController;

@synthesize searchEngine;
@synthesize searchResult;

@synthesize searchBar;
@synthesize tableView;

- (void) dealloc {
    self.navigationController = nil;
    self.searchEngine = nil;
    self.searchResult = nil;

    self.searchBar = nil;
    self.tableView = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super init]) {
        self.navigationController = navigationController_;
        self.searchEngine = [SearchEngine engineWithModel:navigationController.model delegate:self];
    }

    return self;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (void) loadView {
    [super loadView];
    CGRect rect = self.view.frame;
    //rect.size.width -= ABS(rect.origin.x);
    //rect.size.height -= ABS(rect.origin.y);
    rect.origin.x = 0;
    rect.origin.y = 0;

    self.searchBar = [[[UISearchBar alloc] initWithFrame:rect] autorelease];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [searchBar sizeToFit];

    CGRect searchBarRect = searchBar.frame;
    CGRectDivide(rect, &searchBarRect, &rect, searchBarRect.size.height, CGRectMinYEdge);

    self.tableView = [[[UITableView alloc] initWithFrame:rect
                                                   style:UITableViewStylePlain] autorelease];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:searchBar];
    [self.view addSubview:tableView];
}


- (void) searchBarCancelButtonClicked:(UISearchBar*) searchBar_ {
    [searchBar resignFirstResponder];
    [navigationController hideSearchView];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


- (BOOL) noResults {
    return
    searchResult != nil &&
    searchResult.movies.count == 0 &&
    searchResult.theaters.count == 0 &&
    searchResult.upcomingMovies.count == 0 &&
    searchResult.dvds.count == 0;
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

    return 4;
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
    } else {
        return searchResult.dvds.count;
    }
}


- (BOOL) sortingByTitle {
    return YES;
}


- (UITableViewCell*) movieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.movies objectAtIndex:row];

    static NSString* reuseIdentifier = @"MovieTitleCellReuseIdentifier";
    MovieTitleCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                      reuseIdentifier:reuseIdentifier
                                                model:self.model
                                                style:UITableViewStylePlain] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) theaterCellForRow:(NSInteger) row {
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    static NSString* reuseIdentifier = @"TheaterNameCellReuseIdentifier";

    TheaterNameCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[TheaterNameCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                       reuseIdentifier:reuseIdentifier
                                                 model:self.model] autorelease];
    }

    [cell setTheater:theater];
    return cell;
}


- (UITableViewCell*) upcomingMovieCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    static NSString* reuseIdentifier = @"UpcomingMovieCellReuseIdentifier";

    UpcomingMovieCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UpcomingMovieCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                         reuseIdentifier:reuseIdentifier
                                                   model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) dvdCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.dvds objectAtIndex:row];

    static NSString* reuseIdentifier = @"DvdCellReuseIdentifier";

    UpcomingMovieCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                               reuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
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
    } else {
        return [self dvdCellForRow:indexPath.row];
    }
}


- (ApplicationTabBarController*) tabBarController {
    return navigationController.tabBarController;
}


- (void) didSelectMovieRow:(NSInteger) row {
    [self.tabBarController switchToMovies];
    Movie* movie = [searchResult.movies objectAtIndex:row];

    [self.tabBarController.selectedNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectTheaterRow:(NSInteger) row {
    [self.tabBarController switchToTheaters];
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    [self.tabBarController.selectedNavigationController pushTheaterDetails:theater animated:YES];
}


- (void) didSelectUpcomingMovieRow:(NSInteger) row {
    [self.tabBarController switchToUpcoming];
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    [self.tabBarController.selectedNavigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectDvdRow:(NSInteger) row {
    [self.tabBarController switchToDVD];
    Movie* movie = [searchResult.dvds objectAtIndex:row];

    [self.tabBarController.selectedNavigationController pushMovieDetails:movie animated:YES];
}


- (void)            tableView:(UITableView*) tableView_
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [navigationController hideSearchView];
    if (indexPath.section == 0) {
        return [self didSelectMovieRow:indexPath.row];
    } else if (indexPath.section == 1) {
        return [self didSelectTheaterRow:indexPath.row];
    } else if (indexPath.section == 2) {
        return [self didSelectUpcomingMovieRow:indexPath.row];
    } else if (indexPath.section == 3) {
        return [self didSelectDvdRow:indexPath.row];
    }
}


- (void) onShow {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [searchBar resignFirstResponder];
    [searchBar becomeFirstResponder];
}


- (void) onHide {
    [searchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}


- (void) keyboardWillShow:(NSNotification*) notification {
    NSValue* value = [notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey];

    CGRect rect;
    [value getValue:&rect];

    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDuration:0.3];

        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height -= rect.size.height;
        tableView.frame = tableViewFrame;
    }
    [UIView commitAnimations];
}


- (void) keyboardWillHide:(NSNotification*) notification {
    NSValue* value = [notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey];

    CGRect rect;
    [value getValue:&rect];

    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDuration:0.3];

        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.size.height += rect.size.height;
        tableView.frame = tableViewFrame;
    }
    [UIView commitAnimations];
}


- (void) reportResult:(SearchResult*) result {
    self.searchResult = result;
    [self.tableView reloadData];
}


- (void) searchBar:(UISearchBar*) searchBar
     textDidChange:(NSString*) searchText {
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (searchText.length == 0) {
        [searchEngine invalidateExistingRequests];
        self.searchResult = nil;
    } else {
        [searchEngine submitRequest:searchText];
    }

    [self.tableView reloadData];
}


- (CGFloat)         tableView:(UITableView*) tableView_
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (searchResult != nil) {
        if (indexPath.section == 2 || indexPath.section == 3) {
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
            return NSLocalizedString(@"DVDs", nil);
        }
    }

    return nil;
}

@end