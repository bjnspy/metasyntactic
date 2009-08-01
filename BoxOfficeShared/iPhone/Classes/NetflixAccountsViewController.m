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

#import "NetflixAccountsViewController.h"

#import "Controller.h"
#import "Model.h"

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


- (Controller*) controller {
  return [Controller controller];
}


- (Model*) model {
  return [Model model];
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
  self.accounts = [NSMutableArray arrayWithArray:self.model.netflixAccounts];
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
    NetflixUser* user = [self.model.netflixCache userForAccount:account];

    if (user == nil) {
      cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"Account #%d", nil), indexPath.row + 1];
    } else {
      cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    }
    if ([account isEqual:self.model.currentNetflixAccount]) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  } else {
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [ColorCache commandColor];
    if (indexPath.row == 0) {
      cell.textLabel.text = LocalizedString(@"Add New Account", nil);
    } else {
      cell.textLabel.text = LocalizedString(@"Remove Account", nil);
    }
  }

  return cell;
}


- (void) didSelectAccountRow:(NSInteger) row {
  NetflixAccount* account = [accounts objectAtIndex:row];

  [self.controller setCurrentNetflixAccount:account];

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
    [self.controller removeNetflixAccount:account];
    [accounts removeObjectAtIndex:row];

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationRight];

    if (accounts.count == 0) {
      [self onDone:nil];
    }
  }
}


@end
