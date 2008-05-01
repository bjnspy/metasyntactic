//
//  BoxOfficeAppDelegate.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "BoxOfficeAppDelegate.h"

@implementation BoxOfficeAppDelegate

@synthesize window;
@synthesize application;

- (void) applicationDidFinishLaunching:(UIApplication*) app {
    self.application = app;
    
    tabBarController = [[ApplicationTabBarController alloc] initWithSettingsView:settingsView];
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}

- (void) dealloc {
    self.window = nil;
    self.application = nil;
	[super dealloc];
}

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section
{
    /*
    if (tableView == moviesTableView)
    {
        return 1;
    }
     */
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView*) tableView 
         cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    /*
    if (tableView == moviesTableView)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
        cell.text = @"my text value";
        return cell;
    }
     */
    
    return nil;
}

@end
