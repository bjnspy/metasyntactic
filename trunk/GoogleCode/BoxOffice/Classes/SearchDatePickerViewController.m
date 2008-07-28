//
//  SearchDatePickerViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchDatePickerViewController.h"
#import "DateUtilities.h"
#import "Application.h"

@implementation SearchDatePickerViewController

@synthesize controller;

- (void) dealloc {
    self.controller = nil;

    [super dealloc];
}

- (id) initWithNavigationController:(UINavigationController*) navigationController_
                         controller:(BoxOfficeController*) controller_
                         withValues:(NSArray*) values_
                       defaultValue:(NSString*) defaultValue_ {
    if (self = [super initWithController:navigationController_
                               withTitle:NSLocalizedString(@"Search date", nil)
                              withObject:self
                            withSelector:@selector(onSearchDateChanged:)
                              withValues:values_
                            defaultValue:defaultValue_]) {
        self.controller = controller_;
    }

    return self;
}

+ (SearchDatePickerViewController*) pickerWithNavigationController:(UINavigationController*) navigationController
                                                        controller:(BoxOfficeController*) controller {
    NSMutableArray* values = [NSMutableArray array];
    NSDate* today = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    for (int i = 0; i < 7; i++) {
        NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
        [components setDay:i];
        NSDate* date = [calendar dateByAddingComponents:components toDate:today options:0];

        [values addObject:[DateUtilities formatFullDate:date]];
    }
    NSString* defaultValue = [DateUtilities formatFullDate:[[controller model] searchDate]];

    return [[[SearchDatePickerViewController alloc] initWithNavigationController:navigationController
                                                                      controller:controller
                                                                      withValues:values
                                                                    defaultValue:defaultValue] autorelease];
}

- (void) onSearchDateChanged:(NSString*) dateString {
    [self.controller setSearchDate:[DateUtilities dateWithNaturalLanguageString:dateString]];
}

@end