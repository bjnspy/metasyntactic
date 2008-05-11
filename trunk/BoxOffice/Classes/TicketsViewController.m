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

@implementation TicketsViewController

@synthesize controller;
@synthesize theater;
@synthesize movie;
@synthesize showtimes;
@synthesize ticketUrls;

- (void) dealloc {
    self.controller = nil;
    self.theater = nil;
    self.movie = nil;
    self.showtimes = nil;
    self.ticketUrls = nil;
	[super dealloc];
}

NSComparisonResult compareTheaterElements(id t1, id t2, void* context) {
    XmlElement* theaterElement1 = t1;
    XmlElement* theaterElement2 = t2;
    NSString* theaterName = context;
    
    int distance1 = [[DifferenceEngine engine] editDistanceFrom:[theaterElement1 element:@"name"].text to:theaterName];
    int distance2 = [[DifferenceEngine engine] editDistanceFrom:[theaterElement2 element:@"name"].text to:theaterName];
    
    if (distance1 < distance2) {
        return NSOrderedAscending;
    } else if (distance1 > distance2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }    
}

NSComparisonResult compareMovieElements(id t1, id t2, void* context) {
    XmlElement* movieElement1 = t1;
    XmlElement* movieElement2 = t2;
    NSString* movieName = context;
    
    int distance1 = [[DifferenceEngine engine] editDistanceFrom:[movieElement1 element:@"title"].text to:movieName];
    int distance2 = [[DifferenceEngine engine] editDistanceFrom:[movieElement2 element:@"title"].text to:movieName];
    
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
    NSDate* date = [NSDate dateWithNaturalLanguageString:showtime];
    
    for (XmlElement* movieElement in [theaterElement element:@"movies"].children) {
        if ([movieId isEqual:[movieElement attributeValue:@"id"]]) {
            for (XmlElement* performanceElement in [movieElement element:@"performances"].children) {
                NSDate* performanceDate = [NSDate dateWithNaturalLanguageString:[performanceElement attributeValue:@"showtime"]];
                
                if ([date isEqual:performanceDate]) {
                    return [performanceElement attributeValue:@"showid"];
                }
            }
        }
    }
     
    return nil;
}

- (void) findTicketUrls {
    XmlElement* ticketElement = [[self.controller model] tickets];
    XmlElement* dataElement = [ticketElement element:@"data"];
    XmlElement* moviesElement = [dataElement element:@"movies"];
    XmlElement* theatersElement = [dataElement element:@"theaters"];
    
    NSArray* sortedMovieElements = [moviesElement.children sortedArrayUsingFunction:compareMovieElements
                                                                            context:self.movie.title];
    
    NSArray* sortedTheaterElements = [theatersElement.children sortedArrayUsingFunction:compareTheaterElements
                                                                                context:self.theater.name];
    
    XmlElement* bestMovieElement = [sortedMovieElements objectAtIndex:0];
    XmlElement* bestTheaterElement = [sortedTheaterElements objectAtIndex:0];
    
    if (![DifferenceEngine areSimilar:[bestMovieElement element:@"title"].text
                                other:self.movie.title]) {
        return;
    }
    
    if (![DifferenceEngine areSimilar:[bestTheaterElement element:@"name"].text
                                other:self.theater.name]) {
        return;
    }
    
    for (NSString* showtime in self.showtimes) {
        NSString* urlString = @"";
        
        if ([@"True" isEqual:[bestTheaterElement attributeValue:@"iswired"]]) {
            NSString* showId = [self findShowId:showtime
                                   movieElement:bestMovieElement
                                 theaterElement:bestTheaterElement];
            
            if (showId != nil) {
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
                
                urlString =
                  [NSString stringWithFormat:@"https://mobile.fandango.com/tickets.jsp?mk=%@&tk=%@&showtime=%d:%d:%d:%d:%02d",
                    [bestMovieElement attributeValue:@"id"],
                    [bestTheaterElement attributeValue:@"id"],
                    [components year],
                    [components month],
                    (alreadyAfter ? [components day] + 1 : [components day]),
                    [components hour],
                    [components minute]];
                                
                //urlString =
                  //[NSString stringWithFormat:@"https://www.fandango.com/purchase/movietickets/process03/ticketboxoffice.aspx?row_count=%@&mid=%@&tid=%@",
                     //showId, [bestMovieElement attributeValue:@"id"], [bestTheaterElement attributeValue:@"tmsid"]];
            }
        }
        
        [self.ticketUrls addObject:urlString];
    }
}

- (id) initWithController:(AbstractNavigationController*) controller_
                  theater:(Theater*) theater_
                    movie:(Movie*) movie_  {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.controller = controller_;
        self.theater = theater_;
        self.movie = movie_;
        self.showtimes = [[self.controller model] movieShowtimes:self.movie forTheater:self.theater];
        self.ticketUrls = [NSMutableArray array];
        
        [self findTicketUrls];
        
        self.title = [NSString stringWithFormat:@"@ %@", theater.name];
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
    
	static NSString* cellIdentifier = @"TicketsViewControllerCellIdentifier";

	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
     
    cell.text = [showtimes objectAtIndex:row]; 
    
	return cell;
}

- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
    
    NSInteger row = [indexPath row];
    
    NSString* ticketUrl = [self.ticketUrls objectAtIndex:row];
    if (![Utilities isNilOrEmpty:ticketUrl]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ticketUrl]];
    }
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    NSInteger row = [indexPath row];
    if ([self.ticketUrls objectAtIndex:row] != nil) {
        return UITableViewCellAccessoryDetailDisclosureButton;
    } else {
        return UITableViewCellAccessoryNone;
    }

}

@end

