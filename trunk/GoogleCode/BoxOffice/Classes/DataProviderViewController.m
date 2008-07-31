//
//  DataProviderViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DataProviderViewController.h"
#import "SettingsNavigationController.h"
#import "ApplicationTabBarController.h"

@implementation DataProviderViewController

@synthesize navigationController;

- (void) dealloc {
    self.navigationController = nil;
    
    [super dealloc];
}

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
    }
    
    return self;
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (BoxOfficeController*) controller {
    return [self.navigationController controller];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    return self.model.dataProviders.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"DataProviderCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    // Configure the cell
    if (indexPath.row == [self.model dataProviderIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.text = [[self.model.dataProviders objectAtIndex:indexPath.row] displayName];
    
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
    
    [self.controller setDataProviderIndex:selectPath.row];
    [self.navigationController.tabBarController popNavigationControllersToRoot];
    [self.navigationController popViewControllerAnimated:YES];
}


@end

