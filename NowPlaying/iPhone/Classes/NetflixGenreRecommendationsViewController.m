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

#import "NetflixGenreRecommendationsViewController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "GlobalActivityIndicator.h"
#import "Movie.h"
#import "MultiDictionary.h"
#import "MutableNetflixCache.h"
#import "NetflixCache.h"
#import "NetflixCell.h"
#import "Model.h"
#import "Queue.h"
#import "ViewControllerUtilities.h"

@interface NetflixGenreRecommendationsViewController()
@property (copy) NSString* genre;
@property (retain) NSArray* movies;
@end


@implementation NetflixGenreRecommendationsViewController

@synthesize genre;
@synthesize movies;

- (void) dealloc {
    self.genre = nil;
    self.movies = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                              genre:(NSString*) genre_ {
    if (self = [super initWithStyle:UITableViewStylePlain navigationController:navigationController_]) {
        self.genre = genre_;
        self.title = genre_;

        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = genre;
        self.navigationItem.titleView = label;
    }

    return self;
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
    // do nothing.  we don't want to refresh the view (because it causes an
    // ugly flash).  Instead, just refresh things when teh view becomes visible
}


- (void) internalRefresh {
    [self initializeData];
    [self reloadTableViewData];
}


- (void) minorRefreshWorker {
    if (!visible) {
        return;
    }

    for (id cell in self.tableView.visibleCells) {
        [cell refresh];
    }
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[AppDelegate globalActivityView]] autorelease];
    self.tableView.rowHeight = 100;
    [self internalRefresh];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}


- (void) didReceiveMemoryWarningWorker {
    [super didReceiveMemoryWarningWorker];
    self.movies = [NSArray array];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return movies.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    NetflixCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NetflixCell alloc] initWithFrame:CGRectZero
                                   reuseIdentifier:reuseIdentifier
                                             model:self.model] autorelease];
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


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (movies.count == 0) {
        return self.model.netflixCache.noInformationFound;
    }

    return nil;
}

@end