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

#import "DatePickerViewController.h"

#import "DatePickerDelegate.h"

@interface DatePickerViewController()
@property (retain) UIDatePicker* datePicker;
@end


@implementation DatePickerViewController

@synthesize datePicker;
@synthesize delegate;

- (void) dealloc {
  self.datePicker = nil;
  self.delegate = nil;
  [super dealloc];
}


- (id) initWithTitle:(NSString*) title_ mode:(UIDatePickerMode) mode_ {
  if ((self = [super init])) {
    self.title = title_;
    mode = mode_;
  }
  return self;
}


+ (DatePickerViewController*) controllerWithTitle:(NSString*) title mode:(UIDatePickerMode) mode {
  return [[[DatePickerViewController alloc] initWithTitle:title mode:mode] autorelease];
}


- (void) loadView {
  [super loadView];

  self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

  self.datePicker = [[[UIDatePicker alloc] init] autorelease];
  datePicker.datePickerMode = mode;
  [datePicker sizeToFit];

  CGRect frame = datePicker.frame;
  frame.origin.y = self.view.frame.size.height;
  datePicker.frame = frame;

  [self.view addSubview:datePicker];
}


- (void) onBeforeViewControllerPushed {
  [super onBeforeViewControllerPushed];

  [UIView beginAnimations:nil context:NULL];
  {
    CGRect frame = datePicker.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    datePicker.frame = frame;
  }
  [UIView commitAnimations];

  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel)] autorelease];
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onSave)] autorelease];
}


- (void) onCancel {
  [[datePicker retain] autorelease];
  [self.navigationController popViewControllerAnimated:YES];
  [delegate onDatePickerCancel:datePicker];
}


- (void) onSave {
  [[datePicker retain] autorelease];
  [self.navigationController popViewControllerAnimated:YES];
  [delegate onDatePickerSave:datePicker];
}

@end
