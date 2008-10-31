//
//  DVDNavigationController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 10/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DVDNavigationController.h"

#import "Movie.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "NowPlayingModel.h"

@implementation DVDNavigationController

@synthesize dvdViewController;

- (void) dealloc {
    self.dvdViewController = nil;

    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.title = NSLocalizedString(@"DVD", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"DVD.png"];
    }

    return self;
}


- (void) loadView {
    [super loadView];
    self.dvdViewController = [[[DVDViewController alloc] initWithNavigationController:self] autorelease];
    [self pushViewController:dvdViewController animated:NO];
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
    for (Movie* movie in self.model.dvdCache.allMovies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            return movie;
        }
    }

    return [super movieForTitle:canonicalTitle];
}

@end