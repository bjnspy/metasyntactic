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

#import "TextFieldEditorViewController.h"

@interface TextFieldEditorViewController()
@property (retain) UITextField* textField_;
@property (retain) UILabel* messageLabel_;
@end

@implementation TextFieldEditorViewController

@synthesize textField_;
@synthesize messageLabel_;

property_wrapper(UITextField*, textField, TextField);
property_wrapper(UILabel*, messageLabel, MessageLabel);

- (void) dealloc {
    self.textField = nil;
    self.messageLabel = nil;

    [super dealloc];
}


- (id) initWithController:(AbstractNavigationController*) controller
                    title:(NSString*) title
                   object:(id) object_
                 selector:(SEL) selector_
                     text:(NSString*) text
                  message:(NSString*) message
              placeHolder:(NSString*) placeHolder
                     type:(UIKeyboardType) type {
    if (self = [super initWithController:controller withObject:object_ withSelector:selector_]) {
        self.textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        self.textField.text = text;
        self.textField.placeholder = placeHolder;
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.font = [UIFont boldSystemFontOfSize:17];
        self.textField.keyboardType = type;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.delegate = self;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;

        self.messageLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.text = message;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textColor = [UIColor grayColor];
        [self.messageLabel sizeToFit];

        self.title = title;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    [self.view addSubview:self.textField];
    self.textField.frame = CGRectMake(20, 50, self.view.frame.size.width - 40, 30);

    [self.view addSubview:self.messageLabel];
    CGRect frame = self.messageLabel.frame;
    frame.origin.x = self.textField.frame.origin.x;
    frame.origin.y = self.textField.frame.origin.y + 40;
    self.messageLabel.frame = frame;

    [self.textField becomeFirstResponder];
}


- (void) save:(id) sender {
    NSString* trimmedValue = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.object performSelector:self.selector withObject:trimmedValue];
    [super save:sender];
}


- (BOOL) textFieldShouldClear:(UITextField*) textField {
    self.messageLabel.text = @"";
    return YES;
}

@end