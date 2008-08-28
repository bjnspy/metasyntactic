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