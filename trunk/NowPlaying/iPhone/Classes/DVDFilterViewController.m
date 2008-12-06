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

#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "SettingsNavigationController.h"

@interface DVDFilterViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) id target;
@property SEL selector;
@end


@implementation DVDFilterViewController

@synthesize navigationController;
@synthesize target;
@synthesize selector;

- (void) dealloc {
    self.navigationController = nil;
    self.target = nil;
    self.selector = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                             target:(id) target_
                           selector:(SEL) selector_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.target = target_;
        self.selector = selector_;
        self.title = NSLocalizedString(@"DVD/Blu-ray", nil);
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
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    return 3;
}


- (void) setCheckmarkForCell:(UITableViewCell*) cell
                       atRow:(NSInteger) row {
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (row == 0) {
        if (self.model.dvdMoviesShowBoth) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if (row == 1) {
        if (self.model.dvdMoviesShowOnlyDVDs) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if (row == 2) {
        if (self.model.dvdMoviesShowOnlyBluray) {
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
        cell.text = NSLocalizedString(@"Both", @"Option for when the user wants both DVD and blu-ray");
    } else if (indexPath.row == 1) {
        cell.text = NSLocalizedString(@"DVD", nil);
    } else if (indexPath.row == 2) {
        cell.text = NSLocalizedString(@"Blu-ray", nil);
    }

    [self setCheckmarkForCell:cell atRow:indexPath.row];

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) selectPath {
    [self.tableView deselectRowAtIndexPath:selectPath animated:YES];

    if (selectPath.row == 0) {
        [self.model setDvdMoviesShowDVDs:YES];
        [self.model setDvdMoviesShowBluray:YES];
    } else if (selectPath.row == 1) {
        [self.model setDvdMoviesShowDVDs:YES];
        [self.model setDvdMoviesShowBluray:NO];
    } else {
        [self.model setDvdMoviesShowDVDs:NO];
        [self.model setDvdMoviesShowBluray:YES];
    }

    for (int i = 0; i <= 2; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];

        [self setCheckmarkForCell:cell atRow:i];
    }

    [NowPlayingAppDelegate majorRefresh:YES];

    [target performSelector:selector];
}

@end