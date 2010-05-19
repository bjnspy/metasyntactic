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

#import "ConstitutionSignersViewController.h"

#import "Article.h"
#import "Person.h"
#import "Section.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ConstitutionSignersViewController()
@property (retain) MultiDictionary* signers;
@property (retain) NSArray* keys;
@end


@implementation ConstitutionSignersViewController

@synthesize signers;
@synthesize keys;

- (void) dealloc {
  self.signers = nil;
  self.keys = nil;

  [super dealloc];
}


- (id) initWithSigners:(MultiDictionary*) signers_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.signers = signers_;
    self.title = NSLocalizedString(@"Signers", nil);

    self.keys = [signers.allKeys sortedArrayUsingSelector:@selector(compare:)];
  }

  return self;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return keys.count;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[signers objectsForKey:[keys objectAtIndex:section]] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  AutoResizingCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[AutoResizingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  Person* signer = [[signers objectsForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  cell.textLabel.text = signer.name;

  return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Person* signer = [[signers objectsForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

  [(id)self.navigationController pushBrowser:signer.link animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  return [keys objectAtIndex:section];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  Person* signer = [[signers objectsForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

  return [WrappableCell height:signer.name accessoryType:UITableViewCellAccessoryNone];
}

@end
