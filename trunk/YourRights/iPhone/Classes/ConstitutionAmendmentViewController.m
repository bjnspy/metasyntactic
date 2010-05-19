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

#import "ConstitutionAmendmentViewController.h"

#import "Amendment.h"
#import "Section.h"
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
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.amendment = amendment_;
  }

  return self;
}


- (void) loadView {
  [super loadView];
  self.title = amendment.synopsis;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
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
    cell.textLabel.text = @"Wikipedia";
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
