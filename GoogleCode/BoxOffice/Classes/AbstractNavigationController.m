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

#import "AbstractNavigationController.h"
#import "ApplicationTabBarController.h"
#import "TicketsViewController.h"

@implementation AbstractNavigationController

@synthesize tabBarController;
@synthesize ticketsViewController;

- (void) dealloc {
    self.tabBarController = nil;
    self.ticketsViewController = nil;

    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super init]) {
        self.tabBarController = controller;
    }

    return self;
}

- (void) refresh {
    [self.ticketsViewController refresh];
}

- (BoxOfficeModel*) model {
    return [self.tabBarController model];
}

- (BoxOfficeController*) controller {
    return [self.tabBarController controller];
}

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated {
    self.ticketsViewController =
    [[[TicketsViewController alloc] initWithController:self
                                               theater:theater
                                                 movie:movie
                                                 title:title] autorelease];

    [self pushViewController:ticketsViewController animated:animated];
}

- (void) navigateToLastViewedPage {
}

@end
