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

#import "QuestionsViewController.h"

#import "AnswerViewController.h"
#import "Model.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface QuestionsViewController()
@property (copy) NSString* sectionTitle;
@property (copy) NSString* preamble;
@property (retain) NSArray* questions;
@property (retain) NSArray* otherResources;
@property (retain) NSArray* links;
@end


@implementation QuestionsViewController

@synthesize sectionTitle;
@synthesize preamble;
@synthesize questions;
@synthesize otherResources;
@synthesize links;

- (void) dealloc {
  self.sectionTitle = nil;
  self.preamble = nil;
  self.questions = nil;
  self.otherResources = nil;
  self.links = nil;

  [super dealloc];
}


- (Model*) model {
  return [Model model];
}


- (id) initWithSectionTitle:(NSString*) sectionTitle_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.sectionTitle = sectionTitle_;
    self.preamble = [self.model preambleForSectionTitle:sectionTitle];
    self.questions = [self.model questionsForSectionTitle:sectionTitle];
    self.otherResources = [self.model otherResourcesForSectionTitle:sectionTitle];
    self.links = [self.model linksForSectionTitle:sectionTitle];
  }

  return self;
}


- (void) loadView {
  [super loadView];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease]] autorelease];
  self.title = [self.model shortSectionTitleForSectionTitle:sectionTitle];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return preamble.length == 0 ? 0 : 1;
  } else if (section == 1) {
    return questions.count;
  } else if (section == 2) {
    return otherResources.count;
  } else {
    return links.count;
  }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:preamble] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
  } else if (indexPath.section == 1) {
    NSString* text = [questions objectAtIndex:indexPath.row];

    UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
  } else if (indexPath.section == 2) {
    NSString* text = [otherResources objectAtIndex:indexPath.row];

    UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
  } else {
    NSString* link = [links objectAtIndex:indexPath.row];
    UITableViewCell* cell = [[[UITableViewCell alloc] init] autorelease];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.text = link;
    if ([link rangeOfString:@"@"].length > 0) {
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    } else {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    return cell;
  }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    return [WrappableCell height:preamble accessoryType:UITableViewCellAccessoryNone];
  } else if (indexPath.section == 1) {
    return [WrappableCell height:[questions objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
  } else if (indexPath.section == 2) {
    return [WrappableCell height:[otherResources objectAtIndex:indexPath.row] accessoryType:UITableViewCellAccessoryNone];
  } else {
    return tableView.rowHeight;
  }
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
  } else if (indexPath.section == 1) {
    NSString* question = [questions objectAtIndex:indexPath.row];
    NSString* answer = [self.model answerForQuestion:question withSectionTitle:sectionTitle];
    AnswerViewController* controller = [[[AnswerViewController alloc] initWithSectionTitle:sectionTitle
                                                                                  question:question
                                                                                    answer:answer] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  } else if (indexPath.section == 2) {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
  } else {
    NSString* link = [links objectAtIndex:indexPath.row];
    if ([link rangeOfString:@"@"].length > 0) {
      link = [NSString stringWithFormat:@"mailto:%@", link];

      NSURL* url = [NSURL URLWithString:link];
      [[UIApplication sharedApplication] openURL:url];
    } else {
      [(id)self.navigationController pushBrowser:link animated:YES];
    }
  }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section == 0 && preamble.length > 0) {
    return NSLocalizedString(@"Information", nil);
  } else if (section == 1) {
    if (preamble.length > 0 || otherResources.count > 0 || links.count > 0) {
      return NSLocalizedString(@"Questions", nil);
    }
  } else if (section == 2 && otherResources.count > 0) {
    return NSLocalizedString(@"Other Resources", nil);
  } else if (section == 3 && links.count > 0) {
    return NSLocalizedString(@"Useful Links", nil);
  }

  return nil;
}


@end
