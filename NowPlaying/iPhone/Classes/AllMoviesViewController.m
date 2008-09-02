// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
                               NSLocalizedString(@"Title", nil),
                               NSLocalizedString(@"Release", nil),
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
    if (self.model.noRatings && segmentedControl.numberOfSegments == 3) {
        segmentedControl.selectedSegmentIndex = self.model.allMoviesSelectedSegmentIndex;
        [segmentedControl removeSegmentAtIndex:2 animated:NO];
    } else if (!self.model.noRatings && segmentedControl.numberOfSegments == 2) {
        [segmentedControl insertSegmentWithTitle:NSLocalizedString(@"Score", nil) atIndex:2 animated:NO];
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