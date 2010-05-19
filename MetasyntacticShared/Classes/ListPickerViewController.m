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

#import "ListPickerViewController.h"

#import "ListPickerDelegate.h"

@interface ListPickerViewController()
@property (retain) NSArray*items;
@end

@implementation ListPickerViewController

@synthesize items;
@synthesize delegate;

- (void) dealloc {
  self.items = nil;
  self.delegate = nil;
  [super dealloc];
}


- (id) initWithTitle:(NSString*) title items:(NSArray*) items_ {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = title;
    self.items = items_;
  }
  return self;
}


+ (ListPickerViewController*) controllerWithTitle:(NSString*) title items:(NSArray*) items {
  return [[[ListPickerViewController alloc] initWithTitle:title items:items] autorelease];
}


- (void) loadView {
  [super loadView];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)] autorelease];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 1;
}


- (NSInteger)       tableView:(UITableView*) table
        numberOfRowsInSection:(NSInteger) section {
  return items.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }

  cell.textLabel.text = [[items objectAtIndex:indexPath.row] description];
  return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryCheckmark;
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  id value = [[[items objectAtIndex:indexPath.row] retain] autorelease];
  [self.navigationController popViewControllerAnimated:YES];
  [delegate onListPickerSave:value];
}


- (void) onCancel {
  [self.navigationController popViewControllerAnimated:YES];
  [delegate onListPickerCancel];
}


@end
