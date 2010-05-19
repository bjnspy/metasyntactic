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

#import "DVDFilterViewController.h"

#import "Controller.h"
#import "Model.h"

@implementation DVDFilterViewController

- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = LocalizedString(@"Settings", nil);
  }

  return self;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 1;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
  return 2;
}


- (void) setCheckmarkForCell:(UITableViewCell*) cell
                       atRow:(NSInteger) row {
  cell.accessoryType = UITableViewCellAccessoryNone;

  if (row == 0) {
    if ([Model model].dvdMoviesShowDVDs) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  } else if (row == 1) {
    if ([Model model].dvdMoviesShowBluray) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }

  if (indexPath.row == 0) {
    cell.textLabel.text = LocalizedString(@"DVD", nil);
  } else if (indexPath.row == 1) {
    cell.textLabel.text = LocalizedString(@"Blu-ray", nil);
  }

  [self setCheckmarkForCell:cell atRow:indexPath.row];

  return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) selectPath {
  [self.tableView deselectRowAtIndexPath:selectPath animated:YES];

  if (selectPath.row == 0) {
    [[Controller controller] setDvdMoviesShowDVDs:![Model model].dvdMoviesShowDVDs];
  } else {
    [[Controller controller] setDvdMoviesShowBluray:![Model model].dvdMoviesShowBluray];
  }

  for (NSInteger i = 0; i <= 1; i++) {
    NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];

    [self setCheckmarkForCell:cell atRow:i];
  }
}

@end
