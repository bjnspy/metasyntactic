//
//  TheaterDetailsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TheaterDetailsViewController.h"


@implementation TheaterDetailsViewController

@synthesize navigationController;
@synthesize theater;
@synthesize movieNames;
@synthesize movieShowtimes;

- (id) initWithNavigationController:(TheatersNavigationController*) controller
                            theater:(Theater*) theater_
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.theater = theater_;
        self.navigationController = controller;
        self.movieNames = [NSMutableArray array];
        self.movieShowtimes = [NSMutableArray array];
        
        NSMutableArray* mutableMovieNames = [NSMutableArray array];
        for (NSString* name in theater.movieToShowtimesMap)
        {
            [mutableMovieNames addObject:name];
        }
        self.movieNames = [mutableMovieNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSMutableArray* mutableMovieShowtimes = [NSMutableArray array];
        for (NSString* name in self.movieNames)
        {
            [mutableMovieShowtimes addObject:[theater.movieToShowtimesMap valueForKey:name]];
        }
        self.movieShowtimes = mutableMovieShowtimes;
        
        self.title = self.theater.name;
    }
    
    return self;
}

- (void) dealloc
{
    self.movieNames = nil;
    self.movieShowtimes = nil;
    self.navigationController = nil;
    self.theater = nil;
    [super dealloc];
}

- (void) refresh
{
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView
{
    return [self.movieNames count] + 1;
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section
{
    if (section == 0)
    {
        return 1;
    }
    
    return [[self.movieShowtimes objectAtIndex:(section - 1)] count];
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0)
    {
        cell.text = self.theater.address;
    }
    else
    {
        cell.text = [[self.movieShowtimes objectAtIndex:(section - 1)] objectAtIndex:row];
    }
    
    return cell;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section
{
    if (section == 0)
    {
        return @"Address";
    }
    
    return [self.movieNames objectAtIndex:(section - 1)];
}

/*
- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}
 */

@end
