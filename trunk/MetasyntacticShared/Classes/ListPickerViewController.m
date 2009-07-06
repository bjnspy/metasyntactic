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
