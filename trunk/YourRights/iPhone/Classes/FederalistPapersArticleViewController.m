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

#import "FederalistPapersArticleViewController.h"

#import "Article.h"
#import "FederalistPapersSectionViewController.h"
#import "Section.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface FederalistPapersArticleViewController()
@property (retain) Article* article;
@end


@implementation FederalistPapersArticleViewController

@synthesize article;

- (void) dealloc {
  self.article = nil;

  [super dealloc];
}


- (id) initWithArticle:(Article*) article_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.article = article_;
    self.title = article.title;
  }

  return self;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return article.sections.count;
}


- (UITableViewCell*) cellForSectionRow:(NSInteger) row {
  Section* section = [article.sections objectAtIndex:row];
  WrappableCell *cell = [[[WrappableCell alloc] initWithTitle:section.title] autorelease];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self cellForSectionRow:indexPath.row];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Section* section = [article.sections objectAtIndex:indexPath.row];
  FederalistPapersSectionViewController* controller = [[[FederalistPapersSectionViewController alloc] initWithSection:section] autorelease];
  [self.navigationController pushViewController:controller
                                       animated:YES];
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  Section* section = [article.sections objectAtIndex:indexPath.row];

  return [WrappableCell height:section.title
                 accessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

@end
