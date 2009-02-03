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

#import "DVDViewController.h"

#import "BlurayCache.h"
#import "DateUtilities.h"
#import "DVDCache.h"
#import "DVDCell.h"
#import "DVDFilterViewController.h"
#import "DVDNavigationController.h"
#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "TappableLabel.h"

@interface DVDViewController()
@property (retain) UIView* titleView;
@property (retain) UIToolbar* toolbar;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) UIButton* flipButton;
@property (retain) UIView* superView;
@property (retain) UITableView* cachedTableView;
@property (retain) UIViewController* filterViewController;
@property (retain) NSArray* visibleIndexPaths;
@end


@implementation DVDViewController

@synthesize titleView;
@synthesize toolbar;
@synthesize segmentedControl;
@synthesize flipButton;
@synthesize superView;
@synthesize cachedTableView;
@synthesize filterViewController;
@synthesize visibleIndexPaths;

- (void) dealloc {
    self.titleView = nil;
    self.toolbar = nil;
    self.segmentedControl = nil;
    self.flipButton = nil;
    self.superView = nil;
    self.cachedTableView = nil;
    self.filterViewController = nil;
    self.visibleIndexPaths = nil;

    [super dealloc];
}


- (NSArray*) movies {
    NSMutableArray* result = [NSMutableArray array];

    if (self.model.dvdMoviesShowDVDs) {
        [result addObjectsFromArray:self.model.dvdCache.movies];
    }

    if (self.model.dvdMoviesShowBluray) {
        [result addObjectsFromArray:self.model.blurayCache.movies];
    }

    return result;
}


- (BOOL) sortingByTitle {
    return self.model.dvdMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
    return self.model.dvdMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
    return NO;
}


- (int(*)(id,id,void*)) sortByReleaseDateFunction {
    return compareMoviesByReleaseDateAscending;
}


- (void) onSortOrderChanged:(id) sender {
    scrollToCurrentDateOnRefresh = YES;
    self.model.dvdMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self majorRefresh];
}


- (void) setupTitle {
    if (self.model.dvdMoviesShowOnlyBluray) {
        self.title = NSLocalizedString(@"Blu-ray", nil);
    } else {
        self.title = NSLocalizedString(@"DVD", nil);
    }
}


- (id) initWithNavigationController:(AbstractNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
        [self setupTitle];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
}


- (UISegmentedControl*) createSegmentedControl {
    UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                    [NSArray arrayWithObjects:
                                     NSLocalizedString(@"Release", nil),
                                     NSLocalizedString(@"Title", nil), nil]] autorelease];

    control.segmentedControlStyle = UISegmentedControlStyleBar;
    control.selectedSegmentIndex = self.model.dvdMoviesSelectedSegmentIndex;

    [control addTarget:self
                action:@selector(onSortOrderChanged:)
      forControlEvents:UIControlEventValueChanged];

    CGRect rect = control.frame;
    rect.size.width = 240;
    control.frame = rect;

    return control;
}


- (void) loadView {
    [super loadView];

    scrollToCurrentDateOnRefresh = YES;
    self.segmentedControl = [self createSegmentedControl];
    self.navigationItem.titleView = segmentedControl;

    self.tableView.rowHeight = 100;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    self.titleView = nil;
    self.toolbar = nil;
    self.segmentedControl = nil;

    [super didReceiveMemoryWarning];
}


- (UITableViewCell*) createCell:(Movie*) movie {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                               reuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (void) majorRefreshWorker {
    [super majorRefreshWorker];
    [self setupTitle];

    self.tableView.rowHeight = 100;
}


- (void) minorRefreshWorker {
    [super minorRefreshWorker];
    if (!visible) {
        return;
    }
    
    for (id cell in self.tableView.visibleCells) {
        [cell loadImage];
    }
}


- (UIViewController*) createFilterViewController {
    return [[[DVDFilterViewController alloc] initWithNavigationController:navigationController] autorelease];
}

@end