// Copyright 2010 Cyrus Najmabadi
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

#import "GreatestHitsViewController.h"

#import "Decision.h"
#import "DecisionCell.h"
#import "Model.h"
#import "YourRightsNavigationController.h"

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

- (void) dealloc {
  self.sectionTitles = nil;
  self.sectionTitleToDecisions = nil;
  self.segmentedControl = nil;
  self.indexTitles = nil;

  [super dealloc];
}


- (Model*) model {
  return [Model model];
}


- (UISegmentedControl*) setupSegmentedControl {
  UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Year", nil),
                                   NSLocalizedString(@"Category", nil),
                                   NSLocalizedString(@"Pursuer", nil),
                                   NSLocalizedString(@"Defender", nil), nil]] autorelease];

  control.segmentedControlStyle = UISegmentedControlStyleBar;
  control.selectedSegmentIndex = [self.model greatestHitsSortIndex];

  [control addTarget:self
              action:@selector(onSortOrderChanged:)
    forControlEvents:UIControlEventValueChanged];

  CGRect rect = control.frame;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    rect.size.width = 500;
  } else {
    rect.size.width = 250;
  }
  control.frame = rect;

  return control;
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.segmentedControl = [self setupSegmentedControl];

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
  MutableMultiDictionary* dictionary = [MutableMultiDictionary dictionary];

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
  MutableMultiDictionary* dictionary = [MutableMultiDictionary dictionary];

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
  MutableMultiDictionary* dictionary = [MutableMultiDictionary dictionary];

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
  MutableMultiDictionary* dictionary = [MutableMultiDictionary dictionary];

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


- (void) onBeforeReloadTableViewData {
  switch (segmentedControl.selectedSegmentIndex) {
    case 0: [self sortByYear]; break;
    case 1: [self sortByCategory]; break;
    case 2: [self sortByPursuer]; break;
    case 3: [self sortByDefender]; break;
  }
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  self.segmentedControl = [self setupSegmentedControl];
  self.navigationItem.titleView = segmentedControl;
}


- (void) viewWillAppear:(BOOL) animated {
  [super viewWillAppear:animated];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneTapped:)] autorelease];
}


- (void) onDoneTapped:(id) sender {
  [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
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

  if (decision.link.length > 0) {
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
  } else {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }

  [cell setDecision:decision owner:self];

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Decision* decision = [self decisionForIndexPath:indexPath];

  if (decision.link.length == 0) {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  } else {
    [(id)self.navigationController pushBrowser:decision.link animated:YES];
  }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  return [sectionTitles objectAtIndex:section];
}


- (void) onSortOrderChanged:(id) sender {
  [self.model setGreatestHitsSortIndex:segmentedControl.selectedSegmentIndex];
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
  return [DecisionCell height:decision owner:self];
}

@end
