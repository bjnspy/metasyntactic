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
#import "StringUtilities.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface FederalistPapersSectionViewController()
@property (retain) Section* section;
@property (retain) NSArray* chunks;
@end


@implementation FederalistPapersSectionViewController

@synthesize section;
@synthesize chunks;

- (void) dealloc {
    self.section = nil;
    self.chunks = nil;

    [super dealloc];
}


- (id) initWithSection:(Section*) section_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.section = section_;
        self.title = section.title;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.chunks = [StringUtilities splitIntoChunks:section.text];
    }

    return self;
}


- (void) loadView {
    [super loadView];
    self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:self.title];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chunks.count;
}


- (UITableViewCell*) cellForSectionRow:(NSInteger) row {
    NSString* text = [chunks objectAtIndex:row];
    WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;

    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForSectionRow:indexPath.row];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* text = [chunks objectAtIndex:indexPath.row];
    return [WrappableCell height:text
                   accessoryType:UITableViewCellAccessoryNone];
}

@end