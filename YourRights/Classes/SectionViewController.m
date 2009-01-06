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

#import "GreatestHitsViewController.h"
#import "Model.h"
#import "QuestionsViewController.h"
#import "ToughQuestionsViewController.h"
#import "WrappableCell.h"
#import "ViewControllerUtilities.h"

@interface SectionViewController()
@end


@implementation SectionViewController

- (void)dealloc {
    [super dealloc];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationItem.titleView =
        [ViewControllerUtilities viewControllerTitleLabel:NSLocalizedString(@"Know Your Rights", nil)];
    }
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) majorRefresh {
    [self.tableView reloadData];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}


- (void) viewWillAppear:(BOOL) animated {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self majorRefresh];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[Model sectionTitles] count];
    } else {
        return 3;
    }
}


- (NSString*) titleForIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [[Model sectionTitles] objectAtIndex:indexPath.row];
    } else {
        if (indexPath.row == 0) {
            return NSLocalizedString(@"Tough Questions about ACLU positions", nil);
        } else if (indexPath.row == 1) {
            return NSLocalizedString(@"The ACLU Is / Isn't", nil);
        } else {
            return NSLocalizedString(@"ACLU 100 Greatest Hits", nil);
        } 
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* text = [self titleForIndexPath:indexPath];
    if (indexPath.section == 0) {
        text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, text];
        
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        UITableViewCell *cell = [[[WrappableCell alloc] initWithTitle:text] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* text = [self titleForIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, text];
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        return [WrappableCell height:text accessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        NSString* text = [[Model sectionTitles] objectAtIndex:indexPath.row];
        QuestionsViewController* controller = [[[QuestionsViewController alloc] initWithSectionTitle:text] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        if (indexPath.row == 0) {
            ToughQuestionsViewController* controller = [[[ToughQuestionsViewController alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 2) {
            GreatestHitsViewController* controller = [[[GreatestHitsViewController alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Encountering Law Enforment", nil);
    } else {
        return NSLocalizedString(@"ACLU Information", nil);
    }

    return nil;
}



@end