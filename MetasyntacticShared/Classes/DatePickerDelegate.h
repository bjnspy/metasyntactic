//
//  DatePickerDelegate.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol DatePickerDelegate
- (void) onDatePickerCancel:(UIDatePicker*) datePicker;
- (void) onDatePickerSave:(UIDatePicker*) datePicker;
@end
