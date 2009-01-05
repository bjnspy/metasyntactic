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

#import "NetflixMostPopularViewController.h"

#import "AbstractNavigationController.h"
#import "AutoResizingCell.h"
#import "Model.h"
#import "NetflixCache.h"
#import "NetflixMostPopularMoviesViewController.h"

@interface NetflixMostPopularViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) NSDictionary* titleToCount;
@end


@implementation NetflixMostPopularViewController

@synthesize navigationController;
@synthesize titleToCount;

- (void) dealloc {
    self.navigationController = nil;
    self.titleToCount = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"Most Popular", nil);
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
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (NSString* title in [NetflixCache mostPopularTitles]) {
        NSInteger count = [self.model.netflixCache movieCountForRSSTitle:title];
        [dictionary setObject:[NSNumber numberWithInt:count] forKey:title];
    }
    self.titleToCount = dictionary;    
}


- (void) majorRefresh {
    [self initializeData];
    [self.tableView reloadData];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return [[NetflixCache mostPopularTitles] count];
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSString* title = [[NetflixCache mostPopularTitles] objectAtIndex:indexPath.row];
    NSNumber* count = [titleToCount objectForKey:title];
    id number = (count.intValue > 0) ? (id)count : (id)NSLocalizedString(@"Downloading", nil);
    
    cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (%@)", nil), title, number];
    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* title = [[NetflixCache mostPopularTitles] objectAtIndex:indexPath.row];

    NetflixMostPopularMoviesViewController* controller = [[[NetflixMostPopularMoviesViewController alloc] initWithNavigationController:navigationController category:title] autorelease];
    [navigationController pushViewController:controller animated:YES];
}

@end