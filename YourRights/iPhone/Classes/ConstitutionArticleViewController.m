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

#import "ConstitutionArticleViewController.h"

#import "Article.h"
#import "Section.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ConstitutionArticleViewController()
@property (retain) Article* article;
@property (retain) NSArray* sectionChunks;
@end


@implementation ConstitutionArticleViewController

@synthesize article;
@synthesize sectionChunks;

- (void) dealloc {
  self.article = nil;
  self.sectionChunks = nil;

  [super dealloc];
}


- (id) initWithArticle:(Article*) article_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.article = article_;

    NSMutableArray* array = [NSMutableArray array];
    for (Section* section in article_.sections) {
      [array addObject:[StringUtilities splitIntoChunks:section.text]];
    }
    self.sectionChunks = array;
  }

  return self;
}


- (void) loadView {
  [super loadView];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.title = article.title;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return article.sections.count + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section < article.sections.count) {
    return [[sectionChunks objectAtIndex:section] count];
  } else {
    if (article.link.length > 0) {
      return 1;
    }
  }

  return 0;
}


- (UITableViewCell*) cellForSectionRowAtIndexPath:(NSIndexPath*) indexPath {
  NSArray* chunks = [sectionChunks objectAtIndex:indexPath.section];
  NSString* chunk = [chunks objectAtIndex:indexPath.row];
  WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:chunk] autorelease];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  return cell;
}


- (UITableViewCell*) cellForLinksRow:(NSInteger) row {
  UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
  cell.textLabel.text = @"Wikipedia";
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section < article.sections.count) {
    return [self cellForSectionRowAtIndexPath:indexPath];
  } else {
    return [self cellForLinksRow:indexPath.row];
  }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section < article.sections.count) {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  } else {
    [(id)self.navigationController pushBrowser:article.link animated:YES];
  }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section < article.sections.count) {
    if (article.sections.count > 1) {
      return [NSString stringWithFormat:NSLocalizedString(@"Section %d", nil), section + 1];
    }
  } else {
    if (article.link.length > 0) {
      return NSLocalizedString(@"Links", nil);
    }
  }

  return nil;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section < article.sections.count) {
    NSArray* chunks = [sectionChunks objectAtIndex:indexPath.section];
    NSString* chunk = [chunks objectAtIndex:indexPath.row];

    return [WrappableCell height:chunk accessoryType:UITableViewCellAccessoryNone];
  } else {
    return tableView.rowHeight;
  }
}

@end
