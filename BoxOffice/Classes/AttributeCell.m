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

#import "AttributeCell.h"

#import "ColorCache.h"

@implementation AttributeCell

@synthesize keyLabel;
@synthesize valueLabel;

- (void) dealloc {
    self.keyLabel = nil;
    self.valueLabel = nil;

    [super dealloc];
}

+ (UIFont*) keyFont {
    return [UIFont boldSystemFontOfSize:12.0];
}


- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.keyLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.valueLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];

        self.keyLabel.textColor = [ColorCache commandColor];
        self.keyLabel.font = [AttributeCell keyFont];
        self.keyLabel.textAlignment = UITextAlignmentRight;

        self.valueLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.valueLabel.adjustsFontSizeToFitWidth = YES;
        self.valueLabel.minimumFontSize = 10.0;

        [self.contentView addSubview:keyLabel];
        [self.contentView addSubview:valueLabel];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    {
        CGRect frame = keyLabel.frame;
        frame.origin.y = floor((self.contentView.frame.size.height - keyLabel.frame.size.height) / 2);
        keyLabel.frame = frame;
    }

    {
        CGRect frame = valueLabel.frame;
        frame.origin.y = floor((self.contentView.frame.size.height - valueLabel.frame.size.height) / 2);
        frame.size.width = self.contentView.frame.size.width - frame.origin.x;
        valueLabel.frame = frame;
    }
}


- (void) setKey:(NSString*) key
          value:(NSString*) value
       keyWidth:(CGFloat) keyWidth {
    self.keyLabel.text = key;
    self.valueLabel.text = value;

    {
        [self.keyLabel sizeToFit];
        CGRect frame = self.keyLabel.frame;
        frame.origin.x = keyWidth - frame.size.width;
        self.keyLabel.frame = frame;
    }

    {
        [self.valueLabel sizeToFit];
        CGRect frame = self.valueLabel.frame;
        frame.origin.x = keyWidth + 10;
        self.valueLabel.frame = frame;
    }
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.keyLabel.textColor = [UIColor whiteColor];
        self.valueLabel.textColor = [UIColor whiteColor];
    } else {
        self.keyLabel.textColor = [ColorCache commandColor];
        self.valueLabel.textColor = [UIColor blackColor];
    }
}


@end