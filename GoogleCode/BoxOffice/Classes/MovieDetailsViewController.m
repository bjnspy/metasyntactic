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
@synthesize trailersArray;
@synthesize hiddenTheaterCount;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.trailersArray = nil;
    self.hiddenTheaterCount = 0;
    
    [super dealloc];
}

- (void) orderTheaters {
    [self.theatersArray sortUsingFunction:compareTheatersByDistance
                                  context:[self.model theaterDistanceMap]];    
    
    NSMutableArray* favorites = [NSMutableArray array];
    NSMutableArray* nonFavorites = [NSMutableArray array];
    
    for (Theater* theater in self.theatersArray) {
        if ([self.model isFavoriteTheater:theater]) {
            [favorites addObject:theater];
        } else {
            [nonFavorites addObject:theater];
        }
    }

    NSMutableArray* result = [NSMutableArray array];
    [result addObjectsFromArray:favorites];
    [result addObjectsFromArray:nonFavorites];
    
    self.theatersArray = result;
}

- (void) initializeData:(BOOL) filter {
    NSArray* theatersShowingMovie = [self.model theatersShowingMovie:self.movie];
    
    if (filter) {
        self.theatersArray = [NSMutableArray arrayWithArray:[self.model theatersInRange:theatersShowingMovie]];
        self.hiddenTheaterCount = theatersShowingMovie.count - theatersArray.count;
    } else {
        self.theatersArray = [NSMutableArray arrayWithArray:theatersShowingMovie];
        self.hiddenTheaterCount = 0;
    }
    
    [self orderTheaters];
            
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
        self.trailersArray = [NSArray arrayWithArray:[self.model trailersForMovie:self.movie]];
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
    NSInteger sections = 1;
    
    if (trailersArray.count) {
        sections += 1;
    }
    
    sections += theatersArray.count;
    
    return sections;
}

- (NSInteger) numberOfRowsInHeaderSection {
    if (hiddenTheaterCount > 0) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger) numberOfRowsInTrailersSection {
    return trailersArray.count;
}

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return [self numberOfRowsInHeaderSection];
    }
    
    if (section == 1 && trailersArray.count) {
        return [self numberOfRowsInTrailersSection];
    }
        
    return 1;
}

- (UIImage*) posterImage {
    UIImage* image = [self.model posterForMovie:self.movie];
    if (image == nil) {
        image = [UIImage imageNamed:@"ImageNotAvailable.png"];
    }
    return image;
}

- (CGFloat) heightForRowInHeaderSection:(NSInteger) row {
    if (row == 0) {
        return [self posterImage].size.height + 10;
    } else if (row == 1) {
        return [self.tableView rowHeight] - 10;
    } else {
        return [self.tableView rowHeight];
    } 
}

- (NSInteger) getTheaterIndex:(NSInteger) section {
    if (trailersArray.count) {
        return section - 2;
    } else {
        return section - 1;
    }
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        return [self heightForRowInHeaderSection:row];
    }
    
    if (section == 1 && self.trailersArray.count) {
        return [tableView rowHeight];
    }
        
    NSInteger showtimesCount = [[self.showtimesArray objectAtIndex:[self getTheaterIndex:section]] count];
    NSInteger rows = showtimesCount / SHOWTIMES_PER_ROW;
    NSInteger remainder = showtimesCount % SHOWTIMES_PER_ROW;
    if (remainder > 0) {
        rows++;
    }
    
    return (rows * 14) + 18;
}

- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
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
            text = [NSString stringWithFormat:@"%@ - %@: %d:%02d",
                    rating,
                    NSLocalizedString(@"Running time", nil),
                    hours, minutes];
        } 
        
        cell.textAlignment = UITextAlignmentCenter;
        cell.text = text;
        cell.font = [UIFont boldSystemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
}

- (UITableViewCell*) cellForTrailersRow:(NSInteger) row {
    static NSString* reuseIdentifier = @"MovieTrailersCellIdentifier";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        
        cell.textColor = [Application commandColor];
        cell.font = [UIFont boldSystemFontOfSize:14];
        cell.textAlignment = UITextAlignmentCenter;
    }
    
    if (trailersArray.count == 1) {   
        cell.text = NSLocalizedString(@"Play trailer", nil);
    } else {
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"Play trailer %d", nil), (row + 1)];
    }
    
    return cell;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        return [self cellForHeaderRow:row];
    } 
    
    if (section == 1 && trailersArray.count) {
        return [self cellForTrailersRow:row];
    }
    
    static NSString* reuseIdentifier = @"MovieDetailsCellIdentifier";
    MovieShowtimesCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[MovieShowtimesCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    [cell setShowtimes:[self.showtimesArray objectAtIndex:[self getTheaterIndex:section]]];
    
    return cell;
}

- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return nil;
    }
    
    if (section == 1 && trailersArray.count) {
        return nil;
    }
    
    Theater* theater = [self.theatersArray objectAtIndex:[self getTheaterIndex:section]];
    if ([self.model isFavoriteTheater:theater]) {
        NSString* result = [NSString stringWithFormat:@"%@ %@", [Application starString], [theater name]];
        NSLog(result);
        return result;
    } else {
        return [theater name];
    }
}

- (void) didSelectHeaderRow:(NSInteger) row {
    if (row == 2) {
        [self initializeData:NO];
        [self.tableView reloadData];
    }    
}

- (void) playMovie:(NSString*) urlString {
    NSURL* url = [NSURL URLWithString:urlString];
    MPMoviePlayerController* moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    [moviePlayer play];
}

// When the movie is done, release the controller.
- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController* moviePlayer = [aNotification object];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    // Release the movie instance created in playMovieAtURL:
    [moviePlayer autorelease];
}

- (void) didSelectTrailersRow:(NSInteger) row {
    [self playMovie:[trailersArray objectAtIndex:row]];
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        return [self didSelectHeaderRow:row];
    }
    
    if (section == 1 && trailersArray.count) {
        return [self didSelectTrailersRow:row];
    }
    
    Theater* theater = [self.theatersArray objectAtIndex:[self getTheaterIndex:section]];
    
    [self.navigationController pushTicketsView:self.movie
                                       theater:theater
                                      animated:YES];
}

@end
