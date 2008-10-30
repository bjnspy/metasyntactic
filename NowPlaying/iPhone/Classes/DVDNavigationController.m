//
//  DVDNavigationController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 10/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DVDNavigationController.h"

#import "DVDViewController.h"

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

@end
