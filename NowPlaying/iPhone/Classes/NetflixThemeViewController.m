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

#import "NetflixThemeViewController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "Model.h"

@interface NetflixThemeViewController()
@end


@implementation NetflixThemeViewController

- (void) dealloc {
    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped navigationController:navigationController_]) {
        self.title = NSLocalizedString(@"Theme", nil);
    }

    return self;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView
  numberOfRowsInSection:(NSInteger) section {
    return self.model.netflixThemes.count;
}


- (void) setCheckmarkForCell:(UITableViewCell*) cell
                       atRow:(NSInteger) row {
    cell.accessoryType = UITableViewCellAccessoryNone;

    if ([self.model.netflixTheme isEqual:[self.model.netflixThemes objectAtIndex:row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }

    cell.text = [self.model.netflixThemes objectAtIndex:indexPath.row];
    [self setCheckmarkForCell:cell atRow:indexPath.row];

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) selectPath {
    [self.tableView deselectRowAtIndexPath:selectPath animated:YES];

    [self.model setNetflixTheme:[self.model.netflixThemes objectAtIndex:selectPath.row]];

    for (int i = 0; i < self.model.netflixThemes.count; i++) {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];

        [self setCheckmarkForCell:cell atRow:i];
    }

    [AppDelegate majorRefresh:YES];
}

@end