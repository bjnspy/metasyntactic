//
//  iAmazonAppDelegate.m
//  iAmazon
//
//  Created by Cyrus Najmabadi on 3/6/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iAmazonAppDelegate.h"
#import "MyView.h"

@implementation iAmazonAppDelegate

@synthesize window;
@synthesize contentView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	// Create window
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Set up content view
	self.contentView = [[[MyView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	[window addSubview:contentView];
    
	// Show window
	[window makeKeyAndVisible];
}

- (void)dealloc {
	[contentView release];
	[window release];
	[super dealloc];
}

@end
