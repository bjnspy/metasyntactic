//
//  AllTheatersViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AllTheatersViewController.h"
#import "TheatersNavigationController.h"
#import "Theater.h"

@implementation AllTheatersViewController

@synthesize navigationController;
@synthesize segmentedControl;
@synthesize sortedTheaters;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize alphabeticSectionTitles;

- (void) dealloc
{
    self.navigationController = nil;
    self.segmentedControl = nil;
    self.sortedTheaters = nil;
    self.sectionTitles = nil;
    self.sectionTitleToContentsMap = nil;
    self.alphabeticSectionTitles = nil;
    [super dealloc];
}

- (id) initWithNavigationController:(TheatersNavigationController*) controller
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        self.navigationController = controller;
        self.sortedTheaters = [NSArray array];
        
        segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                             [NSArray arrayWithObjects:@"Name", @"Distance", nil]] autorelease];
        
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
        segmentedControl.selectedSegmentIndex = 1;
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

- (BOOL) sortingByName
{
    return segmentedControl.selectedSegmentIndex == 0;
}

- (BOOL) sortingByDistance
{
    return ![self sortingByName];
}

- (void) onSortOrderChanged:(id) sender
{
    [self refresh];
}

- (BoxOfficeModel*) model
{
    return [self.navigationController model];
}

NSInteger sortByName(id t1, id t2, void *context)
{
    Theater* theater1 = t1;
    Theater* theater2 = t2;
    
    return [theater1.name compare:theater2.name options:NSCaseInsensitiveSearch];
}

NSInteger sortByDistance(id t1, id t2, void *context)
{
    NSDictionary* theaterDistanceMap = context;
    
    Theater* theater1 = t1;
    Theater* theater2 = t2;

    double distance1 = [[theaterDistanceMap objectForKey:theater1.address] doubleValue];
    double distance2 = [[theaterDistanceMap objectForKey:theater2.address] doubleValue];
    
    if (distance1 < distance2)
    {
        return NSOrderedAscending;
    }
    else if (distance1 > distance2)
    {
        return NSOrderedDescending;
    }
    
    return sortByName(t1, t2, nil);
}

- (void) removeUnusedSectionTitles
{
    for (NSInteger i = [self.sectionTitles count] - 1; i >= 0; --i)
    {
        NSString* title = [self.sectionTitles objectAtIndex:i];
        if ([[self.sectionTitleToContentsMap objectsForKey:title] count] == 0)
        {
            [self.sectionTitles removeObjectAtIndex:i];
        }
    }    
}

- (void) sortTheatersByName
{
    // sort by theater name
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:sortByName context:nil];
    
    self.sectionTitles = [NSMutableArray arrayWithArray:self.alphabeticSectionTitles];
    
    for (Theater* theater in self.sortedTheaters)
    {
        unichar firstChar = [theater.name characterAtIndex:0];
        firstChar = toupper(firstChar);
        
        if (firstChar >= 'A' && firstChar <= 'Z')
        {
            NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
            [self.sectionTitleToContentsMap addObject:theater forKey:sectionTitle];
        }
        else
        {
            [self.sectionTitleToContentsMap addObject:theater forKey:@"#"];
        }
    }
    
    [self removeUnusedSectionTitles];
}

- (void) sortTheatersByDistance:(Location*) userLocation
{
    NSMutableDictionary* theaterDistanceMap = [NSMutableDictionary dictionary];
    for (Theater* theater in self.model.theaters)
    {
        double d = [userLocation distanceTo:[self.model locationForAddress:theater.address]];
        NSNumber* value = [NSNumber numberWithDouble:d];
        NSString* key = theater.address;
        [theaterDistanceMap setObject:value forKey:key];
    }
    
    self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:sortByDistance
                                                                context:theaterDistanceMap];
    
    NSString* reallyCloseBy = @"Realllllly close by";
    NSString* oneHalfToOneMile = @"< 1 mile away";
    NSString* oneToTwoMiles = @"< 2 miles away";
    NSString* twoToFileMiles = @"< 5 miles away";
    NSString* fiveToTenMiles = @"< 10 miles away";
    NSString* tenToFifteenMiles = @"< 15 miles away";
    NSString* fifteenToTwentyFiveMiles = @"< 25 miles away";
    NSString* twentyFiveToFiftyMiles = @"< 50 miles away";
    NSString* wayFarAway = @"Waaaaaay too far away";
    NSString* unknownDistance = @"Unknown Distance";
    
    self.sectionTitles = [NSMutableArray arrayWithObjects:reallyCloseBy, oneHalfToOneMile, oneToTwoMiles, twoToFileMiles,
                                                          fiveToTenMiles, tenToFifteenMiles, fifteenToTwentyFiveMiles,
                                                          twentyFiveToFiftyMiles, wayFarAway, unknownDistance, nil];
    
    for (Theater* theater in self.sortedTheaters)
    {
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
        } else if (distance < FLT_MAX) {
            [self.sectionTitleToContentsMap addObject:theater forKey:wayFarAway];
        } else {
            [self.sectionTitleToContentsMap addObject:theater forKey:unknownDistance];
        }
    }
    
    [self removeUnusedSectionTitles];
}

- (void) sortTheaters
{
    self.sectionTitles = [NSMutableArray array];
    self.sectionTitleToContentsMap = [MultiDictionary dictionary];
    
    if ([self sortingByName])
    {
        [self sortTheatersByName];
    }
    else
    {
        // sort by distance
        Location* userLocation = [self.model locationForZipcode:[self.model zipcode]];
        
        if (userLocation == nil)
        {
            // can't sort by distance if we don't know where the user is.  Just sort by name
            // and bucketize everything into the 'unknown distance' range.
            self.sortedTheaters = [self.model.theaters sortedArrayUsingFunction:sortByName context:nil];
            
            NSString* sectionTitle = @"Unknown Distance";
            self.sectionTitles = [NSArray arrayWithObject:sectionTitle];
            [self.sectionTitleToContentsMap addObjects:self.sortedTheaters forKey:sectionTitle];
        }
        else
        {
            [self sortTheatersByDistance:userLocation];
        }
    }
    
    if ([self.sectionTitles count] == 0)
    {
        self.sectionTitles = [NSArray arrayWithObject:@"No Data Found"];   
    }
}

- (void) refresh
{
    [self sortTheaters];
    [self.tableView reloadData];
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath
{
    if ([self sortingByName])
    {
        return UITableViewCellAccessoryNone;
    }
    else
    {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath;
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    
    [self.navigationController pushTheaterDetails:theater];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView
{
    return [self.sectionTitles count];
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section
{
    return [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] count];
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    Theater* theater = [[self.sectionTitleToContentsMap objectsForKey:[self.sectionTitles objectAtIndex:section]] objectAtIndex:row];
    
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    cell.text = theater.name;
    
    return cell;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section
{
    return [self.sectionTitles objectAtIndex:section]; 
}

- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView
{
    if ([self sortingByName])
    {
        return self.alphabeticSectionTitles;
    }
    
    return nil;
}

- (NSInteger)               tableView:(UITableView*) tableView 
          sectionForSectionIndexTitle:(NSString*) title
                              atIndex:(NSInteger) index
{
    // first entry in the list always goes to the first section
    if (index == 0)
    {
        return index;
    }
        
    for (unichar c = [title characterAtIndex:0]; c >= 'A'; c--)
    {
        NSString* s = [NSString stringWithFormat:@"%c", c];
        
        NSInteger result = [self.sectionTitles indexOfObject:s];
        if (result != NSNotFound)
        {
            return result;
        }  
    }
    
    return 0;
}

- (void) viewWillAppear:(BOOL) animated
{
    if ([self sortingByDistance])
    {
        [self refresh];
    }
}

@end
