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

#import "ConstitutionAmendmentViewController.h"

#import "Amendment.h"
#import "GlobalActivityIndicator.h"
#import "Section.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ConstitutionAmendmentViewController()
@property (retain) Amendment* amendment;
@end


@implementation ConstitutionAmendmentViewController

@synthesize amendment;

- (void) dealloc {
    self.amendment = nil;

    [super dealloc];
}


- (id) initWithAmendment:(Amendment*) amendment_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.amendment = amendment_;
    }

    return self;
}


- (void) loadView {
    [super loadView];
    self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:amendment.synopsis];
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
    return amendment.sections.count + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < amendment.sections.count) {
        Section* section = [amendment.sections objectAtIndex:indexPath.section];
        WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:section.text] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
        cell.text = @"Wikipedia";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < amendment.sections.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        [(id)self.navigationController pushBrowser:amendment.link animated:YES];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section < amendment.sections.count) {
        if (section == 0) {
            if (amendment.sections.count == 1) {
                return [NSString stringWithFormat:@"%d", amendment.year];
            } else {
                return [NSString stringWithFormat:@"%d. Section %d", amendment.year, section + 1];
            }
        } else {
            return [NSString stringWithFormat:NSLocalizedString(@"Section %d", nil), section + 1];
        }
    } else {
        return NSLocalizedString(@"Links", nil);
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section < amendment.sections.count) {
        Section* section = [amendment.sections objectAtIndex:indexPath.section];

        NSString* text = section.text;

        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}

@end