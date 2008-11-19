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