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

#import "AnswerViewController.h"
#import "Model.h"
#import "ViewControllerUtilities.h"
#import "WebViewController.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface AnswerViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (copy) NSString* sectionTitle;
@property (copy) NSString* question;
@property (copy) NSString* answer;
@property (retain) NSArray* links;
@end


@implementation AnswerViewController

@synthesize navigationController;
@synthesize sectionTitle;
@synthesize question;
@synthesize answer;
@synthesize links;

- (void) dealloc {
    self.navigationController = nil;
    self.sectionTitle = nil;
    self.question = nil;
    self.answer = nil;
    self.links = nil;
    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                       sectionTitle:(NSString*) sectionTitle_
                   question:(NSString*) question_
                     answer:(NSString*) answer_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.sectionTitle = sectionTitle_;
        self.question = question_;
        self.answer = answer_;
        self.links = [self.model linksForQuestion:question withSectionTitle:sectionTitle];
    }
    
    return self;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return links.count;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:question] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:answer] autorelease];
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


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    } else if (indexPath.section == 1) {
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


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [WrappableCell height:question accessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.section == 1) {
        return [WrappableCell height:answer accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Question", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Answer", nil);
    } else if (section == 2 && links.count > 0) {
        return NSLocalizedString(@"Useful Links", nil);
    }
    
    return nil;
}

@end