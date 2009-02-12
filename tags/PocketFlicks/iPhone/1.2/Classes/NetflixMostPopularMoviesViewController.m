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

#import "NetflixMostPopularMoviesViewController.h"

#import "AbstractNavigationController.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "NetflixCache.h"
#import "NetflixCell.h"
#import "NetworkUtilities.h"
#import "Model.h"
#import "Queue.h"
#import "ViewControllerUtilities.h"

@interface NetflixMostPopularMoviesViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (copy) NSString* category;
@property (retain) NSArray* movies;
@property (retain) NSArray* visibleIndexPaths;
@end


@implementation NetflixMostPopularMoviesViewController

@synthesize navigationController;
@synthesize category;
@synthesize movies;
@synthesize visibleIndexPaths;
- (void) dealloc {
    self.navigationController = nil;
    self.category = nil;
    self.movies = nil;
    self.visibleIndexPaths = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              category:(NSString*) category_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.category = category_;
        self.title = category_;

        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = category;
        self.navigationItem.titleView = label;
    }

    return self;
}


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
    return navigationController.controller;
}


- (void) initializeData {
    self.movies = [self.model.netflixCache moviesForRSSTitle:category];
}


- (void) majorRefreshWorker {
    [self initializeData];
    [self.tableView reloadData];

    if (visibleIndexPaths.count > 0) {
        NSIndexPath* path = [visibleIndexPaths objectAtIndex:0];
        if (path.section >= 0 && path.section < self.tableView.numberOfSections &&
            path.row >= 0 && path.row < [self.tableView numberOfRowsInSection:path.section]) {
            [self.tableView scrollToRowAtIndexPath:[visibleIndexPaths objectAtIndex:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }

        self.visibleIndexPaths = nil;
    }
}


- (void) minorRefreshWorker {
    for (id cell in self.tableView.visibleCells) {
        [cell refresh];
    }
}


- (void) viewWillAppear:(BOOL) animated {
    self.tableView.rowHeight = 100;
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
}


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    self.movies = [NSArray array];

    // Store the currently visible cells so we can scroll back to them when
    // we're reloaded.
    self.visibleIndexPaths = [self.tableView indexPathsForVisibleRows];

    [super didReceiveMemoryWarning];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return movies.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    NetflixCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NetflixCell alloc] initWithFrame:CGRectZero
                                   reuseIdentifier:reuseIdentifier
                                             model:self.model] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Movie* movie = [movies objectAtIndex:indexPath.row];
    [cell setMovie:movie owner:self];

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    Movie* movie = [movies objectAtIndex:indexPath.row];
    [navigationController pushMovieDetails:movie animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (movies.count == 0) {
        return self.model.noInformationFound;
    }

    return nil;
}

@end