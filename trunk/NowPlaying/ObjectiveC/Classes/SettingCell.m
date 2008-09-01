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

#import "SettingCell.h"

#import "ColorCache.h"

@implementation SettingCell

@synthesize valueLabel;
@synthesize valueColor;

- (void) dealloc {
    self.valueLabel = nil;
    self.valueColor = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.valueLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.valueColor = [ColorCache commandColor];
        
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.minimumFontSize = valueLabel.font.pointSize - 4;

        [self.contentView addSubview:valueLabel];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect frame = valueLabel.frame;
    frame.origin.y = floor((self.contentView.frame.size.height - valueLabel.frame.size.height) / 2);
    frame.origin.x = self.contentView.frame.size.width - frame.size.width;
    
    if (self.accessoryType == UITableViewCellAccessoryNone) {
        frame.origin.x -= 10;
    }

    valueLabel.frame = frame;
}


- (void) setKey:(NSString*) key
          value:(NSString*) value {
    self.text = key;
    valueLabel.text = value;

    [valueLabel sizeToFit];
    CGRect frame = valueLabel.frame;
    valueLabel.frame = frame;
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        valueLabel.textColor = [UIColor whiteColor];
    } else {
        valueLabel.textColor = valueColor;
    }
}


@end