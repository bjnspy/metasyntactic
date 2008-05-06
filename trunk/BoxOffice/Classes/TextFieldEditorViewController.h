//
//  TextFieldEditorViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditorViewController.h"

@interface TextFieldEditorViewController : EditorViewController {
    UITextField* textField;
}

@property (retain) UITextField* textField;

- (id) initWithController:(UINavigationController*) navigationController
               withObject:(id) object
             withSelector:(SEL) selector
                 withText:(NSString*) text
                 withType:(UIKeyboardType) type;

@end
