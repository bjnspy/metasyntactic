//
//  TheaterDetailsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TheaterDetailsViewController.h"

#import "Movie.h"
#import "BoxOfficeModel.h"
#import "TheatersNavigationController.h"

@implementation TheaterDetailsViewController

@synthesize navigationController;
@synthesize theater;
@synthesize movies;
@synthesize movieShowtimes;

- (void) dealloc {
    self.movies = nil;
    self.movieShowtimes = nil;
    self.navigationController = nil;
    self.theater = nil;
    [super dealloc];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (id) initWithNavigationController:(TheatersNavigationController*) controller
                            theater:(Theater*) theater_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.theater = theater_;
        self.navigationController = controller;
        self.movies = [NSMutableArray array];
        self.movieShowtimes = [NSMutableArray array];
        
        for (Movie* movie in [self.model moviesAtTheater:theater]) {
            NSArray* showtimes = [self.model movieShowtimes:movie forTheater:theater];
            
            [self.movies addObject:movie];
            [self.movieShowtimes addObject:showtimes];
        }
        
        /*
        NSMutableArray* mutableMovieNames = [NSMutableArray array];
        for (NSString* name in theater.movieToShowtimesMap)
        {
            [mutableMovieNames addObject:name];
        }
        self.movieNames = [mutableMovieNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        NSMutableArray* mutableMovieShowtimes = [NSMutableArray array];
        for (NSString* name in self.movieNames)
        {
            for (Movie* moie in self.model.movies) {
            
            [mutableMovieShowtimes addObject:[theater.movieToShowtimesMap valueForKey:name]];
        }
        self.movieShowtimes = mutableMovieShowtimes;
        */
         
        self.title = self.theater.name;
    }
    
    return self;
}

- (void) refresh
{
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView
{
    return [self.movies count] + 1;
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
    
    Movie* movie = [self.movies objectAtIndex:(section - 1)];
    return movie.title;
}

/*
- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}
 */

@end
