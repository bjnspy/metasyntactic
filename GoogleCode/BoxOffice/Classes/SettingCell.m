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

#import "SettingCell.h"

#import "ColorCache.h"

@implementation SettingCell

@synthesize valueLabel;

- (void) dealloc {
    self.valueLabel = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.valueLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.valueLabel.textColor = [ColorCache commandColor];

        [self addSubview:valueLabel];
    }
    return self;
}


- (void) setKey:(NSString*) key
          value:(NSString*) value {
    self.text = key;
    self.valueLabel.text = value;

    [valueLabel sizeToFit];
    CGRect frame = valueLabel.frame;
    frame.origin.x = 320 - 38 - frame.size.width;
    frame.origin.y = 11;
    valueLabel.frame = frame;
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.valueLabel.textColor = [UIColor whiteColor];
    } else {
        self.valueLabel.textColor = [ColorCache commandColor];
    }
}


@end
