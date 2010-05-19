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

#import "FederalistPapersViewController.h"

#import "Amendment.h"
#import "Article.h"
#import "Constitution.h"
#import "ConstitutionAmendmentViewController.h"
#import "ConstitutionArticleViewController.h"
#import "ConstitutionSignersViewController.h"
#import "FederalistPapersArticleViewController.h"
#import "WrappableCell.h"

@interface FederalistPapersViewController()
@property (retain) Constitution* constitution;
@end

@implementation FederalistPapersViewController

@synthesize constitution;

- (void) dealloc {
  self.constitution = nil;
  [super dealloc];
}


- (id) initWithConstitution:(Constitution*) constitution_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.constitution = constitution_;
    self.title = NSLocalizedString(@"Federalist Papers", nil);
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
  return constitution.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseIdentifier = @"reuseIdentifier";

  AutoResizingCell *cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[AutoResizingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }

  Article* article = [constitution.articles objectAtIndex:indexPath.row];
  cell.textLabel.text = article.title;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Article* article = [constitution.articles objectAtIndex:indexPath.row];
  FederalistPapersArticleViewController* controller = [[[FederalistPapersArticleViewController alloc] initWithArticle:article] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
