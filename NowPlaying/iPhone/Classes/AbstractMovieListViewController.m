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

#import "AbstractMovieListViewController.h"

#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "LocaleUtilities.h"
#import "Movie.h"
#import "MoviesNavigationController.h"
#import "MultiDictionary.h"
#import "NowPlayingModel.h"
#import "Utilities.h"

@interface AbstractMovieListViewController()
    @property (assign) AbstractNavigationController* navigationController;
    @property (retain) NSArray* sortedMovies;
    @property (retain) NSMutableArray* sectionTitles;
    @property (retain) MultiDictionary* sectionTitleToContentsMap;
    @property (retain) NSArray* indexTitles;
    @property (retain) NSArray* visibleIndexPaths;
@end


@implementation AbstractMovieListViewController

@synthesize navigationController;
@synthesize sortedMovies;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize indexTitles;
@synthesize visibleIndexPaths;

- (void) dealloc {
    self.navigationController = nil;
    self.sortedMovies = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.indexTitles = nil;
    self.visibleIndexPaths = nil;

    [super dealloc];
}


- (NSArray*) movies {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) sortingByTitle {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) sortingByReleaseDate {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) sortingByScore {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) onSortOrderChanged:(id) sender {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (UITableViewCell*) createCell:(Movie*) movie {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (int(*)(id,id,void*)) sortByReleaseDateFunction {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (void) removeUnusedSectionTitles {
    for (NSInteger i = sectionTitles.count - 1; i >= 0; --i) {
        NSString* title = [sectionTitles objectAtIndex:i];

        if ([[sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [sectionTitles removeObjectAtIndex:i];
        }
    }
}


- (unichar) firstCharacter:(NSString*) string {
    unichar c1 = toupper([string characterAtIndex:0]);
    if (c1 < 'A' || c1 > 'Z') {
        // remove an accent if it exists.
        NSString* asciiString = [Utilities asciiString:string];
        unichar c2 = toupper([asciiString characterAtIndex:0]);
        if (c2 >= 'A' && c2 <= 'Z') {
            return c2;
        }
    }

    return c1;
}


- (void) sortMoviesByTitle {
    self.sortedMovies = [self.movies sortedArrayUsingFunction:compareMoviesByTitle context:nil];

    for (Movie* movie in sortedMovies) {
        NSString* title = movie.displayTitle;
        unichar firstChar = [self firstCharacter:title];

        if ([LocaleUtilities isJapanese]) {
            if (CFCharacterSetIsCharacterMember(CFCharacterSetGetPredefined(kCFCharacterSetLetter), firstChar)) {
                NSString* sectionTitle = [[[NSString alloc] initWithCharacters:&firstChar length:1] autorelease];
                [sectionTitleToContentsMap addObject:movie forKey:sectionTitle];
            } else {
                [sectionTitleToContentsMap addObject:movie forKey:@"#"];
            }
        } else {
            if (firstChar >= 'A' && firstChar <= 'Z') {
                NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
                [sectionTitleToContentsMap addObject:movie forKey:sectionTitle];
            } else {
                [sectionTitleToContentsMap addObject:movie forKey:@"#"];
            }
        }
    }

    if ([LocaleUtilities isJapanese]) {
        self.sectionTitles = [NSMutableArray arrayWithArray:sectionTitleToContentsMap.allKeys];
        [sectionTitles sortUsingSelector:@selector(compare:)];
    } else {
        self.sectionTitles = [NSMutableArray arrayWithArray:self.indexTitles];
    }

    [self removeUnusedSectionTitles];
}


- (void) sortMoviesByScore {
    self.sortedMovies = [self.movies sortedArrayUsingFunction:compareMoviesByScore context:self.model];
}


- (void) sortMoviesByReleaseDate {
    self.sortedMovies = [self.movies sortedArrayUsingFunction:self.sortByReleaseDateFunction context:self.model];

    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:kCFDateFormatterMediumStyle];
    [formatter setTimeStyle:kCFDateFormatterNoStyle];

    NSDate* today = [DateUtilities today];

    for (Movie* movie in sortedMovies) {
        NSString* title = NSLocalizedString(@"Unknown release date", nil);
        NSDate* releaseDate = [self.model releaseDateForMovie:movie];

        if (releaseDate != nil) {
            if ([releaseDate compare:today] == NSOrderedDescending) {
                title = [DateUtilities formatFullDate:releaseDate];
            } else {
                title = [DateUtilities timeSinceNow:releaseDate];
            }
        }

        [sectionTitleToContentsMap addObject:movie forKey:title];

        if (![sectionTitles containsObject:title]) {
            [sectionTitles addObject:title];
        }
    }

    for (NSString* key in sectionTitleToContentsMap.allKeys) {
        NSMutableArray* values = [sectionTitleToContentsMap mutableObjectsForKey:key];
        [values sortUsingFunction:compareMoviesByScore context:self.model];
    }
}


- (void) sortMovies {
    self.sectionTitles = [NSMutableArray array];
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];

    if (self.sortingByTitle) {
        [self sortMoviesByTitle];
    } else if (self.sortingByReleaseDate) {
        [self sortMoviesByReleaseDate];
    } else if (self.sortingByScore) {
        [self sortMoviesByScore];
    }

    if (sectionTitles.count == 0) {
        self.sectionTitles = [NSArray arrayWithObject:self.model.noInformationFound];
    }
}


- (void) initializeSearchButton {
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.showsTouchWhenHighlighted = YES;
    UIImage* image = [ImageCache searchImage];
    [searchButton setImage:image forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];

    CGRect frame = searchButton.frame;
    frame.origin.x += 0.5;
    frame.size = image.size;
    frame.size.width += 7;
    frame.size.height += 7;
    searchButton.frame = frame;

    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
    self.navigationItem.leftBarButtonItem = item;
}


- (void) search:(id) sender {
    [navigationController showSearchView];
}


- (id) initWithNavigationController:(AbstractNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;
    }

    return self;
}


- (void) setupIndexTitles {
    if ([LocaleUtilities isJapanese]) {
        self.indexTitles = nil;
    } else {
        self.indexTitles =
        [NSArray arrayWithObjects:
         @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
}


- (void) loadView {
    [super loadView];

    self.sortedMovies = [NSArray array];

    [self initializeSearchButton];
    [self setupIndexTitles];
}


- (void) didReceiveMemoryWarning {
    if (/*navigationController.visible ||*/ visible) {
        return;
    }

    // Store the currently visible cells so we can scroll back to them when
    // we're reloaded.
    self.visibleIndexPaths = [self.tableView indexPathsForVisibleRows];

    self.sortedMovies = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.indexTitles = nil;

    [super didReceiveMemoryWarning];
}


- (void) viewDidAppear:(BOOL)animated {
    visible = YES;
    [self.model saveNavigationStack:navigationController];
}


- (void) viewDidDisappear:(BOOL)animated {
    visible = NO;
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    [self majorRefresh];
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self sortMovies];
    [self.tableView reloadData];

    if (visibleIndexPaths.count > 0) {
        NSIndexPath* path = [visibleIndexPaths objectAtIndex:0];
        if (path.section >= 0 && path.section < self.tableView.numberOfSections &&
            path.row >= 0 && path.row < [self.tableView numberOfRowsInSection:path.section]) {
            [self.tableView scrollToRowAtIndexPath:[visibleIndexPaths objectAtIndex:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }

        self.visibleIndexPaths = nil;
    }
}


- (BOOL) outOfBounds:(NSIndexPath*) indexPath {
    NSArray* movies;
    if (self.sortingByScore) {
        movies = sortedMovies;
    } else {
        if (indexPath.section < 0 || indexPath.section >= sectionTitles.count) {
            return YES;
        }

        movies = [sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]];
    }

    if (indexPath.row < 0 || indexPath.row >= movies.count) {
        return YES;
    }

    return NO;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if ([self outOfBounds:indexPath]) {
        return [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }

    Movie* movie;
    if (self.sortingByTitle) {
        movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    } else if (self.sortingByScore) {
        movie = [sortedMovies objectAtIndex:indexPath.row];
    } else if (self.sortingByReleaseDate) {
        movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    //[self.model prioritizeMovie:movie];

    return [self createCell:movie];
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if (self.sortingByTitle && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return UITableViewCellAccessoryNone;
    } else if (self.sortingByScore) {
        return UITableViewCellAccessoryDisclosureIndicator;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if ([self outOfBounds:indexPath]) {
        return;
    }

    Movie* movie;
    if (self.sortingByTitle) {
        movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    } else if (self.sortingByScore) {
        movie = [sortedMovies objectAtIndex:indexPath.row];
    } else {
        movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    [navigationController pushMovieDetails:movie animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if (self.sortingByTitle) {
        return sectionTitles.count;
    } else if (self.sortingByScore) {
        return 1;
    } else {
        return sectionTitles.count;
    }
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (self.sortingByTitle) {
        return [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:section]] count];
    } else if (self.sortingByScore) {
        return sortedMovies.count;
    } else {
        return [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:section]] count];
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (self.sortingByTitle) {
        return [sectionTitles objectAtIndex:section];
    } else if (self.sortingByScore && sortedMovies.count > 0) {
        return nil;
    } else {
        return [sectionTitles objectAtIndex:section];
    }
}


- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if (self.sortingByTitle &&
        self.sortedMovies.count > 0 &&
        UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return indexTitles;
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

        NSInteger result = [sectionTitles indexOfObject:s];
        if (result != NSNotFound) {
            return result;
        }
    }

    return 0;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end