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
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface FederalistPapersViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) Constitution* constitution;
@end

@implementation FederalistPapersViewController

@synthesize navigationController;
@synthesize constitution;

- (void)dealloc {
    self.navigationController = nil;
    self.constitution = nil;
    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                       constitution:(Constitution*) constitution_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.constitution = constitution_;
        self.title = NSLocalizedString(@"Federalist Papers", nil);
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:self.title];
    }
    
    return self;
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
    return constitution.articles.count;
}


// Customize the appearance of table view cells.
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
    FederalistPapersArticleViewController* controller = [[[FederalistPapersArticleViewController alloc] initWithNavigationController:navigationController article:article] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    return nil;
}

/*
- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    return tableView.rowHeight;
}
 */

@end