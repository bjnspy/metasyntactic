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

#import "ACLUArticlesViewController.h"

#import "ArticleBodyCell.h"
#import "ArticleTitleCell.h"
#import "Item.h"
#import "Model.h"
#import "RSSCache.h"
#import "YourRightsNavigationController.h"

@interface ACLUArticlesViewController()
@property (copy) NSString* title;
@property (retain) NSArray* items;
@end


@implementation ACLUArticlesViewController

@synthesize title;
@synthesize items;

- (void) dealloc {
  self.title = nil;
  self.items = nil;

  [super dealloc];
}


- (id) initWithTitle:(NSString*) title_ {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = title_;
  }

  return self;
}


- (Model*) model {
  return [Model model];
}


- (void) onBeforeReloadTableViewData {
  self.items = [self.model.rssCache itemsForTitle:title];
}


- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section < items.count) {
    if (indexPath.row == 1) {
      Item* item = [items objectAtIndex:indexPath.section];
      if (item.link.length != 0) {
        return UITableViewCellAccessoryDetailDisclosureButton;
      }
    }
  }

  return UITableViewCellAccessoryNone;
}


- (void)                            tableView:(UITableView*) tableView
     accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section < items.count) {
    Item* item = [items objectAtIndex:indexPath.section];
    if (item.link) {
      [(id)self.navigationController pushBrowser:item.link animated:YES];
    }
  }
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return MAX(items.count, 1);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (items.count == 0) {
    return 0;
  } else {
    return 2;
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Item* item = [items objectAtIndex:indexPath.section];

  if (indexPath.row == 0) {
    static NSString* reuseIdentifier = @"titleReuseIdentifier";

    ArticleTitleCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[ArticleTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }

    [cell setItem:item];
    return cell;
  } else {
    static NSString* reuseIdentifier = @"bodyReuseIdentifier";

    ArticleBodyCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
      cell = [[[ArticleBodyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:reuseIdentifier
                                 tableViewController:self] autorelease];
    }

    [cell setItem:item];
    return cell;
  }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section < items.count) {
    if (indexPath.row == 1) {
      Item* review = [items objectAtIndex:indexPath.section];

      return MAX([ArticleBodyCell height:review], self.tableView.rowHeight);
    }
  }

  return tableView.rowHeight;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

@end
