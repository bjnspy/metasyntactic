// Copyright (C) 2008 Cyrus Najmabadi
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

@implementation TextFieldEditorViewController

@synthesize textField;

- (void) dealloc {
    self.textField = nil;
    [super dealloc];
}


- (id) initWithController:(UINavigationController*) controller
                    title:(NSString*) title
                   object:(id) object_
                 selector:(SEL) selector_
                     text:(NSString*) text
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

        self.title = title;
    }

    return self;
}


- (void) loadView {
    [super loadView];

    [self.view addSubview:self.textField];
    CGRect frame = CGRectMake(20, 50, self.view.frame.size.width - 40, 30);
    self.textField.frame = frame;

    [self.textField becomeFirstResponder];
}


- (void) save:(id) sender {
    NSString* trimmedValue = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.object performSelector:selector withObject:trimmedValue];
    [super save:sender];
}


@end