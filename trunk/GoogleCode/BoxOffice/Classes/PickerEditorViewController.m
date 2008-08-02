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

#import "PickerEditorViewController.h"


@implementation PickerEditorViewController

@synthesize picker;
@synthesize values;

- (void) dealloc {
    self.picker = nil;
    self.values = nil;
    [super dealloc];
}

- (id) initWithController:(UINavigationController*) controller_
                withTitle:(NSString*) title_
               withObject:(id) object_
             withSelector:(SEL) selector_
               withValues:(NSArray*) values_
             defaultValue:(NSString*) defaultValue {
    if (self = [super initWithController:controller_ withObject:object_ withSelector:selector_]) {
        self.values = values_;

        self.picker = [[[UIPickerView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        self.picker.delegate = self;
        self.picker.showsSelectionIndicator = YES;
        [self.picker selectRow:[values indexOfObject:defaultValue]
                   inComponent:0
                      animated:NO];

        self.title = title_;
    }

    return self;
}

- (void) loadView {
    [super loadView];

    [self.view addSubview:self.picker];

    [self.picker becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL) animated {
    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
    CGFloat screenBottom = screenRect.origin.y + screenRect.size.height;

    CGRect pickerRect = CGRectMake(0, screenBottom - pickerSize.height, pickerSize.width, pickerSize.height);
    self.picker.frame = pickerRect;
}

- (void) save:(id) sender {
    [self.object performSelector:selector
                      withObject:[self.values objectAtIndex:[self.picker selectedRowInComponent:0]]];
    [super save:sender];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*) pickerView {
    return 1;
}

- (NSInteger)      pickerView:(UIPickerView*) pickerView
      numberOfRowsInComponent:(NSInteger) component {
    return values.count;
}

- (NSString*) pickerView:(UIPickerView*) pickerView
             titleForRow:(NSInteger) row
            forComponent:(NSInteger) component {
    return [self.values objectAtIndex:row];
}

@end
