//
//  ListPickerViewController.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
