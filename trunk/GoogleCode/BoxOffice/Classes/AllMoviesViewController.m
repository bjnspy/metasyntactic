//
//  AllMoviesViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllMoviesViewController.h"
#import "MoviesNavigationController.h"
#import "Movie.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"

@implementation AllMoviesViewController

@synthesize navigationController;

- (id) initWithNavigationController:(MoviesNavigationController*) controller
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        self.title = @"All Movies";
        self.navigationController = controller;
                
        UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"        Title        ", @"        Rating        ", nil]] autorelease];
        control.segmentedControlStyle = UISegmentedControlStyleBar;
        self.navigationItem.customTitleView = control;
    }
    
    return self;
}

- (void) dealloc
{
    self.view = nil;
    self.navigationController = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model
{
    return [self.navigationController model];
}

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section
{
    return [self.model.movies count];
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    Movie* movie = [self.model.movies objectAtIndex:[indexPath indexAtPosition:1]];
    cell.text = movie.title;
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
    [self.navigationController pushMovieDetails:[self.model.movies objectAtIndex:[newIndexPath indexAtPosition:1]]];
}

- (void) refresh
{
    [self.tableView reloadData];
}

@end
