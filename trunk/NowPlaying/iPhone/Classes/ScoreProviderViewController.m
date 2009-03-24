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

#import "ScoreProviderViewController.h"

#import "AbstractNavigationController.h"
#import "ApplicationTabBarController.h"
#import "Controller.h"
#import "Model.h"

@interface ScoreProviderViewController()
@end


@implementation ScoreProviderViewController

- (void) dealloc {
    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped navigationController:navigationController_]) {
        self.title = NSLocalizedString(@"Reviews", nil);
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (Controller*) controller {
    return [Controller controller];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    return self.model.scoreProvider.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    // Configure the cell
    if (indexPath.row == self.model.scoreProviderIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.text = [self.model.scoreProvider objectAtIndex:indexPath.row];
    return cell;
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) selectPath {
    [self.tableView deselectRowAtIndexPath:selectPath animated:YES];

    for (int i = 0; i < self.model.scoreProvider.count; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];

        if ([cellPath isEqual:selectPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    [self.controller setScoreProviderIndex:selectPath.row];
    [navigationController popViewControllerAnimated:YES];
}

@end