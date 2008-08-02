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

#import "TheatersNavigationController.h"
#import "ApplicationTabBarController.h"
#import "TicketsViewController.h"

@implementation TheatersNavigationController

@synthesize allTheatersViewController;
@synthesize theaterDetailsViewController;
@synthesize tabBarController;

- (void) dealloc {
    self.allTheatersViewController = nil;
    self.theaterDetailsViewController = nil;
    self.tabBarController = nil;
    [super dealloc];
}

- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.allTheatersViewController = [[[AllTheatersViewController alloc] initWithNavigationController:self] autorelease];

        [self pushViewController:allTheatersViewController animated:NO];

        self.title = NSLocalizedString(@"Theaters", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"MostViewed.png"];
    }

    return self;
}

- (void) navigateToLastViewedPage {
    Theater* currentTheater = [self.model currentlySelectedTheater];
    if (currentTheater != nil) {
        [self pushTheaterDetails:currentTheater animated:NO];

        Movie* currentMovie = [self.model currentlySelectedMovie];
        if (currentMovie != nil) {
            [self pushTicketsView:currentTheater
                            movie:currentMovie
                         animated:NO];
        }
    }
}

- (void) refresh {
    [super refresh];
    [self.allTheatersViewController refresh];
    [self.theaterDetailsViewController refresh];
}

- (void) pushTheaterDetails:(Theater*) theater animated:(BOOL) animated {
    [self popToRootViewControllerAnimated:NO];

    self.theaterDetailsViewController = [[[TheaterDetailsViewController alloc] initWithNavigationController:self theater:theater] autorelease];

    [self pushViewController:theaterDetailsViewController animated:animated];
}

- (void) pushTicketsView:(Theater*) theater
                   movie:(Movie*) movie
                animated:(BOOL) animated {
    [self pushTicketsView:movie
                  theater:theater
                    title:movie.displayTitle
                 animated:animated];
}

@end
