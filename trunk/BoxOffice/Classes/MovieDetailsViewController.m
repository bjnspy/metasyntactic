//
//  MovieDetailsViewController.m
//  BoxOffice
// 
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MoviesNavigationController.h"
#import "Theater.h"
#import "DifferenceEngine.h"
#import "TicketsViewController.h"
#import "MovieShowtimesCell.h"

#define SHOWTIMES_PER_ROW 6

@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize theatersArray;
@synthesize showtimesArray;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    [super dealloc];
}

- (void) initializeData {
    self.theatersArray = [NSMutableArray arrayWithArray:[self.model theatersInRange:[self.model theatersShowingMovie:self.movie]]];
    self.theatersArray = [self.theatersArray sortedArrayUsingFunction:compareTheatersByDistance
                                                              context:[self.model theaterDistanceMap]];
    
    self.showtimesArray = [NSMutableArray array];
    
    for (Theater* theater in self.theatersArray) {
        [self.showtimesArray addObject:[self.model movieShowtimes:self.movie forTheater:theater]];
    }
}

- (id) initWithNavigationController:(MoviesNavigationController*) controller
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.movie = movie_;    
        
        self.title = self.movie.title;
        
        [self initializeData];
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
}

- (void) refresh {
    [self initializeData];
    [self.tableView reloadData];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1 + [self.theatersArray count];
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return 1;
}

- (UIImage*) posterImage {
    UIImage* image = [self.model posterForMovie:self.movie];
    if (image == nil) {
        image = [UIImage imageNamed:@"ImageNotAvailable.png"];
    }
    return image;
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0 && row == 0) {
        return [self posterImage].size.height + 10;
    }
    
    NSInteger showtimesCount = [[self.showtimesArray objectAtIndex:(section - 1)] count];
    NSInteger rows = showtimesCount / SHOWTIMES_PER_ROW;
    NSInteger remainder = showtimesCount % SHOWTIMES_PER_ROW;
    if (remainder > 0) {
        rows++;
    }
    
    return (rows * 14) + 18;
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    if (section == 0 && row == 0) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        
        UIImage* image = [self posterImage];
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(5, 5, image.size.width, image.size.height);
        [cell.contentView addSubview:imageView];
        
        int webX = 5 + image.size.width + 5;
        int webWidth = 295 - webX;
        CGRect webRect = CGRectMake(webX, 5, webWidth, image.size.height);
        UIWebView* webView = [[[UIWebView alloc] initWithFrame:webRect] autorelease];
        
        NSString* content =
        [NSString stringWithFormat:
         @"<html>"
         "<head>"
         "<style>"
         "body {"
         "  margin-top: -2;"
         "  margin-bottom: 0;"
         "  margin-right: 3;"
         "  margin-left: 3;"
         "  font-family: \"helvetica\";"
         "  font-size: 14;"
         "}"
         "</style>"
         "</head>"
         "<body>%@</body>"
         "</html>", movie.synopsis];
        [webView loadHTMLString:content baseURL:[NSURL URLWithString:@""]];
        [cell.contentView addSubview:webView]; 
        
        return cell;
    } else {
        //static NSString* @"MovieDetailsCell";
        return [MovieShowtimesCell cellWithShowtimes:[self.showtimesArray objectAtIndex:(section - 1)]];
    }
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return nil;
    }
    
    return [[self.theatersArray objectAtIndex:(section - 1)] name];
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        return;
    }
    
    Theater* theater = [self.theatersArray objectAtIndex:(section - 1)];
    
    TicketsViewController* controller = 
    [[[TicketsViewController alloc] initWithController:self.navigationController
                                               theater:theater
                                                 movie:self.movie
                                                 title:[NSString stringWithFormat:@"@ %@", theater.name]] autorelease];
    
    [self.navigationController pushViewController:controller
     animated:YES];
}

@end
