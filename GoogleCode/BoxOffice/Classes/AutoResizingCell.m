//
//  AutoResizingCell.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 8/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AutoResizingCell.h"

@implementation AutoResizingCell

@synthesize label;

- (void) dealloc {
    self.label = nil;

    [super dealloc];
}

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        label.font = self.font;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 12;
        label.lineBreakMode = UILineBreakModeMiddleTruncation;

        CGRect frame = label.frame;
        frame.origin.x = 10;
        label.frame = frame;

        [self.contentView addSubview:label];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect labelFrame = label.frame;
    CGRect contentFrame = self.contentView.frame;

    labelFrame.size.width = MIN(labelFrame.size.width, contentFrame.size.width - labelFrame.origin.x);
    labelFrame.origin.y = floor((contentFrame.size.height - labelFrame.size.height) / 2);

    label.frame = labelFrame;
}


- (void) setText:(NSString*) text {
    label.text = text;
    [label sizeToFit];
}

@end
