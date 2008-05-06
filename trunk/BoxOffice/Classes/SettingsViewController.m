//
//  SettingsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"

@implementation SettingsViewController

@synthesize navigationController;
@synthesize currentLocationItem;
@synthesize activityIndicator;

- (void) dealloc
{
    self.navigationController = nil;
    self.currentLocationItem = nil;
    self.activityIndicator = nil;
    [super dealloc];
}

- (id) initWithNavigationController:(SettingsNavigationController*) controller
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.title = @"Settings";
        self.navigationController = controller;
        
        currentLocationItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(onCurrentLocationClicked:)] autorelease]; 

        self.navigationItem.customLeftItem = currentLocationItem;
        
    }
    
    return self;
}

- (void) onCurrentLocationClicked:(id) sender
{
    self.activityIndicator = [[[ActivityIndicator alloc] initWithNavigationItem:self.navigationItem] autorelease];
    [self.activityIndicator start];
}

- (BoxOfficeModel*) model
{
    return [self.navigationController model];
}

- (void) refresh
{
    [self.tableView reloadData];
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section
{
    return 2;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    NSInteger index = [indexPath indexAtPosition:1];
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    
    if (index == 0)
    {
        cell.text = [NSString stringWithFormat:@"Zipcode: %@", [[self model] zipcode]];
    }
    else if (index == 1)
    {
        cell.text = [NSString stringWithFormat:@"Search radius: %d miles", [[self model] searchRadius]];
    }
    
    return cell;
}

@end
