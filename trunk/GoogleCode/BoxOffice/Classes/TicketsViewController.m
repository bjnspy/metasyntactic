//
//  TicketsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/10/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "TicketsViewController.h"
#import "AbstractNavigationController.h"
#import "DifferenceEngine.h"
#import "Utilities.h"
#import "Application.h"
#import "AutoresizingCell.h"
#import "ApplicationTabBarController.h"
#import "ViewControllerUtilities.h"
#import "Performance.h"

@implementation TicketsViewController

@synthesize controller;
@synthesize theater;
@synthesize movie;
@synthesize performances;

- (void) dealloc {
    self.controller = nil;
    self.theater = nil;
    self.movie = nil;
    self.performances = nil;
    
    [super dealloc];
}

- (BoxOfficeModel*) model {
    return [self.controller model];
}

- (id) initWithController:(AbstractNavigationController*) controller_
                  theater:(Theater*) theater_
                    movie:(Movie*) movie_
                    title:(NSString*) title_
            linkToTheater:(BOOL) linkToTheater_  {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.controller = controller_;
        self.theater = theater_;
        self.movie = movie_;
        
        linkToTheater = linkToTheater_;

        self.performances = [self.theater.movieToShowtimesMap objectForKey:movie.identifier];
        
        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = title_;
         
        self.title = title_;
        self.navigationItem.titleView = label;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[self model].activityView] autorelease];
    
    [self.model setCurrentlySelectedMovie:self.movie theater:self.theater];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 2;
}

- (NSInteger)       tableView:(UITableView*) tableView
        numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return [performances count];
    }
    
    return 0;
}

- (Performance*) performanceAtIndex:(NSInteger) index {
    return [self.performances objectAtIndex:index];
}

- (UITableViewCell*) showtimeCellForRow:(NSInteger) row {
    static NSString* reuseIdentifier = @"TicketsViewShowtimeCellIdentifier";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        
        cell.textAlignment = UITextAlignmentCenter;
        cell.font = [UIFont boldSystemFontOfSize:14];
    }
    
    NSString* showtime = [[self performanceAtIndex:row] time];
    if (![self.theater.sellsTickets isEqual:@"True"]) {
        cell.textColor = [UIColor blackColor];
        
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (No Online Ticketing)", nil), showtime];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textColor = [Application commandColor];
        
        NSDate* now = [NSDate date];
        NSDate* showtimeDate = [NSDate dateWithNaturalLanguageString:showtime];
        
        if ([now compare:showtimeDate] == NSOrderedAscending) {
            cell.text = [NSString stringWithFormat:NSLocalizedString(@"Order tickets for %@ today", nil), showtime];
        } else {
            cell.text = [NSString stringWithFormat:NSLocalizedString(@"Order tickets for %@ tomorrow", nil), showtime];
        }
    }
    
    return cell;    
}

- (UITableViewCell*) commandCellForRow:(NSInteger) row {
    static NSString* reuseIdentifier = @"TicketsViewCommandCellIdentifier";
    
    AutoresizingCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[AutoresizingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        cell.label.textColor = [Application commandColor];
    }
    
    if (row == 0) {
        cell.label.text = self.theater.address;
    } else if (row == 1) {
        cell.label.text = self.theater.phoneNumber;
    } else if (row == 2) {
        if (linkToTheater) {
            cell.label.text = NSLocalizedString(@"Show all movies at this theater", nil);
        } else {
            cell.label.text = NSLocalizedString(@"Show all theaters playing this movie", nil);
        }
    }
    
    return cell;
}

- (UITableViewCell*)        tableView:(UITableView*) tableView
                cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        return [self commandCellForRow:row];
    } else if (section == 1) {
        return [self showtimeCellForRow:row];
    }
    
    return nil;
}

- (void) didSelectCommandAtRow:(NSInteger) row {
    if (row == 0) {
        [Application openMap:theater.address];
    } else if (row == 1) {
        [Application makeCall:theater.phoneNumber];
    } else if (row == 2) {
        if (linkToTheater) {
            [self.controller.tabBarController showTheaterDetails:theater];
        } else {
            [self.controller.tabBarController showMovieDetails:movie];
        }
    }
}

- (void) didSelectShowtimeAtRow:(NSInteger) row {
    NSString* showId = [[self performanceAtIndex:row] identifier];
    if (![self.theater.sellsTickets isEqual:@"True"] ||
        [Utilities isNilOrEmpty:showId]) {
        return;
    }
    
    NSString* showtime = [[self performanceAtIndex:row] time];
    NSString* movieId = self.movie.identifier;
    NSString* theaterId = self.theater.identifier;
    
    //https://mobile.fandango.com/tickets.jsp?mk=98591&tk=557&showtime=2008:5:11:16:00
    //https://www.fandango.com/purchase/movietickets/process03/ticketboxoffice.aspx?row_count=1601099982&mid=98591&tid=AAJNK
    
    NSDate* date = [NSDate dateWithNaturalLanguageString:showtime];
    NSDate* now = [NSDate date];
    BOOL alreadyAfter = [now compare:date] == NSOrderedDescending;
    
    NSDateComponents* components = 
    [[NSCalendar currentCalendar]
     components:
     (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)
     fromDate:date];
    
    NSString* url =
    [NSString stringWithFormat:@"https://mobile.fandango.com/tickets.jsp?mk=%@&tk=%@&showtime=%d:%d:%d:%d:%02d",
     movieId,
     theaterId,
     [components year],
     [components month],
     (alreadyAfter ? [components day] + 1 : [components day]),
     [components hour],
     [components minute]];
    
    [Application openBrowser:url];  
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        [self didSelectCommandAtRow:row];
    } else if (section == 1) {
        [self didSelectShowtimeAtRow:row];
    }
}

@end

