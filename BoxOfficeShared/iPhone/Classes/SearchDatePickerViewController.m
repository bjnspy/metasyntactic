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
  self.selector = nil;

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

  if ([DateUtilities isSameDay:date date:[Model model].searchDate]) {
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
