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

#import "FederalistPapersSectionViewController.h"

#import "Article.h"
#import "GlobalActivityIndicator.h"
#import "Section.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface FederalistPapersSectionViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) Section* section;
@end


@implementation FederalistPapersSectionViewController

@synthesize navigationController;
@synthesize section;

- (void) dealloc {
    self.navigationController = nil;
    self.section = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                            section:(Section*) section_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.section = section_;
        self.title = section.title;
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:self.title];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell*) cellForSectionRow:(NSInteger) row {
    WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:section.text] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;

    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForSectionRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    return nil;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    return [WrappableCell height:section.text
                   accessoryType:UITableViewCellAccessoryNone];
}

@end