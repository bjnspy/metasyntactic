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
