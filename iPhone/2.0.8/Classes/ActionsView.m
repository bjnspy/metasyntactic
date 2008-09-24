// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ActionsView.h"


@implementation ActionsView

@synthesize target;
@synthesize selectors;
@synthesize titles;
@synthesize buttons;

- (void) dealloc {
    self.target = nil;
    self.selectors = nil;
    self.titles = nil;
    self.buttons = nil;

    [super dealloc];
}


- (id) initWithTarget:(id) target_
            selectors:(NSArray*) selectors_
               titles:(NSArray*) titles_ {
    if (self = [super initWithFrame:CGRectZero]) {
        self.target = target_;
        self.selectors = selectors_;
        self.titles = titles_;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];

        NSMutableArray* array = [NSMutableArray array];
        for (NSString* title in titles) {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setTitle:title forState:UIControlStateNormal];
            [button sizeToFit];

            [button addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

            [array addObject:button];
            [self addSubview:button];
        }

        self.buttons = array;

        {
            int lastRow = (buttons.count - 1) / 2;

            UIButton* button = [buttons lastObject];
            CGRect frame = button.frame;
            height = (8 + frame.size.height) * (lastRow + 1);
        }
    }

    return self;
}


+ (ActionsView*) viewWithTarget:(id) target
                      selectors:(NSArray*) selectors
                         titles:(NSArray*) titles {
    return [[[ActionsView alloc] initWithTarget:(id) target
                                      selectors:selectors
                                         titles:titles] autorelease];
}


- (void) onButtonPressed:(UIButton*) button {
    SEL selector = [[selectors objectAtIndex:[buttons indexOfObject:button]] pointerValue];
    [target performSelector:selector];
}


- (CGSize) sizeThatFits:(CGSize) size {
    if (buttons.count == 0) {
        return CGSizeZero;
    }

    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }

    return CGSizeMake(width, height);
}


- (CGFloat) height {
    return height;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    for (int i = 0; i < buttons.count; i++) {
        UIButton* button = [buttons objectAtIndex:i];
        NSInteger column = i % 2;
        NSInteger row = i / 2;

        CGRect frame = button.frame;
        frame.size.width = (self.frame.size.width / 2) - 14;
        frame.origin.x = (column == 0 ? 10 : (self.frame.size.width / 2) + 4);
        frame.origin.y = (8 + frame.size.height) * row + 8;
        button.frame = frame;
    }
}


@end