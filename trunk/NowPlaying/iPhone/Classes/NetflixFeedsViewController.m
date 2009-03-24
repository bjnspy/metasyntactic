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
#import "AppDelegate.h"
#import "Feed.h"
#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "MutableNetflixCache.h"
#import "NetflixQueueViewController.h"
#import "Queue.h"

@interface NetflixFeedsViewController()
@property (retain) NSArray* feedKeys;
@end


@implementation NetflixFeedsViewController

@synthesize feedKeys;

- (void) dealloc {
    self.feedKeys = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                           feedKeys:(NSArray*) feedKeys_
                              title:(NSString*) title_ {
    if (self = [super initWithStyle:UITableViewStylePlain navigationController:navigationController_]) {
        self.title = title_;
        self.feedKeys = feedKeys_;
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (void) majorRefreshWorker {
    [self reloadTableViewData];
}


- (void) minorRefreshWorker {
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[AppDelegate globalActivityView]] autorelease];
    [self majorRefresh];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView*) tableView {
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


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

    NSArray* feeds = self.feeds;

    Feed* feed = [feeds objectAtIndex:indexPath.row];

    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 12;
    cell.textLabel.text = [self.model.netflixCache titleForKey:feed.key];
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