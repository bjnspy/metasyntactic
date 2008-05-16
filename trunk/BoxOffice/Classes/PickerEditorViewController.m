//
//  PickerEditorViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/6/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "PickerEditorViewController.h"


@implementation PickerEditorViewController

@synthesize picker;
@synthesize values;

- (void)dealloc
{
    self.picker = nil;
    self.values = nil;
    [super dealloc];
}

- (id) initWithController:(UINavigationController*) controller
                withTitle:(NSString*) title
               withObject:(id) object_
             withSelector:(SEL) selector_
               withValues:(NSArray*) values_
             defaultValue:(NSString*) defaultValue
{
    if (self = [super initWithController:controller withObject:object_ withSelector:selector_])
    {
        self.values = values_;
        
        self.picker = [[[UIPickerView alloc] initWithFrame:CGRectZero] autorelease];
        self.picker.delegate = self;
        self.picker.showsSelectionIndicator = YES;
        [self.picker selectRow:[values indexOfObject:defaultValue]
         inComponent:0
         animated:NO];
        
        self.title = title;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.picker];
    
    [self.picker becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL) animated
{
    CGRect screenRect = self.view.bounds;
    CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
    CGFloat screenBottom = screenRect.origin.y + screenRect.size.height;
    
    CGRect pickerRect = CGRectMake(0, screenBottom - pickerSize.height, pickerSize.width, pickerSize.height);
    self.picker.frame = pickerRect;
}

- (void) save:(id) sender
{
    [self.object performSelector:selector
     withObject:[self.values objectAtIndex:[self.picker selectedRowInComponent:0]]];
    [super save:sender];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*) pickerView
{
    return 1;
}

- (NSInteger)           pickerView:(UIPickerView*) pickerView
           numberOfRowsInComponent:(NSInteger) component
{
    return [self.values count];
}

- (NSString*)     pickerView:(UIPickerView*) pickerView
                 titleForRow:(NSInteger) row
                forComponent:(NSInteger) component
{
    
    return [self.values objectAtIndex:row];
}

@end
