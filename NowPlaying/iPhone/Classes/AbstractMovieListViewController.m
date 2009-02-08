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

#import "Application.h"
#import "DateUtilities.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "LocaleUtilities.h"
#import "Movie.h"
#import "MoviesNavigationController.h"
#import "MultiDictionary.h"
#import "Model.h"
#import "SettingsViewController.h"
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


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
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

    BOOL prioritizeBookmarks = self.model.prioritizeBookmarks;

    for (Movie* movie in sortedMovies) {
        if (prioritizeBookmarks && [self.model isBookmarked:movie]) {
            [sectionTitleToContentsMap addObject:movie forKey:[Application starString]];
            continue;
        }

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
        [self.sectionTitles insertObject:[Application starString] atIndex:0];
    } else {
        self.sectionTitles = [NSMutableArray arrayWithArray:self.indexTitles];
    }
}


- (void) sortMoviesByScore {
    self.sortedMovies = [self.movies sortedArrayUsingFunction:compareMoviesByScore context:self.model];

    BOOL prioritizeBookmarks = self.model.prioritizeBookmarks;

    NSString* bookmarksString = [Application starString];
    NSString* moviesString = NSLocalizedString(@"Movies", nil);

    self.sectionTitles = [NSMutableArray arrayWithObjects:bookmarksString, moviesString, nil];

    for (Movie* movie in sortedMovies) {
        if (prioritizeBookmarks && [self.model isBookmarked:movie]) {
            [sectionTitleToContentsMap addObject:movie forKey:bookmarksString];
        } else {
            [sectionTitleToContentsMap addObject:movie forKey:moviesString];
        }
    }
}


- (void) sortMoviesByReleaseDateWorker {
    self.sortedMovies = [self.movies sortedArrayUsingFunction:self.sortByReleaseDateFunction context:self.model];

    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:kCFDateFormatterMediumStyle];
    [formatter setTimeStyle:kCFDateFormatterNoStyle];

    NSDate* today = [DateUtilities today];

    BOOL prioritizeBookmarks = self.model.prioritizeBookmarks;

    NSString* starString = [Application starString];

    for (Movie* movie in sortedMovies) {
        if (prioritizeBookmarks && [self.model isBookmarked:movie]) {
            [sectionTitleToContentsMap addObject:movie forKey:starString];
            if (![sectionTitles containsObject:starString]) {
                [sectionTitles insertObject:starString atIndex:0];
            }
        } else {
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
    }

    for (NSString* key in sectionTitleToContentsMap.allKeys) {
        if (![starString isEqual:key]) {
            NSMutableArray* values = [sectionTitleToContentsMap mutableObjectsForKey:key];
            [values sortUsingFunction:compareMoviesByScore context:self.model];
        }
    }
}


- (void) sortMoviesByReleaseDate {
    [self sortMoviesByReleaseDateWorker];

    if (!scrollToCurrentDateOnRefresh || visibleIndexPaths != nil) {
        return;
    }
    scrollToCurrentDateOnRefresh = NO;

    NSArray* movies = [self.movies sortedArrayUsingFunction:self.sortByReleaseDateFunction context:self.model];
    NSDate* today = [DateUtilities today];

    NSDate* date = nil;
    for (Movie* movie in movies) {
        NSDate* releaseDate = [self.model releaseDateForMovie:movie];

        if (releaseDate != nil) {
            if ([releaseDate compare:today] == NSOrderedDescending) {
                date = releaseDate;
                break;
            }
        }
    }

    if (date == nil) {
        return;
    }

    NSString* title = [DateUtilities formatFullDate:date];
    NSInteger section = [sectionTitles indexOfObject:title];

    if (section < 0 || section >= sectionTitles.count) {
        return;
    }

    self.visibleIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:section], nil];
}


- (void) setupIndexTitles {
    if ([LocaleUtilities isJapanese]) {
        self.indexTitles = nil;
    } else {
        NSMutableArray* array = [NSMutableArray arrayWithObjects:
                                 @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
                                 @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
                                 @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        if (self.model.prioritizeBookmarks) {
            [array insertObject:[Application starString] atIndex:0];
        }

        self.indexTitles = array;
    }
}


- (void) sortMovies {
    [self setupIndexTitles];
    self.sectionTitles = [NSMutableArray array];
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];

    if (self.sortingByTitle) {
        [self sortMoviesByTitle];
    } else if (self.sortingByReleaseDate) {
        [self sortMoviesByReleaseDate];
    } else if (self.sortingByScore) {
        [self sortMoviesByScore];
    }

    [self removeUnusedSectionTitles];

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


- (void) initializeInfoButton {
    UIButton* infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];

    infoButton.contentMode = UIViewContentModeCenter;
    CGRect frame = infoButton.frame;
    frame.size.width += 4;
    infoButton.frame = frame;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


- (void) loadView {
    [super loadView];

    self.sortedMovies = [NSArray array];

    [self initializeSearchButton];
    [self initializeInfoButton];
}


- (void) didReceiveMemoryWarning {
    if (visible) {
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


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
    [self.model saveNavigationStack:navigationController];
}


- (void) viewDidDisappear:(BOOL) animated {
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
            [self.tableView scrollToRowAtIndexPath:[visibleIndexPaths objectAtIndex:0]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:NO];
        }

        self.visibleIndexPaths = nil;
    }
}


- (BOOL) outOfBounds:(NSIndexPath*) indexPath {
    if (indexPath.section < 0 || indexPath.section >= sectionTitles.count) {
        return YES;
    }

    NSArray* movies = [sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]];
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

    Movie* movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

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

    Movie* movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    [navigationController pushMovieDetails:movie animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return sectionTitles.count;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:section]] count];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    NSString* title = [sectionTitles objectAtIndex:section];

    if (self.sortingByScore) {
        // Hide the header if sorting by score and we have no bookmarked movies
        if (sectionTitles.count == 1 && [NSLocalizedString(@"Movies", nil) isEqual:title]) {
            return nil;
        }
    }

    if ([title isEqual:[Application starString]]) {
        return NSLocalizedString(@"Bookmarks", nil);
    }

    return title;
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
    unichar firstChar = [title characterAtIndex:0];

    if (firstChar == '#') {
        return [sectionTitles indexOfObject:@"#"];
    } else if (firstChar == [Application starCharacter]) {
        return [sectionTitles indexOfObject:[Application starString]];
    } else {
        for (unichar c = firstChar; c >= 'A'; c--) {
            NSString* s = [NSString stringWithFormat:@"%c", c];

            NSInteger result = [sectionTitles indexOfObject:s];
            if (result != NSNotFound) {
                return result;
            }
        }

        return NSNotFound;
    }
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) showInfo {
    [navigationController pushInfoControllerAnimated:YES];
}

@end