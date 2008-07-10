//
//  TextFieldEditorViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/6/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "TextFieldEditorViewController.h"


@implementation TextFieldEditorViewController

@synthesize textField;

- (void) dealloc {
    self.textField = nil;
    [super dealloc];
}

- (id) initWithController:(UINavigationController*) controller
                withTitle:(NSString*) title
               withObject:(id) object_
             withSelector:(SEL) selector_
                 withText:(NSString*) text
                 withType:(UIKeyboardType) type {
    if (self = [super initWithController:controller withObject:object_ withSelector:selector_]) {
        CGRect rect = CGRectMake(20, 72, 280, 30);
        self.textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
        self.textField.text = text;
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.font = [UIFont boldSystemFontOfSize:17];
        self.textField.keyboardType = type;     
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.title = title;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.textField];
    
    [self.textField becomeFirstResponder];
}

- (void) save:(id) sender {
    NSString* trimmedValue = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.object performSelector:selector withObject:trimmedValue];
    [super save:sender];
}

@end
