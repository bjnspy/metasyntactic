//
//  RatingsProviderViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RatingsProviderViewController.h"
#import "SettingsNavigationController.h"
#import "ApplicationTabBarController.h"

@implementation RatingsProviderViewController

@synthesize navigationController;
@synthesize controller;
@synthesize model;

- (void) dealloc {
    self.navigationController = nil;
    self.controller = nil;
    self.model = nil;
    
    [super dealloc];
}

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController_
                         controller:(BoxOfficeController*) controller_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.controller = controller_;
        self.model = [self.controller model];
    }
    
    return self;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    return [[self.model ratingsProviders] count];
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"RatingsProviderCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    // Configure the cell
    if (indexPath.row == [self.model ratingsProviderIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.text = [[self.model ratingsProviders] objectAtIndex:indexPath.row];
    
    return cell;
}

 - (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) selectPath {
     [self.tableView deselectRowAtIndexPath:selectPath animated:YES];
     
     for (int i = 0; i < [[self.model ratingsProviders] count]; i++) {
         NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
         UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];
         
         if ([cellPath isEqual:selectPath]) {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
         } else {
             cell.accessoryType = UITableViewCellAccessoryNone;
         }
     }
     
     [self.controller setRatingsProviderIndex:selectPath.row];
     [self.navigationController.tabBarController popNavigationControllers];
     [self.navigationController popViewControllerAnimated:YES];
 }
 

@end

