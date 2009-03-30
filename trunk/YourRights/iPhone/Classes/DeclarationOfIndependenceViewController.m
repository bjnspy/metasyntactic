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
#import "StringUtilities.h"
#import "ViewControllerUtilities.h"
#import "WrappableCell.h"

@interface DeclarationOfIndependenceViewController()
@property (retain) DeclarationOfIndependence* declaration;
@property (retain) NSArray* chunks;
@end

@implementation DeclarationOfIndependenceViewController

@synthesize declaration;
@synthesize chunks;

- (void) dealloc {
    self.declaration = nil;
    self.chunks = nil;

    [super dealloc];
}


- (id) initWithDeclaration:(DeclarationOfIndependence*) declaration_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.declaration = declaration_;
        self.title = NSLocalizedString(@"Declaration of Independence", nil);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.chunks = [StringUtilities splitIntoChunks:declaration.text];
    }

    return self;
}


- (void) loadView {
    [super loadView];
    self.navigationItem.titleView = [ViewControllerUtilities viewControllerTitleLabel:self.title];
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self reloadTableViewData];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return chunks.count;
    } else {
        return 1;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString* text = [chunks objectAtIndex:indexPath.row];
        WrappableCell* cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
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
        ConstitutionSignersViewController* controller = [[[ConstitutionSignersViewController alloc] initWithSigners:declaration.signers] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
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
        NSString* text = [chunks objectAtIndex:indexPath.row];
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryNone];
    } else {
        return tableView.rowHeight;
    }
}

@end