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

#import "PickerEditorViewController.h"

@interface PickerEditorViewController()
@property (retain) UIPickerView* picker_;
@property (retain) NSArray* values_;
@property (retain) UILabel* label_;
@end


@implementation PickerEditorViewController

@synthesize picker_;
@synthesize values_;
@synthesize label_;

property_wrapper(UIPickerView*, picker, Picker);
property_wrapper(NSArray*, values, Values);
property_wrapper(UILabel*, label, Label);

- (void) dealloc {
    self.picker = nil;
    self.values = nil;
    self.label = nil;

    [super dealloc];
}


- (void) majorRefresh {
    self.label.hidden = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);

    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = self.picker.frame.size;

    CGRect labelRect = CGRectMake(10, 10, screenRect.size.width - 20, screenRect.size.height - 20 - pickerSize.height);
    self.label.frame = labelRect;
    [self.label sizeToFit];
    labelRect = self.label.frame;
    labelRect.origin.x = floor((self.view.bounds.size.width - labelRect.size.width) / 2);
    self.label.frame = labelRect;
}


- (id) initWithController:(AbstractNavigationController*) controller_
                    title:(NSString*) title_
                     text:(NSString*) text_
                   object:(id) object_
                 selector:(SEL) selector_
                   values:(NSArray*) values__
             defaultValue:(NSString*) defaultValue {
    if (self = [super initWithController:controller_ withObject:object_ withSelector:selector_]) {
        self.values = values__;

        self.picker = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
        self.picker.delegate = self;
        self.picker.showsSelectionIndicator = YES;
        [self.picker selectRow:[self.values indexOfObject:defaultValue]
              inComponent:0
                 animated:NO];
        self.picker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

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

    [self majorRefresh];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];

    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
    CGFloat screenBottom = screenRect.origin.y + screenRect.size.height;

    CGRect pickerRect = CGRectMake(0, screenBottom - pickerSize.height, pickerSize.width, pickerSize.height);
    self.picker.frame = pickerRect;
}


- (void) save:(id) sender {
    [self.object performSelector:self.selector
                 withObject:[self.values objectAtIndex:[self.picker selectedRowInComponent:0]]];
    [super save:sender];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*) pickerView {
    return 1;
}


- (NSInteger)      pickerView:(UIPickerView*) pickerView
      numberOfRowsInComponent:(NSInteger) component {
    return self.values.count;
}


- (NSString*) pickerView:(UIPickerView*) pickerView
             titleForRow:(NSInteger) row
            forComponent:(NSInteger) component {
    return [self.values objectAtIndex:row];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end