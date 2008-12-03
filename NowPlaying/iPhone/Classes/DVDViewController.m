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
#import "DVDCache.h"
#import "DVDCell.h"
#import "DVDFilterViewController.h"
#import "DVDNavigationController.h"
#import "NowPlayingModel.h"
#import "TappableLabel.h"

@interface DVDViewController()
@property (retain) UIView* titleView;
@property (retain) UIToolbar* toolbar;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) UIButton* flipButton;
@property (retain) UIView* superView;
@property (retain) UITableView* cachedTableView;
@property (retain) UITableViewController* dvdFilterViewController;
@end


@implementation DVDViewController

@synthesize titleView;
@synthesize toolbar;
@synthesize segmentedControl;
@synthesize flipButton;
@synthesize superView;
@synthesize cachedTableView;
@synthesize dvdFilterViewController;

- (void) dealloc {
    self.titleView = nil;
    self.toolbar = nil;
    self.segmentedControl = nil;
    self.flipButton = nil;
    self.superView = nil;
    self.cachedTableView = nil;
    self.dvdFilterViewController = nil;

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
    self.model.dvdMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self majorRefresh];
}


- (id) initWithNavigationController:(DVDNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
    }

    return self;
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


- (void) setupFlipUpButton {
    self.flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [UIImage imageNamed:@"FlipUp-Normal.png"];
    
    [flipButton setImage:image forState:UIControlStateNormal];
    [flipButton setImage:[UIImage imageNamed:@"FlipUp-Highlighted.png"] forState:UIControlStateHighlighted];
    [flipButton setImage:[UIImage imageNamed:@"FlipUp-Highlighted.png"] forState:(UIControlStateHighlighted | UIControlStateSelected)];
    [flipButton setImage:[UIImage imageNamed:@"FlipUp-Selected.png"] forState:UIControlStateSelected];
    [flipButton addTarget:self action:@selector(flipUpDown:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = flipButton.frame;
    frame.size = image.size;
    flipButton.frame = frame;
    
    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithCustomView:flipButton] autorelease];
    self.navigationItem.rightBarButtonItem = item;
}


- (void) loadView {
    [super loadView];
        
    [self setupFlipUpButton];
    self.segmentedControl = [self createSegmentedControl];
    self.navigationItem.titleView = segmentedControl;

    self.tableView.rowHeight = 100;
}


- (void) didReceiveMemoryWarning {
    if (/*navigationController.visible ||*/ visible) {
        return;
    }

    self.titleView = nil;
    self.toolbar = nil;
    self.segmentedControl = nil;

    [super didReceiveMemoryWarning];
}


- (UITableViewCell*) createCell:(Movie*) movie {
    static NSString* reuseIdentifier = @"DVDCellIdentifier";
    id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                               reuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (void) majorRefresh {
    if (self.model.dvdMoviesShowOnlyBluray) {
        self.title = NSLocalizedString(@"Blu-ray", nil);
    } else {
        self.title = NSLocalizedString(@"DVD", nil);
    }
    
    self.tableView.rowHeight = 100;
    [super majorRefresh];
}


- (void) minorRefreshWorker {
    for (id cell in self.tableView.visibleCells) {
        [cell loadImage];
    }
}


- (void) flipUpDown:(id) sender {
    flipButton.selected = !flipButton.selected;
    
    if (superView == nil) {
        self.superView = self.tableView.superview;
    }
    
    if (dvdFilterViewController == nil) {
        self.dvdFilterViewController =
            [[[DVDFilterViewController alloc] initWithNavigationController:navigationController
                                                                    target:self
                                                                  selector:@selector(onDvdFilterChanged)] autorelease];
        UIView* dvdView = dvdFilterViewController.view;
        CGRect frame = dvdView.frame;
        frame.origin.y -= 20;
        dvdView.frame = frame;
    }
    
    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDuration:1];
        
        if (flipButton.selected) {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                                   forView:superView
                                     cache:YES];
            self.cachedTableView = self.tableView;
            [self.tableView removeFromSuperview];
            [superView addSubview:dvdFilterViewController.view];
        } else {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                                   forView:superView
                                     cache:YES];
            [dvdFilterViewController.view removeFromSuperview];
            [superView addSubview:self.cachedTableView];
        }
    }
    [UIView commitAnimations];
}


- (void) onDvdFilterChanged {
    [self flipUpDown:nil];
}

@end