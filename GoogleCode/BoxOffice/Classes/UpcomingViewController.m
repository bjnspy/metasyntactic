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

#import "UpcomingViewController.h"

#import "UpcomingNavigationController.h"

@implementation UpcomingViewController

@synthesize navigationController;
@synthesize segmentedControl;


- (void)dealloc {
    self.navigationController = nil;
    self.segmentedControl = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(UpcomingNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.title = NSLocalizedString(@"Upcoming", nil);
        
        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Title", nil),
                                   NSLocalizedString(@"Release", nil), nil]] autorelease];
        
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

        CGRect rect = segmentedControl.frame;
        rect.size.width = 240;
        segmentedControl.frame = rect;
        
        self.navigationItem.titleView = segmentedControl;
    }
    
    return self;
}


- (void) refresh {
    [self.tableView reloadData];
}


- (BoxOfficeModel*) model {
    return self.navigationController.model;
}


- (BoxOfficeController*) controller {
    return self.navigationController.controller;
}


@end
