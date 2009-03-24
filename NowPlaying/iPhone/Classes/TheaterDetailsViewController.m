// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "TheaterDetailsViewController.h"

#import "Application.h"
#import "ColorCache.h"
#import "DateUtilities.h"
#import "ImageCache.h"
#import "LookupResult.h"
#import "Model.h"
#import "Movie.h"
#import "MovieShowtimesCell.h"
#import "MovieTitleCell.h"
#import "StringUtilities.h"
#import "Theater.h"
#import "TheatersNavigationController.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"
#import "WarningView.h"

@interface TheaterDetailsViewController()
@property (retain) UISegmentedControl* segmentedControl_;
@property (retain) UIButton* favoriteButton_;
@property (retain) Theater* theater_;
@property (retain) NSArray* movies_;
@property (retain) NSArray* movieShowtimes_;
@end


@implementation TheaterDetailsViewController

@synthesize theater_;
@synthesize movies_;
@synthesize movieShowtimes_;
@synthesize segmentedControl_;
@synthesize favoriteButton_;

property_wrapper(UISegmentedControl*, segmentedControl, SegmentedControl);
property_wrapper(UIButton*, favoriteButton, FavoriteButton);
property_wrapper(Theater*, theater, Theater);
property_wrapper(NSArray*, movies, Movies);
property_wrapper(NSArray*, movieShowtimes, MovieShowtimes);

- (void) dealloc {
    self.theater = nil;
    self.movies = nil;
    self.movieShowtimes = nil;
    self.segmentedControl = nil;
    self.favoriteButton = nil;

    [super dealloc];
}


- (Model*) model {
    return [Model model];
}


- (void) setFavoriteImage {
    self.favoriteButton.selected = [self.model isFavoriteTheater:self.theater];
}


- (void) switchFavorite:(id) sender {
    if ([self.model isFavoriteTheater:self.theater]) {
        [self.model removeFavoriteTheater:self.theater];
    } else {
        [self.model addFavoriteTheater:self.theater];
    }

    [self setFavoriteImage];
}


- (void) initializeFavoriteButton {
    self.favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favoriteButton setImage:[ImageCache emptyStarImage] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[ImageCache filledStarImage] forState:UIControlStateSelected];
    [self.favoriteButton addTarget:self action:@selector(switchFavorite:) forControlEvents:UIControlEventTouchUpInside];

    CGRect frame = self.favoriteButton.frame;
    frame.size = [ImageCache emptyStarImage].size;
    frame.size.width += 10;
    frame.size.height += 10;
    self.favoriteButton.frame = frame;

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.favoriteButton] autorelease];
    [self setFavoriteImage];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                            theater:(Theater*) theater__ {
    if (self = [super initWithStyle:UITableViewStyleGrouped navigationController:navigationController_]) {
        self.theater = theater__;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
    label.text = self.theater.name;

    self.title = self.theater.name;
    self.navigationItem.titleView = label;

    [self initializeFavoriteButton];
}


- (void) didReceiveMemoryWarningWorker {
    [super didReceiveMemoryWarningWorker];
    self.segmentedControl = nil;
    self.favoriteButton = nil;
    self.movies = nil;
    self.movieShowtimes = nil;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self majorRefresh];
}


- (void) minorRefresh {
    [self majorRefresh];
}


- (void) initializeData {
    self.movies = [[self.model moviesAtTheater:self.theater] sortedArrayUsingFunction:compareMoviesByTitle
                                                                         context:self.model];

    NSMutableArray* array = [NSMutableArray array];
    for (Movie* movie in self.movies) {
        NSArray* showtimes = [self.model moviePerformances:movie forTheater:self.theater];

        [array addObject:showtimes];
    }

    self.movieShowtimes = array;
}


- (void) majorRefresh {
    [self initializeData];
    [self reloadTableViewData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    // header
    NSInteger sections = 1;

    // e-mail listings/change date
    sections++;

    // movies
    sections += self.movies.count;

    return sections;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        // theater address and possibly phone number
        return 1 + (self.theater.phoneNumber.length == 0 ? 0 : 1);
    } else if (section == 1) {
        if ([Application canSendMail]) {
            return 2;
        } else {
            return 1;
        }
    } else {
        return 2;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 2 && self.movies.count > 0) {
        if ([DateUtilities isToday:self.model.searchDate]) {
            return NSLocalizedString(@"Today", nil);
        } else {
            return [DateUtilities formatFullDate:self.model.searchDate];
        }
    }

    return nil;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                                    reuseIdentifier:nil] autorelease];

    if (row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Map", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'open a map to the currently listed address'");
        cell.detailTextLabel.text = [self.model simpleAddressForTheater:self.theater];
    } else {
        cell.textLabel.text = NSLocalizedString(@"Call", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'to make a phonecall'");
        cell.detailTextLabel.text = self.theater.phoneNumber;
    }

    return cell;
}


- (UITableViewCell*) cellForActionRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

    cell.textColor = [ColorCache commandColor];
    cell.font = [UIFont boldSystemFontOfSize:14];
    cell.textAlignment = UITextAlignmentCenter;

    if (row == 0 && [Application canSendMail]) {
        cell.text = NSLocalizedString(@"E-mail listings", nil);
    } else {
        cell.text = NSLocalizedString(@"Change date", nil);
    }

    return cell;
}


- (UITableViewCell*) cellForTheaterIndex:(NSInteger) index row:(NSInteger) row {
    if (row == 0) {
        static NSString* reuseIdentifier = @"movieReuseIdentifier";
        MovieTitleCell* movieCell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (movieCell == nil) {
            movieCell = [[[MovieTitleCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
            movieCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        [movieCell setMovie:[self.movies objectAtIndex:index] owner:self];

        return movieCell;
    } else {
        static NSString* reuseIdentifier = @"showtimesReuseIdentifier";
        MovieShowtimesCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        [cell setShowtimes:[self.movieShowtimes objectAtIndex:index]];

        return cell;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        return [self cellForHeaderRow:row];
    } else if (section == 1) {
        return [self cellForActionRow:row];
    } else {
        return [self cellForTheaterIndex:(section - 2) row:row];
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0 || section == 1) {
        return tableView.rowHeight;
    } else {
        section -= 2;

        if (row == 0) {
            return tableView.rowHeight;
        } else {
            return [MovieShowtimesCell heightForShowtimes:[self.movieShowtimes objectAtIndex:section]
                                                    stale:NO] + 18;
        }
    }
}


- (void) didSelectEmailListings {
    NSString* subject = [NSString stringWithFormat:@"%@ - %@",
                                self.theater.name,
                                [DateUtilities formatFullDate:self.model.searchDate]];
    NSMutableString* body = [NSMutableString string];

    [body appendString:@"<p>"];
    [body appendString:@"<a href=\""];
    [body appendString:self.theater.mapUrl];
    [body appendString:@"\">"];
    [body appendString:[self.model simpleAddressForTheater:self.theater]];
    [body appendString:@"</a>"];

    for (int i = 0; i < self.movies.count; i++) {
        [body appendString:@"<p>"];

        Movie* movie = [self.movies objectAtIndex:i];
        NSArray* performances = [self.movieShowtimes objectAtIndex:i];

        [body appendString:movie.displayTitle];
        [body appendString:@"<br/>"];
        [body appendString:[Utilities generateShowtimeLinks:self.model
                                                      movie:movie
                                                    theater:self.theater
                                               performances:performances]];
    }

    [self openMailWithSubject:subject body:body];
}


- (void) pushTicketsView:(Movie*) movie
                animated:(BOOL) animated {
    [self.abstractNavigationController pushTicketsView:movie
                                  theater:self.theater
                                    title:movie.displayTitle
                                 animated:animated];
}


- (void) didSelectChangeDate {
    [self changeDate];
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(id) array {
    if (updateId != [[array objectAtIndex:0] intValue]) {
        return;
    }

    NSDate* searchDate = [array lastObject];

    if (![lookupResult.theaters containsObject:self.theater]) {
        NSString* text =
        [NSString stringWithFormat:
         NSLocalizedString(@"No listings found at '%@' on %@", @"No listings found at 'Regal Meridian 6' on 5/18/2008"),
         self.theater.name,
         [DateUtilities formatShortDate:searchDate]];

        [self onDataProviderUpdateFailure:text context:array];
    } else {
        [super onDataProviderUpdateSuccess:lookupResult context:array];

        // find the up to date version of this theater
        self.theater = [lookupResult.theaters objectAtIndex:[lookupResult.theaters indexOfObject:self.theater]];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        if (row == 0) {
            [Application openMap:self.theater.mapUrl];
        } else {
            [Application makeCall:self.theater.phoneNumber];
            // no call will be made if this is an iPod touch.
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if (section == 1) {
        if (row == 0 && [Application canSendMail]) {
            [self didSelectEmailListings];
        } else {
            [self didSelectChangeDate];
        }
    } else {
        section -= 2;

        Movie* movie = [self.movies objectAtIndex:section];
        if (row == 0) {
            [self.abstractNavigationController pushMovieDetails:movie animated:YES];
        } else {
            [self pushTicketsView:movie animated:YES];
        }
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    if (section == 1) {
        if (self.movies.count == 0) {
            return [NSString stringWithFormat:
                    NSLocalizedString(@"This theater has not yet reported its show times. "
                                      "When they become available, %@ will retrieve them automatically.", nil),
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        }

        if (![self.model isStale:self.theater]) {
            return [self.model showtimesRetrievedOnString:self.theater];
        }
    }

    return nil;
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
    if (section == 1) {
        if (self.movies.count > 0 ) {
            if ([self.model isStale:self.theater]) {
                return [WarningView viewWithText:[self.model showtimesRetrievedOnString:self.theater]];
            }
        }
    }

    return nil;
}


- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger) section {
    WarningView* view = (id)[self tableView:tableView viewForFooterInSection:section];
    if (view != nil) {
        return view.height;
    }

    return -1;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end