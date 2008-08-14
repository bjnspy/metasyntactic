// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice, 
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without 
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

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
