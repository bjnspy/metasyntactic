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
#import "NetflixSearchEngine.h"

@interface NetflixSearchViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) UISearchBar* searchBar;
@property (retain) NetflixSearchEngine* searchEngine;
@property (retain) UIActivityIndicatorView* activityIndicatorView;
@end


@implementation NetflixSearchViewController

@synthesize navigationController;
@synthesize searchBar;
@synthesize searchEngine;
@synthesize activityIndicatorView;

- (void) dealloc {
    self.navigationController = nil;
    self.searchBar = nil;
    self.searchEngine = nil;
    self.activityIndicatorView = nil;

    [super dealloc];
}


- (NowPlayingModel*) model {
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
}


- (void) minorRefreshWorker {
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self majorRefresh];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        //[cell addSubview:searchBar];
    }

    // Set up the cell...

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


- (void) searchBar:(UISearchBar*) searchBar
     textDidChange:(NSString*) searchText {
    if (searchText.length == 0) {
        [activityIndicatorView stopAnimating];
        [searchEngine invalidateExistingRequests];
    } else {
        [activityIndicatorView startAnimating];
        [searchEngine submitRequest:searchText];
    }
}


- (void) reportResult:(SearchResult*) result {
    [activityIndicatorView stopAnimating];


}

@end