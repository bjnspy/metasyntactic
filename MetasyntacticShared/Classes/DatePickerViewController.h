//
//  DatePickerViewController.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractFullScreenViewController.h"

@interface DatePickerViewController : AbstractFullScreenViewController {
@private
  UIDatePickerMode mode;
  UIDatePicker* datePicker;
  id<DatePickerDelegate> delegate;
}

@property (assign) id<DatePickerDelegate> delegate;

+ (DatePickerViewController*) controllerWithTitle:(NSString*) title mode:(UIDatePickerMode) mode;

@end
