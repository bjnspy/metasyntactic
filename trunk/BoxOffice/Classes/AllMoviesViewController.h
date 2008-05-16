//
//  AllMoviesViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "MultiDictionary.h"
#import "PosterView.h"

@class MoviesNavigationController;

@interface AllMoviesViewController : UITableViewController {
    MoviesNavigationController* navigationController;
    UISegmentedControl* segmentedControl;
    
    NSArray* sortedMovies;
    NSMutableArray* sectionTitles;
    MultiDictionary* sectionTitleToContentsMap;
    
    NSArray* alphabeticSectionTitles;
    
    PosterView* posterView;
}

@property (assign) MoviesNavigationController* navigationController;
@property (retain) NSArray* sortedMovies;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) NSMutableArray* sectionTitles;
@property (retain) MultiDictionary* sectionTitleToContentsMap;
@property (retain) NSArray* alphabeticSectionTitles;
@property (retain) PosterView* posterView;

- (id) initWithNavigationController:(MoviesNavigationController*) navigationController;
- (void) dealloc;

- (void) refresh;
- (BoxOfficeModel*) model;

- (void) sortMovies;

@end
