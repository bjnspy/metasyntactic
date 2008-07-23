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
#import "ReviewsViewController.h"
#import "ApplicationTabBarController.h"
#import "FontCache.h"

@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize theatersArray;
@synthesize showtimesArray;
@synthesize trailersArray;
@synthesize reviewsArray;
@synthesize hiddenTheaterCount;
@synthesize posterImage;
@synthesize synopsis;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.trailersArray = nil;
    self.reviewsArray = nil;
    self.hiddenTheaterCount = 0;
    self.posterImage = nil;
    self.synopsis = nil;
    
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

- (void) initializeData {
    NSArray* theatersShowingMovie = [self.model theatersShowingMovie:self.movie];
    
    if (filterTheatersByDistance) {
        self.theatersArray = [NSMutableArray arrayWithArray:[self.model theatersInRange:theatersShowingMovie]];
        self.hiddenTheaterCount = theatersShowingMovie.count - theatersArray.count;
    } else {
        self.theatersArray = [NSMutableArray arrayWithArray:theatersShowingMovie];
        self.hiddenTheaterCount = 0;
    }
    
    [self orderTheaters];
    
    self.showtimesArray = [NSMutableArray array];
    
    for (Theater* theater in self.theatersArray) {
        [self.showtimesArray addObject:[theater performances:self.movie]];
    }
}

- (NSInteger) calculateSynopsisSplit {
    CGFloat posterHeight = self.posterImage.size.height;
    int synopsisX = 5 + self.posterImage.size.width + 5;
    int width = 295 - synopsisX;
    
    CGFloat synopsisHeight = [synopsis sizeWithFont:[FontCache helvetica14]
                                  constrainedToSize:CGSizeMake(width, 2000)
                                      lineBreakMode:UILineBreakModeWordWrap].height;
    if (synopsisHeight <= posterHeight) {
        return synopsis.length;
    }
    
    NSInteger guess = synopsis.length * posterHeight * 1.1 / synopsisHeight;
    guess = MIN(guess, synopsis.length);
    
    while (true) {
        NSRange whitespaceRange = [synopsis rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, guess)];
        NSInteger whitespace = whitespaceRange.location;
        if (whitespace == 0) {
            return synopsis.length;
        }
        
        NSString* synopsisChunk = [synopsis substringToIndex:whitespace];
        
        CGFloat chunkHeight = [synopsisChunk sizeWithFont:[FontCache helvetica14]
                                        constrainedToSize:CGSizeMake(width, 2000)
                                            lineBreakMode:UILineBreakModeWordWrap].height;
        
        if (chunkHeight <= posterHeight) {
            return whitespace;
        }
        
        guess = whitespace;
    }
}

- (NSInteger) calculateSynopsisMax {
    if (synopsisSplit == synopsis.length) {
        return synopsis.length;
    }
    
    NSInteger guess = synopsisSplit * 2;
    if (guess >= synopsis.length) {
        return synopsis.length;
    }
    
    NSRange dot = [synopsis rangeOfString:@"." options:0 range:NSMakeRange(guess, synopsis.length - guess)];
    if (dot.length == 0) {
        return synopsis.length;
    }
    
    return dot.location + 1;
}

- (id) initWithNavigationController:(MoviesNavigationController*) controller
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.movie = movie_;
        filterTheatersByDistance = YES;
        
        [self initializeData];
        
        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = self.movie.title;
        
        self.title = self.movie.title;
        self.navigationItem.titleView = label;
        self.trailersArray = [NSArray arrayWithArray:[self.model trailersForMovie:self.movie]];
        self.reviewsArray = [NSArray arrayWithArray:[self.model reviewsForMovie:self.movie]];
        
        self.posterImage = [self.model posterForMovie:self.movie];
        if (self.posterImage == nil) {
            self.posterImage = [UIImage imageNamed:@"ImageNotAvailable.png"];
        }
        
        self.synopsis = [self.model synopsisForMovie:self.movie];
        synopsisSplit = [self calculateSynopsisSplit];
        synopsisMax = [self calculateSynopsisMax];
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
    
    [self.model setCurrentlySelectedMovie:self.movie theater:nil];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
    [self refresh];
}

- (void) refresh {
    [self initializeData];
    [self.tableView reloadData];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (BOOL) hasInfoSection {
    return trailersArray.count || reviewsArray.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    NSInteger sections = 1;
    
    if ([self hasInfoSection]) {
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

- (NSInteger) numberOfRowsInInfoSection {
    return trailersArray.count + (reviewsArray.count ? 1 : 0);
}

- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return [self numberOfRowsInHeaderSection];
    }
    
    if (section == 1 && [self hasInfoSection]) {
        return [self numberOfRowsInInfoSection];
    }
    
    // theater section
    return 2;
}

- (CGRect) synopsisFrame {
    UIImage* image = [self posterImage];
    
    int synopsisX = 5 + image.size.width + 5;
    int width = 295 - synopsisX;
    
    return CGRectMake(synopsisX, 5, width, image.size.height);
}

- (CGFloat) heightForRowInHeaderSection:(NSInteger) row {
    if (row == 0) {
        double h1 = [self posterImage].size.height;
        
        if (synopsisSplit == synopsis.length) {
            return h1 + 10;
        }
        
        NSInteger start = synopsisSplit + 1;
        NSInteger end = synopsisMax;
        
        NSString* remainder = [synopsis substringWithRange:NSMakeRange(start, end - start)];
        //NSString* remainder = [synopsis substringFromIndex:(synopsisSplit + 1)];
        
        double h2 = [remainder sizeWithFont:[FontCache helvetica14]
                               constrainedToSize:CGSizeMake(290, 2000)
                                   lineBreakMode:UILineBreakModeWordWrap].height;
        
        return h1 + h2 + 10;
    } else if (row == 1) {
        return [self.tableView rowHeight] - 10;
    } else {
        return [self.tableView rowHeight];
    } 
}

- (NSInteger) getTheaterIndex:(NSInteger) section {
    if ([self hasInfoSection]) {
        return section - 2;
    } else {
        return section - 1;
    }
}

- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self heightForRowInHeaderSection:indexPath.row];
    }
    
    if (indexPath.section == 1 && [self hasInfoSection]) {
        return [tableView rowHeight];
    }
    
    // theater section
    if (indexPath.row == 0) {
        return [tableView rowHeight];
    } else {
        return [MovieShowtimesCell heightForShowtimes:[self.showtimesArray objectAtIndex:[self getTheaterIndex:indexPath.section]]] + 18;
    }
}

- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    if (row == 0) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage* image = [self posterImage];
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(5, 5, image.size.width, image.size.height);
        [cell.contentView addSubview:imageView];
        
        CGRect synopsisFrame = [self synopsisFrame];
        
        UILabel* synopsisLabel = [[[UILabel alloc] initWithFrame:synopsisFrame] autorelease];
        synopsisLabel.font = [FontCache helvetica14];
        synopsisLabel.lineBreakMode = UILineBreakModeWordWrap;
        synopsisLabel.numberOfLines = 0;
        synopsisLabel.text = [synopsis substringToIndex:synopsisSplit];
        [synopsisLabel sizeToFit];
        
        if (synopsisSplit < synopsis.length) {
            NSInteger start = synopsisSplit + 1;
            NSInteger end = synopsisMax;
            
            NSString* remainder = [synopsis substringWithRange:NSMakeRange(start, end - start)];
            
            CGFloat height = [remainder sizeWithFont:[FontCache helvetica14]
                                constrainedToSize:CGSizeMake(290, 2000)
                                    lineBreakMode:UILineBreakModeWordWrap].height;
            
            CGRect remainderRect =  CGRectMake(5, posterImage.size.height + 5, 290, height);
            
            UILabel* remainderChunk = [[[UILabel alloc] initWithFrame:remainderRect] autorelease];
            remainderChunk.font = [FontCache helvetica14];
            remainderChunk.lineBreakMode = UILineBreakModeWordWrap;
            remainderChunk.numberOfLines = 0;
            remainderChunk.text = remainder;
            
            [cell.contentView addSubview:remainderChunk];
            
            synopsisFrame = synopsisLabel.frame;
            synopsisFrame.origin.y = (self.posterImage.size.height + 5) - synopsisFrame.size.height;
            synopsisLabel.frame = synopsisFrame;
        }
        
        
        [cell.contentView addSubview:synopsisLabel]; 
        
        return cell;
    } else if (row == 1) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        
        cell.textAlignment = UITextAlignmentCenter;
        cell.text = [self.movie ratingAndRuntimeString];
        cell.font = [UIFont boldSystemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        cell.textAlignment = UITextAlignmentCenter;
        
        if (self.hiddenTheaterCount == 1) {
            cell.text = [NSString stringWithFormat:NSLocalizedString(@"Show %d hidden theater", nil), self.hiddenTheaterCount];
        } else {
            cell.text = [NSString stringWithFormat:NSLocalizedString(@"Show %d hidden theaters", nil), self.hiddenTheaterCount];
        }
        
        cell.textColor = [Application commandColor];
        cell.font = [UIFont boldSystemFontOfSize:14];
        
        return cell;
    }    
}

- (UITableViewCell*) cellForInfoRow:(NSInteger) row {
    static NSString* reuseIdentifier = @"MovieTrailersCellIdentifier";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                       reuseIdentifier:reuseIdentifier] autorelease];
        
        cell.textColor = [Application commandColor];
        cell.font = [UIFont boldSystemFontOfSize:14];
        cell.textAlignment = UITextAlignmentCenter;
    }
    
    if (row < trailersArray.count) {
        if (trailersArray.count == 1) {   
            cell.text = NSLocalizedString(@"Play trailer", nil);
        } else {
            cell.text = [NSString stringWithFormat:NSLocalizedString(@"Play trailer %d", nil), (row + 1)];
        }
    } else {
        cell.text = NSLocalizedString(@"Read reviews", nil);
    }
    
    return cell;
}

- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self cellForHeaderRow:indexPath.row];
    } 
    
    if (indexPath.section == 1 && [self hasInfoSection]) {
        return [self cellForInfoRow:indexPath.row];
    }
    
    // theater section
    if (indexPath.row == 0) {
        static NSString* reuseIdentifier = @"MovieDetailsTheaterCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                           reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        Theater* theater = [self.theatersArray objectAtIndex:[self getTheaterIndex:indexPath.section]];
        if ([self.model isFavoriteTheater:theater]) {
            cell.text = [NSString stringWithFormat:@"%@ %@", [Application starString], [theater name]];
        } else {
            cell.text = [theater name];
        }
        
        return cell;
    } else {
        static NSString* reuseIdentifier = @"MovieDetailsShowtimesCellIdentifier";
        MovieShowtimesCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                              reuseIdentifier:reuseIdentifier] autorelease];
        }
        
        [cell setShowtimes:[self.showtimesArray objectAtIndex:[self getTheaterIndex:indexPath.section]]];
        
        return cell;
    }
}

- (void) didSelectHeaderRow:(NSInteger) row {
    if (row == 2) {
        filterTheatersByDistance = NO;
        [self initializeData];
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
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void) didSelectInfoRow:(NSInteger) row {
    if (row < trailersArray.count) {
        [self playMovie:[trailersArray objectAtIndex:row]];
    } else {
        [self.navigationController pushReviewsView:reviewsArray animated:YES];
    }
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self didSelectHeaderRow:indexPath.row];
    }
    
    if (indexPath.section == 1 && [self hasInfoSection]) {
        return [self didSelectInfoRow:indexPath.row];
    }
    
    // theater section
    Theater* theater = [self.theatersArray objectAtIndex:[self getTheaterIndex:indexPath.section]];
    
    if (indexPath.row == 0) {
        [self.navigationController.tabBarController showTheaterDetails:theater];
    } else {
        [self.navigationController pushTicketsView:self.movie theater:theater animated:YES];
    }
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return UITableViewCellAccessoryNone;
    }
    
    if (section == 1 && [self hasInfoSection]) {
        return UITableViewCellAccessoryNone;
    }
    
    // theater section
    return UITableViewCellAccessoryDisclosureIndicator;
}

@end
