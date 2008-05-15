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

- (void) findShowIds {
    DifferenceEngine* engine = [DifferenceEngine engine];
    
    XmlElement* ticketElement = [[self.controller model] tickets];
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
                    title:(NSString*) title_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.controller = controller_;
        self.theater = theater_;
        self.movie = movie_;
        self.showtimes = [[self.controller model] movieShowtimes:self.movie forTheater:self.theater];

        self.showIds = [NSMutableArray array];
        self.movieIds = [NSMutableArray array];
        self.theaterIds = [NSMutableArray array];
        
        [self findShowIds];
        if ([self.showIds count] == 0) {
            for (int i = 0; i < [self.showtimes count]; i++) {
                [self.showIds addObject:@""];
            }
        }
        
        self.title = title_;
    }
    
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger)       tableView:(UITableView*) tableView
        numberOfRowsInSection:(NSInteger) section {
    return [showtimes count];;
}

- (UITableViewCell*)        tableView:(UITableView*) tableView
                cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    
    NSInteger row = [indexPath row];
    
    static NSString* reuseIdentifier = @"TicketsViewCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
    
        cell.textAlignment = UITextAlignmentCenter;
        cell.font = [UIFont boldSystemFontOfSize:14];
    }
    
    NSString* showtime = [showtimes objectAtIndex:row];
    if ([Utilities isNilOrEmpty:[self.showIds objectAtIndex:[indexPath row]]]) {
        cell.text = [NSString stringWithFormat:@"%@ (No Online Ticketing)", showtime];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textColor = [Application lightBlueTextColor];
        cell.text = [NSString stringWithFormat:@"Order Tickets for %@ Show", showtime];
    }
    
    return cell;
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath; {
    NSInteger row = [indexPath row];
    
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

@end

