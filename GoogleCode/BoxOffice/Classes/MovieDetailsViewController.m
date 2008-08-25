// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "MovieDetailsViewController.h"

#import "Application.h"
#import "AutoResizingCell.h"
#import "BoxOfficeModel.h"
#import "ColorCache.h"
#import "DateUtilities.h"
#import "FontCache.h"
#import "Movie.h"
#import "MovieOverviewCell.h"
#import "MovieShowtimesCell.h"
#import "MoviesNavigationController.h"
#import "Theater.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"

@implementation MovieDetailsViewController

@synthesize navigationController;
@synthesize movie;
@synthesize theatersArray;
@synthesize showtimesArray;
@synthesize trailersArray;
@synthesize reviewsArray;
@synthesize hiddenTheaterCount;

- (void) dealloc {
    self.navigationController = nil;
    self.movie = nil;
    self.theatersArray = nil;
    self.showtimesArray = nil;
    self.trailersArray = nil;
    self.reviewsArray = nil;
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


- (BoxOfficeController*) controller {
    return self.navigationController.controller;
}


- (BoxOfficeModel*) model {
    return self.navigationController.model;
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
        [self.showtimesArray addObject:[self.model moviePerformances:movie forTheater:theater]];
    }
}


- (id) initWithNavigationController:(AbstractNavigationController*) controller
                              movie:(Movie*) movie_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.movie = movie_;
        filterTheatersByDistance = YES;

        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = self.movie.displayTitle;

        self.title = self.movie.displayTitle;
        self.navigationItem.titleView = label;
        self.trailersArray = [NSArray arrayWithArray:[self.model trailersForMovie:self.movie]];

        if (!self.model.noRatings) {
            self.reviewsArray = [NSArray arrayWithArray:[self.model reviewsForMovie:self.movie]];
        }
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self refresh];
}


- (void) removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}


- (void) viewWillDisappear:(BOOL) animated {
    [self removeNotifications];
}


- (void) viewDidAppear:(BOOL) animated {
    [self.model saveNavigationStack:self.navigationController];
}


- (void) refresh {
    [self initializeData];
    [self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    // Header
    NSInteger sections = 1;

    // actions
    sections += 1;

    // theaters
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


- (NSInteger) numberOfRowsInActionSection {
    // trailers
    NSInteger rows = trailersArray.count;

    // reviews
    rows += (reviewsArray.count ? 1 : 0);

    // email listings
    rows++;

    return rows;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return [self numberOfRowsInHeaderSection];
    }

    if (section == 1) {
        return [self numberOfRowsInActionSection];
    }

    // theater section
    return 2;
}


- (CGFloat) heightForRowInHeaderSection:(NSInteger) row {
    if (row == 0) {
        return [MovieOverviewCell heightForMovie:movie model:self.model];
    } else if (row == 1) {
        return self.tableView.rowHeight - 10;
    } else {
        return self.tableView.rowHeight;
    }
}


- (NSInteger) getTheaterIndex:(NSInteger) section {
    return section - 2;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self heightForRowInHeaderSection:indexPath.row];
    }

    if (indexPath.section == 1) {
        return tableView.rowHeight;
    }

    // theater section
    if (indexPath.row == 0) {
        return tableView.rowHeight;
    } else {
        return [MovieShowtimesCell heightForShowtimes:[self.showtimesArray objectAtIndex:[self getTheaterIndex:indexPath.section]]
                                        useSmallFonts:[self.model useSmallFonts]] + 18;
    }
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    if (row == 0) {
        return [MovieOverviewCell cellWithMovie:movie model:self.model frame:[UIScreen mainScreen].applicationFrame reuseIdentifier:nil];
    } else if (row == 1) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

        cell.textAlignment = UITextAlignmentCenter;
        cell.text = self.movie.ratingAndRuntimeString;
        cell.font = [UIFont boldSystemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
        cell.textAlignment = UITextAlignmentCenter;

        if (self.hiddenTheaterCount == 1) {
            cell.text = NSLocalizedString(@"Show 1 hidden theater", nil);
        } else {
            cell.text = [NSString stringWithFormat:NSLocalizedString(@"Show %d hidden theaters", nil), self.hiddenTheaterCount];
        }

        cell.textColor = [ColorCache commandColor];
        cell.font = [UIFont boldSystemFontOfSize:14];

        return cell;
    }
}


- (UITableViewCell*) cellForActionRow:(NSInteger) row {
    static NSString* reuseIdentifier = @"MovieDetailsActionCellIdentifier";

    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                       reuseIdentifier:reuseIdentifier] autorelease];

        cell.textColor = [ColorCache commandColor];
        cell.font = [UIFont boldSystemFontOfSize:14];
        cell.textAlignment = UITextAlignmentCenter;
    }

    if (row < trailersArray.count) {
        if (trailersArray.count == 1) {
            cell.text = NSLocalizedString(@"Play trailer", nil);
        } else {
            cell.text = [NSString stringWithFormat:NSLocalizedString(@"Play trailer %d", nil), (row + 1)];
        }
    } else if (row == trailersArray.count && self.reviewsArray.count > 0) {
        cell.text = NSLocalizedString(@"Read reviews", nil);
    } else {
        cell.text = NSLocalizedString(@"E-mail listings", nil);
    }

    return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self cellForHeaderRow:indexPath.row];
    }

    if (indexPath.section == 1) {
        return [self cellForActionRow:indexPath.row];
    }

    // theater section
    if (indexPath.row == 0) {
        static NSString* reuseIdentifier = @"MovieDetailsTheaterCellIdentifier";
        AutoResizingCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero
                                           reuseIdentifier:reuseIdentifier] autorelease];
        }

        Theater* theater = [self.theatersArray objectAtIndex:[self getTheaterIndex:indexPath.section]];
        if ([self.model isFavoriteTheater:theater]) {
            cell.text = [NSString stringWithFormat:@"%@ %@", [Application starString], theater.name];
        } else {
            cell.text = theater.name;
        }

        return cell;
    } else {
        static NSString* reuseIdentifier = @"MovieDetailsShowtimesCellIdentifier";
        MovieShowtimesCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                              reuseIdentifier:reuseIdentifier] autorelease];
        }

        [cell setShowtimes:[self.showtimesArray objectAtIndex:[self getTheaterIndex:indexPath.section]]
             useSmallFonts:self.model.useSmallFonts];

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


- (void) playTrailer:(NSInteger) row {
    NSString* urlString = [trailersArray objectAtIndex:row];
    MPMoviePlayerController* moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:urlString]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedPlaying:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];

    [moviePlayer play];
}


- (void) movieFinishedPlaying:(NSNotification*) notification {
    MPMoviePlayerController* moviePlayer = notification.object;
    [moviePlayer stop];
    [moviePlayer autorelease];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self removeNotifications];
}


- (void) didSelectActionRow:(NSInteger) row {
    if (row < trailersArray.count) {
        [self playTrailer:row];
    } else if (row == trailersArray.count && self.reviewsArray.count > 0) {
        [self.navigationController pushReviewsView:movie animated:YES];
    } else {
        NSString* movieAndDate = [NSString stringWithFormat:@"%@ - %@",
                                  self.movie.canonicalTitle,
                                  [DateUtilities formatFullDate:self.model.searchDate]];
        NSMutableString* body = [NSMutableString string];

        for (int i = 0; i < theatersArray.count; i++) {
            if (i != 0) {
                [body appendString:@"\n\n"];
            }

            Theater* theater = [theatersArray objectAtIndex:i];
            NSArray* performances = [showtimesArray objectAtIndex:i];

            [body appendString:theater.name];
            [body appendString:@"\n"];
            [body appendString:@"<a href=\"http://maps.google.com/maps?q="];
            [body appendString:theater.address];
            [body appendString:@"\">"];
            [body appendString:[self.model simpleAddressForTheater:theater]];
            [body appendString:@"</a>"];

            [body appendString:@"\n"];
            [body appendString:[Utilities generateShowtimeLinks:self.model
                                                          movie:movie
                                                        theater:theater
                                                   performances:performances]];
        }

        NSString* url = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@",
                         [Utilities stringByAddingPercentEscapes:movieAndDate],
                         [Utilities stringByAddingPercentEscapes:body]];

        [Application openBrowser:url];
    }
}


- (void) pushTicketsView:(Theater*) theater
                animated:(BOOL) animated {
    [self.navigationController pushTicketsView:self.movie
                                       theater:theater
                                         title:theater.name
                                      animated:animated];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self didSelectHeaderRow:indexPath.row];
    }

    if (indexPath.section == 1) {
        return [self didSelectActionRow:indexPath.row];
    }

    // theater section
    Theater* theater = [self.theatersArray objectAtIndex:[self getTheaterIndex:indexPath.section]];

    if (indexPath.row == 0) {
        [self.navigationController pushTheaterDetails:theater animated:YES];
    } else {
        [self pushTicketsView:theater animated:YES];
    }
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;

    if (section == 0) {
        return UITableViewCellAccessoryNone;
    }

    if (section == 1) {
        return UITableViewCellAccessoryNone;
    }

    // theater section
    return UITableViewCellAccessoryDisclosureIndicator;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self refresh];
}

@end