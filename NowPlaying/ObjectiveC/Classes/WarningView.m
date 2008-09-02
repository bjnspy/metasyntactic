//
//  WarningView.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 9/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WarningView.h"

#import "ColorCache.h"
#import "DateUtilities.h"
#import "FontCache.h"
#import "ImageCache.h"
#import "Utilities.h"

@implementation WarningView

@synthesize imageView;
@synthesize label;

const NSInteger LABEL_X = 47;
const NSInteger TOP_BUFFER = 5;

- (void) dealloc {
    self.imageView = nil;
    self.label = nil;

    [super dealloc];
}


- (id) init:(NSDate*) syncDate {
    if (self = [super initWithFrame:CGRectZero]) {
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.text = [Utilities generateShowtimesRetrievedOnString:syncDate];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor groupTableViewBackgroundColor];
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


+ (WarningView*) view:(NSDate*) syncDate {
    return [[[WarningView alloc] init:syncDate] autorelease];
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
        frame.origin.x = 10;
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