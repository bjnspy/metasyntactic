//
//  NetflixNavigationController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixNavigationController.h"

#import "NetflixViewController.h"

@interface NetflixNavigationController()
@property (retain) NetflixViewController* netflixViewController;
@end


@implementation NetflixNavigationController

@synthesize netflixViewController;

- (void) dealloc {
    self.netflixViewController = nil;
    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.tabBarItem.image = [UIImage imageNamed:@"DVD.png"];
        self.title = NSLocalizedString(@"Netflix", nil);
    }
    
    return self;
}


- (void) loadView {
    [super loadView];
    
    if (netflixViewController == nil) {
        self.netflixViewController = [[[NetflixViewController alloc] initWithNavigationController:self] autorelease];
        [self pushViewController:netflixViewController animated:NO];
    }
}

@end