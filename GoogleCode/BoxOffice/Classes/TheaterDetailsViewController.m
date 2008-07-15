//
//  TheaterDetailsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "TheaterDetailsViewController.h"

#import "Movie.h"
#import "BoxOfficeModel.h"
#import "TheatersNavigationController.h"
#import "TicketsViewController.h"
#import "MovieShowtimesCell.h"
#import "Application.h"
#import "Utilities.h"
#import "AutoresizingCell.h"
#import "ViewControllerUtilities.h"

#define SHOWTIMES_PER_ROW 6

@implementation TheaterDetailsViewController

@synthesize navigationController;
@synthesize theater;
@synthesize movies;
@synthesize movieShowtimes;
@synthesize segmentedControl;

- (void) dealloc {
    self.navigationController = nil;
    self.theater = nil;
    self.movies = nil;
    self.movieShowtimes = nil;
    self.segmentedControl = nil;
    
    [super dealloc];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (void) setFavoriteImage {
    UIImage* image = [self.model isFavoriteTheater:theater] ? [Application filledStarImage]
                                                            : [Application emptyStarImage];
    
    self.navigationItem.rightBarButtonItem.image = image;
}

- (void) switchFavorite:(id) sender {
    if ([self.model isFavoriteTheater:theater]) {
        [self.model removeFavoriteTheater:theater];
    } else {
        [self.model addFavoriteTheater:theater];
    }
    
    [self setFavoriteImage];
}

- (id) initWithNavigationController:(TheatersNavigationController*) controller
                            theater:(Theater*) theater_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.theater = theater_;
        self.navigationController = controller;
        
        self.movies = [self.model moviesAtTheater:theater];
        NSInteger (*sortFunction)(id, id, void *) =
            [self.model sortingMoviesByTitle] ? compareMoviesByTitle :
                                                ([self.model sortingMoviesByRating] ? compareMoviesByRating
                                                                                    : compareMoviesByReleaseDate);
        [self.movies sortUsingFunction:sortFunction context:self.model];    
        
        self.movieShowtimes = [NSMutableArray array];
        for (Movie* movie in self.movies) {
            NSArray* showtimes = [self.model movieShowtimes:movie forTheater:theater];
            
            [self.movieShowtimes addObject:showtimes];
        }
        
        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = self.theater.name;
         
        self.title = self.theater.name;
        self.navigationItem.titleView = label;
   
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[Application emptyStarImage]
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(switchFavorite:)] autorelease];
        [self setFavoriteImage];
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    [self.model setCurrentlySelectedMovie:nil theater:self.theater];
}

- (void) refresh {
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self.movies count] + 1;
}

- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        // theater address and possibly phone number
        return 1 + ([Utilities isNilOrEmpty:theater.phoneNumber] ? 0 : 1);
    }
    
    return 1;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        AutoresizingCell* cell = [[[AutoresizingCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.label.textColor = [Application commandColor];
        
        if (row == 0) {
            cell.label.text = self.theater.address;
        } else {
            cell.label.text = self.theater.phoneNumber;
        }
        
        return cell;
    } else {
        static NSString* reuseIdentifier = @"TheaterDetailsCellIdentifier";
        id i = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        MovieShowtimesCell* cell = i;
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setShowtimes:[self.movieShowtimes objectAtIndex:(section - 1)]];
        
        return cell;
    }
}

- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return nil;
    }
    
    Movie* movie = [self.movies objectAtIndex:(section - 1)];

    //return [NSString stringWithFormat:@"%@ (%@)", movie.title, movie.rating];
    
    return movie.title;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        return [tableView rowHeight];
    }
    
    NSInteger showtimesCount = [[self.movieShowtimes objectAtIndex:(section - 1)] count];
    NSInteger rows = showtimesCount / SHOWTIMES_PER_ROW;
    NSInteger remainder = showtimesCount % SHOWTIMES_PER_ROW;
    if (remainder > 0) {
        rows++;
    }
    
    return (rows * 14) + 18;
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        if (row == 0) {
            [Application openMap:theater.address];
        } else {
            [Application makeCall:theater.phoneNumber];
        }
    } else {    
        Movie* movie = [self.movies objectAtIndex:(section - 1)];    
        [self.navigationController  pushTicketsView:self.theater movie:movie animated:YES];
    }
}

@end