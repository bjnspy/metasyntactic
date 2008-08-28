// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "RatingsProviderViewController.h"

#import "ApplicationTabBarController.h"
#import "BoxOfficeModel.h"
#import "SettingsNavigationController.h"

@implementation RatingsProviderViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(SettingsNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"Reviews", nil);
    }

    return self;
}


- (BoxOfficeModel*) model {
    return self.navigationController.model;
}


- (BoxOfficeController*) controller {
    return self.navigationController.controller;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    return self.model.ratingsProviders.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"RatingsProviderCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    // Configure the cell
    if (indexPath.row == [self.model ratingsProviderIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.text = [[self.model ratingsProviders] objectAtIndex:indexPath.row];
    return cell;
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) selectPath {
    [self.tableView deselectRowAtIndexPath:selectPath animated:YES];

    for (int i = 0; i < self.model.ratingsProviders.count; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];

        if ([cellPath isEqual:selectPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    [self.controller setRatingsProviderIndex:selectPath.row];
    [self.navigationController.tabBarController popNavigationControllersToRoot];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
