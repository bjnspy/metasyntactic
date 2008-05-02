//
//  MovieDetailsViewController.m
//  BoxOffice
// 
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailsViewController.h"

@implementation MovieDetailsViewController

@synthesize navigationController;

- (id) initWithNavigationController:(MoviesNavigationController*) controller
{
    if (self = [super init])
    {
        self.title = @"Movie Details";
        self.navigationController = controller;
        
        UIView* view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        self.view = view;
    }
    
    return self;
}

- (void) dealloc
{
    self.view = nil;
    self.navigationController = nil;
    [super dealloc];
}

- (void) refresh
{
}

@end
