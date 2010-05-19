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

#import "TextFieldEditorViewController.h"

@interface TextFieldEditorViewController()
@property (retain) UITextField* textField;
@property (retain) UILabel* messageLabel;
@end

@implementation TextFieldEditorViewController

@synthesize textField;
@synthesize messageLabel;

- (void) dealloc {
  self.textField = nil;
  self.messageLabel = nil;

  [super dealloc];
}


- (id) initWithTitle:(NSString*) title
              object:(id) object_
            selector:(SEL) selector_
                text:(NSString*) text
             message:(NSString*) message
         placeHolder:(NSString*) placeHolder
                type:(UIKeyboardType) type {
  if ((self = [super initWithObject:object_ selector:selector_])) {
    self.textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    textField.text = text;
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = [UIFont boldSystemFontOfSize:17];
    textField.keyboardType = type;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;

    self.messageLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = [UIColor grayColor];
    [messageLabel sizeToFit];

    self.title = title;
  }

  return self;
}


- (void) loadView {
  [super loadView];

  [self.view addSubview:textField];
  textField.frame = CGRectMake(20, 50, self.view.frame.size.width - 40, 30);

  [self.view addSubview:messageLabel];
  CGRect frame = messageLabel.frame;
  frame.origin.x = textField.frame.origin.x;
  frame.origin.y = textField.frame.origin.y + 40;
  messageLabel.frame = frame;

  [textField becomeFirstResponder];
}


- (void) save:(id) sender {
  NSString* trimmedValue = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  [object performSelector:selector withObject:trimmedValue];
  [super save:sender];
}


- (BOOL) textFieldShouldClear:(UITextField*) textField {
  messageLabel.text = @"";
  return YES;
}

@end
