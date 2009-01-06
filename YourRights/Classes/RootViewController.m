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

#import "RootViewController.h"

#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface RootViewController()
@property (retain) UITableView* tableView;
@property (retain) NSArray* sectionTitles;
@end


@implementation RootViewController

@synthesize tableView;
@synthesize sectionTitles;

- (void) dealloc {
    self.tableView = nil;
    self.sectionTitles = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.sectionTitles = 
        [NSArray arrayWithObjects:
         NSLocalizedString(@"Your Rights When Encountering Law Enforcement", nil),
         NSLocalizedString(@"Tough Question about ACLU positions", nil),
         NSLocalizedString(@"The ACLU Is/Isn't", nil),
         NSLocalizedString(@"ACLU 100 Greatest Hits", nil), nil];

        self.navigationItem.titleView =
        [ViewControllerUtilities viewControllerTitleLabel:NSLocalizedString(@"Know Your Rights", nil)];
    }
    
    return self;
}


- (void) loadView {
    self.tableView = [[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;

    self.view = tableView;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:[sectionTitles objectAtIndex:indexPath.section]] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    return [WrappableCell height:[sectionTitles objectAtIndex:indexPath.section] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
}


@end
