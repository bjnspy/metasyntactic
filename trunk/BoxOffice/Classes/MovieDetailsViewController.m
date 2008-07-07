//
//  MovieDetailsViewController.m
//  BoxOffice
// 
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MoviesNavigationController.h"
#import "Theater.h"
#import "DifferenceEngine.h"
#import "TicketsViewController.h"
#import "MovieShowtimesCell.h"
#import "Application.h"
#import "ViewControllerUtilities.h"
#import "Utilities.h"

#define SHOWTIMES_PER_ROW 6

@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize theatersArray;
@synthesize showtimesArray;
@synthesize hiddenTheaterCount;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.hiddenTheaterCount = 0;
    [super dealloc];
}

- (void) initializeData:(BOOL) filter {
    NSArray* theatersShowingMovie = [self.model theatersShowingMovie:self.movie];
    
    if (filter) {
        self.theatersArray = [NSMutableArray arrayWithArray:[self.model theatersInRange:theatersShowingMovie]];
        self.theatersArray = [self.theatersArray sortedArrayUsingFunction:compareTheatersByDistance
                              context:[self.model theaterDistanceMap]];
        
        self.hiddenTheaterCount = [theatersShowingMovie count] - [self.theatersArray count];
    } else {
        self.theatersArray = theatersShowingMovie;
        self.hiddenTheaterCount = 0;
    }
    
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
        
        [self initializeData:YES];
        
        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = self.movie.title;
         
        self.title = self.movie.title;
        self.navigationItem.titleView = label;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self.model setCurrentlySelectedMovie:self.movie theater:nil];
}

- (void) refresh {
    [self initializeData:YES];
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
    if (section == 0) {
        if (hiddenTheaterCount > 0) {
            return 3;
        } else {
            return 2;
        }
    } else {
        return 1;
    }
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
    
    if (section == 0) {
        if (row == 0) {
            return [self posterImage].size.height + 10;
        } else {
            return [tableView rowHeight];
        }
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
    
    if (section == 0) {
        if (row == 0) {
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
             "  <head>"
             "   <style>"
             "    body {"
             "     margin-top: -2;"
             "     margin-bottom: 0;"
             "     margin-right: 3;"
             "     margin-left: 3;"
             "     font-family: \"helvetica\";"
             "     font-size: 14;"
             "    }"
             "   </style>"
             "  </head>"
             "  <body>%@</body>"
             " </html>", [self.model synopsisForMovie:movie]];
            [webView loadHTMLString:content baseURL:[NSURL URLWithString:@""]];
            [cell.contentView addSubview:webView]; 
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else if (row == 1) {
            UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            
            NSInteger length = [self.movie.length intValue];
            NSInteger hours = length / 60;
            NSInteger minutes = length % 60;
            
            NSString* rating = self.movie.rating;
            if ([Utilities isNilOrEmpty:rating] || [rating isEqual:@"NR"]) {
                rating = NSLocalizedString(@"Not rated", nil);
            } else {
                rating = [NSString stringWithFormat:NSLocalizedString(@"Rated %@", nil), rating];
            }
            
            NSString* text = rating;
            if (length != 0) {
                text = [NSString stringWithFormat:NSLocalizedString(@"%@ - Running time: %d:%02d", nil), rating, hours, minutes];
            } 
                
            cell.textAlignment = UITextAlignmentCenter;
            cell.text = text;
            cell.font = [UIFont boldSystemFontOfSize:14];
            
            return cell;
        } else {
            UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
            cell.textAlignment = UITextAlignmentCenter;
            
            if (self.hiddenTheaterCount == 1) {
                cell.text = [NSString stringWithFormat:NSLocalizedString(@"Show %d theater outside search radius", nil), self.hiddenTheaterCount];
            } else {
                cell.text = [NSString stringWithFormat:NSLocalizedString(@"Show %d theaters outside search radius", nil), self.hiddenTheaterCount];
            }
            
            cell.textColor = [Application commandColor];
            cell.font = [UIFont boldSystemFontOfSize:14];
            
            return cell;
        }
    } else {
        static NSString* reuseIdentifier = @"MovieDetailsCellIdentifier";
        MovieShowtimesCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];;
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setShowtimes:[self.showtimesArray objectAtIndex:(section - 1)]];
  
        return cell;
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
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        if (row == 2) {
            [self initializeData:NO];
            [self.tableView reloadData];
        }
        return;
    }
    
    Theater* theater = [self.theatersArray objectAtIndex:(section - 1)];
    

    [self.navigationController pushTicketsView:self.movie
                                       theater:theater
                                      animated:YES];
}

@end
