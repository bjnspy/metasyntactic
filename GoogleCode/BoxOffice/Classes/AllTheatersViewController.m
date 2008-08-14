// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "AllTheatersViewController.h"

#import "Application.h"
#import "BoxOfficeModel.h"
#import "Location.h"
#import "MultiDictionary.h"
#import "Theater.h"
#import "TheatersNavigationController.h"

@implementation AllTheatersViewController

@synthesize navigationController;
@synthesize segmentedControl;
@synthesize sortedTheaters;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize alphabeticSectionTitles;

- (void) dealloc {
    self.navigationController = nil;
    self.segmentedControl = nil;
    self.sortedTheaters = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.alphabeticSectionTitles = nil;

    [super dealloc];
}


- (BOOL) sortingByName {
    return segmentedControl.selectedSegmentIndex == 0;
}


- (BOOL) sortingByDistance {
    return ![self sortingByName];
}


- (void) onSortOrderChanged:(id) sender {
    [self.model setAllTheatersSelectedSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    [self refresh];
}


- (BoxOfficeModel*) model {
    return [self.navigationController model];
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

    self.sectionTitles = [NSMutableArray arrayWithArray:self.alphabeticSectionTitles];

    for (Theater* theater in [self.model theatersInRange:self.sortedTheaters]) {
        if ([self.model isFavoriteTheater:theater]) {
            [self.sectionTitleToContentsMap addObject:theater forKey:[Application starString]];
        }

        unichar firstChar = [theater.name characterAtIndex:0];
        firstChar = toupper(firstChar);

        if (firstChar >= 'A' && firstChar <= 'Z') {
            NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
            [self.sectionTitleToContentsMap addObject:theater forKey:sectionTitle];
        } else {
            [self.sectionTitleToContentsMap addObject:theater forKey:@"#"];
        }
    }

    [self removeUnusedSectionTitles];
}


- (void) sortTheatersByDistance {
    NSDictionary* theaterDistanceMap = [self.model theaterDistanceMap];
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:compareTheatersByDistance
                                                                context:theaterDistanceMap];

    NSString* favorites                 = NSLocalizedString(@"Favorites", nil);
    NSString* reallyCloseBy             = NSLocalizedString(@"Really close by", nil);
    NSString* oneHalfToOneMile          = NSLocalizedString(@"Less than 1 mile away", nil);
    NSString* oneToTwoMiles             = NSLocalizedString(@"Less than 2 miles away", nil);
    NSString* twoToFileMiles            = NSLocalizedString(@"Less than 5 miles away", nil);
    NSString* fiveToTenMiles            = NSLocalizedString(@"Less than 10 miles away", nil);
    NSString* tenToFifteenMiles         = NSLocalizedString(@"Less than 15 miles away", nil);
    NSString* fifteenToTwentyFiveMiles  = NSLocalizedString(@"Less than 25 miles away", nil);
    NSString* twentyFiveToFiftyMiles    = NSLocalizedString(@"Less than 50 miles away", nil);
    NSString* reallyFarAway             = NSLocalizedString(@"Really far away", nil);
    NSString* unknownDistance           = NSLocalizedString(@"Unknown Distance", nil);

    self.sectionTitles = [NSMutableArray arrayWithObjects:
                          favorites, reallyCloseBy, oneHalfToOneMile, oneToTwoMiles,
                          twoToFileMiles, fiveToTenMiles, tenToFifteenMiles,
                          fifteenToTwentyFiveMiles, twentyFiveToFiftyMiles, reallyFarAway,
                          unknownDistance, nil];

    for (Theater* theater in [self.model theatersInRange:self.sortedTheaters]) {
        if ([self.model isFavoriteTheater:theater]) {
            [self.sectionTitleToContentsMap addObject:theater forKey:favorites];
        } else {
            double distance = [[theaterDistanceMap objectForKey:theater.address] doubleValue];

            if (distance <= 0.5) {
                [self.sectionTitleToContentsMap addObject:theater forKey:reallyCloseBy];
            } else if (distance <= 1) {
                [self.sectionTitleToContentsMap addObject:theater forKey:oneHalfToOneMile];
            } else if (distance <= 2) {
                [self.sectionTitleToContentsMap addObject:theater forKey:oneToTwoMiles];
            } else if (distance <= 5) {
                [self.sectionTitleToContentsMap addObject:theater forKey:twoToFileMiles];
            } else if (distance <= 10) {
                [self.sectionTitleToContentsMap addObject:theater forKey:fiveToTenMiles];
            } else if (distance <= 15) {
                [self.sectionTitleToContentsMap addObject:theater forKey:tenToFifteenMiles];
            } else if (distance <= 25) {
                [self.sectionTitleToContentsMap addObject:theater forKey:fifteenToTwentyFiveMiles];
            } else if (distance <= 50) {
                [self.sectionTitleToContentsMap addObject:theater forKey:twentyFiveToFiftyMiles];
            } else if (distance < UNKNOWN_DISTANCE) {
                [self.sectionTitleToContentsMap addObject:theater forKey:reallyFarAway];
            } else {
                [self.sectionTitleToContentsMap addObject:theater forKey:unknownDistance];
            }
        }
    }

    [self removeUnusedSectionTitles];
}


- (void) sortTheaters {
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];

    if ([self sortingByName]) {
        [self sortTheatersByName];
    } else {
        [self sortTheatersByDistance];
    }

    if (sectionTitles.count == 0) {
        self.sectionTitles = [NSArray arrayWithObject:[self.model noLocationInformationFound]];
    }
}


- (id) initWithNavigationController:(TheatersNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;
        self.sortedTheaters = [NSArray array];

        segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                             [NSArray arrayWithObjects:NSLocalizedString(@"Name", nil), NSLocalizedString(@"Distance", nil), nil]] autorelease];

        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.selectedSegmentIndex = [self.model allTheatersSelectedSegmentIndex];
        [segmentedControl addTarget:self
                             action:@selector(onSortOrderChanged:)
                   forControlEvents:UIControlEventValueChanged];

        CGRect rect = segmentedControl.frame;
        rect.size.width = 240;
        segmentedControl.frame = rect;

        self.navigationItem.titleView = segmentedControl;

        {
            self.alphabeticSectionTitles =
            [NSArray arrayWithObjects:
             [Application starString],
             @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
             @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
             @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        }

        self.title = NSLocalizedString(@"Theaters", nil);
    }

    return self;
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    if ([self sortingByName]) {
        return UITableViewCellAccessoryNone;
    } else {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    [self.navigationController pushTheaterDetails:theater animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return sectionTitles.count;
}


- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
}


- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    static NSString* reuseIdentifier = @"AllTheatersCellIdentifier";

    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame reuseIdentifier:reuseIdentifier] autorelease];
    }

    cell.text = theater.name;

    return cell;
}


- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    NSString* indexTitle = [sectionTitles objectAtIndex:section];
    if (indexTitle == [Application starString]) {
        return NSLocalizedString(@"Favorites", nil);
    }

    return [sectionTitles objectAtIndex:section];
}


- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self sortingByName] && sortedTheaters.count > 0) {
        return self.alphabeticSectionTitles;
    }

    return nil;
}


- (NSInteger) sectionForSectionIndexTitle:(NSString*) title {
    unichar firstChar = [title characterAtIndex:0];
    if (firstChar == '#') {
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
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self.model setCurrentlySelectedMovie:nil theater:nil];

    [self refresh];
}


- (void) refresh {
    [self sortTheaters];
    [self.tableView reloadData];
}


@end
