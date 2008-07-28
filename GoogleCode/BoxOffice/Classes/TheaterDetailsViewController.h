//
//  TheaterDetailsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Theater.h"

@class TheatersNavigationController;

@interface TheaterDetailsViewController : UITableViewController {
    TheatersNavigationController* navigationController;
    UISegmentedControl* segmentedControl;
    Theater* theater;
    
    NSArray* movies;
    NSMutableArray* movieShowtimes;
}

@property (assign) TheatersNavigationController* navigationController;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) Theater* theater;
@property (retain) NSArray* movies;
@property (retain) NSMutableArray* movieShowtimes;

- (id) initWithNavigationController:(TheatersNavigationController*) navigationController
                            theater:(Theater*) theater;

- (void) refresh;

@end
