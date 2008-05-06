//
//  TextFieldEditorViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextFieldEditorViewController.h"


@implementation TextFieldEditorViewController

@synthesize textField;

- (void)dealloc
{
    self.textField = nil;
	[super dealloc];
}

- (id) initWithController:(UINavigationController*) controller
               withObject:(id) object_
             withSelector:(SEL) selector_
                 withText:(NSString*) text
{
    if (self = [super initWithController:controller withObject:object_ withSelector:selector_])
    {
        CGRect rect = CGRectMake(20, 72, 280, 42);
        self.textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
        self.textField.text = text;
        self.textField.borderStyle = UITextFieldBorderStyleBezel;
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.font = [UIFont boldSystemFontOfSize:16];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.textField];
    
    [self.textField becomeFirstResponder];
}

- (void) save:(id) sender
{
    [self.object performSelector:selector withObject:self.textField.text];
    [super save:sender];
}

@end
