//
//  PickerEditorViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorViewController.h"

@interface PickerEditorViewController : EditorViewController<UIPickerViewDelegate> {
    UIPickerView* picker;
    NSArray* values;
}

@property (retain) UIPickerView* picker;
@property (retain) NSArray* values;

- (id) initWithController:(UINavigationController*) navigationController
               withObject:(id) object
             withSelector:(SEL) selector
               withValues:(NSArray*) values
             defaultValue:(NSString*) defaultValue;

@end
