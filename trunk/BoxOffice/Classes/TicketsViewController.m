//
//  TicketsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TicketsViewController.h"
#import "AbstractNavigationController.h"
#import "DifferenceEngine.h"
#import "Utilities.h"
#import "Application.h"
#import "AutoresizingCell.h"
#import "ApplicationTabBarController.h"
#import "ViewControllerUtilities.h"

@implementation TicketsViewController

@synthesize controller;
@synthesize theater;
@synthesize movie;
@synthesize showtimes;
@synthesize showIds;
@synthesize movieIds;
@synthesize theaterIds;

- (void) dealloc {
    self.controller = nil;
    self.theater = nil;
    self.movie = nil;
    self.showtimes = nil;
    self.showIds = nil;
    self.movieIds = nil;
    self.theaterIds = nil;
    [super dealloc];
}

NSComparisonResult compareTheaterElements(id t1, id t2, void* context1, void* context2) {
    XmlElement* theaterElement1 = t1;
    XmlElement* theaterElement2 = t2;
    NSString* theaterName = context1;
    DifferenceEngine* engine = context2;
    
    int distance1 = [engine editDistanceFrom:[theaterElement1 element:@"name"].text to:theaterName];
    int distance2 = [engine editDistanceFrom:[theaterElement2 element:@"name"].text to:theaterName];
    
    if (distance1 < distance2) {
        return NSOrderedAscending;
    } else if (distance1 > distance2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }    
}

NSComparisonResult compareMovieElements(id t1, id t2, void* context1, void* context2) {
    XmlElement* movieElement1 = t1;
    XmlElement* movieElement2 = t2;
    NSString* movieName = context1;
    DifferenceEngine* engine = context2;
    
    int distance1 = [engine editDistanceFrom:[movieElement1 element:@"title"].text to:movieName];
    int distance2 = [engine editDistanceFrom:[movieElement2 element:@"title"].text to:movieName];
    
    if (distance1 < distance2) {
        return NSOrderedAscending;
    } else if (distance1 > distance2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSString*) findShowId:(NSString*) showtime
            movieElement:(XmlElement*) movieElement
          theaterElement:(XmlElement*) theaterElement {
    NSString* movieId = [movieElement.attributes valueForKey:@"id"];
    NSString* date1 = [Theater processShowtime:showtime];
    
    for (XmlElement* movieElement in [theaterElement element:@"movies"].children) {
        if ([movieId isEqual:[movieElement attributeValue:@"id"]]) {
            for (XmlElement* performanceElement in [movieElement element:@"performances"].children) {
                NSString* performanceDate = [Theater processShowtime:[performanceElement attributeValue:@"showtime"]];
                
                if ([date1 isEqual:performanceDate]) {
                    return [performanceElement attributeValue:@"showid"];
                }
            }
        }
    }
    
    return nil;
}

- (BoxOfficeModel*) model {
    return [self.controller model];
}

- (void) findShowIds {
    DifferenceEngine* engine = [DifferenceEngine engine];
    
    XmlElement* ticketElement = [[self model] tickets];
    XmlElement* dataElement = [ticketElement element:@"data"];
    XmlElement* moviesElement = [dataElement element:@"movies"];
    XmlElement* theatersElement = [dataElement element:@"theaters"];
    
    XmlElement* bestMovieElement = [Utilities findSmallestElementInArray:moviesElement.children
                                                           usingFunction:compareMovieElements
                                                                context1:self.movie.title
                                                                context2:engine];
    
    XmlElement* bestTheaterElement = [Utilities findSmallestElementInArray:theatersElement.children
                                                             usingFunction:compareTheaterElements
                                                                  context1:self.theater.name
                                                                  context2:engine]; 
    
    
    if ([DifferenceEngine areSimilar:[bestMovieElement element:@"title"].text other:self.movie.title] &&
        [DifferenceEngine areSimilar:[bestTheaterElement element:@"name"].text other:self.theater.name] &&
        [@"True" isEqual:[bestTheaterElement attributeValue:@"iswired"]]) {
        
        for (NSString* showtime in self.showtimes) {
            NSString* showId = [self findShowId:showtime
                                   movieElement:bestMovieElement
                                 theaterElement:bestTheaterElement];
            
            if (showId == nil) {
                showId = @"";
            }
            
            [self.showIds addObject:showId];
            [self.movieIds addObject:[bestMovieElement attributeValue:@"id"]];
            [self.theaterIds addObject:[bestTheaterElement attributeValue:@"id"]];
        }
    }
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
        self.showtimes = [[self model] movieShowtimes:self.movie forTheater:self.theater];
        linkToTheater = linkToTheater_;

        self.showIds = [NSMutableArray array];
        self.movieIds = [NSMutableArray array];
        self.theaterIds = [NSMutableArray array];
        
        [self findShowIds];
        if ([self.showIds count] == 0) {
            for (int i = 0; i < [self.showtimes count]; i++) {
                [self.showIds addObject:@""];
            }
        }
        
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
        return [showtimes count];
    }
    
    return 0;
}

- (UITableViewCell*) showtimeCellForRow:(NSInteger) row {
    static NSString* reuseIdentifier = @"TicketsViewShowtimeCellIdentifier";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        
        cell.textAlignment = UITextAlignmentCenter;
        cell.font = [UIFont boldSystemFontOfSize:14];
    }
    
    NSString* showtime = [showtimes objectAtIndex:row];
    if ([Utilities isNilOrEmpty:[self.showIds objectAtIndex:row]]) {
        cell.textColor = [UIColor blackColor];
        
        cell.text = [NSString stringWithFormat:@"%@ (No Online Ticketing)", showtime];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textColor = [Application commandColor];
        
        NSDate* now = [NSDate date];
        NSDate* showtimeDate = [NSDate dateWithNaturalLanguageString:showtime];
        
        NSString* day;
        if ([now compare:showtimeDate] == NSOrderedAscending) {
            day = @"Today";
        } else {
            day = @"Tomorrow";
        }
        
        cell.text = [NSString stringWithFormat:@"Order Tickets for %@ %@", showtime, day];
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
            cell.label.text = @"Show All Movies at This Theater";
        } else {
            cell.label.text = @"Show All Theaters Playing This Movie";
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
    NSString* showId = [self.showIds objectAtIndex:row];
    if ([Utilities isNilOrEmpty:showId]) {
        return;
    }
    
    NSString* showtime =[self.showtimes objectAtIndex:row];
    NSString* movieId = [self.movieIds objectAtIndex:row];
    NSString* theaterId = [self.theaterIds objectAtIndex:row];
    
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
    
    NSString* urlString =
    [NSString stringWithFormat:@"https://mobile.fandango.com/tickets.jsp?mk=%@&tk=%@&showtime=%d:%d:%d:%d:%02d",
     movieId,
     theaterId,
     [components year],
     [components month],
     (alreadyAfter ? [components day] + 1 : [components day]),
     [components hour],
     [components minute]];
    
    //urlString =
    //[NSString stringWithFormat:@"https://www.fandango.com/purchase/movietickets/process03/ticketboxoffice.aspx?row_count=%@&mid=%@&tid=%@",
    //showId, [bestMovieElement attributeValue:@"id"], [bestTheaterElement attributeValue:@"tmsid"]];
    
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url];    
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == 0) {
        [self didSelectCommandAtRow:row];
    } else if (section == 1) {
        [self didSelectShowtimeAtRow:row];
    }
}

@end

