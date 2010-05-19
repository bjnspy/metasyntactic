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

#import "SectionViewController.h"

#import "ACLUInfoViewController.h"
#import "ACLUNewsViewController.h"
#import "Application.h"
#import "ArticlesOfConfederation.h"
#import "Constitution.h"
#import "ConstitutionViewController.h"
#import "CreditsViewController.h"
#import "DeclarationOfIndependenceViewController.h"
#import "FederalistPapers.h"
#import "FederalistPapersViewController.h"
#import "GreatestHitsViewController.h"
#import "Model.h"
#import "QuestionsViewController.h"
#import "ToughQuestionsViewController.h"
#import "UnitedStatesConstitution.h"
#import "WrappableCell.h"
#import "YourRightsNavigationController.h"

@interface SectionViewController()
@end


@implementation SectionViewController


- (void) dealloc {
  [super dealloc];
}


- (Model*) model {
  return [Model model];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.title = [Application name];

    self.navigationItem.leftBarButtonItem =
      [self createInfoButton:@selector(onInfoTapped)];
  }

  return self;
}


- (void) onInfoTapped {
  CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];

  UINavigationController* navigationController = [[[AbstractNavigationController alloc] initWithRootViewController:controller] autorelease];
  navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentModalViewController:navigationController animated:YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 4;
  } else if (section == 1) {
    return 4;
  } else {
    return [[self.model sectionTitles] count];
  }
}


- (NSString*) titleForIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return NSLocalizedString(@"United States Constitution", nil);
    } else if (indexPath.row == 1) {
      return NSLocalizedString(@"Declaration of Independence", nil);
    } else if (indexPath.row == 2) {
      return NSLocalizedString(@"Articles of Confederation", nil);
    } else {
      return NSLocalizedString(@"Federalist Papers", nil);
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      return NSLocalizedString(@"ACLU News", nil);
    } else if (indexPath.row == 1) {
      return NSLocalizedString(@"Tough Questions about ACLU positions", nil);
    } else if (indexPath.row == 2) {
      return NSLocalizedString(@"The ACLU Is / Is Not", nil);
    } else {
      return NSLocalizedString(@"ACLU 100 Greatest Hits", nil);
    }
  } else {
    return [[self.model sectionTitles] objectAtIndex:indexPath.row];
  }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  NSString* text = [self titleForIndexPath:indexPath];

  if (indexPath.section == 0) {
    UITableViewCell *cell = [[[AutoResizingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.textLabel.text = text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
  } else if (indexPath.section == 1) {
    UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
  } else {
    text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, text];

    UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
  }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
  NSString* text = [self titleForIndexPath:indexPath];

  if (indexPath.section == 0) {
    return tableView.rowHeight;
  } else if (indexPath.section == 1) {
    return [WrappableCell height:text accessoryType:UITableViewCellAccessoryDisclosureIndicator];
  } else {
    text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, text];
    return [WrappableCell height:text accessoryType:UITableViewCellAccessoryDisclosureIndicator];
  }
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if (indexPath.section == 0) {
    NSString* title = [self titleForIndexPath:indexPath];
    if (indexPath.row == 0) {
      Constitution* constitution = [UnitedStatesConstitution unitedStatesConstitution];
      ConstitutionViewController* controller = [[[ConstitutionViewController alloc] initWithConstitution:constitution
                                                                                                   title:title] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 1) {
      DeclarationOfIndependenceViewController* controller = [[[DeclarationOfIndependenceViewController alloc] initWithDeclaration:self.model.declarationOfIndependence] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 2) {
      Constitution* constitution = [ArticlesOfConfederation articlesOfConfederation];
      ConstitutionViewController* controller = [[[ConstitutionViewController alloc] initWithConstitution:constitution
                                                                                                   title:title] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    } else {
      Constitution* constitution = [FederalistPapers federalistPapers];
      FederalistPapersViewController* controller = [[[FederalistPapersViewController alloc] initWithConstitution:constitution] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      ACLUNewsViewController* controller = [[[ACLUNewsViewController alloc] init] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 1) {
      ToughQuestionsViewController* controller = [[[ToughQuestionsViewController alloc] init] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 2) {
      ACLUInfoViewController* controller = [[[ACLUInfoViewController alloc] init] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 3) {
      GreatestHitsViewController* controller = [[[GreatestHitsViewController alloc] init] autorelease];
      [self.navigationController pushViewController:controller animated:YES];
    }
  } else {
    NSString* text = [[self.model sectionTitles] objectAtIndex:indexPath.row];
    QuestionsViewController* controller = [[[QuestionsViewController alloc] initWithSectionTitle:text] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
  }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section == 0) {
    return NSLocalizedString(@"Documents", nil);
  } else if (section == 1) {
    return NSLocalizedString(@"ACLU Information", nil);
  } else {
    return NSLocalizedString(@"Encountering Law Enforcement", nil);
  }

  return nil;
}

@end
