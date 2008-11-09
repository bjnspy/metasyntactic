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

#import "DVDCache.h"
#import "DVDCell.h"
#import "DVDNavigationController.h"
#import "NowPlayingModel.h"

@implementation DVDViewController

- (void) dealloc {
    [super dealloc];
}


- (NSArray*) movies {
    NSMutableArray* result = [NSMutableArray array];
    [result addObjectsFromArray:self.model.dvdCache.movies];
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


- (UISegmentedControl*) setupSegmentedControl {
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


- (void) onSortOrderChanged:(id) sender {
    self.model.dvdMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self refresh];
}


- (id) initWithNavigationController:(DVDNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
        self.title = NSLocalizedString(@"DVD", nil);
        self.tableView.rowHeight = 100;
    }

    return self;
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


- (void) refresh {
    self.tableView.rowHeight = 100;
    [super refresh];
}

@end