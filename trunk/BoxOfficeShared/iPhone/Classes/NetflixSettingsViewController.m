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

#import "NetflixSettingsViewController.h"

@implementation NetflixSettingsViewController

- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
  }

  return self;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 2;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
//  if (section == 0) {
//    return 1;
//  } else if (section == 1) {
//    return 0;
//    return [Model model].netflixPreferredFormats.count;
//  }

  return 0;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

//  if (indexPath.section == 0) {
//    cell.textLabel.text = LocalizedString(@"Instant Watch", nil);
//    UISwitch* switch_ = [[[UISwitch alloc] init] autorelease];
//    switch_.enabled = NO;
//    switch_.on = [Model model].netflixCanInstantWatch;
//    cell.accessoryView = switch_;
//  } else {
//    cell.textLabel.text = [[Model model].netflixPreferredFormats objectAtIndex:indexPath.row];
//  }

  return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section == 1) {
    return LocalizedString(@"Preferred Formats", @"The preferred movie format that the user has.  i.e. DVD or Bluray");
  }

  return nil;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
  if (section == 1) {
    return LocalizedString(@"Currently, settings can only be modified from Netflix's website", nil);
  }

  return nil;
}

@end
