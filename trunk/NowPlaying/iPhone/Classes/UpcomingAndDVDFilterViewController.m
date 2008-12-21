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

#import "UpcomingAndDVDFilterViewController.h"

#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "SettingsNavigationController.h"

@interface UpcomingAndDVDFilterViewController()
@property (assign) AbstractNavigationController* navigationController;
@end


@implementation UpcomingAndDVDFilterViewController

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


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 2;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}


- (void) setCheckmarkForCell:(UITableViewCell*) cell
                 atIndexPath:(NSIndexPath*) indexPath {
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.model.dvdMoviesShowDVDs) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        } else if (indexPath.row == 1) {
            if (self.model.dvdMoviesShowBluray) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    } else {
        if (self.model.upcomingAndDVDShowUpcoming) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}


- (void) setCheckmarkForIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self setCheckmarkForCell:cell atIndexPath:indexPath];
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

    [self setCheckmarkForCell:cell atIndexPath:indexPath];

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

    [self setCheckmarkForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self setCheckmarkForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [self setCheckmarkForIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];

    [NowPlayingAppDelegate majorRefresh:YES];
}

@end