//
//  TheatersNavigationController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TheatersNavigationController.h"


@implementation TheatersNavigationController

@synthesize allTheatersViewController;
@synthesize theaterDetailsViewController;

- (id) init
{
    if (self = [super init])
    {
        self.title = @"Theaters";
        
        self.allTheatersViewController = [[AllTheatersViewController alloc] init];
        self.theaterDetailsViewController = [[TheaterDetailsViewController alloc] init];
        
        [self pushViewController:allTheatersViewController animated:NO];
    }
    
    return self;
}

- (void) dealloc
{
    self.allTheatersViewController = nil;
    self.theaterDetailsViewController = nil;
    [super dealloc];
}

@end
