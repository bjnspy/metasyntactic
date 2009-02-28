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

#import "DeclarationOfIndependenceViewController.h"

#import "ConstitutionSignersViewController.h"
#import "DateUtilities.h"
#import "DeclarationOfIndependence.h"
#import "GlobalActivityIndicator.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface DeclarationOfIndependenceViewController()
@property (assign) YourRightsNavigationController* navigationController;
@property (retain) DeclarationOfIndependence* declaration;
@end

@implementation DeclarationOfIndependenceViewController

@synthesize navigationController;
@synthesize declaration;

- (void) dealloc {
    self.navigationController = nil;
    self.declaration = nil;
    
    [super dealloc];
}


- (id) initWithNavigationController:(YourRightsNavigationController*) navigationController_
                        declaration:(DeclarationOfIndependence*) declaration_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.declaration = declaration_;
        self.title = NSLocalizedString(@"Declaration of Independence", nil);
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
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WrappableCell* cell = [[[WrappableCell alloc] initWithTitle:declaration.text] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
        cell.text = NSLocalizedString(@"Signers", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ConstitutionSignersViewController* controller = [[[ConstitutionSignersViewController alloc] initWithNavigationController:navigationController
                                                                                                                         signers:declaration.signers] autorelease];
        [navigationController pushViewController:controller animated:YES];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return [DateUtilities formatLongDate:declaration.date];
    } else {
        return NSLocalizedString(@"Information", nil);
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [WrappableCell height:declaration.text accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}

@end