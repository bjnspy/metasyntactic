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

#import "NetflixFeedsViewController.h"

#import "AbstractNavigationController.h"
#import "AutoResizingCell.h"
#import "Feed.h"
#import "GlobalActivityIndicator.h"
#import "MutableNetflixCache.h"
#import "NetflixQueueViewController.h"
#import "MetaFlixModel.h"
#import "Queue.h"

@interface NetflixFeedsViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) NSArray* feedKeys;
@end


@implementation NetflixFeedsViewController

@synthesize navigationController;
@synthesize feedKeys;

- (void) dealloc {
    self.navigationController = nil;
    self.feedKeys = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                           feedKeys:(NSArray*) feedKeys_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"Queues", nil);
        self.feedKeys = feedKeys_;
    }

    return self;
}


- (MetaFlixModel*) model {
    return navigationController.model;
}


- (MetaFlixController*) controller {
    return navigationController.controller;
}


- (void) majorRefreshWorker {
    [self.tableView reloadData];
}


- (void) minorRefreshWorker {
}


- (void) viewWillAppear:(BOOL) animated {
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}


- (NSArray*) feeds {
    NSArray* feeds = self.model.netflixCache.feeds;

    NSMutableArray* result = [NSMutableArray array];
    for (Feed* feed in feeds) {
        if ([feedKeys containsObject:feed.key]) {
            [result addObject:feed];
        }
    }
    return result;
}


- (BOOL) hasFeeds {
    return self.feeds.count > 0;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return self.feeds.count;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (!self.hasFeeds) {
        return self.model.netflixCache.noInformationFound;
    }

    return nil;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    AutoResizingCell* cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero] autorelease];

    NSArray* feeds = self.feeds;

    Feed* feed = [feeds objectAtIndex:indexPath.row];

    cell.text = [self.model.netflixCache titleForKey:feed.key];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSArray* feeds = self.feeds;

    Feed* feed = [feeds objectAtIndex:indexPath.row];
    NetflixQueueViewController* controller = [[[NetflixQueueViewController alloc] initWithNavigationController:navigationController
                                                                                                       feedKey:feed.key] autorelease];
    [navigationController pushViewController:controller animated:YES];
}

@end