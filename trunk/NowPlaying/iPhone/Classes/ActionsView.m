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

#import "ActionsView.h"

#import "Model.h"

@interface ActionsView()
@property (assign) id target_;
@property (retain) NSArray* selectors_;
@property (retain) NSArray* titles_;
@property (retain) NSArray* buttons_;
@property (retain) NSArray* arguments_;
@property CGFloat height_;
@end


@implementation ActionsView

@synthesize target_;
@synthesize selectors_;
@synthesize titles_;
@synthesize buttons_;
@synthesize arguments_;
@synthesize height_;

property_wrapper(id, target, Target);
property_wrapper(NSArray*, selectors, Selectors);
property_wrapper(NSArray*, titles, Titles);
property_wrapper(NSArray*, buttons, Buttons);
property_wrapper(NSArray*, arguments, Arguments);
property_wrapper(CGFloat, height, Height);

- (void) dealloc {
    self.target = nil;
    self.selectors = nil;
    self.titles = nil;
    self.buttons = nil;
    self.arguments = nil;

    [super dealloc];
}


- (id) initWithTarget:(id) target__
            selectors:(NSArray*) selectors__
               titles:(NSArray*) titles__
            arguments:(NSArray*) arguments__ {
    if (self = [super initWithFrame:CGRectZero]) {
        self.target = target__;
        self.selectors = selectors__;
        self.titles = titles__;
        self.arguments = arguments__;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];

        NSMutableArray* array = [NSMutableArray array];
        for (NSString* title in self.titles) {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:title forState:UIControlStateNormal];
            [button sizeToFit];

            [button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

            [array addObject:button];
            [self addSubview:button];
        }

        self.buttons = array;

        {
            int lastRow = (self.buttons.count - 1) / 2;

            UIButton* button = [self.buttons lastObject];
            CGRect frame = button.frame;
            self.height = (8 + frame.size.height) * (lastRow + 1);
        }
    }

    return self;
}


+ (ActionsView*) viewWithTarget:(id) target
                      selectors:(NSArray*) selectors
                         titles:(NSArray*) titles
                      arguments:(NSArray*) arguments {
    return [[[ActionsView alloc] initWithTarget:(id) target
                                      selectors:selectors
                                         titles:titles
                                      arguments:arguments] autorelease];
}


- (void) onButtonTapped:(UIButton*) button {
    NSInteger index = [self.buttons indexOfObject:button];

    SEL selector = [[self.selectors objectAtIndex:index] pointerValue];
    if ([self.target respondsToSelector:selector]) {
        id argument = [self.arguments objectAtIndex:index];

        if (argument == [NSNull null]) {
            [self.target performSelector:selector];
        } else {
            [self.target performSelector:selector withObject:argument];
        }
    }
}


- (CGSize) sizeThatFits:(CGSize) size withModel:(Model*) model {
    if (self.buttons.count == 0) {
        return CGSizeZero;
    }

    double width;
    if ([model screenRotationEnabled] &&
        UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }

    return CGSizeMake(width, self.height);
}


- (void) layoutSubviews {
    [super layoutSubviews];

    BOOL oddNumberOfButtons = ((self.buttons.count % 2) == 1);

    for (int i = 0; i < self.buttons.count; i++) {
        UIButton* button = [self.buttons objectAtIndex:i];

        NSInteger column;
        NSInteger row;
        if (oddNumberOfButtons && i != 0) {
            column = (i + 1) % 2;
            row = (i + 1) / 2;
        } else {
            column = i % 2;
            row = i / 2;
        }

        CGRect frame = button.frame;
        frame.origin.x = (column == 0 ? 10 : (self.frame.size.width / 2) + 4);
        frame.origin.y = (8 + frame.size.height) * row + 8;

        if (i == 0 && oddNumberOfButtons) {
            frame.size.width = (self.frame.size.width - 2 * frame.origin.x);
        } else {
            frame.size.width = (self.frame.size.width / 2) - 14;
        }

        button.frame = frame;
    }
}

@end