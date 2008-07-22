//
//  MovieDetailsViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "Movie.h"
#import "BoxOfficeModel.h"

@class MoviesNavigationController;

@interface MovieDetailsViewController : UITableViewController {
    MoviesNavigationController* navigationController;
    
    Movie* movie;
    NSMutableArray* theatersArray;
    NSMutableArray* showtimesArray;
    NSArray* trailersArray;
    NSArray* reviewsArray;
    
    NSInteger hiddenTheaterCount;
    
    UIImage* posterImage;
    NSString* synopsis;
    NSInteger synopsisSplit;
    NSInteger synopsisMax;
}

@property (assign) MoviesNavigationController* navigationController;
@property (retain) Movie* movie;
@property (retain) NSMutableArray* theatersArray;
@property (retain) NSMutableArray* showtimesArray;
@property (retain) NSArray* trailersArray;
@property (retain) NSArray* reviewsArray;
@property NSInteger hiddenTheaterCount;
@property (copy) NSString* synopsis;
@property (retain) UIImage* posterImage;

- (id) initWithNavigationController:(MoviesNavigationController*) navigationController
                              movie:(Movie*) movie;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
