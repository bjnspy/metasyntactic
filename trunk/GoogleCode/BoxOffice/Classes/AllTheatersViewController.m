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
@synthesize tableView;

- (id) initWithNavigationController:(TheatersNavigationController*) controller
{
    if (self = [super init])
    {
        self.title = @"All Theaters";
        
        self.navigationController = controller;
        
        self.tableView = [[[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.view = self.tableView;
    }
    
    return self;
}

- (void) dealloc
{
    self.view = nil;
    self.tableView = nil;
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
    Theater* movie = [self.model.theaters objectAtIndex:[indexPath indexAtPosition:1]];
    cell.text = movie.name;
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
    //[self.model.movies objectAtIndex:[newIndexPath indexAtPosition:1]]
    [self.navigationController pushTheaterDetails:nil];
}

@end
