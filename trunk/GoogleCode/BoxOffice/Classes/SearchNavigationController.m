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

#import "SearchNavigationController.h"

#import "SearchMovieDetailsViewController.h"
#import "SearchPersonDetailsViewController.h"
#import "SearchStartPageViewController.h"

@implementation SearchNavigationController

@synthesize startPageViewController;

- (void) dealloc {
    self.startPageViewController = nil;
    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.startPageViewController = [[[SearchStartPageViewController alloc] initWithNavigationController:self] autorelease];

        [self pushViewController:startPageViewController animated:NO];

        self.title = @"IMDb";
        self.tabBarItem.image = [UIImage imageNamed:@"Search.png"];
    }

    return self;
}

- (void) pushMovieDetails:(XmlElement*) movieElement
                 animated:(BOOL) animated {
    SearchMovieDetailsViewController* controller =
    [[[SearchMovieDetailsViewController alloc] initWithNavigationController:self
                                                               movieDetails:movieElement] autorelease];

    [self pushViewController:controller animated:YES];
}

- (void) pushPersonDetails:(XmlElement*) personElement
                  animated:(BOOL) animated {
    SearchPersonDetailsViewController* controller =
    [[[SearchPersonDetailsViewController alloc] initWithNavigationController:self
                                                               personDetails:personElement] autorelease];

    [self pushViewController:controller animated:YES];
}

@end
