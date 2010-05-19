// Copyright 2010 Cyrus Najmabadi
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

#import "TheaterDetailsViewController.h"

#import "Application.h"
#import "BoxOfficeStockImages.h"
#import "FavoriteTheaterCache.h"
#import "LookupResult.h"
#import "Model.h"
#import "MovieShowtimesCell.h"
#import "MovieTitleCell.h"
#import "Theater.h"
#import "TheatersNavigationController.h"
#import "Utilities.h"
#import "WarningView.h"


@interface TheaterDetailsViewController()
@property (retain) UIButton* favoriteButton;
@property (retain) Theater* theater;
@property (retain) NSArray* movies;
@property (retain) NSArray* movieShowtimes;
@end


@implementation TheaterDetailsViewController

@synthesize theater;
@synthesize movies;
@synthesize movieShowtimes;
@synthesize favoriteButton;

- (void) dealloc {
  self.theater = nil;
  self.movies = nil;
  self.movieShowtimes = nil;
  self.favoriteButton = nil;

  [super dealloc];
}


- (void) setFavoriteImage {
  favoriteButton.selected = [[FavoriteTheaterCache cache] isFavoriteTheater:theater];
}


- (void) switchFavorite:(id) sender {
  if ([[FavoriteTheaterCache cache] isFavoriteTheater:theater]) {
    [[FavoriteTheaterCache cache] removeFavoriteTheater:theater];
  } else {
    [[FavoriteTheaterCache cache] addFavoriteTheater:theater];
  }

  [self setFavoriteImage];
}


- (void) initializeFavoriteButton {
  self.favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [favoriteButton setImage:[BoxOfficeStockImages emptyStarImage] forState:UIControlStateNormal];
  [favoriteButton setImage:[BoxOfficeStockImages filledYellowStarImage] forState:UIControlStateSelected];
  [favoriteButton addTarget:self action:@selector(switchFavorite:) forControlEvents:UIControlEventTouchUpInside];

  CGRect frame = favoriteButton.frame;
  frame.size = [BoxOfficeStockImages emptyStarImage].size;
  frame.size.width += 10;
  frame.size.height += 10;
  favoriteButton.frame = frame;

  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:favoriteButton] autorelease];
  [self setFavoriteImage];
}


- (id) initWithTheater:(Theater*) theater_ {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.theater = theater_;
  }

  return self;
}


- (void) loadView {
  [super loadView];

  [self initializeFavoriteButton];
  self.title = theater.name;
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  self.favoriteButton = nil;
  self.movies = nil;
  self.movieShowtimes = nil;
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  self.movies = [[[Model model] moviesAtTheater:theater] sortedArrayUsingFunction:compareMoviesByTitle
                                                                       context:[Model model]];

  NSMutableArray* array = [NSMutableArray array];
  for (Movie* movie in movies) {
    NSArray* showtimes = [[Model model] moviePerformances:movie forTheater:theater];

    [array addObject:showtimes];
  }

  self.movieShowtimes = array;
}


- (void) minorRefresh {
  [self majorRefresh];
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
    if ([DateUtilities isToday:[Model model].searchDate]) {
      return LocalizedString(@"Today", nil);
    } else {
      return [DateUtilities formatFullDate:[Model model].searchDate];
    }
  }

  return nil;
}


- (UITableViewCell*) cellForHeaderRow:(NSInteger) row {
  AttributeCell* cell = [[[AttributeCell alloc] initWithReuseIdentifier:nil] autorelease];

  if (row == 0) {
    cell.textLabel.text = LocalizedString(@"Map", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'open a map to the currently listed address'");
    cell.detailTextLabel.text = [[Model model] simpleAddressForTheater:theater];
  } else {
    cell.textLabel.text = LocalizedString(@"Call", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'to make a phonecall'");
    cell.detailTextLabel.text = theater.phoneNumber;
  }

  return cell;
}


- (UITableViewCell*) cellForActionRow:(NSInteger) row {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  cell.textLabel.textColor = [ColorCache commandColor];
  cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
  cell.textLabel.textAlignment = UITextAlignmentCenter;

  if (row == 0) {
    cell.textLabel.text = LocalizedString(@"E-mail listings", nil);
  } else {
    cell.textLabel.text = LocalizedString(@"Change date", nil);
  }

  return cell;
}


- (UITableViewCell*) cellForTheaterIndex:(NSInteger) index row:(NSInteger) row {
  if (row == 0) {
    Movie* movie = [movies objectAtIndex:index];

    MovieTitleCell* cell = [MovieTitleCell movieTitleCellForMovie:movie inTableView:self.tableView];
    return cell;
  } else {
    static NSString* reuseIdentifier = @"showtimesReuseIdentifier";
    MovieShowtimesCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[MovieShowtimesCell alloc] initWithReuseIdentifier:reuseIdentifier tableViewController:self] autorelease];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    [cell setShowtimes:[movieShowtimes objectAtIndex:index]];

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
    if (row == 0) {
      return tableView.rowHeight;
    } else {
      id cell = [self tableView:tableView
          cellForRowAtIndexPath:indexPath];
      return [cell height] + 18;
    }
  }
}


- (void) didSelectEmailListings {
  NSString* subject = [NSString stringWithFormat:@"%@ - %@",
                       theater.name,
                       [DateUtilities formatFullDate:[Model model].searchDate]];
  NSMutableString* body = [NSMutableString string];

  [body appendString:@"<p>"];
  [body appendString:@"<a href=\""];
  [body appendString:theater.mapUrl];
  [body appendString:@"\">"];
  [body appendString:[[Model model] simpleAddressForTheater:theater]];
  [body appendString:@"</a>"];

  for (NSInteger i = 0; i < movies.count; i++) {
    [body appendString:@"<p>"];

    Movie* movie = [movies objectAtIndex:i];
    NSArray* performances = [movieShowtimes objectAtIndex:i];

    [body appendString:movie.displayTitle];
    [body appendString:@"<br/>"];
    [body appendString:[Utilities generateShowtimeLinks:[Model model]
                                                  movie:movie
                                                theater:theater
                                           performances:performances]];
  }

  [self openMailTo:nil
       withSubject:subject
              body:body
            isHTML:YES];
}


- (void) pushTicketsView:(Movie*) movie
                animated:(BOOL) animated {
  [self.commonNavigationController pushTicketsView:movie
   theater:theater
   title:movie.displayTitle
   animated:animated];
}


- (void) didSelectChangeDate {
  [self changeDate];
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(NSArray*) array {
  if (updateId != [array.firstObject integerValue]) {
    return;
  }

  NSDate* searchDate = array.lastObject;

  if (![lookupResult.theaters containsObject:theater]) {
    NSString* text =
    [NSString stringWithFormat:
     LocalizedString(@"No listings found at '%@' on %@", @"No listings found at 'Regal Meridian 6' on 5/18/2008"),
     theater.name,
     [DateUtilities formatShortDate:searchDate]];

    [self onDataProviderUpdateFailure:text context:array];
  } else {
    // find the up to date version of this theater
    self.theater = [lookupResult.theaters objectAtIndex:[lookupResult.theaters indexOfObject:theater]];

    [super onDataProviderUpdateSuccess:lookupResult context:array];
  }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;

  if (section == 0) {
    if (row == 0) {
      return [self.abstractNavigationController pushMapWithCenter:theater animated:YES];
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
      [self.commonNavigationController pushMovieDetails:movie animated:YES];
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
              LocalizedString(@"This theater has not yet reported its show times. "
                              "When they become available, %@ will retrieve them automatically.", nil),
              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    }

    if (![[Model model] isStale:theater]) {
      return [[Model model] showtimesRetrievedOnString:theater];
    }
  }

  return nil;
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
  if (section == 1) {
    if (movies.count > 0 ) {
      if ([[Model model] isStale:theater]) {
        return [WarningView viewWithText:[[Model model] showtimesRetrievedOnString:theater]];
      }
    }
  }

  return nil;
}


- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger) section {
  WarningView* view = (id)[self tableView:tableView viewForFooterInSection:section];
  if (view != nil) {
    return [view height:self];
  }

  return -1;
}

@end
