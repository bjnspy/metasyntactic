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
#import "NetflixSearchViewController.h"

#import "AbstractNavigationController.h"
#import "ColorCache.h"
#import "Model.h"
#import "NetflixCell.h"
#import "NetflixSearchEngine.h"
#import "SearchResult.h"

@interface NetflixSearchViewController()
@property (retain) UISearchBar* searchBar;
@property (retain) NetflixSearchEngine* searchEngine;
@property (retain) NSArray* movies;
@property (retain) NSArray* people;
@end


@implementation NetflixSearchViewController

@synthesize searchBar;
@synthesize searchEngine;
@synthesize movies;
@synthesize people;

- (void) dealloc {
    self.searchBar = nil;
    self.searchEngine = nil;
    self.movies = nil;
    self.people = nil;

    [super dealloc];
}


- (Model*) model {
    return [Model model];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.searchEngine = [NetflixSearchEngine engineWithDelegate:self];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    self.searchBar = [[[UISearchBar alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    searchBar.delegate = self;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.tintColor = self.navigationController.navigationBar.tintColor;
    [searchBar sizeToFit];

    self.navigationItem.titleView = searchBar;
}


- (void) majorRefreshWorker {
    [self reloadTableViewData];
}


- (void) minorRefreshWorker {
    for (id cell in self.tableView.visibleCells) {
        [cell refresh];
    }
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 100;

    if (searchBar.text.length == 0) {
        [searchBar becomeFirstResponder];
    }
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return NO;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return movies.count;
    } else {
        return people.count;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && movies.count > 0) {
        return NSLocalizedString(@"Movies", nil);
    } else if (section == 1 && people.count > 0) {
        return NSLocalizedString(@"People", @"Category for people matched by a search");
    }

    return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        static NSString* reuseIdentifier = @"movieReuseIdentifier";

        NetflixCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NetflixCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
        }

        Movie* movie = [movies objectAtIndex:indexPath.row];
        [cell setMovie:movie owner:self];

        return cell;
    } else {
        return nil;
        /*
         static NSString* reuseIdentifier = @"personReuseIdentifier";

         PersonCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
         if (cell == nil) {
         cell = [[[PersonCell alloc] initWithFrame:CGRectZero
                                   reuseIdentifier:reuseIdentifier
                                             model:self.model] autorelease];
         }

         Person* person = [people objectAtIndex:indexPath.row];
         [cell setPerson:person owner:self];

         return cell;
         */
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        Movie* movie = [movies objectAtIndex:indexPath.row];
        [self.abstractNavigationController pushMovieDetails:movie animated:YES];
    } else {

    }
}


- (void) searchBar:(UISearchBar*) searchBar
     textDidChange:(NSString*) searchText {
    if (searchText.length == 0) {
        [searchEngine invalidateExistingRequests];
        self.movies = [NSArray array];
        self.people = [NSArray array];
        [self majorRefresh];
    } else {
        [searchEngine submitRequest:searchText];
    }
}


- (void) searchBarSearchButtonClicked:(UISearchBar*) sender {
    [searchBar resignFirstResponder];
}


- (void) reportResult:(SearchResult*) result {
    NSAssert([NSThread isMainThread], nil);

    self.movies = result.movies;
    //self.people = result.people;
    [self majorRefresh];
}

@end
#endif