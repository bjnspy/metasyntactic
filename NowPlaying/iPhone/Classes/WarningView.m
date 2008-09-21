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

#import "WarningView.h"

#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"

@implementation WarningView

@synthesize imageView;
@synthesize label;

const NSInteger LABEL_X = 52;
const NSInteger TOP_BUFFER = 5;

- (void) dealloc {
    self.imageView = nil;
    self.label = nil;

    [super dealloc];
}


- (id) init:(NSString*) text {
    if (self = [super initWithFrame:CGRectZero]) {
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];

        self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.text = text;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.font = [FontCache footerFont];
        label.textColor = [ColorCache footerColor];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
        label.textAlignment = UITextAlignmentCenter;

        self.imageView = [[[UIImageView alloc] initWithImage:[ImageCache warning32x32]] autorelease];

        [self addSubview:imageView];
        [self addSubview:label];
    }

    return self;
}


+ (WarningView*) view:(NSString*) text {
    return [[[WarningView alloc] init:text] autorelease];
}

- (void) layoutSubviews {
    {
        NSString* text = label.text;
        CGRect frame = label.frame;
        frame.origin.x = LABEL_X;
        frame.origin.y = TOP_BUFFER;
        frame.size.width = self.frame.size.width - 10 - frame.origin.x;
        frame.size.height = [text sizeWithFont:[FontCache footerFont]
                             constrainedToSize:CGSizeMake(frame.size.width, 2000)
                                 lineBreakMode:UILineBreakModeWordWrap].height;
        label.frame = frame;
    }

    {
        CGRect frame = imageView.frame;
        frame.origin.x = 20;
        frame.origin.y = MAX(label.frame.origin.y, label.frame.origin.y + (int)((label.frame.size.height - [ImageCache warning32x32].size.height) / 2.0));
        imageView.frame = frame;
    }
}

- (CGFloat) height {
    double imageHeight = [ImageCache warning32x32].size.height;

    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }

    NSInteger labelX = LABEL_X;
    NSInteger labelWidth = width - 10 - labelX;
    NSString* text = label.text;
    double labelHeight = [text sizeWithFont:[FontCache footerFont]
                          constrainedToSize:CGSizeMake(labelWidth, 2000)
                              lineBreakMode:UILineBreakModeWordWrap].height;

    return TOP_BUFFER + MAX(imageHeight, labelHeight);
}


@end
