//
//  NetflixRecommendationsViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixRecommendationsViewController.h"

#import "AbstractNavigationController.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "NetflixCache.h"
#import "NetflixGenreRecommendationsViewController.h"
#import "NowPlayingModel.h"
#import "Queue.h"

@interface NetflixRecommendationsViewController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) NSArray* genres;
@property (retain) MultiDictionary* genreToMovies;
@end


@implementation NetflixRecommendationsViewController

@synthesize navigationController;
@synthesize genres;
@synthesize genreToMovies;

- (void)dealloc {
    self.navigationController = nil;
    self.genres = nil;
    self.genreToMovies = nil;
    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = navigationController_;
        self.title = NSLocalizedString(@"Recommendations", nil);
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
    self.genreToMovies = [MultiDictionary dictionary];

    NSMutableSet* set = [NSMutableSet set];
    Queue* queue = [self.model.netflixCache queueForKey:[NetflixCache recommendationKey]];
    for (Movie* movie in queue.movies) {
        if (movie.genres.count > 0) {
            NSString* genre = [movie.genres objectAtIndex:0];

            [genreToMovies addObject:movie forKey:genre];
            [set addObject:genre];
        }
    }

    self.genres = [[set allObjects] sortedArrayUsingSelector:@selector(compare:)];
}


- (void) majorRefreshWorker {
    [self initializeData];
    [self.tableView reloadData];
}


- (void) minorRefreshWorker {
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    [self majorRefresh];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    self.genreToMovies = [MultiDictionary dictionary];
    self.genres = [NSArray array];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* genre = [genres objectAtIndex:indexPath.row];

    NetflixGenreRecommendationsViewController* controller =
    [[[NetflixGenreRecommendationsViewController alloc] initWithNavigationController:navigationController genre:genre] autorelease];

    [navigationController pushViewController:controller animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return genres.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];

    NSString* genre = [genres objectAtIndex:indexPath.row];
    NSInteger count = [[genreToMovies objectsForKey:genre] count];
    cell.text =
    [NSString stringWithFormat:
     NSLocalizedString(@"%@ (%d)", @"name and count.  i.e.: Drama (58)"),
     genre, count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (genres.count == 0) {
        return self.model.netflixCache.noInformationFound;
    }

    return nil;
}


@end
