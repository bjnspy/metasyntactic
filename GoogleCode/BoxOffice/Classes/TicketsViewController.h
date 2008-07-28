//
//  TicketsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/10/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Movie.h"
#import "Theater.h"

@class AbstractNavigationController;

@interface TicketsViewController : UITableViewController {
    AbstractNavigationController* navigationController;
    Movie* movie;
    Theater* theater;

    NSMutableArray* performances;
    NSMutableArray* futurePerformances;
}

@property (retain) AbstractNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) Theater* theater;
@property (retain) NSMutableArray* performances;
@property (retain) NSMutableArray* futurePerformances;

- (id) initWithController:(AbstractNavigationController*) navigationController
                  theater:(Theater*) theater
                    movie:(Movie*) movie
                    title:(NSString*) title;

- (void) refresh;

@end
