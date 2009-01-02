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

#import "DVDFilterViewController.h"

#import "MetaFlixAppDelegate.h"
#import "MetaFlixModel.h"
#import "SettingsNavigationController.h"

@interface DVDFilterViewController()
@property (assign) AbstractNavigationController* navigationController;
@end


@implementation DVDFilterViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"Settings", nil);
    }

    return self;
}


- (MetaFlixModel*) model {
    return navigationController.model;
}


- (MetaFlixController*) controller {
    return navigationController.controller;
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
        if (self.model.dvdMoviesShowDVDs) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if (row == 1) {
        if (self.model.dvdMoviesShowBluray) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"DVDFilterCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }

    if (indexPath.row == 0) {
        cell.text = NSLocalizedString(@"DVD", nil);
    } else if (indexPath.row == 1) {
        cell.text = NSLocalizedString(@"Blu-ray", nil);
    }

    [self setCheckmarkForCell:cell atRow:indexPath.row];

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) selectPath {
    [self.tableView deselectRowAtIndexPath:selectPath animated:YES];

    if (selectPath.row == 0) {
        [self.model setDvdMoviesShowDVDs:!self.model.dvdMoviesShowDVDs];
    } else {
        [self.model setDvdMoviesShowBluray:!self.model.dvdMoviesShowBluray];
    }

    for (int i = 0; i <= 1; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];

        [self setCheckmarkForCell:cell atRow:i];
    }

    [MetaFlixAppDelegate majorRefresh:YES];
}

@end