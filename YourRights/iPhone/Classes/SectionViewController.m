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

#import "SectionViewController.h"

#import "ACLUInfoViewController.h"
#import "ACLUNewsViewController.h"
#import "CreditsViewController.h"
#import "GlobalActivityIndicator.h"
#import "GreatestHitsViewController.h"
#import "Model.h"
#import "QuestionsViewController.h"
#import "ToughQuestionsViewController.h"
#import "WrappableCell.h"
#import "ViewControllerUtilities.h"
#import "YourRightsNavigationController.h"

@interface SectionViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) UITableView* tableView;
@property (retain) CreditsViewController* creditsViewController;
@end


@implementation SectionViewController

@synthesize navigationController;
@synthesize tableView;
@synthesize creditsViewController;

- (void) dealloc {
    self.navigationController = nil;
    self.tableView = nil;
    self.creditsViewController = nil;

    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_ {
    if (self = [super init]) {
        self.navigationController = navigationController_;
        self.navigationItem.titleView =
        [ViewControllerUtilities viewControllerTitleLabel:NSLocalizedString(@"Know Your Rights", nil)];

        UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        CGRect frame = button.frame;
        frame.size.width += 10;
        button.frame = frame;

        [button addTarget:self action:@selector(flipView:) forControlEvents:UIControlEventTouchUpInside];

        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }

    return self;
}


- (void) createCreditsView {
    if (creditsViewController != nil) {
        return;
    }

    self.creditsViewController = [[[CreditsViewController alloc] initWithNavigationController:self.navigationController] autorelease];
    self.creditsViewController.view.frame = tableView.frame;
}


- (void) flipView:(id) sender {
    [self createCreditsView];

    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDuration:1];

        if (tableView.superview) {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                   forView:self.view
                                     cache:YES];
            [tableView removeFromSuperview];
            [self.view addSubview:creditsViewController.tableView];
        } else {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                   forView:self.view
                                     cache:YES];
            [creditsViewController.tableView removeFromSuperview];
            [self.view addSubview:tableView];
        }
    }
    [UIView commitAnimations];
}


- (UITableView*) createTableView:(CGRect) tableViewRect {
    UITableView* table = [[[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain] autorelease];
    table.delegate = self;
    table.dataSource = self;

    // add the subviews and set their resize behavior
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return table;
}


- (void) loadView {
    CGRect rect = [UIScreen mainScreen].bounds;

    self.view = [[[UIView alloc] initWithFrame:rect] autorelease];
    self.view.autoresizesSubviews = YES;

    self.tableView = [self createTableView:rect];

    [self.view addSubview:tableView];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return [[self.model sectionTitles] count];
    }
}


- (NSString*) titleForIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return NSLocalizedString(@"ACLU News", nil);
        } else if (indexPath.row == 1) {
            return NSLocalizedString(@"Tough Questions about ACLU positions", nil);
        } else if (indexPath.row == 2) {
            return NSLocalizedString(@"The ACLU Is / Is Not", nil);
        } else {
            return NSLocalizedString(@"ACLU 100 Greatest Hits", nil);
        }
    } else {
        return [[self.model sectionTitles] objectAtIndex:indexPath.row];
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* text = [self titleForIndexPath:indexPath];
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    } else {
        text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, text];

        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* text = [self titleForIndexPath:indexPath];

    if (indexPath.section == 0) {
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, text];
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ACLUNewsViewController* controller = [[[ACLUNewsViewController alloc] initWithNavigationController:navigationController] autorelease];
            [navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 1) {
            ToughQuestionsViewController* controller = [[[ToughQuestionsViewController alloc] initWithNavigationController:navigationController] autorelease];
            [navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 2) {
            ACLUInfoViewController* controller = [[[ACLUInfoViewController alloc] init] autorelease];
            [navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 3) {
            GreatestHitsViewController* controller = [[[GreatestHitsViewController alloc] initWithNavigationController:navigationController] autorelease];
            [navigationController pushViewController:controller animated:YES];
        }
    } else {
        NSString* text = [[self.model sectionTitles] objectAtIndex:indexPath.row];
        QuestionsViewController* controller = [[[QuestionsViewController alloc] initWithNavigationController:navigationController
                                                                                                sectionTitle:text] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"ACLU Information", nil);
    } else {
        return NSLocalizedString(@"Encountering Law Enforcement", nil);
    }

    return nil;
}



@end