// Copyright (C) 2008 Cyrus Najmabadi
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

#import "NumbersViewController.h"

#import "NowPlayingModel.h"
#import "NumbersNavigationController.h"
#import "SettingCell.h"

@implementation NumbersViewController

@synthesize navigationController;
@synthesize segmentedControl;

- (void) dealloc {
    self.navigationController = nil;
    self.segmentedControl = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(NumbersNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.title = NSLocalizedString(@"Numbers", nil);

        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Daily", nil),
                                   NSLocalizedString(@"Weekend", nil), nil]] autorelease];

        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.selectedSegmentIndex = [self.model allTheatersSelectedSegmentIndex];

        CGRect rect = segmentedControl.frame;
        rect.size.width = 240;
        segmentedControl.frame = rect;

        self.navigationItem.titleView = segmentedControl;
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self refresh];
}


- (void) refresh {
    [self.tableView reloadData];
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 3;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return 6;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"NumbersViewCellIdentifier";
    SettingCell* cell = nil;//(id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;

        if (indexPath.row >= 2) {
            UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, -1, 300, 2)] autorelease];
            label.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:label];
        }
    }

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setKey:@"Title" value:@"Dark Knight, The"];
        } else if (indexPath.row == 1) {
            [cell setKey:@"Days in Theater" value:@"24"];
        } else if (indexPath.row == 2) {
            [cell setKey:@"Weekend Gross" value:@"$26,117,030"];
        } else if (indexPath.row == 3) {
            [cell setKey:@"Change" value:@"-38.78%"];
        } else if (indexPath.row == 4) {
            [cell setKey:@"Theaters" value:@"4,025"];
        } else if (indexPath.row == 5) {
            [cell setKey:@"Total Gross" value:@"$441,628,497"];
        }
    } else {
        if (indexPath.row == 0) {
            [cell setKey:@"Title" value:@"Mummy"];
        } else if (indexPath.row == 1) {
            [cell setKey:@"Days in Theater" value:@"10"];
        } else if (indexPath.row == 2) {
            [cell setKey:@"Weekend Gross" value:@"$16,490,970"];
        } else if (indexPath.row == 3) {
            [cell setKey:@"Change" value:@"-59.24%"];
        } else if (indexPath.row == 4) {
            [cell setKey:@"Theaters" value:@"3,778"];
        } else if (indexPath.row == 5) {
            [cell setKey:@"Total Gross" value:@"$71,048,920"];
        }
    }

    return cell;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        return tableView.rowHeight;
    }

    return tableView.rowHeight - 16;
}


@end