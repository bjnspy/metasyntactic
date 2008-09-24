// Copyright (C) 2008 Cyrus Najmabadi
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

#import "SearchViewController.h"

#import "AbstractNavigationController.h"
#import "MovieTitleCell.h"
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
    rect.origin.y = 0;

//    self.view = [[[UIView alloc] initWithFrame:rect] autorelease];
//    self.view.autoresizesSubviews = YES;

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
    searchResult.upcomingMovies.count == 0;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if (searchResult == nil) {
        return 1;
    }
    
    if ([self noResults]) {
        return 1;
    }
    
    return 3;
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
    } else {
        return searchResult.upcomingMovies.count;
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
    } else {
        return [self upcomingMovieCellForRow:indexPath.row];
    }
}


- (void) didSelectMovieRow:(NSInteger) row {
    Movie* movie = [searchResult.movies objectAtIndex:row];

    [navigationController pushMovieDetails:movie animated:YES];
}


- (void) didSelectTheaterRow:(NSInteger) row {
    Theater* theater = [searchResult.theaters objectAtIndex:row];

    [navigationController pushTheaterDetails:theater animated:YES];
}


- (void) didSelectUpcomingMovieRow:(NSInteger) row {
    Movie* movie = [searchResult.upcomingMovies objectAtIndex:row];

    [navigationController pushMovieDetails:movie animated:YES];
}


- (void)            tableView:(UITableView*) tableView_
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        return [self didSelectMovieRow:indexPath.row];
    } else if (indexPath.section == 1) {
        return [self didSelectTheaterRow:indexPath.row];
    } else {
        return [self didSelectUpcomingMovieRow:indexPath.row];
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
    CGRect rect;
    [[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&rect];

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
    CGRect rect;
    [[notification.userInfo objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&rect];

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
        [self reportResult:nil];
    } else {
        [searchEngine submitRequest:searchText];
    }
}


- (CGFloat)         tableView:(UITableView*) tableView_
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (searchResult != nil && indexPath.section == 2) {
        return 100;
    }

    return self.tableView.rowHeight;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (searchResult == nil) {
        return nil;
    }
    
    if ([self noResults]) {
        return [NSString stringWithFormat:NSLocalizedString(@"No results found for '%@'", nil), searchResult.value];
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
    }
    
    return nil;
}


@end
