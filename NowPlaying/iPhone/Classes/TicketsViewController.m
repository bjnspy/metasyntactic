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

#import "TicketsViewController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "Application.h"
#import "AttributeCell.h"
#import "ColorCache.h"
#import "DataProvider.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "LookupResult.h"
#import "Movie.h"
#import "Model.h"
#import "Performance.h"
#import "SearchDatePickerViewController.h"
#import "StringUtilities.h"
#import "Theater.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"
#import "WarningView.h"

@interface TicketsViewController()
@property (retain) Movie* movie;
@property (retain) Theater* theater;
@property (retain) NSArray* performances;
@end


@implementation TicketsViewController

@synthesize theater;
@synthesize movie;
@synthesize performances;

- (void) dealloc {
    self.theater = nil;
    self.movie = nil;
    self.performances = nil;

    [super dealloc];
}


- (void) initializeData {
    NSArray* allPerformances =  [self.model moviePerformances:movie forTheater:theater];
    NSMutableArray* result = [NSMutableArray array];

    NSDate* now = [DateUtilities currentTime];

    for (Performance* performance in allPerformances) {
        if ([DateUtilities isToday:self.model.searchDate]) {
            NSDate* time = performance.time;

            // skip times that have already passed.
            if ([now compare:time] == NSOrderedDescending) {

                // except for times that are before 4 AM
                NSDateComponents* components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit
                                                                               fromDate:time];
                if (components.hour > 4) {
                    continue;
                }
            }
        }

        [result addObject:performance];
    }

    self.performances = result;
}


- (void) majorRefresh {
    [self initializeData];
    [self.tableView reloadData];
}


- (id) initWithController:(AbstractNavigationController*) navigationController_
                  theater:(Theater*) theater_
                    movie:(Movie*) movie_
                    title:(NSString*) title_ {
    if (self = [super initWithNavigationController:navigationController_]) {
        self.theater = theater_;
        self.movie = movie_;
        self.title = title_;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
    label.text = self.title;

    self.navigationItem.titleView = label;
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

    self.performances = nil;

    [super didReceiveMemoryWarning];
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[AppDelegate globalActivityView]] autorelease];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self majorRefresh];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 3;
}


- (NSInteger)       tableView:(UITableView*) tableView
        numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        if (theater.phoneNumber.length == 0) {
            return 1;
        } else {
            return 2;
        }
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return performances.count;
    }

    return 0;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        return nil;
    } else if (section == 2 && performances.count) {
        if ([DateUtilities isToday:self.model.searchDate]) {
            return NSLocalizedString(@"Today", nil);
        } else {
            return [DateUtilities formatFullDate:self.model.searchDate];
        }
    }

    return nil;
}


- (UIView*)        tableView:(UITableView*) tableView
      viewForFooterInSection:(NSInteger) section {
    if (section == 1) {
        if (performances.count > 0 ) {
            if ([self.model isStale:theater]) {
                return [WarningView viewWithText:[self.model showtimesRetrievedOnString:theater]
                                           model:self.model];
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


- (UITableViewCell*) showtimeCellForSection:(NSInteger) section
                                        row:(NSInteger) row {
    static NSString* reuseIdentifier = @"reuseIdentifier";

    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                       reuseIdentifier:reuseIdentifier] autorelease];

        cell.textAlignment = UITextAlignmentCenter;
        cell.font = [UIFont boldSystemFontOfSize:14];
    }

    Performance* performance = [performances objectAtIndex:row];

    if (performance.url.length == 0) {
        cell.textColor = [UIColor blackColor];
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (No Online Ticketing)", nil),
                     performance.timeString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textColor = [ColorCache commandColor];
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"Order tickets for %@", nil),
                     performance.timeString];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    return cell;
}


- (UITableViewCell*) commandCellForRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                                    reuseIdentifier:nil] autorelease];
    
    if (row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Map", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'open a map to the currently listed address'");
        cell.detailTextLabel.text = [self.model simpleAddressForTheater:theater];
    } else {
        cell.textLabel.text = NSLocalizedString(@"Call", @"This string should try to be short.  So abbreviations are acceptable. It's a verb that means 'to make a phonecall'");
        cell.detailTextLabel.text = theater.phoneNumber;
    }
    
    return cell;
}


- (UITableViewCell*) infoCellForRow:(NSInteger) row {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];

    cell.textAlignment = UITextAlignmentCenter;
    cell.font = [UIFont boldSystemFontOfSize:14];
    cell.textColor = [ColorCache commandColor];

    if (row == 0) {
        cell.text = NSLocalizedString(@"Change date", nil);
    } else {
        cell.text = NSLocalizedString(@"E-mail listings", @"This string must it on a button half the width of the screen.  It means 'email the theater listings to a friend'");
    }

    return cell;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self commandCellForRow:indexPath.row];
    } else if (indexPath.section == 1) {
        return [self infoCellForRow:indexPath.row];
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        return [self showtimeCellForSection:indexPath.section row:indexPath.row];
    }

    return nil;
}


- (void) didSelectCommandAtRow:(NSInteger) row {
    if (row == 0) {
        [Application openMap:theater.mapUrl];
    } else if (row == 1) {
        [Application makeCall:theater.phoneNumber];
    }
}


- (void) didSelectShowtimeAtRow:(NSInteger) row {
    Performance* performance = [performances objectAtIndex:row];

    if (performance.url.length == 0) {
        return;
    }

    [navigationController pushBrowser:performance.url animated:YES];
}


- (void) didSelectEmailListings {
    NSString* theaterAndDate = [NSString stringWithFormat:@"%@ - %@",
                                movie.canonicalTitle,
                                [DateUtilities formatFullDate:self.model.searchDate]];
    NSMutableString* body = [NSMutableString string];

    [body appendString:theater.name];
    [body appendString:@"\n"];
    [body appendString:@"<a href=\""];
    [body appendString:theater.mapUrl];
    [body appendString:@"\">"];
    [body appendString:[self.model simpleAddressForTheater:theater]];
    [body appendString:@"</a>"];

    [body appendString:@"\n\n"];
    [body appendString:movie.canonicalTitle];
    [body appendString:@"\n"];

    [body appendString:[Utilities generateShowtimeLinks:self.model
                                                  movie:movie
                                                theater:theater
                                           performances:performances]];

    NSString* url = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@",
                     [StringUtilities stringByAddingPercentEscapes:theaterAndDate],
                     [StringUtilities stringByAddingPercentEscapes:body]];

    [Application openBrowser:url];
}


- (void) didSelectInfoCellAtRow:(NSInteger) row {
    if (row == 0) {
        [self changeDate];
    } else {
        [self didSelectEmailListings];
    }
}


- (void) onDataProviderUpdateSuccess:(LookupResult*) lookupResult context:(id) array {
    if (updateId != [[array objectAtIndex:0] intValue]) {
        return;
    }

    NSDate* searchDate = [array lastObject];

    NSArray* lookupResultPerformances = [[lookupResult.performances objectForKey:theater.name] objectForKey:movie.canonicalTitle];

    if (lookupResultPerformances.count == 0) {
        NSString* text =
        [NSString stringWithFormat:
         NSLocalizedString(@"No listings found for '%@' at '%@' on %@", @"No listings found for 'The Dark Knight' at 'Regal Meridian 6' on 5/18/2008"),
         movie.canonicalTitle,
         theater.name,
         [DateUtilities formatShortDate:searchDate]];

        [self onDataProviderUpdateFailure:text context:array];
    } else {
        [super onDataProviderUpdateSuccess:lookupResult context:array];

        // find the up to date version of this theater and movie
        self.theater = [lookupResult.theaters objectAtIndex:[lookupResult.theaters indexOfObject:theater]];
        self.movie = [lookupResult.movies objectAtIndex:[lookupResult.movies indexOfObject:movie]];
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self didSelectCommandAtRow:indexPath.row];
    } else if (indexPath.section == 1) {
        [self didSelectInfoCellAtRow:indexPath.row];
    } else if (indexPath.section == 2) {
        [self didSelectShowtimeAtRow:indexPath.row];
    }
}

@end