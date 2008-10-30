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

#import "AllMoviesViewController.h"

#import "MovieTitleCell.h"
#import "MoviesNavigationController.h"
#import "NowPlayingModel.h"

@implementation AllMoviesViewController


- (void) dealloc {
    [super dealloc];
}


- (NSArray*) movies {
    return self.model.movies;
}


- (BOOL) sortingByTitle {
    return self.model.allMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
    return self.model.allMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
    return self.model.allMoviesSortingByScore;
}


- (int(*)(id,id,void*)) sortByReleaseDateFunction {
    return compareMoviesByReleaseDateDescending;
}


- (void) setupSegmentedControl {
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               NSLocalizedString(@"Title", @"This is on a button that allows the user to sort movies based on their title."),
                               NSLocalizedString(@"Release", @"This is on a button that allows the user to sort movies based on how recently they were released."),
                               NSLocalizedString(@"Score", nil), nil]] autorelease];

    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = self.model.allMoviesSelectedSegmentIndex;

    [segmentedControl addTarget:self
                         action:@selector(onSortOrderChanged:)
               forControlEvents:UIControlEventValueChanged];

    CGRect rect = segmentedControl.frame;
    rect.size.width = 240;
    segmentedControl.frame = rect;

    self.navigationItem.titleView = segmentedControl;
}


- (void) onSortOrderChanged:(id) sender {
    self.model.allMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self refresh];
}


- (id) initWithNavigationController:(MoviesNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
        self.title = NSLocalizedString(@"Movies", nil);
    }

    return self;
}


- (void) refresh {
    if (self.model.noScores && segmentedControl.numberOfSegments == 3) {
        segmentedControl.selectedSegmentIndex = self.model.allMoviesSelectedSegmentIndex;
        [segmentedControl removeSegmentAtIndex:2 animated:NO];
    } else if (!self.model.noScores && segmentedControl.numberOfSegments == 2) {
        [segmentedControl insertSegmentWithTitle:NSLocalizedString(@"Score", @"This is on a button that allows users to sort movies by how well they were rated.") atIndex:2 animated:NO];
    }

    [super refresh];
}


- (MovieTitleCell*) createCell:(NSString*) reuseIdentifier {
    return [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                  reuseIdentifier:reuseIdentifier
                                            model:self.model
                                            style:UITableViewStylePlain] autorelease];
}

@end