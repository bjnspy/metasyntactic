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

#import "AllTheatersViewController.h"

#import "Application.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "LocaleUtilities.h"
#import "Location.h"
#import "MultiDictionary.h"
#import "Model.h"
#import "SettingsViewController.h"
#import "Theater.h"
#import "TheaterNameCell.h"
#import "TheatersNavigationController.h"

@interface AllTheatersViewController()
@property (assign) TheatersNavigationController* navigationController;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) NSArray* sortedTheaters;

@property (retain) NSMutableArray* sectionTitles;
@property (retain) MultiDictionary* sectionTitleToContentsMap;

@property (retain) NSArray* indexTitles;
@property (retain) NSArray* visibleIndexPaths;
@end


@implementation AllTheatersViewController

@synthesize navigationController;
@synthesize segmentedControl;
@synthesize sortedTheaters;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize indexTitles;
@synthesize visibleIndexPaths;

- (void) dealloc {
    self.navigationController = nil;
    self.segmentedControl = nil;
    self.sortedTheaters = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.indexTitles = nil;
    self.visibleIndexPaths = nil;

    [super dealloc];
}


- (BOOL) sortingByName {
    return segmentedControl.selectedSegmentIndex == 1;
}


- (BOOL) sortingByDistance {
    return !self.sortingByName;
}


- (void) onSortOrderChanged:(id) sender {
    self.model.allTheatersSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self majorRefresh];
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


- (void) sortTheatersByName {
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:compareTheatersByName context:nil];

    for (Theater* theater in [self.model theatersInRange:sortedTheaters]) {
        if ([self.model isFavoriteTheater:theater]) {
            [sectionTitleToContentsMap addObject:theater forKey:[Application starString]];
            continue;
        }

        unichar firstChar = [theater.name characterAtIndex:0];
        firstChar = toupper(firstChar);

        if ([LocaleUtilities isJapanese]) {
            if (CFCharacterSetIsCharacterMember(CFCharacterSetGetPredefined(kCFCharacterSetLetter), firstChar)) {
                NSString* sectionTitle = [[[NSString alloc] initWithCharacters:&firstChar length:1] autorelease];
                [sectionTitleToContentsMap addObject:theater forKey:sectionTitle];
            } else {
                [sectionTitleToContentsMap addObject:theater forKey:@"#"];
            }
        } else {
            if (firstChar >= 'A' && firstChar <= 'Z') {
                NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
                [sectionTitleToContentsMap addObject:theater forKey:sectionTitle];
            } else {
                [sectionTitleToContentsMap addObject:theater forKey:@"#"];
            }
        }
    }

    if ([LocaleUtilities isJapanese]) {
        self.sectionTitles = [NSMutableArray arrayWithArray:sectionTitleToContentsMap.allKeys];
        [sectionTitles sortUsingSelector:@selector(compare:)];
    } else {
        self.sectionTitles = [NSMutableArray arrayWithArray:indexTitles];
    }
}


- (void) sortTheatersByDistance {
    NSDictionary* theaterDistanceMap = self.model.theaterDistanceMap;
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:compareTheatersByDistance
                           context:theaterDistanceMap];

    NSString* favorites = NSLocalizedString(@"Favorites", nil);
    NSString* reallyCloseBy = NSLocalizedString(@"Really close by", nil);
    NSString* reallyFarAway = NSLocalizedString(@"Really far away", nil);
    NSString* unknownDistance = NSLocalizedString(@"Unknown Distance", nil);

    NSString* singularUnit = ([Application useKilometers] ? NSLocalizedString(@"kilometer", nil) :
                              NSLocalizedString(@"mile", nil));
    NSString* pluralUnit = ([Application useKilometers] ? NSLocalizedString(@"kilometers", nil) :
                            NSLocalizedString(@"miles", nil));

    int distances[] = {
        1, 2, 5, 10, 15, 20, 30, 40, 50
    };

    NSMutableArray* distancesArray = [NSMutableArray array];
    for (int i = 0; i < ArrayLength(distances); i++) {
        int distance = distances[i];
        if (distance == 1) {
            [distancesArray addObject:[NSString stringWithFormat:NSLocalizedString(@"Less than 1 %@ away", @"singular. refers to a distance like 'Less than 1 mile away'"), singularUnit]];
        } else {
            [distancesArray addObject:[NSString stringWithFormat:NSLocalizedString(@"Less than %d %@ away", @"plural. refers to a distance like 'Less than 2 miles away'"), distance, pluralUnit]];
        }
    }

    self.sectionTitles = [NSMutableArray array];

    [sectionTitles addObject:favorites];
    [sectionTitles addObject:reallyCloseBy];
    [sectionTitles addObjectsFromArray:distancesArray];
    [sectionTitles addObject:reallyFarAway];
    [sectionTitles addObject:unknownDistance];

    NSArray* theatersInRange = [self.model theatersInRange:sortedTheaters];
    for (Theater* theater in theatersInRange) {
        if ([self.model isFavoriteTheater:theater]) {
            [sectionTitleToContentsMap addObject:theater forKey:favorites];
            continue;
        }

        double distance = [[theaterDistanceMap objectForKey:theater.name] doubleValue];

        if (distance <= 0.5) {
            [sectionTitleToContentsMap addObject:theater forKey:reallyCloseBy];
            continue;
        }

        for (int i = 0; i < ArrayLength(distances); i++) {
            if (distance <= distances[i]) {
                [sectionTitleToContentsMap addObject:theater forKey:[distancesArray objectAtIndex:i]];
                goto outer;
            }
        }

        if (distance < UNKNOWN_DISTANCE) {
            [sectionTitleToContentsMap addObject:theater forKey:reallyFarAway];
        } else {
            [sectionTitleToContentsMap addObject:theater forKey:unknownDistance];
        }

        // i hate goto/labels. however, objective-c lacks a 'continue outer' statement.
        // so we simulate here directly.
    outer: ;
    }
}


- (void) sortTheaters {
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];

    if ([self sortingByName]) {
        [self sortTheatersByName];
    } else {
        [self sortTheatersByDistance];
    }

    [self removeUnusedSectionTitles];

    if (sectionTitles.count == 0) {
        NSArray* theaters = self.model.theaters;
        if (theaters.count == 1) {
            self.sectionTitles = [NSArray arrayWithObject:NSLocalizedString(@"1 theater outside search area", nil)];
        } else if (theaters.count > 1) {
            self.sectionTitles = [NSArray arrayWithObject:
                                  [NSString stringWithFormat:NSLocalizedString(@"%d theaters outside search area", nil), theaters.count]];
        } else {
            self.sectionTitles = [NSArray arrayWithObject:self.model.noInformationFound];
        }
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
    //UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)] autorelease];
    self.navigationItem.leftBarButtonItem = item;
}


- (void) search:(id) sender {
    [navigationController showSearchView];
}


- (void) initializeSegmentedControl {
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               NSLocalizedString(@"Distance", @"This is on a button that allows users to sort theaters by distance"),
                               NSLocalizedString(@"Name", @"This is on a button that allows users to sort theaters by their name"), nil]] autorelease];

    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = self.model.allTheatersSelectedSegmentIndex;
    [segmentedControl addTarget:self
                         action:@selector(onSortOrderChanged:)
               forControlEvents:UIControlEventValueChanged];

    CGRect rect = segmentedControl.frame;
    rect.size.width = 240;
    segmentedControl.frame = rect;
}


- (id) initWithNavigationController:(TheatersNavigationController*) controller {
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
         [Application starString],
         @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
}


- (void) loadView {
    [super loadView];

    self.sortedTheaters = [NSArray array];

    [self initializeSegmentedControl];
    [self initializeSearchButton];

    self.navigationItem.titleView = segmentedControl;

    [self setupIndexTitles];

    self.title = NSLocalizedString(@"Theaters", nil);
}


- (void) viewDidAppear:(BOOL) animated {
    visible = YES;
    [self.model saveNavigationStack:self.navigationController];
}


- (void) viewDidDisappear:(BOOL) animated {
    visible = NO;
}


- (void) didReceiveMemoryWarning {
    if (visible) {
        return;
    }

    // Store the currently visible cells so we can scroll back to them when
    // we're reloaded.
    self.visibleIndexPaths = [self.tableView indexPathsForVisibleRows];

    self.segmentedControl = nil;
    self.sortedTheaters = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.indexTitles = nil;

    [super didReceiveMemoryWarning];
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if ([self sortingByName] && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (BOOL) outOfBounds:(NSIndexPath*) indexPath {
    if (indexPath.section < 0 || indexPath.section >= sectionTitles.count) {
        return YES;
    }

    NSArray* theaters = [sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]];
    if (indexPath.row < 0 || indexPath.row >= theaters.count) {
        return YES;
    }

    return NO;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if ([self outOfBounds:indexPath]) {
        return;
    }

    Theater* theater = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    [navigationController pushTheaterDetails:theater animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return sectionTitles.count;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:section]] count];
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if ([self outOfBounds:indexPath]) {
        return [[[UITableView alloc] init] autorelease];
    }

    Theater* theater = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    static NSString* reuseIdentifier = @"reuseIdentifier";

    TheaterNameCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[TheaterNameCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                       reuseIdentifier:reuseIdentifier
                                                 model:self.model] autorelease];
    }

    [cell setTheater:theater];
    return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    NSString* sectionTitle = [sectionTitles objectAtIndex:section];
    if ([sectionTitle isEqual:[Application starString]]) {
        return NSLocalizedString(@"Favorites", nil);
    }

    return sectionTitle;
}


- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self sortingByName] &&
        sortedTheaters.count > 0 &&
        UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return indexTitles;
    }

    return nil;
}


- (NSInteger) sectionForSectionIndexTitle:(NSString*) title {
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


- (NSInteger)           tableView:(UITableView*) tableView
      sectionForSectionIndexTitle:(NSString*) title
                          atIndex:(NSInteger) index {
    NSInteger result = [self sectionForSectionIndexTitle:title];
    if (result == NSNotFound) {
        return 0;
    }

    return result;
}


- (void) viewWillAppear:(BOOL) animated {
    [GlobalActivityIndicator setCurrentViewController:self];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [self majorRefresh];
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self sortTheaters];
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


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) flipView {
    UIViewController* controller = [[[SettingsViewController alloc] initWithNavigationController:self.navigationController] autorelease];
    [navigationController pushViewController:controller animated:YES];
}

@end