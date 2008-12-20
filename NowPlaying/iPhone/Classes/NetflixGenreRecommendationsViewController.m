//
//  NetflixGenreRecommendationsViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixGenreRecommendationsViewController.h"

#import "AbstractNavigationController.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "NetflixCache.h"
#import "NetflixMovieTitleCell.h"
#import "NowPlayingModel.h"
#import "Queue.h"
#import "ViewControllerUtilities.h"

@interface NetflixGenreRecommendationsViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (copy) NSString* genre;
@property (retain) NSArray* movies;
@end


@implementation NetflixGenreRecommendationsViewController

@synthesize navigationController;
@synthesize genre;
@synthesize movies;

- (void)dealloc {
    self.navigationController = nil;
    self.genre = nil;
    self.movies = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              genre:(NSString*) genre_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.genre = genre_;
        self.title = genre_;

        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = genre;
        self.navigationItem.titleView = label;
    }

    return self;
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (void) initializeData {
    NSMutableArray* array = [NSMutableArray array];

    Queue* queue = [self.model.netflixCache queueForKey:[NetflixCache recommendationKey]];
    for (Movie* movie in queue.movies) {
        NSArray* genres = movie.genres;
        if (genres.count > 0 && [genre isEqual:[genres objectAtIndex:0]]) {
            [array addObject:movie];
        }
    }

    self.movies = array;
}


- (void) majorRefreshWorker {
    [self initializeData];
    [self.tableView reloadData];
}


- (void) minorRefreshWorker {
    [self majorRefresh];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return movies.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"NetflixGenreReuseIdentifier";
    NetflixMovieTitleCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NetflixMovieTitleCell alloc] initWithFrame:CGRectZero
                                             reuseIdentifier:reuseIdentifier
                                                       model:self.model
                                                       style:UITableViewStylePlain] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Movie* movie = [movies objectAtIndex:indexPath.row];
    [cell setMovie:movie owner:self];

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    Movie* movie = [movies objectAtIndex:indexPath.row];
    [navigationController pushMovieDetails:movie animated:YES];
}

@end