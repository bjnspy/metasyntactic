// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "ReviewBodyCell.h"

#import "FontCache.h"
#import "Review.h"
#import "Utilities.h"

@implementation ReviewBodyCell

@synthesize review;
@synthesize label;

- (void) dealloc {
    self.review = nil;
    self.label = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.label = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.label.font = [FontCache helvetica14];
        self.label.lineBreakMode = UILineBreakModeWordWrap;
        self.label.numberOfLines = 0;

        [self.contentView addSubview:label];
    }
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    self.label.text = review.text;

    double width = self.frame.size.width;
    width -= 40;
    if (![Utilities isNilOrEmpty:review.link]) {
        width -= 25;
    }

    CGRect rect = CGRectMake(10, 5, width, [ReviewBodyCell height:review] - 10);
    self.label.frame = rect;
}


+ (CGFloat) height:(Review*) review {
    double width;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    width -= 40;
    if (![Utilities isNilOrEmpty:review.link]) {
        width -= 25;
    }

    CGSize size = CGSizeMake(width, 2000);
    size = [review.text sizeWithFont:[FontCache helvetica14]
                   constrainedToSize:size
                       lineBreakMode:UILineBreakModeWordWrap];

    return size.height + 10;
}


@end
