// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "DeclarationOfIndependenceViewController.h"

#import "ConstitutionSignersViewController.h"
#import "DeclarationOfIndependence.h"
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
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.declaration = declaration_;
    self.title = NSLocalizedString(@"Declaration of Independence", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.chunks = [StringUtilities splitIntoChunks:declaration.text];
  }

  return self;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
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
    cell.textLabel.text = NSLocalizedString(@"Signers", nil);
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
