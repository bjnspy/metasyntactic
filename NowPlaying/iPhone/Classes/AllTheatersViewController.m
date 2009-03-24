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
#import "LocalSearchDisplayController.h"
#import "LocaleUtilities.h"
#import "Location.h"
#import "Model.h"
#import "MutableMultiDictionary.h"
#import "SettingsViewController.h"
#import "Theater.h"
#import "TheaterNameCell.h"
#import "TheatersNavigationController.h"

@interface AllTheatersViewController()
@property (retain) UISegmentedControl* segmentedControl_;
@property (retain) UISearchBar* searchBar_;
@property (retain) LocalSearchDisplayController* searchDisplayController_;
@property (retain) NSArray* sortedTheaters_;
@property (retain) NSArray* sectionTitles_;
@property (retain) MultiDictionary* sectionTitleToContentsMap_;
@property (retain) NSArray* indexTitles_;
@end


@implementation AllTheatersViewController

@synthesize segmentedControl_;
@synthesize searchBar_;
@synthesize searchDisplayController_;
@synthesize sortedTheaters_;
@synthesize sectionTitles_;
@synthesize sectionTitleToContentsMap_;
@synthesize indexTitles_;

property_wrapper(UISegmentedControl*, segmentedControl, SegmentedControl);
property_wrapper(UISearchBar*, searchBar, SearchBar);
property_wrapper(LocalSearchDisplayController*, searchDisplayController, SearchDisplayController);
property_wrapper(NSArray*, sortedTheaters, SortedTheaters);
property_wrapper(NSArray*, sectionTitles, SectionTitles);
property_wrapper(MultiDictionary*, sectionTitleToContentsMap, SectionTitleToContentsMap);
property_wrapper(NSArray*, indexTitles, IndexTitles);

- (void) dealloc {
    self.segmentedControl = nil;
    self.searchBar = nil;
    self.searchDisplayController = nil;
    self.sortedTheaters = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.indexTitles = nil;

    [super dealloc];
}


- (Model*) model {
    return [Model model];
}


- (BOOL) sortingByName {
    return self.segmentedControl.selectedSegmentIndex == 1;
}


- (BOOL) sortingByDistance {
    return !self.sortingByName;
}


- (void) onSortOrderChanged:(id) sender {
    self.model.allTheatersSelectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
    [self majorRefresh];
}


- (void) removeUnusedSectionTitles {
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.sectionTitles];

    for (NSInteger i = array.count - 1; i >= 0; --i) {
        NSString* title = [array objectAtIndex:i];
        if ([[self.sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [array removeObjectAtIndex:i];
        }
    }

    self.sectionTitles = array;
}


- (void) sortTheatersByName {
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:compareTheatersByName context:nil];

    MutableMultiDictionary* map = [MutableMultiDictionary dictionary];

    for (Theater* theater in [self.model theatersInRange:self.sortedTheaters]) {
        if ([self.model isFavoriteTheater:theater]) {
            [map addObject:theater forKey:[Application starString]];
            continue;
        }

        unichar firstChar = [theater.name characterAtIndex:0];
        firstChar = toupper(firstChar);

        if ([LocaleUtilities isJapanese]) {
            if (CFCharacterSetIsCharacterMember(CFCharacterSetGetPredefined(kCFCharacterSetLetter), firstChar)) {
                NSString* sectionTitle = [[[NSString alloc] initWithCharacters:&firstChar length:1] autorelease];
                [map addObject:theater forKey:sectionTitle];
            } else {
                [map addObject:theater forKey:@"#"];
            }
        } else {
            if (firstChar >= 'A' && firstChar <= 'Z') {
                NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
                [map addObject:theater forKey:sectionTitle];
            } else {
                [map addObject:theater forKey:@"#"];
            }
        }
    }

    if ([LocaleUtilities isJapanese]) {
        self.sectionTitles = [NSMutableArray arrayWithArray:self.sectionTitleToContentsMap.allKeys];
        self.sectionTitles = [self.sectionTitles sortedArrayUsingSelector:@selector(compare:)];
    } else {
        self.sectionTitles = [NSMutableArray arrayWithArray:self.indexTitles];
    }

    self.sectionTitleToContentsMap = map;
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

    NSMutableArray* array = [NSMutableArray array];

    [array addObject:favorites];
    [array addObject:reallyCloseBy];
    [array addObjectsFromArray:distancesArray];
    [array addObject:reallyFarAway];
    [array addObject:unknownDistance];
    self.sectionTitles = array;
    MutableMultiDictionary* map = [MutableMultiDictionary dictionary];

    NSArray* theatersInRange = [self.model theatersInRange:self.sortedTheaters];
    for (Theater* theater in theatersInRange) {
        if ([self.model isFavoriteTheater:theater]) {
            [map addObject:theater forKey:favorites];
            continue;
        }

        double distance = [[theaterDistanceMap objectForKey:theater.name] doubleValue];

        if (distance <= 0.5) {
            [map addObject:theater forKey:reallyCloseBy];
            continue;
        }

        for (int i = 0; i < ArrayLength(distances); i++) {
            if (distance <= distances[i]) {
                [map addObject:theater forKey:[distancesArray objectAtIndex:i]];
                goto outer;
            }
        }

        if (distance < UNKNOWN_DISTANCE) {
            [map addObject:theater forKey:reallyFarAway];
        } else {
            [map addObject:theater forKey:unknownDistance];
        }

        // i hate goto/labels. however, objective-c lacks a 'continue outer' statement.
        // so we simulate here directly.
    outer: ;
    }

    self.sectionTitleToContentsMap = map;
}


- (void) sortTheaters {
    if ([self sortingByName]) {
        [self sortTheatersByName];
    } else {
        [self sortTheatersByDistance];
    }

    [self removeUnusedSectionTitles];

    if (self.sectionTitles.count == 0) {
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


- (void) initializeSegmentedControl {
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               NSLocalizedString(@"Distance", @"This is on a button that allows users to sort theaters by distance"),
                               NSLocalizedString(@"Name", @"This is on a button that allows users to sort theaters by their name"), nil]] autorelease];

    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.selectedSegmentIndex = self.model.allTheatersSelectedSegmentIndex;
    [self.segmentedControl addTarget:self
                         action:@selector(onSortOrderChanged:)
               forControlEvents:UIControlEventValueChanged];

    CGRect rect = self.segmentedControl.frame;
    rect.size.width = 240;
    self.segmentedControl.frame = rect;
}


- (id) initWithNavigationController:(TheatersNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain navigationController:navigationController_]) {
        self.title = NSLocalizedString(@"Theaters", nil);
    }

    return self;
}


- (void) setupIndexTitles {
    if ([LocaleUtilities isJapanese]) {
        self.indexTitles = nil;
    } else {
        self.indexTitles =
        [NSArray arrayWithObjects:
         UITableViewIndexSearch,
         [Application starString],
         @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
}


- (void) initializeInfoButton {
    UIButton* infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];

    infoButton.contentMode = UIViewContentModeCenter;
    CGRect frame = infoButton.frame;
    frame.size.width += 4;
    infoButton.frame = frame;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


- (void) initializeSearchDisplay {
    self.searchBar = [[[UISearchBar alloc] init] autorelease];
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;

    self.searchDisplayController = [[[LocalSearchDisplayController alloc] initNavigationController:self.abstractNavigationController
                                                                                         searchBar:self.searchBar
                                                                                contentsController:self] autorelease];
}


- (void) loadView {
    [super loadView];

    self.sortedTheaters = [NSArray array];

    [self initializeSegmentedControl];
    [self initializeSearchDisplay];
    [self initializeInfoButton];

    self.navigationItem.titleView = self.segmentedControl;

    [self setupIndexTitles];

    self.title = NSLocalizedString(@"Theaters", nil);
}


- (void) didReceiveMemoryWarningWorker {
    [super didReceiveMemoryWarningWorker];
    self.segmentedControl = nil;
    self.sortedTheaters = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.indexTitles = nil;
}


- (BOOL) outOfBounds:(NSIndexPath*) indexPath {
    if (indexPath.section < 0 || indexPath.section >= self.sectionTitles.count) {
        return YES;
    }

    NSArray* theaters = [self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]];
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

    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    [self.abstractNavigationController pushTheaterDetails:theater animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return self.sectionTitles.count;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if ([self outOfBounds:indexPath]) {
        return [[[UITableView alloc] init] autorelease];
    }

    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    static NSString* reuseIdentifier = @"reuseIdentifier";

    TheaterNameCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[TheaterNameCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    if ([self sortingByName] && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    [cell setTheater:theater];
    return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    NSString* sectionTitle = [self.sectionTitles objectAtIndex:section];
    if ([sectionTitle isEqual:[Application starString]]) {
        return NSLocalizedString(@"Favorites", nil);
    }

    return sectionTitle;
}


- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self sortingByName] &&
        self.sortedTheaters.count > 0 &&
        UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return self.indexTitles;
    }

    return nil;
}


- (NSInteger) sectionForSectionIndexTitle:(NSString*) title {
    unichar firstChar = [title characterAtIndex:0];
    if ([UITableViewIndexSearch isEqual:title]) {
        [self.tableView scrollRectToVisible:self.searchBar.frame animated:NO];
        return -1;
    } else if (firstChar == '#') {
        return [self.sectionTitles indexOfObject:@"#"];
    } else if (firstChar == [Application starCharacter]) {
        return [self.sectionTitles indexOfObject:[Application starString]];
    } else {
        for (unichar c = firstChar; c >= 'A'; c--) {
            NSString* s = [NSString stringWithFormat:@"%c", c];

            NSInteger result = [self.sectionTitles indexOfObject:s];
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
    [super viewWillAppear:animated];

    [self majorRefresh];
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self sortTheaters];
    [self reloadTableViewData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) showInfo {
    [self.abstractNavigationController pushInfoControllerAnimated:YES];
}

@end