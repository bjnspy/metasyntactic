//
//  YourRightsNavigationController.m
//  YourRights
//
//  Created by Cyrus Najmabadi on 1/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YourRightsNavigationController.h"

#import "SectionViewController.h"

@interface YourRightsNavigationController()
@property (retain) SectionViewController* viewController;
@end

@implementation YourRightsNavigationController

@synthesize viewController;

- (void) dealloc {
    self.viewController = nil;
    
    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        self.viewController = [[[SectionViewController alloc] init] autorelease];
        [self pushViewController:viewController animated:NO];
    }
    
    return self;
}

@end
