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

#import "AbstractNavigationController.h"

#import "ApplicationTabBarController.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "NowPlayingModel.h"
#import "PostersViewController.h"
#import "ReviewsViewController.h"
#import "SearchViewController.h"
#import "Theater.h"
#import "TheaterDetailsViewController.h"
#import "TicketsViewController.h"

@interface AbstractNavigationController()
@property (assign) ApplicationTabBarController* tabBarController;
@property (retain) SearchViewController* searchViewController;
@property (retain) PostersViewController* postersViewController;
@property BOOL visible;
@end


@implementation AbstractNavigationController

@synthesize tabBarController;
@synthesize searchViewController;
@synthesize postersViewController;
@synthesize visible;

- (void) dealloc {
    self.tabBarController = nil;
    self.searchViewController = nil;
    self.postersViewController = nil;

    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super init]) {
        self.tabBarController = controller;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    viewLoaded = YES;
    self.view.autoresizesSubviews = YES;
}


- (void) refreshWithSelector:(SEL) selector {
    if (!viewLoaded || !visible) {
        return;
    }
    
    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:selector]) {
            [controller performSelector:selector];
        }
    }
}


- (void) majorRefresh {
    [self refreshWithSelector:@selector(majorRefresh)];
}


- (void) minorRefresh {
    [self refreshWithSelector:@selector(minorRefresh)];
}


- (void) viewDidAppear:(BOOL)animated {
    visible = YES;
}


- (void) viewDidDisappear:(BOOL)animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (visible || postersViewController != nil) {
        return;
    }

    [self popToRootViewControllerAnimated:NO];
    [super didReceiveMemoryWarning];
}


- (NowPlayingModel*) model {
    return tabBarController.model;
}


- (NowPlayingController*) controller {
    return tabBarController.controller;
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
    for (Movie* movie in self.model.movies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            return movie;
        }
    }

    return nil;
}


- (Theater*) theaterForName:(NSString*) name {
    for (Theater* theater in self.model.theaters) {
        if ([theater.name isEqual:name]) {
            return theater;
        }
    }

    return nil;
}


- (void) navigateToLastViewedPage {
    NSArray* types = self.model.navigationStackTypes;
    NSArray* values = self.model.navigationStackValues;

    for (int i = 0; i < types.count; i++) {
        NSInteger type = [[types objectAtIndex:i] intValue];
        id value = [values objectAtIndex:i];

        if (type == MovieDetails) {
            Movie* movie = [self movieForTitle:value];
            [self pushMovieDetails:movie animated:NO];
        } else if (type == TheaterDetails) {
            Theater* theater = [self theaterForName:value];
            [self pushTheaterDetails:theater animated:NO];
        } else if (type == Reviews) {
            Movie* movie = [self movieForTitle:value];
            [self pushReviewsView:movie animated:NO];
        } else if (type == Tickets) {
            Movie* movie = [self movieForTitle:[value objectAtIndex:0]];
            Theater* theater = [self theaterForName:[value objectAtIndex:1]];
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
    if (movie == nil) {
        return;
    }

    UIViewController* viewController = [[[MovieDetailsViewController alloc] initWithNavigationController:self
                                                                                                   movie:movie] autorelease];

    [self pushViewController:viewController animated:animated];
}


- (void) pushTheaterDetails:(Theater*) theater animated:(BOOL) animated {
    if (theater == nil) {
        return;
    }

    UIViewController* viewController = [[[TheaterDetailsViewController alloc] initWithNavigationController:self
                                                                                                   theater:theater] autorelease];

    [self pushViewController:viewController animated:animated];
}


- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated {
    if (movie == nil || theater == nil) {
        return;
    }

    UIViewController* viewController = [[[TicketsViewController alloc] initWithController:self
                                                                                  theater:theater
                                                                                    movie:movie
                                                                                    title:title] autorelease];

    [self pushViewController:viewController animated:animated];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return postersViewController == nil;
}


- (void) showSearchView {
    if (searchViewController == nil) {
        self.searchViewController = [[[SearchViewController alloc] initWithNavigationController:self] autorelease];
    }

    [self presentModalViewController:searchViewController animated:YES];
    [searchViewController onShow];
}


- (void) hideSearchView {
    [searchViewController onHide];
    [self dismissModalViewControllerAnimated:YES];
}


- (void) hidePostersView {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self dismissModalViewControllerAnimated:YES];
    self.postersViewController = nil;
}


- (void) showPostersView:(Movie*) movie posterCount:(NSInteger) posterCount {
    if (postersViewController != nil) {
        [self hidePostersView];
    }

    self.postersViewController =
    [[[PostersViewController alloc] initWithNavigationController:self
                                                          movie:movie
                                                    posterCount:posterCount] autorelease];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [self presentModalViewController:postersViewController animated:YES];
}

@end