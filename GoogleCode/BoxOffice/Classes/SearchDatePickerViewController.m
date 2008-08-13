// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "SearchDatePickerViewController.h"

#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"
#import "DateUtilities.h"

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
                                   title:NSLocalizedString(@"Search Date", nil)
                                    text:NSLocalizedString(@"Data for future dates may be incomplete. Reset the search date to the current date to see full listings.", nil)
                                  object:self
                                selector:@selector(onSearchDateChanged:)
                                  values:values_
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
