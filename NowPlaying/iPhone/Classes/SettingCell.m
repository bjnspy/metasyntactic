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

#import "SettingCell.h"

#import "ColorCache.h"

@interface SettingCell()
@property (retain) UILabel* valueLabel;
@property (retain) UIColor* valueColor;
@end


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