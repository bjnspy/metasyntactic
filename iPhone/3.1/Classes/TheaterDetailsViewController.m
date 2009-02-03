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
#import "AttributeCell.h"
#import "ColorCache.h"
#import "DateUtilities.h"
#import "ImageCache.h"
#import "LookupResult.h"
#import "Movie.h"
#import "MovieShowtimesCell.h"
#import "MovieTitleCell.h"
#import "Model.h"
#import "Theater.h"
#import "TheatersNavigationController.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"
#import "WarningView.h"

@interface TheaterDetailsViewController()
    @property (retain) UISegmentedControl* segmentedControl;
    @property (retain) UIButton* favoriteButton;
    @property (retain) Theater* theater;
    @property (retain) NSArray* movies;
    @property (retain) NSMutableArray* movieShowtimes;
@end


@implementation TheaterDetailsViewController

@synthesize theater;
@synthesize movies;
@synthesize movieShowtimes;
@synthesize segmentedControl;
@synthesize favoriteButton;

- (void) dealloc {
    self.theater = nil;
    self.movies = nil;
    self.movieShowtimes = nil;
    self.segmentedControl = nil;
    self.favoriteButton = nil;

    [super dealloc];
}


- (void) setFavoriteImage {
    self.favoriteButton.selected = [self.model isFavoriteTheater:theater];
}


- (void) switchFavorite:(id) sender {
    if ([self.model isFavoriteTheater:theater]) {
        [self.model removeFavoriteTheater:theater];
    } else {
        [self.model addFavoriteTheater:theater];
    }

    [self setFavoriteImage];
}


- (void) initializeFavoriteButton {
    self.favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteButton setImage:[ImageCache emptyStarImage] forState:UIControlStateNormal];
    [favoriteButton setImage:[ImageCache filledStarImage] forState:UIControlStateSelected];
    [favoriteButton addTarget:self action:@selector(switchFavorite:) forControlEvents:UIControlEventTouchUpInside];

    CGRect frame = favoriteButton.frame;
    frame.size = [ImageCache emptyStarImage].size;
    frame.size.width += 10;
    frame.size.height += 10;
    favoriteButton.frame = frame;

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:favoriteButton] autorelease];
    [self setFavoriteImage];
}


- (id) initWithNavigationController:(AbstractNavigationController*) controller
                            theater:(Theater*) theater_ {
    if (self = [super initWithNavigationController:controller]) {
        self.theater = theater_;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
    label.text = theater.name;

    self.title = theater.name;
    self.navigationItem.titleView = label;

    [self initializeFavoriteButton];
}


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
    [self.model saveNavigationStack:navigationController];
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    self.segmentedControl = nil;
    self.favoriteButton = nil;
    self.movies = nil;
    self.movieShowtimes = nil;

    [super didReceiveMemoryWarning];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self majorRefresh];
}


- (void) minorRefresh {
    [self majorRefresh];
}


- (void) initializeData {
    self.movies = [[self.model moviesAtTheater:theater] sortedArrayUsingFunction:compareMoviesByTitle
                                                                         context:self.model];

    self.movieShowtimes = [NSMutableArray array];
    for (Movie* movie in movies) {
        NSArray* showtimes = [self.model moviePerformances:movie forTheater:theater];

        [movieShowtimes addObject:showtimes];
    }
}


- (void) majorRefresh {
    [self initializeData];
    [self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    // header
    NSInteger sections = 1;

    // e-mail listings/change date
    sections++;

    // movies
    sections += movies.count;

    return sections;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        // theater address and possibly phone number
        return 1 + (theater.phoneNumber.length == 0 ? 0 : 1);
    } else if (section == 1) {
        return 2;
    } else {
        return 2;
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 2 && movies.count > 0) {
        if ([DateUtilities isToday:self.model.searchDate]) {
            return NSLocalizedString(@"Today", nil);
        } else {
            return [DateUtilities formatFullDate:self.model.searchDate];
        }
    }

    return nil;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
    AttributeCell* cell = [[[AttributeCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                                reuseIdentifier:nil] autorelease];

    NSString* mapString = NSLocalizedString(@"Map", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'open a map to the currently listed address'");
    NSString* callString = NSLocalizedString(@"Call", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'to make a phonecall'");
    CGSize size1 = [mapString sizeWithFont:[AttributeCell keyFont]];
    CGSize size2 = [callString sizeWithFont:[AttributeCell keyFont]];

    NSInteger width = MAX(size1.width, size2.width) + 30;

    if (row == 0) {
        [cell setKey:mapString
               value:[self.model simpleAddressForTheater:theater]
            keyWidth:width];
    } else {
        [cell setKey:callString
               value:theater.phoneNumber
            keyWidth:width];
    }

    return cell;
}


- (UITableViewCell*) cellForActionRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

    cell.textColor = [ColorCache commandColor];
    cell.font = [UIFont boldSystemFontOfSize:14];
    cell.textAlignment = UITextAlignmentCenter;

    if (row == 0) {
        cell.text = NSLocalizedString(@"E-mail listings", nil);
    } else {
        cell.text = NSLocalizedString(@"Change date", nil);
    }

    return cell;
}


- (UITableViewCell*) cellForTheaterIndex:(NSInteger) index row:(NSInteger) row {
    if (row == 0) {
        static NSString* reuseIdentifier = @"movieReuseIdentifier";
        id movieCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (movieCell == nil) {
            movieCell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                               reuseIdentifier:reuseIdentifier
                                                         model:self.model
                                                         style:UITableViewStyleGrouped] autorelease];
        }

        [movieCell setMovie:[movies objectAtIndex:index] owner:self];

        return movieCell;
    } else {
        static NSString* reuseIdentifier = @"showtimesReuseIdentifier";
        id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[MovieShowtimesCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                              reuseIdentifier:reuseIdentifier] autorelease];
        }

        [cell setShowtimes:[movieShowtimes objectAtIndex:index]
             useSmallFonts:self.model.useSmallFonts];

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
            return [MovieShowtimesCell heightForShowtimes:[movieShowtimes objectAtIndex:section]
                                                    stale:NO
                                            useSmallFonts:self.model.useSmallFonts] + 18;
        }
    }
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = indexPath.section;

    if (section == 0) {
        return UITableViewCellAccessoryNone;
    } else if (section == 1) {
        return UITableViewCellAccessoryNone;
    }

    return UITableViewCellAccessoryDisclosureIndicator;
}


- (void) didSelectEmailListings {
    NSString* theaterAndDate = [NSString stringWithFormat:@"%@ - %@",
                                theater.name,
                                [DateUtilities formatFullDate:self.model.searchDate]];
    NSMutableString* body = [NSMutableString string];

    [body appendString:@"<a href=\""];
    [body appendString:theater.mapUrl];
    [body appendString:@"\">"];
    [body appendString:[self.model simpleAddressForTheater:theater]];
    [body appendString:@"</a>"];

    for (int i = 0; i < movies.count; i++) {
        [body appendString:@"\n\n"];

        Movie* movie = [movies objectAtIndex:i];
        NSArray* performances = [movieShowtimes objectAtIndex:i];

        [body appendString:movie.displayTitle];
        [body appendString:@"\n"];
        [body appendString:[Utilities generateShowtimeLinks:self.model
                                                      movie:movie
                                                    theater:theater
                                               performances:performances]];
    }

    NSString* url = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@",
                     [Utilities stringByAddingPercentEscapes:theaterAndDate],
                     [Utilities stringByAddingPercentEscapes:body]];

    [Application openBrowser:url];
}


- (void) pushTicketsView:(Movie*) movie
                animated:(BOOL) animated {
    [navigationController pushTicketsView:movie
                                  theater:theater
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

    if (![lookupResult.theaters containsObject:theater]) {
        NSString* text =
        [NSString stringWithFormat:
         NSLocalizedString(@"No listings found at '%@' on %@", @"No listings found at 'Regal Meridian 6' on 5/18/2008"),
         theater.name,
         [DateUtilities formatShortDate:searchDate]];

        [self onDataProviderUpdateFailure:text context:array];
    } else {
        [super onDataProviderUpdateSuccess:lookupResult context:array];

        // find the up to date version of this theater
        self.theater = [lookupResult.theaters objectAtIndex:[lookupResult.theaters indexOfObject:theater]];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        if (row == 0) {
            [Application openMap:theater.mapUrl];
        } else {
            [Application makeCall:theater.phoneNumber];
            // no call will be made if this is an iPod touch.
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            [self didSelectEmailListings];
        } else {
            [self didSelectChangeDate];
        }
    } else {
        section -= 2;

        Movie* movie = [movies objectAtIndex:section];
        if (row == 0) {
            [navigationController pushMovieDetails:movie animated:YES];
        } else {
            [self pushTicketsView:movie animated:YES];
        }
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    if (section == 1) {
        if (movies.count == 0) {
            return [NSString stringWithFormat:
                    NSLocalizedString(@"This theater has not yet reported its show times. "
                                      "When they become available, %@ will retrieve them automatically.", nil),
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        }

        if (![self.model isStale:theater]) {
            return [self.model showtimesRetrievedOnString:theater];
        }
    }

    return nil;
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
    if (section == 1) {
        if (movies.count > 0 ) {
            if ([self.model isStale:theater]) {
                return [WarningView view:[self.model showtimesRetrievedOnString:theater]];
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