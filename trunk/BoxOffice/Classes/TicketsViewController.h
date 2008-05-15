//
//  TicketsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"
#import "Theater.h"

@class AbstractNavigationController;

@interface TicketsViewController : UITableViewController {
    AbstractNavigationController* controller;
    Movie* movie;
    Theater* theater;
    NSArray* showtimes;
    
    NSMutableArray* ticketUrls;
}

@property (retain) AbstractNavigationController* controller;
@property (retain) Movie* movie;
@property (retain) Theater* theater;
@property (retain) NSArray* showtimes;
@property (retain) NSMutableArray* ticketUrls;

- (id) initWithController:(AbstractNavigationController*) controller
                  theater:(Theater*) theater
                    movie:(Movie*) movie
                    title:(NSString*) title;

@end
