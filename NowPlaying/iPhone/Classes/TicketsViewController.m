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
#import "Application.h"
#import "AttributeCell.h"
#import "ColorCache.h"
#import "DataProvider.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "NowPlayingModel.h"
#import "Performance.h"
#import "SearchDatePickerViewController.h"
#import "Theater.h"
#import "Utilities.h"
#import "ViewControllerUtilities.h"
#import "WarningView.h"

@interface TicketsViewController()
@property (retain) AbstractNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) Theater* theater;
@property (retain) NSMutableArray* performances;
@end


@implementation TicketsViewController

@synthesize navigationController;
@synthesize theater;
@synthesize movie;
@synthesize performances;

- (void) dealloc {
    self.navigationController = nil;
    self.theater = nil;
    self.movie = nil;
    self.performances = nil;

    [super dealloc];
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (void) majorRefresh {
    NSArray* allPerformances =  [self.model moviePerformances:movie forTheater:theater];
    self.performances = [NSMutableArray array];

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

        [performances addObject:performance];
    }
}


- (id) initWithController:(AbstractNavigationController*) navigationController_
                  theater:(Theater*) theater_
                    movie:(Movie*) movie_
                    title:(NSString*) title_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
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


- (void) viewDidAppear:(BOOL)animated {
    visible = YES;
    [self.model saveNavigationStack:navigationController];
}


- (void) viewDidDisappear:(BOOL)animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (/*navigationController.visible ||*/ visible) {
        return;
    }

    self.performances = nil;

    [super didReceiveMemoryWarning];
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];

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


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    if (section == 1) {
        if (performances.count == 0) {
            return NSLocalizedString(@"No more show times available today.", nil);
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
        if (performances.count > 0 ) {
            if ([self.model isStale:theater]) {
                return [WarningView view:[self.model showtimesRetrievedOnString:theater]];
            }
        }
    }

    return nil;
}

- (CGFloat)          tableView:(UITableView*) tableView
      heightForFooterInSection:(NSInteger)section {
    WarningView* view = (id)[self tableView:tableView viewForFooterInSection:section];
    if (view != nil) {
        return view.height;
    }

    return -1;
}


- (UITableViewCell*) showtimeCellForSection:(NSInteger) section row:(NSInteger) row {
    static NSString* reuseIdentifier = @"TicketsViewShowtimeCellIdentifier";

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

    [Application openBrowser:performance.url];
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
                     [Utilities stringByAddingPercentEscapes:theaterAndDate],
                     [Utilities stringByAddingPercentEscapes:body]];

    [Application openBrowser:url];
}


- (void) didSelectInfoCellAtRow:(NSInteger) row {
    if (row == 0) {
        SearchDatePickerViewController* pickerController = [SearchDatePickerViewController pickerWithNavigationController:navigationController];
        [navigationController pushViewController:pickerController animated:YES];
    } else {
        [self didSelectEmailListings];
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