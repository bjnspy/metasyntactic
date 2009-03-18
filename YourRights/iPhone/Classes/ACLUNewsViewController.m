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

#import "ACLUNewsViewController.h"

#import "ACLUArticlesViewController.h"
#import "AutoResizingCell.h"
#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "NetworkUtilities.h"
#import "RSSCache.h"
#import "YourRightsNavigationController.h"

@interface ACLUNewsViewController()
@property (retain) NSMutableArray* titlesWithArticles;
@end


@implementation ACLUNewsViewController

@synthesize titlesWithArticles;

- (void) dealloc {
    self.titlesWithArticles = nil;
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"News", nil);
    }

    return self;
}


- (Model*) model {
    return (id)[(id)self.navigationController model];
}


- (void) majorRefresh {
    self.titlesWithArticles = [NSMutableArray array];

    for (NSString* title in [RSSCache titles]) {
        NSArray* items = [self.model.rssCache itemsForTitle:title];
        if (items.count > 0) {
            [titlesWithArticles addObject:title];
        }
    }

    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(titlesWithArticles.count, 1);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (titlesWithArticles.count == 0) {
        return 0;
    }

    return 1;
}


- (NSString*)       tableView:(UITableView*) tableView
       titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && titlesWithArticles.count == 0) {
        if ([GlobalActivityIndicator hasVisibleBackgroundTasks]) {
            return NSLocalizedString(@"Downloading data", nil);
        } else if (![NetworkUtilities isNetworkAvailable]) {
            return NSLocalizedString(@"Network unavailable", nil);
        } else {
            return NSLocalizedString(@"No information found", nil);
        }
    }

    return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";

    AutoResizingCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }

    NSString* title = [titlesWithArticles objectAtIndex:indexPath.section];
    NSArray* items = [self.model.rssCache itemsForTitle:title];

    cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (%d)", nil), title, items.count];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* title = [[RSSCache titles] objectAtIndex:indexPath.section];
    ACLUArticlesViewController* controller = [[[ACLUArticlesViewController alloc] initWithTitle:title] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end