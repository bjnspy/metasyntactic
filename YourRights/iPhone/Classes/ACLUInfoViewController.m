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

#import "ACLUInfoViewController.h"

#import "GlobalActivityIndicator.h"
#import "WrappableCell.h"

@interface ACLUInfoViewController()
@property (retain) NSArray* isArray;
@property (retain) NSArray* isNotArray;
@end

@implementation ACLUInfoViewController

@synthesize isArray;
@synthesize isNotArray;

- (void)dealloc {
    self.isArray = nil;
    self.isNotArray = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.isArray =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"A non-governmental, non-profit, independent organization.", nil),
         NSLocalizedString(@"A membership organization that anyone can join for $20/yr.", nil),
         NSLocalizedString(@"An advocacy organization that uses its "
                           @"work in the courts to breath life into the "
                           @"promises of the Bill of Rights.", nil),
         NSLocalizedString(@"An organization that will criticize "
                           @"politicians from any political party if "
                           @"their actions compromise civil liberties "
                           @"or civil rights.", nil),
         NSLocalizedString(@"An organization that fights for the right "
                           @"of everyone to speak their message— "
                           @"even those whose message we detest.", nil),
         NSLocalizedString(@"An organization that even our political "
                           @"enemies respect because we take "
                           @"consistent stands based on policies "
                           @"developed over the last 80 years.", nil),
         NSLocalizedString(@"An organization that educates the "
                           @"public about the threats to civil liberties "
                           @"and civil rights.", nil),
         NSLocalizedString(@"An organization that changes policy in "
                           @"a very deliberate manner after much "
                           @"discussion.", nil),
         NSLocalizedString(@"An organization that works with "
                           @"coalitions where the issues "
                           @"support/advance civil liberties and civil "
                           @"rights.", nil),
         NSLocalizedString(@"A representatively-run organization. "
                           @"The members elect board member "
                           @"representatives who vote on policy.", nil), nil];

        self.isNotArray =
        [NSArray arrayWithObjects:
         NSLocalizedString(@"A government agency.", nil),
         NSLocalizedString(@"A lawyers group.", nil),
         NSLocalizedString(@"A legal services provider.  ACLU gets "
                           @"involved in only a few court cases.  We "
                           @"do not accept individual cases unless "
                           @"they will either establish new legal "
                           @"precedents or protect civil liberties "
                           @"under attack.", nil),
         NSLocalizedString(@"A partisan political organization.  ACLU "
                           @"does not support or oppose candidates "
                           @"for elective office.", nil),
         NSLocalizedString(@"A group that supports the free speech "
                           @"rights of racists because we agree with "
                           @"their message.", nil),
         NSLocalizedString(@"An organization that changes its "
                           @"policies when lobbying government "
                           @"agencies just to suit a particular "
                           @"popular agenda.", nil),
         NSLocalizedString(@"An organization that chooses issues to "
                           @"educate the public based on their "
                           @"shock value.", nil),
         NSLocalizedString(@"An organization that changes policies "
                           @"easily/lightly in response to pressure.", nil),
         NSLocalizedString(@"An organization that always agrees with "
                           @"its allies, supporters, members or "
                           @"coalitions.", nil),
         NSLocalizedString(@"An organization that has members who "
                           @"vote directly on ACLU policy.", nil), nil];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return isArray.count;
    } else {
        return isNotArray.count;
    }
}


- (NSString*) textForIndexPath:(NSIndexPath*) indexPath {
    NSString* text;
    if (indexPath.section == 0) {
        text = [isArray objectAtIndex:indexPath.row];
    } else {
        text = [isNotArray objectAtIndex:indexPath.row];
    }

    return text;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* text = [self textForIndexPath:indexPath];

    WrappableCell* cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
    return cell;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* text = [self textForIndexPath:indexPath];

    return [WrappableCell height:text accessoryType:UITableViewCellAccessoryNone];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"The ACLU Is:", nil);
    } else {
        return NSLocalizedString(@"The ACLU Is Not:", nil);
    }
}

@end