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

#import "SearchDistancePickerViewController.h"

#import "Application.h"
#import "Controller.h"
#import "Model.h"

@interface SearchDistancePickerViewController()
@property (retain) NSArray* values;
@end


@implementation SearchDistancePickerViewController

@synthesize values;

- (void) dealloc {
    self.values = nil;
    [super dealloc];
}


- (id) init {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.title = LocalizedString(@"Search Distance", nil);
        self.values = [NSArray arrayWithObjects:
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                       @"10", @"15", @"20", @"25", @"30",
                       @"35", @"40", @"45", @"50", nil];
    }

    return self;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    NSString* value = [NSString stringWithFormat:@"%d", [Model model].searchRadius];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[values indexOfObject:value]
                                                inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return values.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

    NSString* value = [values objectAtIndex:indexPath.row];
    NSString* defaultValue = [NSString stringWithFormat:@"%d", [Model model].searchRadius];

    if (indexPath.row == 0) {
        cell.textLabel.text = ([Application useKilometers] ? LocalizedString(@"1 kilometer", nil) : LocalizedString(@"1 mile", nil));
    } else {
        cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"%@ %@", nil),
                     value,
                     ([Application useKilometers] ? LocalizedString(@"kilometers", nil) : LocalizedString(@"miles", nil))];
    }

    if ([value isEqual:defaultValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    for (UITableViewCell* cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    NSString* radius = [values objectAtIndex:indexPath.row];
    [[Controller controller] setSearchRadius:radius.integerValue];

    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    return LocalizedString(@"Theater providers often limit the maximum search distance they will provide data for. As a result, some theaters may not show up for you even if your search distance is set high.", nil);
}

@end
