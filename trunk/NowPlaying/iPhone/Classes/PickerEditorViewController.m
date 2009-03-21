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
@property (retain) UIPickerView* picker;
@property (retain) NSArray* values;
@property (retain) UILabel* label;
@end


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


- (void) majorRefresh {
    label.hidden = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);

    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = picker.frame.size;

    CGRect labelRect = CGRectMake(10, 10, screenRect.size.width - 20, screenRect.size.height - 20 - pickerSize.height);
    label.frame = labelRect;
    [label sizeToFit];
    labelRect = label.frame;
    labelRect.origin.x = floor((self.view.bounds.size.width - labelRect.size.width) / 2);
    label.frame = labelRect;
}


- (id) initWithController:(AbstractNavigationController*) controller_
                    title:(NSString*) title_
                     text:(NSString*) text_
                   object:(id) object_
                 selector:(SEL) selector_
                   values:(NSArray*) values_
             defaultValue:(NSString*) defaultValue {
    if (self = [super initWithController:controller_ withObject:object_ withSelector:selector_]) {
        self.values = values_;

        self.picker = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
        picker.delegate = self;
        picker.showsSelectionIndicator = YES;
        [picker selectRow:[values indexOfObject:defaultValue]
              inComponent:0
                 animated:NO];
        picker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

        self.title = title_;

        if (text_ != nil) {
            self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
            label.text = text_;
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = UITextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
        }
    }

    return self;
}


- (void) loadView {
    [super loadView];

    [self.view addSubview:picker];
    [self.view addSubview:label];

    [picker becomeFirstResponder];

    [self majorRefresh];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];

    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    CGFloat screenBottom = screenRect.origin.y + screenRect.size.height;

    CGRect pickerRect = CGRectMake(0, screenBottom - pickerSize.height, pickerSize.width, pickerSize.height);
    picker.frame = pickerRect;
}


- (void) save:(id) sender {
    [object performSelector:selector
                 withObject:[values objectAtIndex:[picker selectedRowInComponent:0]]];
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
    return [values objectAtIndex:row];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self majorRefresh];
}

@end