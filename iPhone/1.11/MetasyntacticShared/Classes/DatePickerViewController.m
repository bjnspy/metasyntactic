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
