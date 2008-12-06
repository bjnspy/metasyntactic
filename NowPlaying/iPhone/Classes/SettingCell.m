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
@property (retain) UILabel* keyLabel;
@property (retain) UILabel* valueLabel;
@property (retain) UILabel* separatorLine;
@property (retain) UIFont* cachedFont;
@end


@implementation SettingCell

@synthesize keyLabel;
@synthesize valueLabel;
@synthesize separatorLine;
@synthesize cachedFont;

- (void) dealloc {
    self.keyLabel = nil;
    self.valueLabel = nil;
    self.separatorLine = nil;
    self.cachedFont = nil;

    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.keyLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];

        self.valueLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        valueLabel.textColor = [ColorCache commandColor];
        valueLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.minimumFontSize = valueLabel.font.pointSize - 4;

        self.separatorLine = [[[UILabel alloc] init] autorelease];

        [self.contentView addSubview:keyLabel];
        [self.contentView addSubview:valueLabel];
    }

    return self;
}


- (void) resizeLabels {
    [keyLabel sizeToFit];
    [valueLabel sizeToFit];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    if (cachedFont == nil) {
        self.cachedFont = self.font;
        self.keyLabel.font = self.cachedFont;
        [self resizeLabels];
    }

    CGRect keyFrame = keyLabel.frame;
    keyFrame.origin.y = floor((self.contentView.frame.size.height - keyFrame.size.height) / 2);
    keyFrame.origin.x = 10;
    keyLabel.frame = keyFrame;

    CGRect valueFrame = valueLabel.frame;
    valueFrame.origin.y = floor((self.contentView.frame.size.height - valueFrame.size.height) / 2);
    valueFrame.origin.x = MAX(keyFrame.origin.x + keyFrame.size.width + 10,
                              self.contentView.frame.size.width - valueFrame.size.width);
    valueFrame.size.width = MIN(valueFrame.size.width,
                                self.contentView.frame.size.width - valueFrame.origin.x);

    if (self.accessoryType == UITableViewCellAccessoryNone) {
        valueFrame.origin.x -= 10;
    }

    valueLabel.frame = valueFrame;

    CGRect separatorFrame = CGRectMake(1, -1, self.contentView.frame.size.width - 2, 1);
    separatorLine.frame = separatorFrame;
}


- (void) setKey:(NSString*) key
          value:(NSString*) value
  hideSeparator:(BOOL) hideSeparator  {
    keyLabel.text = key;
    valueLabel.text = value;

    [separatorLine removeFromSuperview];
    if (hideSeparator) {
        [self.contentView addSubview:separatorLine];
    }

    [self resizeLabels];
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        keyLabel.textColor = [UIColor whiteColor];
        valueLabel.textColor = [UIColor whiteColor];
    } else {
        keyLabel.textColor = [UIColor blackColor];
        valueLabel.textColor = [ColorCache commandColor];
    }
}

@end