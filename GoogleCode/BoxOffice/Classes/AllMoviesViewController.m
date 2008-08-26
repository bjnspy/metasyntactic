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

#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"
#import "BoxOfficeModel.h"
#import "DateUtilities.h"
#import "Movie.h"
#import "MovieTitleCell.h"
#import "MoviesNavigationController.h"
#import "MultiDictionary.h"
#import "PosterView.h"

@implementation AllMoviesViewController

@synthesize navigationController;
@synthesize sortedMovies;
@synthesize segmentedControl;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize alphabeticSectionTitles;
@synthesize posterView;

- (void) dealloc {
    self.navigationController = nil;
    self.sortedMovies = nil;
    self.segmentedControl = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.alphabeticSectionTitles = nil;
    self.posterView = nil;

    [super dealloc];
}


- (void) onSortOrderChanged:(id) sender {
    [self.model setAllMoviesSelectedSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    [self refresh];
}


- (void) removeUnusedSectionTitles {
    for (NSInteger i = sectionTitles.count - 1; i >= 0; --i) {
        NSString* title = [sectionTitles objectAtIndex:i];

        if ([[sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [sectionTitles removeObjectAtIndex:i];
        }
    }
}


- (void) sortMoviesByTitle {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:compareMoviesByTitle context:nil];

    self.sectionTitles = [NSMutableArray arrayWithArray:self.alphabeticSectionTitles];

    for (Movie* movie in self.sortedMovies) {
        unichar firstChar = [movie.displayTitle characterAtIndex:0];
        firstChar = toupper(firstChar);

        if (firstChar >= 'A' && firstChar <= 'Z') {
            NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
            [self.sectionTitleToContentsMap addObject:movie forKey:sectionTitle];
        } else {
            [self.sectionTitleToContentsMap addObject:movie forKey:@"#"];
        }
    }

    [self removeUnusedSectionTitles];
}


- (void) sortMoviesByScore {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:compareMoviesByScore context:self.model];
}


- (void) sortMoviesByReleaseDate {
    self.sortedMovies = [self.model.movies sortedArrayUsingFunction:compareMoviesByReleaseDate context:self.model];

    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:kCFDateFormatterMediumStyle];
    [formatter setTimeStyle:kCFDateFormatterNoStyle];

    NSDate* today = [DateUtilities today];

    for (Movie* movie in self.sortedMovies) {
        NSString* title = NSLocalizedString(@"Unknown release date", nil);
        if (movie.releaseDate != nil) {
            if ([movie.releaseDate compare:today] == NSOrderedDescending) {
                title = [DateUtilities formatFullDate:movie.releaseDate];
            } else {
                title = [DateUtilities timeSinceNow:movie.releaseDate];
            }
        }

        [self.sectionTitleToContentsMap addObject:movie forKey:title];

        if (![self.sectionTitles containsObject:title]) {
            [self.sectionTitles addObject:title];
        }
    }

    for (NSString* key in [self.sectionTitleToContentsMap allKeys]) {
        NSMutableArray* values = [self.sectionTitleToContentsMap mutableObjectsForKey:key];
        [values sortUsingFunction:compareMoviesByScore context:self.model];
    }
}


- (void) sortMovies {
    self.sectionTitles = [NSMutableArray array];
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];

    if (self.model.sortingMoviesByTitle) {
        [self sortMoviesByTitle];
    } else if (self.model.sortingMoviesByReleaseDate) {
        [self sortMoviesByReleaseDate];
    } else if (self.model.sortingMoviesByScore) {
        [self sortMoviesByScore];
    }

    if (sectionTitles.count == 0) {
        self.sectionTitles = [NSArray arrayWithObject:[self.model noLocationInformationFound]];
    }
}


- (void) setupSegmentedControl {
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               NSLocalizedString(@"Title", nil),
                               NSLocalizedString(@"Release", nil),
                               NSLocalizedString(@"Score", nil), nil]] autorelease];

    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.selectedSegmentIndex = self.model.allMoviesSelectedSegmentIndex;

    [self.segmentedControl addTarget:self
                              action:@selector(onSortOrderChanged:)
                    forControlEvents:UIControlEventValueChanged];

    CGRect rect = self.segmentedControl.frame;
    rect.size.width = 240;
    self.segmentedControl.frame = rect;

    self.navigationItem.titleView = segmentedControl;
}


- (id) initWithNavigationController:(MoviesNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;

        self.sortedMovies = [NSArray array];

        [self setupSegmentedControl];

        self.alphabeticSectionTitles =
        [NSArray arrayWithObjects:
         @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];

        self.title = NSLocalizedString(@"Movies", nil);
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self refresh];
}


- (void) viewDidAppear:(BOOL) animated {
    [self.model saveNavigationStack:self.navigationController];
}


- (void) refresh {
    if (self.model.noRatings && self.segmentedControl.numberOfSegments == 3) {
        self.segmentedControl.selectedSegmentIndex  = self.model.allMoviesSelectedSegmentIndex;
        [self.segmentedControl removeSegmentAtIndex:2 animated:NO];
    } else if (!self.model.noRatings && self.segmentedControl.numberOfSegments == 2) {
        [self.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"Score", nil) atIndex:2 animated:NO];
    }

    [self sortMovies];
    [self.tableView reloadData];
}


- (BoxOfficeModel*) model {
    return self.navigationController.model;
}


- (BoxOfficeController*) controller {
    return self.navigationController.controller;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    Movie* movie;
    if ([self.model sortingMoviesByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    } else if ([self.model sortingMoviesByScore]) {
        movie = [self.sortedMovies objectAtIndex:indexPath.row];
    } else {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    static NSString* reuseIdentifier = @"AllMoviesCellIdentifier";
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    MovieTitleCell* movieCell = cell;
    if (movieCell == nil) {
        movieCell = [[[MovieTitleCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                           reuseIdentifier:reuseIdentifier
                                                     model:self.model
                                                     style:UITableViewStylePlain] autorelease];
    }

    [movieCell setMovie:movie];
    return movieCell;
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if ([self.model sortingMoviesByTitle] && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return UITableViewCellAccessoryNone;
    } else if ([self.model sortingMoviesByScore]) {
        return UITableViewCellAccessoryDisclosureIndicator;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    Movie* movie;
    if ([self.model sortingMoviesByTitle]) {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    } else if ([self.model sortingMoviesByScore]) {
        movie = [self.sortedMovies objectAtIndex:indexPath.row];
    } else {
        movie = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    [self.navigationController pushMovieDetails:movie animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if ([self.model sortingMoviesByTitle]) {
        return sectionTitles.count;
    } else if ([self.model sortingMoviesByScore]) {
        return 1;
    } else {
        return sectionTitles.count;
    }
}


- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    if ([self.model sortingMoviesByTitle]) {
        return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
    } else if ([self.model sortingMoviesByScore]) {
        return sortedMovies.count;
    } else {
        return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if ([self.model sortingMoviesByTitle]) {
        return [self.sectionTitles objectAtIndex:section];
    } else if ([self.model sortingMoviesByScore] && self.sortedMovies.count > 0) {
        return nil;
    } else {
        return [self.sectionTitles objectAtIndex:section];
    }
}


- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self.model sortingMoviesByTitle] &&
        self.sortedMovies.count > 0 &&
        UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return self.alphabeticSectionTitles;
    }

    return nil;
}


- (NSInteger)           tableView:(UITableView*) tableView
      sectionForSectionIndexTitle:(NSString*) title
                          atIndex:(NSInteger) index {
    if (index == 0) {
        return index;
    }

    for (unichar c = [title characterAtIndex:0]; c >= 'A'; c--) {
        NSString* s = [NSString stringWithFormat:@"%c", c];

        NSInteger result = [self.sectionTitles indexOfObject:s];
        if (result != NSNotFound) {
            return result;
        }
    }

    return 0;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self refresh];
}

@end
