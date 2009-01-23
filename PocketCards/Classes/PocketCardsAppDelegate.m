//
//  PocketCardsAppDelegate.m
//  PocketCards
//
//  Created by Cyrus Najmabadi on 1/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "PocketCardsAppDelegate.h"

@implementation PocketCardsAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
