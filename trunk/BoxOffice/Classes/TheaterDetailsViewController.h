//
//  TheaterDetailsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Theater.h"

@class TheatersNavigationController;

@interface TheaterDetailsViewController : UITableViewController {
    TheatersNavigationController* navigationController;
    Theater* theater;
    
    NSArray* movieNames;
    NSArray* movieShowtimes;
}

@property (assign) TheatersNavigationController* navigationController;
@property (retain) Theater* theater;
@property (retain) NSArray* movieNames;
@property (retain) NSArray* movieShowtimes;

- (id) initWithNavigationController:(TheatersNavigationController*) navigationController
                            theater:(Theater*) theater;
- (void) dealloc;

- (void) refresh;

@end
