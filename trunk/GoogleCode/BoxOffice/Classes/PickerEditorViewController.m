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


- (id) initWithController:(UINavigationController*) controller_
                    title:(NSString*) title_
                     text:(NSString*) text_
                   object:(id) object_
                 selector:(SEL) selector_
                   values:(NSArray*) values_
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
}


- (void) viewWillAppear:(BOOL) animated {
    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
    CGFloat screenBottom = screenRect.origin.y + screenRect.size.height;

    CGRect pickerRect = CGRectMake(0, screenBottom - pickerSize.height, pickerSize.width, pickerSize.height);
    self.picker.frame = pickerRect;

    CGRect labelRect = CGRectMake(10, 10, screenRect.size.width - 20, screenRect.size.height - 20 - pickerSize.height);
    self.label.frame = labelRect;
    [self.label sizeToFit];
    labelRect = self.label.frame;
    labelRect.origin.x = floor((320 - labelRect.size.width) / 2);
    self.label.frame = labelRect;
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
