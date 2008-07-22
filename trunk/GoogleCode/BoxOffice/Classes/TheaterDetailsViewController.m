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
#import "AttributeCell.h"
#import "MovieTitleCell.h"
#import "ApplicationTabBarController.h"
#import "ImageCache.h"

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
    UIImage* image = [self.model isFavoriteTheater:theater] ? [ImageCache filledStarImage]
                                                            : [ImageCache emptyStarImage];
    
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
        NSInteger (*sortFunction)(id, id, void *) = compareMoviesByTitle;
        /*
            [self.model sortingMoviesByTitle] ? compareMoviesByTitle :
                                                ([self.model sortingMoviesByScore] ? compareMoviesByScore
                                                                                    : compareMoviesByReleaseDate);
         */
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
   
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[ImageCache emptyStarImage]
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(switchFavorite:)] autorelease];
        [self setFavoriteImage];
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    [self.model setCurrentlySelectedMovie:nil theater:self.theater];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void) refresh {
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return self.movies.count + 1;
}

- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        // theater address and possibly phone number
        return 1 + ([Utilities isNilOrEmpty:theater.phoneNumber] ? 0 : 1);
    }
    
    return 2;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        AttributeCell* cell = [[[AttributeCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                    reuseIdentifier:nil] autorelease];
        
        if (row == 0) {
            Location* location = [self.model locationForAddress:theater.address];
            if (location.address != nil && location.city != nil) {
                [cell setKey:NSLocalizedString(@"Map", nil)
                       value:[NSString stringWithFormat:@"%@, %@", location.address, location.city]
                hasIndicator:NO];
            } else {
                [cell setKey:NSLocalizedString(@"Map", nil) value:theater.address hasIndicator:NO];
            }
        } else {
            [cell setKey:NSLocalizedString(@"Call", nil) value:theater.phoneNumber hasIndicator:NO];
        }
        
        return cell;
    } else {
        if (row == 0) {
            static NSString* reuseIdentifier = @"TheaterDetailsMovieCellIdentifier";
            MovieTitleCell* movieCell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (movieCell == nil) {    
                movieCell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                   reuseIdentifier:reuseIdentifier
                                                             model:self.model
                                                             style:UITableViewStyleGrouped] autorelease];
            }
            
            [movieCell setMovie:[self.movies objectAtIndex:(section - 1)]];
            
            return movieCell;
        } else {
            static NSString* reuseIdentifier = @"TheaterDetailsShowtimesCellIdentifier";
            id i = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            MovieShowtimesCell* cell = i;
            if (cell == nil) {
                cell = [[[MovieShowtimesCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                  reuseIdentifier:reuseIdentifier] autorelease];
            }
            
            [cell setShowtimes:[self.movieShowtimes objectAtIndex:(section - 1)]];
            
            return cell;
        }
    }
}

- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return nil;
    }
    
    return nil;
    
    Movie* movie = [self.movies objectAtIndex:(section - 1)];
    NSInteger score = [self.model scoreForMovie:movie];
    if (score >= 0 && score <= 100) {
        return [NSString stringWithFormat:@"%@ (%@) - %d%%", movie.title, movie.rating, score];
    } else {
        return [NSString stringWithFormat:@"%@ (%@)", movie.title, movie.rating];
    }
    
    return movie.title;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        return [tableView rowHeight];
    }
    
    if (row == 0) {
        return [tableView rowHeight];
    }
    
    return [MovieShowtimesCell heightForShowtimes:[self.movieShowtimes objectAtIndex:(section - 1)]] + 18;
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return UITableViewCellAccessoryNone;
    }
    
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            [Application openMap:theater.address];
        } else {
            [Application makeCall:theater.phoneNumber];
        }
    } else {  
        Movie* movie = [self.movies objectAtIndex:(section - 1)];    
        if (row == 0) {
            [self.navigationController.tabBarController showMovieDetails:movie];
        } else {
            [self.navigationController  pushTicketsView:self.theater movie:movie animated:YES];
        }
    }
}

@end