// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "SearchDatePickerViewController.h"

#import "AbstractNavigationController.h"
#import "DateUtilities.h"
#import "NowPlayingModel.h"

@implementation SearchDatePickerViewController


- (void) dealloc {
    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                         withValues:(NSArray*) values_
                       defaultValue:(NSString*) defaultValue_ 
                             object:(id) object_ 
                           selector:(SEL) selector_ {
    if (self = [super initWithController:navigationController_
                                   title:NSLocalizedString(@"Search Date", @"This is noun, not a verb. It is the date we are getting movie listings for.")
                                    text:NSLocalizedString(@"Data for future dates may be incomplete. Reset the search date to the current date to see full listings.", nil)
                                  object:object_
                                selector:selector_
                                  values:values_
                            defaultValue:defaultValue_]) {
    }

    return self;
}


+ (SearchDatePickerViewController*) pickerWithNavigationController:(AbstractNavigationController*) navigationController 
                                                            object:(id) object 
                                                          selector:(SEL) selector {
    NSMutableArray* values = [NSMutableArray array];
    NSDate* today = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    for (int i = 0; i < 7; i++) {
        NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
        [components setDay:i];
        NSDate* date = [calendar dateByAddingComponents:components toDate:today options:0];

        [values addObject:[DateUtilities formatFullDate:date]];
    }
    NSString* defaultValue = [DateUtilities formatFullDate:navigationController.model.searchDate];

    return [[[SearchDatePickerViewController alloc] initWithNavigationController:navigationController
                                                                      withValues:values
                                                                    defaultValue:defaultValue
                                                                          object:object
                                                                        selector:selector] autorelease];
}

@end