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

#import "FederalistPapersViewController.h"

#import "Amendment.h"
#import "Article.h"
#import "AutoResizingCell.h"
#import "Constitution.h"
#import "ConstitutionAmendmentViewController.h"
#import "ConstitutionArticleViewController.h"
#import "ConstitutionSignersViewController.h"
#import "FederalistPapersArticleViewController.h"
#import "GlobalActivityIndicator.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface FederalistPapersViewController()
@property (retain) Constitution* constitution;
@end

@implementation FederalistPapersViewController

@synthesize constitution;

- (void)dealloc {
    self.constitution = nil;
    [super dealloc];
}


- (id) initWithConstitution:(Constitution*) constitution_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.constitution = constitution_;
        self.title = NSLocalizedString(@"Federalist Papers", nil);
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
    return constitution.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";

    AutoResizingCell *cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }

    Article* article = [constitution.articles objectAtIndex:indexPath.row];
    cell.text = article.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article* article = [constitution.articles objectAtIndex:indexPath.row];
    FederalistPapersArticleViewController* controller = [[[FederalistPapersArticleViewController alloc] initWithArticle:article] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

@end