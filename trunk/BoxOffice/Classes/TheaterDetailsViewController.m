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
#import "TicketsViewController.h"
#import "MovieShowtimesCell.h"
#import "Application.h"

#define SHOWTIMES_PER_ROW 6

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
        
        self.title = self.theater.name;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
}

- (void) refresh {
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self.movies count] + 1;
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return 1;
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
        
        label.textAlignment = UITextAlignmentCenter;
        label.text = self.theater.address;
        label.textColor = [Application lightBlueTextColor];
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.adjustsFontSizeToFitWidth = YES;
        
        [cell.contentView addSubview:label];
        return cell;
    } else {
        return [MovieShowtimesCell cellWithShowtimes:[self.movieShowtimes objectAtIndex:(section - 1)]];
    }
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return @"Address";
    }
    
    Movie* movie = [self.movies objectAtIndex:(section - 1)];
    return movie.title;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0 && row == 0) {
        return [tableView rowHeight];
    }
    
    NSInteger showtimesCount = [[self.movieShowtimes objectAtIndex:(section - 1)] count];
    NSInteger rows = showtimesCount / SHOWTIMES_PER_ROW;
    NSInteger remainder = showtimesCount % SHOWTIMES_PER_ROW;
    if (remainder > 0) {
        rows++;
    }
    
    return (rows * 14) + 18;
    
//    return 32;
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = [indexPath section];
    if (section == 0) {
        return;
    }
    
    Movie* movie = [self.movies objectAtIndex:(section - 1)];    
    
    TicketsViewController* controller =
    [[[TicketsViewController alloc] initWithController:self.navigationController
                                               theater:self.theater
                                                 movie:movie 
                                                 title:movie.title] autorelease];
    [self.navigationController pushViewController:controller
     animated:YES];
}

@end