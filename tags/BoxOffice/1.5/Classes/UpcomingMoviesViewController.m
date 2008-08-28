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

#import "UpcomingMoviesViewController.h"

#import "BoxOfficeModel.h"
#import "UpcomingCache.h"
#import "UpcomingMovieCell.h"
#import "UpcomingMoviesNavigationController.h"

@implementation UpcomingMoviesViewController

- (void) dealloc {
    [super dealloc];
}


- (NSArray*) movies {
    return self.model.upcomingCache.upcomingMovies;
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


- (void) setupSegmentedControl {
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               NSLocalizedString(@"Title", nil),
                               NSLocalizedString(@"Release", nil), nil]] autorelease];

    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.selectedSegmentIndex = self.model.upcomingMoviesSelectedSegmentIndex;

    [self.segmentedControl addTarget:self
                              action:@selector(onSortOrderChanged:)
                    forControlEvents:UIControlEventValueChanged];

    CGRect rect = self.segmentedControl.frame;
    rect.size.width = 240;
    self.segmentedControl.frame = rect;

    self.navigationItem.titleView = segmentedControl;
}


- (void) onSortOrderChanged:(id) sender {
    [self.model setUpcomingMoviesSelectedSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    [self refresh];
}


- (id) initWithNavigationController:(UpcomingMoviesNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
        self.title = NSLocalizedString(@"Upcoming", nil);
        self.tableView.rowHeight = 100;
    }

    return self;
}


- (id) createCell:(NSString*) reuseIdentifier {
    return [[[UpcomingMovieCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                     reuseIdentifier:reuseIdentifier
                                               model:self.model] autorelease];
}


@end
