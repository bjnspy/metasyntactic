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

#import "SearchDatePickerViewController.h"

#import "Model.h"

@interface SearchDatePickerViewController()
@property (retain) id object;
@property SEL selector;
@end

@implementation SearchDatePickerViewController

@synthesize object;
@synthesize selector;

- (void) dealloc {
    self.object = nil;

    [super dealloc];
}


- (id) initWithObject:(id) object_
             selector:(SEL) selector_ {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.object = object_;
        self.selector = selector_;
        self.title = LocalizedString(@"Search Date", @"This is noun, not a verb. It is the date we are getting movie listings for.");
    }

    return self;
}


+ (SearchDatePickerViewController*) pickerWithObject:(id) object selector:(SEL) selector {
    return [[[SearchDatePickerViewController alloc] initWithObject:object selector:selector] autorelease];
}


- (Model*) model {
    return [Model model];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return 7;
}


- (NSDate*) dateForRow:(NSInteger) row {
    NSDate* today = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
    [components setDay:row];
    NSDate* date = [calendar dateByAddingComponents:components toDate:today options:0];

    return date;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

    NSDate* date = [self dateForRow:indexPath.row];

    if ([DateUtilities isToday:date]) {
        cell.textLabel.text = LocalizedString(@"Today", nil);
    } else {
        cell.textLabel.text = [DateUtilities formatFullDate:date];
    }

    if ([DateUtilities isSameDay:date date:self.model.searchDate]) {
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

    [self.navigationController popViewControllerAnimated:YES];
    [object performSelector:selector withObject:[self dateForRow:indexPath.row]];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForFooterInSection:(NSInteger) section {
    return LocalizedString(@"Data for future dates may be incomplete. Reset the search date to the current date to see full listings.", nil);
}

@end
