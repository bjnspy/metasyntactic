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

#import "ToughQuestionsViewController.h"

#import "AnswerViewController.h"
#import "Model.h"
#import "ToughAnswerViewController.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface ToughQuestionsViewController()
@end


@implementation ToughQuestionsViewController

- (void) dealloc {
  [super dealloc];
}


- (Model*) model {
  return [Model model];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
  }

  return self;
}


- (void) loadView {
  [super loadView];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease]] autorelease];
  self.title = NSLocalizedString(@"Tough Questions", nil);
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
  return [self.model toughQuestions].count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  NSString* text = [[self.model toughQuestions] objectAtIndex:indexPath.row];

  UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  return [WrappableCell height:[[self.model toughQuestions] objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  NSString* question = [[self.model toughQuestions] objectAtIndex:indexPath.row];
  NSString* answer = [self.model answerForToughQuestion:question];
  ToughAnswerViewController* controller = [[[ToughAnswerViewController alloc] initWithQuestion:question answer:answer] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


@end
