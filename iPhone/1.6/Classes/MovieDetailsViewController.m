// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "MovieDetailsViewController.h"

#import "Application.h"
#import "ColorCache.h"
#import "DateUtilities.h"
#import "Movie.h"
#import "MovieOverviewCell.h"
#import "MovieShowtimesCell.h"
#import "MoviesNavigationController.h"
#import "NowPlayingModel.h"
#import "Theater.h"
#import "TheaterNameCell.h"
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
    [theatersArray sortUsingFunction:compareTheatersByDistance
                             context:self.model.theaterDistanceMap];

    NSMutableArray* favorites = [NSMutableArray array];
    NSMutableArray* nonFavorites = [NSMutableArray array];

    for (Theater* theater in theatersArray) {
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


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (void) initializeData {
    NSArray* theatersShowingMovie = [self.model theatersShowingMovie:movie];

    if (filterTheatersByDistance) {
        self.theatersArray = [NSMutableArray arrayWithArray:[self.model theatersInRange:theatersShowingMovie]];
        self.hiddenTheaterCount = theatersShowingMovie.count - theatersArray.count;
    } else {
        self.theatersArray = [NSMutableArray arrayWithArray:theatersShowingMovie];
        self.hiddenTheaterCount = 0;
    }

    [self orderTheaters];

    self.showtimesArray = [NSMutableArray array];

    for (Theater* theater in theatersArray) {
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
        label.text = movie.displayTitle;

        self.title = movie.displayTitle;
        self.navigationItem.titleView = label;
        self.trailersArray = [NSArray arrayWithArray:[self.model trailersForMovie:movie]];

        if (!self.model.noRatings) {
            self.reviewsArray = [NSArray arrayWithArray:[self.model reviewsForMovie:movie]];
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
    [self.model saveNavigationStack:navigationController];
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

    // show hidden theaters
    if (hiddenTheaterCount > 0) {
        sections += 1;
    }

    return sections;
}


- (NSInteger) numberOfRowsInHeaderSection {
    return 2;
}


- (NSInteger) numberOfRowsInActionSection {
    // trailers
    NSInteger rows = trailersArray.count;

    // reviews
    rows += (reviewsArray.count ? 1 : 0);

    // email listings
    rows += (theatersArray.count ? 1 : 0);

    return rows;
}


- (NSInteger) getTheaterIndex:(NSInteger) section {
    return section - 2;
}


- (NSInteger) isTheaterSection:(NSInteger) section {
    NSInteger theaterIndex = [self getTheaterIndex:section];
    return theaterIndex >= 0 && theaterIndex < theatersArray.count;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return [self numberOfRowsInHeaderSection];
    }

    if (section == 1) {
        return [self numberOfRowsInActionSection];
    }

    if ([self isTheaterSection:section]) {
        return 2;
    }

    // show hidden theaters
    return 1;
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


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self heightForRowInHeaderSection:indexPath.row];
    }

    if (indexPath.section == 1) {
        return tableView.rowHeight;
    }

    if ([self isTheaterSection:indexPath.section]) {
        // theater section
        if (indexPath.row == 0) {
            return tableView.rowHeight;
        } else {
            NSInteger theaterIndex = [self getTheaterIndex:indexPath.section];
            Theater* theater = [theatersArray objectAtIndex:theaterIndex];

            return [MovieShowtimesCell heightForShowtimes:[showtimesArray objectAtIndex:theaterIndex]
                                                    stale:[self.model isStale:theater]
                                            useSmallFonts:self.model.useSmallFonts] + 18;
        }
    }

    // show hidden theaters
    return tableView.rowHeight;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    if (row == 0) {
        return [MovieOverviewCell cellWithMovie:movie model:self.model frame:[UIScreen mainScreen].applicationFrame reuseIdentifier:nil];
    } else {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

        cell.textAlignment = UITextAlignmentCenter;
        cell.text = movie.ratingAndRuntimeString;
        cell.font = [UIFont boldSystemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

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


- (UITableViewCell*) cellForTheaterSection:(NSInteger) theaterIndex
                                       row:(NSInteger) row {
    if (row == 0) {
        static NSString* reuseIdentifier = @"MovieDetailsTheaterCellIdentifier";
        id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[TheaterNameCell alloc] initWithFrame:CGRectZero
                                           reuseIdentifier:reuseIdentifier
                                                     model:self.model] autorelease];
        }

        Theater* theater = [theatersArray objectAtIndex:theaterIndex];
        [cell setTheater:theater];

        return cell;
    } else {
        static NSString* reuseIdentifier = @"MovieDetailsShowtimesCellIdentifier";
        id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                              reuseIdentifier:reuseIdentifier] autorelease];
        }

        Theater* theater = [theatersArray objectAtIndex:theaterIndex];
        BOOL stale = [self.model isStale:theater];
        [cell setStale:stale];

        [cell setShowtimes:[showtimesArray objectAtIndex:theaterIndex]
             useSmallFonts:self.model.useSmallFonts];

        return cell;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
       titleForFooterInSection:(NSInteger) section {
    if (![self isTheaterSection:section]) {
        return nil;
    }

    Theater* theater = [theatersArray objectAtIndex:[self getTheaterIndex:section]];
    if (![self.model isStale:theater]) {
        return nil;
    }

    return [self.model showtimesRetrievedOnString:theater];
}


- (UITableViewCell*) showHiddenTheatersCell {
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


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self cellForHeaderRow:indexPath.row];
    }

    if (indexPath.section == 1) {
        return [self cellForActionRow:indexPath.row];
    }

    if ([self isTheaterSection:indexPath.section]) {
        // theater section
        return [self cellForTheaterSection:[self getTheaterIndex:indexPath.section] row:indexPath.row];
    }

    return [self showHiddenTheatersCell];
}


- (void) didSelectShowHiddenTheaters {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];

    filterTheatersByDistance = NO;
    [self refresh];
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
    } else if (row == trailersArray.count && reviewsArray.count > 0) {
        [navigationController pushReviewsView:movie animated:YES];
    } else {
        NSString* movieAndDate = [NSString stringWithFormat:@"%@ - %@",
                                  movie.canonicalTitle,
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
    [navigationController pushTicketsView:movie
                                  theater:theater
                                    title:theater.name
                                 animated:animated];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return;
    }

    if (indexPath.section == 1) {
        [self didSelectActionRow:indexPath.row];
        return;
    }

    if ([self isTheaterSection:indexPath.section]) {
        // theater section
        Theater* theater = [theatersArray objectAtIndex:[self getTheaterIndex:indexPath.section]];

        if (indexPath.row == 0) {
            [navigationController pushTheaterDetails:theater animated:YES];
        } else {
            [self pushTicketsView:theater animated:YES];
        }
        return;
    }

    [self didSelectShowHiddenTheaters];
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

    if ([self isTheaterSection:section]) {
        // theater section
        return UITableViewCellAccessoryDisclosureIndicator;
    }

    // show hidden theaters
    return UITableViewCellAccessoryNone;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self refresh];
}


@end