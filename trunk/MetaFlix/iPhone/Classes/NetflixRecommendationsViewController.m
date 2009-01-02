// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "NetflixRecommendationsViewController.h"

#import "AbstractNavigationController.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "MutableNetflixCache.h"
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


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return YES;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    self.genreToMovies = [MultiDictionary dictionary];
    self.genres = [NSArray array];

    [super didReceiveMemoryWarning];
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