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

#import "QuestionsViewController.h"

#import "AnswerViewController.h"
#import "Model.h"
#import "ViewControllerUtilities.h"
#import "WebViewController.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface QuestionsViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (copy) NSString* sectionTitle;
@property (copy) NSString* preamble;
@property (retain) NSArray* questions;
@property (retain) NSArray* otherResources;
@property (retain) NSArray* links;
@end


@implementation QuestionsViewController

@synthesize navigationController;
@synthesize sectionTitle;
@synthesize preamble;
@synthesize questions;
@synthesize otherResources;
@synthesize links;

- (void)dealloc {
    self.navigationController = nil;
    self.sectionTitle = nil;
    self.preamble = nil;
    self.questions = nil;
    self.otherResources = nil;
    self.links = nil;

    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                       sectionTitle:(NSString*) sectionTitle_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.sectionTitle = sectionTitle_;
        self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:[self.model shortSectionTitleForSectionTitle:sectionTitle]];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease]] autorelease];
        self.preamble = [self.model preambleForSectionTitle:sectionTitle];
        self.questions = [self.model questionsForSectionTitle:sectionTitle];
        self.otherResources = [self.model otherResourcesForSectionTitle:sectionTitle];
        self.links = [self.model linksForSectionTitle:sectionTitle];
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
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return preamble.length == 0 ? 0 : 1;
    } else if (section == 1) {
        return questions.count;
    } else if (section == 2) {
        return otherResources.count;
    } else {
        return links.count;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:preamble] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.section == 1) {
        NSString* text = [questions objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else if (indexPath.section == 2) {
        NSString* text = [otherResources objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        NSString* link = [links objectAtIndex:indexPath.row];
        UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
        cell.textColor = [UIColor blueColor];
        cell.text = link;
        if ([link rangeOfString:@"@"].length > 0) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.font = [UIFont systemFontOfSize:14];
        cell.lineBreakMode = UILineBreakModeMiddleTruncation;
        return cell;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [WrappableCell height:preamble accessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.section == 1) {
        return [WrappableCell height:[questions objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else if (indexPath.section == 2) {
        return [WrappableCell height:[otherResources objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    } else if (indexPath.section == 1) {
        NSString* question = [questions objectAtIndex:indexPath.row];
        NSString* answer = [self.model answerForQuestion:question withSectionTitle:sectionTitle];
        AnswerViewController* controller = [[[AnswerViewController alloc] initWithNavigationController:navigationController
                                                                                          sectionTitle:sectionTitle
                                                                                              question:question
                                                                                                answer:answer] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section == 2) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];   
    } else {
        NSString* link = [links objectAtIndex:indexPath.row];
        if ([link rangeOfString:@"@"].length > 0) {
            link = [NSString stringWithFormat:@"mailto:%@", link];
            
            NSURL* url = [NSURL URLWithString:link];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            WebViewController* controller = [[[WebViewController alloc] initWithNavigationController:(id)self.navigationController address:link showSafariButton:YES] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && preamble.length > 0) {
        return NSLocalizedString(@"Information", nil);
    } else if (section == 1) {
        if (preamble.length > 0 || otherResources.count > 0 || links.count > 0) {
            return NSLocalizedString(@"Questions", nil);
        }
    } else if (section == 2 && otherResources.count > 0) {
        return NSLocalizedString(@"Other Resources", nil);
    } else if (section == 3 && links.count > 0) {
        return NSLocalizedString(@"Useful Links", nil);
    }
    
    return nil;
}


@end
