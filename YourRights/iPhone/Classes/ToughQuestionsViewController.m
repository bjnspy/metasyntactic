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

#import "ToughQuestionsViewController.h"

#import "AnswerViewController.h"
#import "Model.h"
#import "ToughAnswerViewController.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ToughQuestionsViewController()
@property (assign) YourRightsNavigationController* navigationController;
@end


@implementation ToughQuestionsViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;
    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:NSLocalizedString(@"Tough Questions", nil)];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease]] autorelease];
    }

    return self;
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model toughQuestions].count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* text = [[self.model toughQuestions] objectAtIndex:indexPath.row];

    UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    return [WrappableCell height:[[self.model toughQuestions] objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* question = [[self.model toughQuestions] objectAtIndex:indexPath.row];
    NSString* answer = [self.model answerForToughQuestion:question];
    ToughAnswerViewController* controller = [[[ToughAnswerViewController alloc] initWithQuestion:question answer:answer] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
