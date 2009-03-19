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
#import "Model.h"
#import "MovieTitleCell.h"
#import "AppDelegate.h"
#import "SearchEngine.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"

@interface SearchViewController()
@property (assign)  AbstractNavigationController* navigationController;
@property (retain) SearchEngine* searchEngine;
@property (retain) SearchResult* searchResult;
@property (retain) UISearchBar* searchBar;
@property (retain) UITableView* tableView;
@end


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


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
    return navigationController.controller;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}


- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}


- (void) loadView {
    [super loadView];

    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;

    self.searchBar = [[[UISearchBar alloc] initWithFrame:rect] autorelease];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.showsScopeBar = YES;
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Movies", nil), NSLocalizedString(@"Theaters", nil), NSLocalizedString(@"Upcoming", nil), NSLocalizedString(@"DVD", nil), nil];
    searchBar.selectedScopeButtonIndex = self.model.searchSelectedScopeButtonIndex;
    [searchBar sizeToFit];

    CGRect searchBarRect = searchBar.frame;
    CGRectDivide(rect, &searchBarRect, &rect, searchBarRect.size.height, CGRectMinYEdge);

    self.tableView = [[[UITableView alloc] initWithFrame:rect
                                                   style:UITableViewStylePlain] autorelease];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIBarButtonItem* flexibleWidth = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem* doneItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDismiss)] autorelease];;
    self.toolbarItems = [NSArray arrayWithObjects:flexibleWidth, doneItem, nil];
    
    [self.view addSubview:searchBar];
    [self.view addSubview:tableView];
}


- (void) onDismiss {
    [searchBar resignFirstResponder];
    [navigationController hideSearchView];
}


- (void) searchBarCancelButtonClicked:(UISearchBar*) searchBar_ {
    [self onDismiss];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}


- (BOOL) shouldShowMovies {
    return searchBar.selectedScopeButtonIndex == 0;
}


- (BOOL) shouldShowTheaters {
    return searchBar.selectedScopeButtonIndex == 1;
}


- (BOOL) shouldShowUpcoming {
    return searchBar.selectedScopeButtonIndex == 2;
}


- (BOOL) shouldShowDVDBluray {
    return searchBar.selectedScopeButtonIndex == 3;
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
    MovieTitleCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
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
    
    TheaterNameCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
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

    DVDCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                               reuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UITableViewCell*) blurayCellForRow:(NSInteger) row {
    Movie* movie = [searchResult.bluray objectAtIndex:row];

    static NSString* reuseIdentifier = @"BlurayCellReuseIdentifier";

    DVDCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithFrame:CGRectZero
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
    } else if (indexPath.section == 4) {
        return [self didSelectBlurayRow:indexPath.row];
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
    NSAssert([NSThread isMainThread], nil);
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


- (void) searchBarSearchButtonClicked:(UISearchBar*) sender {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [navigationController setToolbarHidden:NO animated:YES];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar_ {
    [navigationController setToolbarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}


- (BOOL) hidesBottomBarWhenPushed {
    return YES;
}


- (void) searchBar:(UISearchBar*) searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    self.model.searchSelectedScopeButtonIndex = selectedScope;
    [self.tableView reloadData];
}

@end