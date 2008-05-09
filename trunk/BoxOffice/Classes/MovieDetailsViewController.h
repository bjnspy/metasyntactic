//
//  MovieDetailsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"
#import "BoxOfficeModel.h"

@class MoviesNavigationController;

@interface MovieDetailsViewController : UITableViewController {
    MoviesNavigationController* navigationController;
    Movie* movie;
    NSMutableArray* theatersArray;
    NSMutableArray* showtimesArray;
}

@property (assign) MoviesNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) NSMutableArray* theatersArray;
@property (retain) NSMutableArray* showtimesArray;

- (id) initWithNavigationController:(MoviesNavigationController*) navigationController
                              movie:(Movie*) movie;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
