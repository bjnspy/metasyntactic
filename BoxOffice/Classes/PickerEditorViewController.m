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
@synthesize label;

- (void) dealloc {
    self.picker = nil;
    self.values = nil;
    self.label = nil;

    [super dealloc];
}


- (void) refresh {
    label.hidden = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);

    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = self.picker.frame.size;

    CGRect labelRect = CGRectMake(10, 10, screenRect.size.width - 20, screenRect.size.height - 20 - pickerSize.height);
    self.label.frame = labelRect;
    [self.label sizeToFit];
    labelRect = self.label.frame;
    labelRect.origin.x = floor((self.view.bounds.size.width - labelRect.size.width) / 2);
    self.label.frame = labelRect;
}


- (id) initWithController:(UINavigationController*) controller_
                    title:(NSString*) title_
                     text:(NSString*) text_
                   object:(id) object_
                 selector:(SEL) selector_
                   values:(NSArray*) values_
             defaultValue:(NSString*) defaultValue {
    if (self = [super initWithController:controller_ withObject:object_ withSelector:selector_]) {
        self.values = values_;

        self.picker = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
        self.picker.delegate = self;
        self.picker.showsSelectionIndicator = YES;
        [self.picker selectRow:[values indexOfObject:defaultValue]
         inComponent:0
         animated:NO];
        picker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

        self.title = title_;

        if (text_ != nil) {
            self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            self.label.text = text_;
            self.label.font = [UIFont systemFontOfSize:15];
            self.label.textAlignment = UITextAlignmentCenter;
            self.label.textColor = [UIColor darkGrayColor];
            self.label.backgroundColor = [UIColor clearColor];
            self.label.numberOfLines = 0;
        }
    }

    return self;
}


- (void) loadView {
    [super loadView];

    [self.view addSubview:self.picker];
    [self.view addSubview:self.label];

    [self.picker becomeFirstResponder];

    [self refresh];
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


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self refresh];
}


@end
