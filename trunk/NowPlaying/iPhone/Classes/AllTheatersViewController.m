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
#import "ImageCache.h"
#import "LocalSearchDisplayController.h"
#import "Model.h"
#import "Theater.h"
#import "TheaterNameCell.h"
#import "TheatersNavigationController.h"

@interface AllTheatersViewController()
@property (retain) UISegmentedControl* segmentedControl;
#ifdef IPHONE_OS_VERSION_3
@property (retain) UISearchBar* searchBar;
@property (retain) LocalSearchDisplayController* searchDisplayController;
#endif
@property (retain) NSArray* sortedTheaters;
@property (retain) NSArray* sectionTitles;
@property (retain) MultiDictionary* sectionTitleToContentsMap;
@property (retain) NSArray* indexTitles;
@end


@implementation AllTheatersViewController

@synthesize segmentedControl;
#ifdef IPHONE_OS_VERSION_3
@synthesize searchBar;
@synthesize searchDisplayController;
#endif
@synthesize sortedTheaters;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize indexTitles;

- (void) dealloc {
    self.segmentedControl = nil;
#ifdef IPHONE_OS_VERSION_3
    self.searchBar = nil;
    self.searchDisplayController = nil;
#endif
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
    return segmentedControl.selectedSegmentIndex == 1;
}


- (BOOL) sortingByDistance {
    return !self.sortingByName;
}


- (void) onSortOrderChanged:(id) sender {
    self.model.allTheatersSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self majorRefresh];
}


- (void) removeUnusedSectionTitles {
    NSMutableArray* array = [NSMutableArray arrayWithArray:sectionTitles];

    for (NSInteger i = array.count - 1; i >= 0; --i) {
        NSString* title = [array objectAtIndex:i];
        if ([[sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [array removeObjectAtIndex:i];
        }
    }

    self.sectionTitles = array;
}


- (void) sortTheatersByName {
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:compareTheatersByName context:nil];

    MutableMultiDictionary* map = [MutableMultiDictionary dictionary];

    for (Theater* theater in [self.model theatersInRange:sortedTheaters]) {
        if ([self.model isFavoriteTheater:theater]) {
            [map addObject:theater forKey:[StringUtilities starString]];
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
        self.sectionTitles = [NSMutableArray arrayWithArray:sectionTitleToContentsMap.allKeys];
        self.sectionTitles = [sectionTitles sortedArrayUsingSelector:@selector(compare:)];
    } else {
        self.sectionTitles = [NSMutableArray arrayWithArray:indexTitles];
    }

    self.sectionTitleToContentsMap = map;
}


- (void) sortTheatersByDistance {
    NSDictionary* theaterDistanceMap = self.model.theaterDistanceMap;
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:compareTheatersByDistance
                                                                context:theaterDistanceMap];

    NSString* favorites = LocalizedString(@"Favorites", nil);
    NSString* reallyCloseBy = LocalizedString(@"Really close by", nil);
    NSString* reallyFarAway = LocalizedString(@"Really far away", nil);
    NSString* unknownDistance = LocalizedString(@"Unknown Distance", nil);

    NSString* singularUnit = ([Application useKilometers] ? LocalizedString(@"kilometer", nil) :
                              LocalizedString(@"mile", nil));
    NSString* pluralUnit = ([Application useKilometers] ? LocalizedString(@"kilometers", nil) :
                            LocalizedString(@"miles", nil));

    int distances[] = {
        1, 2, 5, 10, 15, 20, 30, 40, 50
    };

    NSMutableArray* distancesArray = [NSMutableArray array];
    for (int i = 0; i < ArrayLength(distances); i++) {
        int distance = distances[i];
        if (distance == 1) {
            [distancesArray addObject:[NSString stringWithFormat:LocalizedString(@"Less than 1 %@ away", @"singular. refers to a distance like 'Less than 1 mile away'"), singularUnit]];
        } else {
            [distancesArray addObject:[NSString stringWithFormat:LocalizedString(@"Less than %d %@ away", @"plural. refers to a distance like 'Less than 2 miles away'"), distance, pluralUnit]];
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

    NSArray* theatersInRange = [self.model theatersInRange:sortedTheaters];
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

    if (sectionTitles.count == 0) {
        NSArray* theaters = self.model.theaters;
        if (theaters.count == 1) {
            self.sectionTitles = [NSArray arrayWithObject:LocalizedString(@"1 theater outside search area", nil)];
        } else if (theaters.count > 1) {
            self.sectionTitles = [NSArray arrayWithObject:
                               [NSString stringWithFormat:LocalizedString(@"%d theaters outside search area", @"i.e.: 10 theaters outside search area"), theaters.count]];
        } else {
            self.sectionTitles = [NSArray arrayWithObject:self.model.noInformationFound];
        }
    }
}


- (void) initializeSegmentedControl {
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                             [NSArray arrayWithObjects:
                               LocalizedString(@"Distance", @"Must be very short. 1 word max. This is on a button that allows users to sort theaters by distance"),
                               LocalizedString(@"Name", @"Must be very short. 1 word max. This is on a button that allows users to sort theaters by their name"),
                               nil]] autorelease];

    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = self.model.allTheatersSelectedSegmentIndex;
    [segmentedControl addTarget:self
                         action:@selector(onSortOrderChanged:)
               forControlEvents:UIControlEventValueChanged];

    CGRect rect = segmentedControl.frame;
    rect.size.width = 310;
    segmentedControl.frame = rect;
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = LocalizedString(@"Theaters", nil);
    }

    return self;
}


- (void) setupIndexTitles {
    if ([LocaleUtilities isJapanese]) {
        self.indexTitles = nil;
    } else {
        self.indexTitles =
        [NSArray arrayWithObjects:
#ifdef IPHONE_OS_VERSION_3
         UITableViewIndexSearch,
#endif
         [StringUtilities starString],
         @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
}


- (void) initializeInfoButton {
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];

    infoButton.contentMode = UIViewContentModeCenter;
    CGRect frame = infoButton.frame;
    frame.size.width += 4;
    infoButton.frame = frame;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
}


- (void) initializeSearchDisplay {
#ifdef IPHONE_OS_VERSION_3
    self.searchBar = [[[UISearchBar alloc] init] autorelease];
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;

    self.searchDisplayController = [[[LocalSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                         contentsController:self] autorelease];
#else
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.showsTouchWhenHighlighted = YES;
    UIImage* image = [ImageCache searchImage];
    [searchButton setImage:image forState:UIControlStateNormal];
    [searchButton addTarget:self.navigationController action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];

    CGRect frame = searchButton.frame;
    frame.origin.x += 0.5;
    frame.size = image.size;
    frame.size.width += 7;
    frame.size.height += 7;
    searchButton.frame = frame;

    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithCustomView:searchButton] autorelease];
    self.navigationItem.rightBarButtonItem = item;
#endif
}


- (void) loadView {
    [super loadView];

    self.sortedTheaters = [NSArray array];

    [self initializeSegmentedControl];
    [self initializeSearchDisplay];
    [self initializeInfoButton];

    self.navigationItem.titleView = segmentedControl;

    [self setupIndexTitles];

    self.title = LocalizedString(@"Theaters", nil);
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
    if (indexPath.section < 0 || indexPath.section >= sectionTitles.count) {
        return YES;
    }

    NSArray* theaters = [sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]];
    if (indexPath.row < 0 || indexPath.row >= theaters.count) {
        return YES;
    }

    return NO;
}


- (CommonNavigationController*) commonNavigationController {
  return (id)self.navigationController;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if ([self outOfBounds:indexPath]) {
        return;
    }

    Theater* theater = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    [self.commonNavigationController pushTheaterDetails:theater animated:YES];
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
    NSString* sectionTitle = [sectionTitles objectAtIndex:section];
    if ([sectionTitle isEqual:[StringUtilities starString]]) {
        return LocalizedString(@"Favorites", nil);
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
#ifdef IPHONE_OS_VERSION_3
    if ([UITableViewIndexSearch isEqual:title]) {
        [self.tableView scrollRectToVisible:searchBar.frame animated:NO];
        return -1;
    } else
#endif
    if (firstChar == '#') {
        return [sectionTitles indexOfObject:@"#"];
    } else if (firstChar == [StringUtilities starCharacter]) {
        return [sectionTitles indexOfObject:[StringUtilities starString]];
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
    [super viewWillAppear:animated];
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self sortTheaters];
    [self reloadTableViewData];
}


- (void) showInfo {
    [self.commonNavigationController pushInfoControllerAnimated:YES];
}


#ifdef IPHONE_OS_VERSION_3
- (void) onTabBarItemSelected {
    [searchDisplayController setActive:NO animated:YES];
}
#endif

@end