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

#import "FederalistPapersArticleViewController.h"

#import "Article.h"
#import "FederalistPapersSectionViewController.h"
#import "GlobalActivityIndicator.h"
#import "Section.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface FederalistPapersArticleViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) Article* article;
@end


@implementation FederalistPapersArticleViewController

@synthesize navigationController;
@synthesize article;

- (void) dealloc {
    self.navigationController = nil;
    self.article = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                            article:(Article*) article_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.article = article_;
        self.title = article.title;
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:self.title];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return article.sections.count;
}


- (UIFont*) font {
    return [UIFont boldSystemFontOfSize:18];
}


- (UITableViewCell*) cellForSectionRow:(NSInteger) row {
    Section* section = [article.sections objectAtIndex:row];
    WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:section.title] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.font = self.font;
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForSectionRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Section* section = [article.sections objectAtIndex:indexPath.row];
    FederalistPapersSectionViewController* controller = [[[FederalistPapersSectionViewController alloc] initWithNavigationController:navigationController section:section] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    return nil;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    Section* section = [article.sections objectAtIndex:indexPath.row];

    return [WrappableCell height:section.title
                   accessoryType:UITableViewCellAccessoryDisclosureIndicator
                            font:self.font];
}

@end