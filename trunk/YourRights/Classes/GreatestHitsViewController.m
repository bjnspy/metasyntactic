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

#import "GreatestHitsViewController.h"

#import "DecisionCell.h"
#import "Model.h"
#import "MultiDictionary.h"
#import "Decision.h"

@interface GreatestHitsViewController()
@property (retain) NSArray* sectionTitles;
@property (retain) NSArray* indexTitles;
@property (retain) MultiDictionary* sectionTitleToDecisions;
@property (retain) UISegmentedControl* segmentedControl;
@end


@implementation GreatestHitsViewController

@synthesize sectionTitles;
@synthesize sectionTitleToDecisions;
@synthesize segmentedControl;
@synthesize indexTitles;

- (void)dealloc {
    self.sectionTitles = nil;
    self.sectionTitleToDecisions = nil;
    self.segmentedControl = nil;
    self.indexTitles = nil;

    [super dealloc];
}


- (UISegmentedControl*) setupSegmentedControl {
    UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                    [NSArray arrayWithObjects:
                                     NSLocalizedString(@"Year", nil),
                                     NSLocalizedString(@"Category", nil),
                                     NSLocalizedString(@"Pursuer", nil),
                                     NSLocalizedString(@"Defender", nil), nil]] autorelease];
    
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    control.selectedSegmentIndex = [Model greatestHitsSortIndex];
    
    [control addTarget:self
                action:@selector(onSortOrderChanged:)
      forControlEvents:UIControlEventValueChanged];
    
    CGRect rect = control.frame;
    rect.size.width = 250;
    control.frame = rect;
    
    return control;
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.segmentedControl = [self setupSegmentedControl];
        self.navigationItem.titleView = segmentedControl;
        
        self.indexTitles =
        [NSArray arrayWithObjects:
         @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
         @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
         @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }

    return self;
}


- (void) sortByYear {
    NSMutableArray* titles = [NSMutableArray array];
    MultiDictionary* dictionary = [MultiDictionary dictionary];
    
    for (Decision* decision in [Decision greatestHits]) {
        NSString* year = [NSString stringWithFormat:@"%d", decision.year];
        
        if (![titles containsObject:year]) {
            [titles addObject:year];
        }
        
        [dictionary addObject:decision forKey:year];
    }
    
    self.sectionTitles = titles;
    self.sectionTitleToDecisions = dictionary;
}


- (void) sortByCategory {
    NSMutableArray* titles = [NSMutableArray array];
    MultiDictionary* dictionary = [MultiDictionary dictionary];
    
    for (Decision* decision in [Decision greatestHits]) {
        NSString* category = [Decision categoryString:decision.category];
        
        if (![titles containsObject:category]) {
            [titles addObject:category];
        }
        
        [dictionary addObject:decision forKey:category];
    }
    
    self.sectionTitles = [titles sortedArrayUsingSelector:@selector(compare:)];
    self.sectionTitleToDecisions = dictionary;
}


- (void) sortByPursuer {
    NSMutableArray* titles = [NSMutableArray array];
    MultiDictionary* dictionary = [MultiDictionary dictionary];
    
    for (Decision* decision in [Decision greatestHits]) {
        NSString* title = [decision.title substringToIndex:1];
        
        if (![titles containsObject:title]) {
            [titles addObject:title];
        }
        
        [dictionary addObject:decision forKey:title];
    }
    
    self.sectionTitles = [titles sortedArrayUsingSelector:@selector(compare:)];
    self.sectionTitleToDecisions = dictionary;
}


- (void) sortByDefender {
    NSMutableArray* titles = [NSMutableArray array];
    MultiDictionary* dictionary = [MultiDictionary dictionary];
    
    for (Decision* decision in [Decision greatestHits]) {
        NSRange range = [decision.title rangeOfString:@"v. "];
        NSString* title;
        
        if (range.length > 0) {
            title = [decision.title substringWithRange:NSMakeRange(range.location + range.length, 1)];
        } else {
            title = [decision.title substringToIndex:1];
        }
        
        if (![titles containsObject:title]) {
            [titles addObject:title];
        }
        
        [dictionary addObject:decision forKey:title];
    }
    
    self.sectionTitles = [titles sortedArrayUsingSelector:@selector(compare:)];
    self.sectionTitleToDecisions = dictionary;
}


- (BOOL) sortingByYear {
    return segmentedControl.selectedSegmentIndex == 0;
}


- (BOOL) sortingByCategory {
    return segmentedControl.selectedSegmentIndex == 1;
}


- (BOOL) sortingByPersuer {
    return segmentedControl.selectedSegmentIndex == 2;
}


- (BOOL) sortingByDefender {
    return segmentedControl.selectedSegmentIndex == 3;
}


- (void) initializeData {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0: [self sortByYear]; break;
        case 1: [self sortByCategory]; break;
        case 2: [self sortByPursuer]; break;
        case 3: [self sortByDefender]; break;
    }
}


- (void) majorRefresh {
    [self initializeData];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [self majorRefresh];
    [super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(sectionTitles.count, 1);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sectionTitles.count == 0) {
        return 0;
    }

    return [[sectionTitleToDecisions objectsForKey:[sectionTitles objectAtIndex:section]] count];
}


- (Decision*) decisionForIndexPath:(NSIndexPath*) indexPath {
    NSString* section = [sectionTitles objectAtIndex:indexPath.section];
    Decision* decision = [[sectionTitleToDecisions objectsForKey:section] objectAtIndex:indexPath.row];
    
    return decision;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    Decision* decision = [self decisionForIndexPath:indexPath];
    
    static NSString* reuseIdentifier = @"reuseIdentifier";
    DecisionCell* cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DecisionCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    }

    if (decision.link.length > 0 &&
        ([self sortingByYear] || [self sortingByCategory])) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell setDecision:decision owner:self];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    return [sectionTitles objectAtIndex:section];
}


- (void) onSortOrderChanged:(id) sender {
    [Model setGreatestHitsSortIndex:segmentedControl.selectedSegmentIndex];
    [self majorRefresh];
}


- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
    if ([self sortingByPersuer] || [self sortingByDefender]) {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            return indexTitles;
        }
    }
    
    return nil;
}


- (NSInteger)           tableView:(UITableView*) tableView
      sectionForSectionIndexTitle:(NSString*) title
                          atIndex:(NSInteger) index {
    unichar firstChar = [title characterAtIndex:0];
    
    for (unichar c = firstChar; c >= 'A'; c--) {
        NSString* s = [NSString stringWithFormat:@"%c", c];
        
        NSInteger result = [sectionTitles indexOfObject:s];
        if (result != NSNotFound) {
            return result;
        }
    }
    
    return 0;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    Decision* decision = [self decisionForIndexPath:indexPath];
    return [DecisionCell height:decision];
}

@end