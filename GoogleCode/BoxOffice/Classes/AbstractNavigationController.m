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

#import "AbstractNavigationController.h"

#import "ApplicationTabBarController.h"
#import "BoxOfficeModel.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "ReviewsViewController.h"
#import "Theater.h"
#import "TheaterDetailsViewController.h"
#import "TicketsViewController.h"

@implementation AbstractNavigationController

@synthesize tabBarController;

- (void) dealloc {
    self.tabBarController = nil;

    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super init]) {
        self.tabBarController = controller;
        self.view.autoresizesSubviews = YES;
    }

    return self;
}


- (void) refresh {
    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(refresh)]) {
            [controller refresh];
        }
    }
}


- (BoxOfficeModel*) model {
    return self.tabBarController.model;
}


- (BoxOfficeController*) controller {
    return self.tabBarController.controller;
}


- (void) navigateToLastViewedPage {
    NSArray* types = self.model.navigationStackTypes;
    NSArray* values = self.model.navigationStackValues;

    for (int i = 0; i < types.count; i++) {
        NSInteger type = [[types objectAtIndex:i] intValue];
        id value = [values objectAtIndex:i];

        if (type == MovieDetails) {
            Movie* movie = [Movie movieWithDictionary:value];
            [self pushMovieDetails:movie animated:NO];
        } else if (type == TheaterDetails) {
            Theater* theater = [Theater theaterWithDictionary:value];
            [self pushTheaterDetails:theater animated:NO];
        } else if (type == Reviews) {
            Movie* movie = [Movie movieWithDictionary:value];
            [self pushReviewsView:movie animated:NO];
        } else if (type == Tickets) {
            Movie* movie = [Movie movieWithDictionary:[value objectAtIndex:0]];
            Theater* theater = [Theater theaterWithDictionary:[value objectAtIndex:1]];
            NSString* title = [value objectAtIndex:2];

            [self pushTicketsView:movie theater:theater title:title animated:NO];
        }
    }
}


- (void) pushReviewsView:(Movie*) movie animated:(BOOL) animated {
    ReviewsViewController* controller = [[[ReviewsViewController alloc] initWithNavigationController:self
                                                                                              movie:movie] autorelease];

    [self pushViewController:controller animated:animated];
}


- (void) pushMovieDetails:(Movie*) movie
                 animated:(BOOL) animated {
    UIViewController* viewController = [[[MovieDetailsViewController alloc] initWithNavigationController:self
                                                                                                   movie:movie] autorelease];

    [self pushViewController:viewController animated:animated];
}


- (void) pushTheaterDetails:(Theater*) theater animated:(BOOL) animated {
    UIViewController* viewController = [[[TheaterDetailsViewController alloc] initWithNavigationController:self
                                                                                                   theater:theater] autorelease];

    [self pushViewController:viewController animated:animated];
}


- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated {
    UIViewController* viewController = [[[TicketsViewController alloc] initWithController:self
                                                                                  theater:theater
                                                                                    movie:movie
                                                                                    title:title] autorelease];
    
    [self pushViewController:viewController animated:animated];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


@end
