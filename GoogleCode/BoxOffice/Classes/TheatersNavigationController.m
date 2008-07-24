//
//  TheatersNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

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
    Theater* currentTheater = [[self model] currentlySelectedTheater];
    if (currentTheater != nil) {
        [self pushTheaterDetails:currentTheater animated:NO];
        
        Movie* currentMovie = [[self model] currentlySelectedMovie];
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
                    title:movie.title
                 animated:animated];
}

@end
