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

#import "ACLUNewsViewController.h"

#import "ACLUArticlesViewController.h"
#import "Model.h"
#import "RSSCache.h"
#import "YourRightsNavigationController.h"

@interface ACLUNewsViewController()
@property (retain) NSArray* titlesWithArticles;
@end


@implementation ACLUNewsViewController

@synthesize titlesWithArticles;

- (void) dealloc {
  self.titlesWithArticles = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = NSLocalizedString(@"News", nil);
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (void) onBeforeReloadTableViewData {
  NSMutableArray* array = [NSMutableArray array];

  for (NSString* title in [RSSCache titles]) {
    NSArray* items = [self.model.rssCache itemsForTitle:title];
    if (items.count > 0) {
      [array addObject:title];
    }
  }

  self.titlesWithArticles = array;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return titlesWithArticles.count;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (titlesWithArticles.count == 0) {
    if ([[OperationQueue operationQueue] hasPriorityOperations]) {
      return NSLocalizedString(@"Downloading data", nil);
    } else if (![NetworkUtilities isNetworkAvailable]) {
      return NSLocalizedString(@"Network unavailable", nil);
    } else {
      return NSLocalizedString(@"No information found", nil);
    }
  }

  return nil;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";

  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
  }

  NSString* title = [titlesWithArticles objectAtIndex:indexPath.row];
  NSArray* items = [self.model.rssCache itemsForTitle:title];

  cell.textLabel.text = title;
  if (items.count == 1) {
    cell.detailTextLabel.text = NSLocalizedString(@"1 Article", nil);
  } else {
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d Articles", nil), items.count];
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString* title = [titlesWithArticles objectAtIndex:indexPath.row];
  ACLUArticlesViewController* controller = [[[ACLUArticlesViewController alloc] initWithTitle:title] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

@end
