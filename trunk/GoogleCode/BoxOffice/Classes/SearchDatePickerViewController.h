//
//  SearchDatePickerViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerEditorViewController.h"
#import "BoxOfficeController.h"

@interface SearchDatePickerViewController : PickerEditorViewController {
    BoxOfficeController* controller;
}

@property (retain) BoxOfficeController* controller;

+ (SearchDatePickerViewController*) pickerWithNavigationController:(UINavigationController*) navigationController
                                                        controller:(BoxOfficeController*) controller;

@end
