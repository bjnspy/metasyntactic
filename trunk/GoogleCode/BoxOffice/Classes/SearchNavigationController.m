//
//  SearchNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchNavigationController.h"
#import "SearchMovieDetailsViewController.h"
#import "SearchPersonDetailsViewController.h"

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
