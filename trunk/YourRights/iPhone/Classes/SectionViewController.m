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

#import "SectionViewController.h"

#import "ACLUInfoViewController.h"
#import "ACLUNewsViewController.h"
#import "Application.h"
#import "AutoResizingCell.h"
#import "ArticlesOfConfederation.h"
#import "Constitution.h"
#import "ConstitutionViewController.h"
#import "CreditsViewController.h"
#import "DeclarationOfIndependenceViewController.h"
#import "FederalistPapers.h"
#import "GreatestHitsViewController.h"
#import "FederalistPapersViewController.h"
#import "Model.h"
#import "QuestionsViewController.h"
#import "ToughQuestionsViewController.h"
#import "UnitedStatesConstitution.h"
#import "WrappableCell.h"
#import "ViewControllerUtilities.h"
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
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = [Application name];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        CGRect frame = button.frame;
        frame.size.width += 10;
        button.frame = frame;

        [button addTarget:self action:@selector(onInfoTapped:) forControlEvents:UIControlEventTouchUpInside];

        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    }

    return self;
}


- (void) onInfoTapped:(id) sender {
    CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self reloadTableViewData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
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
        UITableViewCell *cell = [[[AutoResizingCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
        cell.text = text;
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