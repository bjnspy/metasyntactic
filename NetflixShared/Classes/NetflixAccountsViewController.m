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

#import "NetflixAccountsViewController.h"

#import "NetflixAccount.h"
#import "NetflixAccountCache.h"
#import "NetflixLoginViewController.h"
#import "NetflixSharedApplication.h"
#import "NetflixUser.h"
#import "NetflixUserCache.h"

@interface NetflixAccountsViewController()
@property (retain) NSMutableArray* accounts;
@end


@implementation NetflixAccountsViewController

@synthesize accounts;

- (void) dealloc {
  self.accounts = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = LocalizedString(@"Accounts", nil);
  }
  return self;
}


- (void) majorRefresh {
  // do *NOT* remove this.  It prevents us from refreshing while the user is
  // typeing and causing nasty crashes.
}


- (void) minorRefresh {
  // do *NOT* remove this.  It prevents us from refreshing while the user is
  // typeing and causing nasty crashes.
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  self.accounts = [NSMutableArray arrayWithArray:[[NetflixAccountCache cache] accounts]];
}


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];
  [super majorRefresh];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 2;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
  if (section == 0) {
    return accounts.count;
  } else {
    if (self.editing) {
      return 0;
    } else {
      return 2;
    }
  }
}


- (BOOL)          tableView:(UITableView*) tableView
       canEditRowAtIndexPath:(NSIndexPath*) indexPath {
  return tableView.editing && indexPath.section == 0;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  if (indexPath.section == 0) {
    NetflixAccount* account = [accounts objectAtIndex:indexPath.row];
    NetflixUser* user = [[NetflixUserCache cache] userForAccount:account];

    if (user == nil) {
      cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"Account #%d", nil), indexPath.row + 1];
    } else {
      cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    }
    if ([account isEqual:[[NetflixAccountCache cache] currentAccount]]) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  } else {
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [ColorCache commandColor];
    if (indexPath.row == 0) {
      cell.textLabel.text = LocalizedString(@"Add Existing Account / Profile", nil);
    } else {
      cell.textLabel.text = LocalizedString(@"Remove Account / Profile", nil);
    }
  }

  return cell;
}


- (void) didSelectAccountRow:(NSInteger) row {
  NetflixAccount* account = [accounts objectAtIndex:row];

  [[NetflixAccountCache cache] setCurrentAccount:account];

  for (NSInteger i = 0; i < accounts.count; i++) {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    if (i == row) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  }
}


- (void) didSelectAddAccountRow {
  UIViewController* controller = [[[NetflixLoginViewController alloc] init] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (void) setupButton {
  UIBarButtonItem* item = nil;
  if (self.tableView.editing) {
    item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)] autorelease];
  }
  [self.navigationItem setRightBarButtonItem:item animated:YES];
}


- (void) onButtonTapped:(UITableViewRowAnimation) animation {
  [self setupButton];

  [self.tableView beginUpdates];
  {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]
     withRowAnimation:animation];
  }
  [self.tableView endUpdates];
}


- (void) didSelectRemoveAccountRow {
  [self setEditing:YES animated:YES];
  [self onButtonTapped:UITableViewRowAnimationFade];
}


- (void) onDone:(id) sender {
  [self setEditing:NO animated:YES];
  [self onButtonTapped:UITableViewRowAnimationFade];
}


- (void) didSelectActionRow:(NSInteger) row {
  if (row == 0) {
    [self didSelectAddAccountRow];
  } else {
    [self didSelectRemoveAccountRow];
  }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 0) {
    [self didSelectAccountRow:indexPath.row];
  } else {
    [self didSelectActionRow:indexPath.row];
  }
}


- (void)       tableView:(UITableView*) tableView
      commitEditingStyle:(UITableViewCellEditingStyle) editingStyle
       forRowAtIndexPath:(NSIndexPath*) indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSInteger row = indexPath.row;
    NetflixAccount* account = [accounts objectAtIndex:row];
    [[NetflixAccountCache cache] removeAccount:account];
    [accounts removeObjectAtIndex:row];

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationRight];

    if (accounts.count == 0) {
      [self onDone:nil];
    }
  }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
  if (!self.editing) {
    if (section == 1) {
      return LocalizedString(@"Usernames and passwords for your additional profiles can be found on Netflix.com under:\n\nYour Account & Help\nAccount profiles\nEdit\nSign In Name", nil);
    }
  }

  return nil;
}

@end
