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

#import "UpcomingMoviesViewController.h"

#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "UpcomingCache.h"
#import "UpcomingMovieCell.h"
#import "UpcomingMoviesNavigationController.h"

@interface UpcomingMoviesViewController()
@property (retain) UISegmentedControl* segmentedControl;
@end


@implementation UpcomingMoviesViewController

@synthesize segmentedControl;

- (void) dealloc {
    self.segmentedControl = nil;
    [super dealloc];
}


- (NSArray*) movies {
    return self.model.upcomingCache.movies;
}


- (BOOL) sortingByTitle {
    return self.model.upcomingMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
    return self.model.upcomingMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
    return NO;
}


- (int(*)(id,id,void*)) sortByReleaseDateFunction {
    return compareMoviesByReleaseDateAscending;
}


- (UISegmentedControl*) setupSegmentedControl {
    UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               NSLocalizedString(@"Release", nil),
                               NSLocalizedString(@"Title", nil), nil]] autorelease];

    control.segmentedControlStyle = UISegmentedControlStyleBar;
    control.selectedSegmentIndex = self.model.upcomingMoviesSelectedSegmentIndex;

    [control addTarget:self
                action:@selector(onSortOrderChanged:)
      forControlEvents:UIControlEventValueChanged];

    CGRect rect = control.frame;
    rect.size.width = 240;
    control.frame = rect;

    return control;
}


- (void) onSortOrderChanged:(id) sender {
    scrollToCurrentDateOnRefresh = YES;
    self.model.upcomingMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self majorRefresh];
}


- (id) initWithNavigationController:(UpcomingMoviesNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
    }

    return self;
}


- (void) loadView {
    [super loadView];

    scrollToCurrentDateOnRefresh = YES;
    self.segmentedControl = [self setupSegmentedControl];
    self.navigationItem.titleView = segmentedControl;

    self.title = NSLocalizedString(@"Upcoming", nil);
    self.tableView.rowHeight = 100;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    self.segmentedControl = nil;

    [super didReceiveMemoryWarning];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
}


- (UITableViewCell*) createCell:(Movie*) movie {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UpcomingMovieCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                         reuseIdentifier:reuseIdentifier
                                                   model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (void) majorRefreshWorker {
    [super majorRefreshWorker];
    self.tableView.rowHeight = 100;
}


- (void) minorRefreshWorker {
    [super minorRefreshWorker];
    for (id cell in self.tableView.visibleCells) {
        [cell loadImage];
    }
}

@end