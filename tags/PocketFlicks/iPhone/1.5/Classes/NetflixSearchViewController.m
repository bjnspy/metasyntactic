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

#import "NetflixSearchViewController.h"

#import "AbstractNavigationController.h"
#import "ColorCache.h"
#import "GlobalActivityIndicator.h"
#import "NetflixCell.h"
#import "NetflixSearchEngine.h"
#import "PersonCell.h"
#import "SearchResult.h"

@interface NetflixSearchViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) UISearchBar* searchBar;
@property (retain) NetflixSearchEngine* searchEngine;
@property (retain) UIActivityIndicatorView* activityIndicatorView;
@property (retain) NSArray* movies;
@property (retain) NSArray* people;
@property (copy) NSString* error;
@end


@implementation NetflixSearchViewController

@synthesize navigationController;
@synthesize searchBar;
@synthesize searchEngine;
@synthesize activityIndicatorView;
@synthesize movies;
@synthesize people;
@synthesize error;

- (void) dealloc {
    self.navigationController = nil;
    self.searchBar = nil;
    self.searchEngine = nil;
    self.activityIndicatorView = nil;
    self.movies = nil;
    self.people = nil;
    self.error = nil;

    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.searchEngine = [NetflixSearchEngine engineWithModel:self.model
                                                        delegate:self];
        self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];

        CGRect frame = activityIndicatorView.frame;
        frame.size.width += 4;

        UIView* activityView = [[[UIView alloc] initWithFrame:frame] autorelease];
        [activityView addSubview:activityIndicatorView];

        self.navigationItem.rightBarButtonItem =
        [[[UIBarButtonItem alloc] initWithCustomView:activityView] autorelease];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;

    self.searchBar = [[[UISearchBar alloc] initWithFrame:rect] autorelease];
    searchBar.delegate = self;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.tintColor = [ColorCache netflixYellow];

    [searchBar sizeToFit];

    self.navigationItem.titleView = searchBar;
}


- (void) majorRefreshWorker {
    [self.tableView reloadData];
}


- (void) minorRefreshWorker {
    if (!visible) {
        return;
    }

    for (id cell in self.tableView.visibleCells) {
        [cell refresh];
    }
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 100;
    [self majorRefresh];

    if (searchBar.text.length == 0) {
        [searchBar becomeFirstResponder];
    }
}


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return NO;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    [super didReceiveMemoryWarning];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return movies.count;
    } else if (section == 1) {
        return people.count;
    } else {
        return 0;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && movies.count > 0) {
        return NSLocalizedString(@"Movies", nil);
    } else if (section == 1 && people.count > 0) {
        return NSLocalizedString(@"People", nil);
    } else if (section == 2 && error.length > 0) {
        return error;
    }

    return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    if (indexPath.section == 0) {
        static NSString* reuseIdentifier = @"movieReuseIdentifier";

        NetflixCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NetflixCell alloc] initWithFrame:CGRectZero
                                       reuseIdentifier:reuseIdentifier
                                                 model:self.model] autorelease];
        }

        Movie* movie = [movies objectAtIndex:indexPath.row];
        [cell setMovie:movie owner:self];

        return cell;
    } else {
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
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        Movie* movie = [movies objectAtIndex:indexPath.row];
        [navigationController pushMovieDetails:movie animated:YES];
    } else {

    }
}


- (void) searchBar:(UISearchBar*) searchBar
     textDidChange:(NSString*) searchText {
    self.error = nil;

    if (searchText.length == 0) {
        [activityIndicatorView stopAnimating];
        [searchEngine invalidateExistingRequests];
        self.movies = [NSArray array];
        self.people = [NSArray array];
        [self majorRefresh];
    } else {
        [activityIndicatorView startAnimating];
        [searchEngine submitRequest:searchText];
    }
}


- (void) searchBarSearchButtonClicked:(UISearchBar*) sender {
    [searchBar resignFirstResponder];
}


- (void) reportResult:(SearchResult*) result {
    NSAssert([NSThread isMainThread], nil);
    [activityIndicatorView stopAnimating];

    self.movies = result.movies;
    self.people = result.people;
    self.error = result.error;
    [self majorRefresh];
}

@end