//
//  AllTheatersViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "AllTheatersViewController.h"
#import "TheatersNavigationController.h"
#import "Theater.h"
#import "Location.h"
#import "ApplicationTabBarController.h"

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
    [[self model] setAllTheatersSelectedSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    [self refresh];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (void) removeUnusedSectionTitles {
    for (NSInteger i = [self.sectionTitles count] - 1; i >= 0; --i) {
        NSString* title = [self.sectionTitles objectAtIndex:i];
        if ([[self.sectionTitleToContentsMap objectsForKey:title] count] == 0) {
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }    
}

- (void) sortTheatersByName {
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:compareTheatersByName context:nil];
    
    self.sectionTitles = [NSMutableArray arrayWithArray:self.alphabeticSectionTitles];
    
    for (Theater* theater in [self.model theatersInRange:self.sortedTheaters]) {
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
    NSString* oneHalfToOneMile          = NSLocalizedString(@"< 1 mile away", nil);
    NSString* oneToTwoMiles             = NSLocalizedString(@"< 2 miles away", nil);
    NSString* twoToFileMiles            = NSLocalizedString(@"< 5 miles away", nil);
    NSString* fiveToTenMiles            = NSLocalizedString(@"< 10 miles away", nil);
    NSString* tenToFifteenMiles         = NSLocalizedString(@"< 15 miles away", nil);
    NSString* fifteenToTwentyFiveMiles  = NSLocalizedString(@"< 25 miles away", nil);
    NSString* twentyFiveToFiftyMiles    = NSLocalizedString(@"< 50 miles away", nil);
    NSString* reallyFarAway             = NSLocalizedString(@"Really far away", nil);
    NSString* unknownDistance           = NSLocalizedString(@"Unknown Distance", nil);
    
    self.sectionTitles = [NSMutableArray arrayWithObjects:
                          favorites, reallyCloseBy, oneHalfToOneMile, oneToTwoMiles,
                          twoToFileMiles, fiveToTenMiles, tenToFifteenMiles,
                          fifteenToTwentyFiveMiles, twentyFiveToFiftyMiles, reallyFarAway,
                          unknownDistance, nil];
    
    for (Theater* theater in [self.model theatersInRange:self.sortedTheaters]) {
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
    
    [self removeUnusedSectionTitles];
}

- (void) sortTheaters {
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];
    
    if ([self sortingByName]) {
        [self sortTheatersByName];
    } else {
        [self sortTheatersByDistance];
    }
    
    if ([self.sectionTitles count] == 0) {
        self.sectionTitles = [NSArray arrayWithObject:NSLocalizedString(@"No information found", nil)]; 
    }
}

- (id) initWithNavigationController:(TheatersNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationController = controller;
        self.sortedTheaters = [NSArray array];
        
        segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                             [NSArray arrayWithObjects:NSLocalizedString(@"Name", nil), NSLocalizedString(@"Distance", nil), nil]] autorelease];
        
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
        segmentedControl.selectedSegmentIndex = [[self model] allTheatersSelectedSegmentIndex];
        [segmentedControl addTarget:self
                             action:@selector(onSortOrderChanged:)
                   forControlEvents:UIControlEventValueChanged];
        
        CGRect rect = segmentedControl.frame;
        rect.size.width = 200;
        segmentedControl.frame = rect;
        
        self.navigationItem.titleView = segmentedControl;
        
        {
            self.alphabeticSectionTitles =
            [NSArray arrayWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", 
             @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", 
             @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        }
    }
    
    return self;
}

- (void) refresh {
    [self sortTheaters];
    [self.tableView reloadData];
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
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    
    [self.navigationController pushTheaterDetails:theater animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self.sectionTitles count];
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];

    static NSString* reuseIdentifier = @"AllTheatersCellIdentifiers";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    cell.text = theater.name;
    
    return cell;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    return [self.sectionTitles objectAtIndex:section]; 
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self sortingByName]) {
        return self.alphabeticSectionTitles;
    }
    
    return nil;
}

- (NSInteger)               tableView:(UITableView*) tableView 
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

- (void) viewWillAppear:(BOOL) animated {
    [self refresh];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self.model setCurrentlySelectedMovie:nil theater:nil];
}

@end