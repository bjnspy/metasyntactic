//
//  AllTheatersViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllTheatersViewController.h"
#import "TheatersNavigationController.h"
#import "Theater.h"

@implementation AllTheatersViewController

@synthesize navigationController;

- (id) initWithNavigationController:(TheatersNavigationController*) controller
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        self.title = @"All Theaters";
        
        self.navigationController = controller;
    }
    
    return self;
}

- (void) dealloc
{
    self.navigationController = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model
{
    return [self.navigationController model];
}

- (void) refresh
{
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section
{
    return [self.model.theaters count];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    Theater* theater = [self.model.theaters objectAtIndex:[indexPath indexAtPosition:1]];
    cell.text = theater.name;
    return cell;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)                     tableView:(UITableView*) tableView
         selectionDidChangeToIndexPath:(NSIndexPath*) newIndexPath
                         fromIndexPath:(NSIndexPath*) oldIndexPath
{
    Theater* theater = [self.model.theaters objectAtIndex:[newIndexPath indexAtPosition:1]];
    [self.navigationController pushTheaterDetails:theater];
}

@end
