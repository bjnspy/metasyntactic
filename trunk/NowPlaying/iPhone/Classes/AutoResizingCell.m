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
/*
#import "AutoResizingCell.h"

@interface AutoResizingCell()
@property (retain) UILabel* label;
@property (retain) UIColor* textColorData;
@end


@implementation AutoResizingCell

@synthesize label;
@synthesize textColorData;

- (void) dealloc {
    self.label = nil;
    self.textColorData = nil;

    [super dealloc];
}

- (id) initWithFrame:(CGRect) frame
     reuseIdentifier:(NSString*) reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        self.textColorData = [UIColor blackColor];
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

    if (self.image != nil) {
        labelFrame.origin.x = 15 + self.image.size.width;
    }

    labelFrame.size.width = MIN(labelFrame.size.width, contentFrame.size.width - labelFrame.origin.x);
    labelFrame.origin.y = floor((contentFrame.size.height - labelFrame.size.height) / 2);

    label.frame = labelFrame;
}


- (void) setText:(NSString*) text {
    label.text = text;
    [label sizeToFit];
}


- (NSString*) text {
    return label.text;
}


- (void) setTextColor:(UIColor*) color {
    label.textColor = color;
    self.textColorData = color;
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        label.textColor = self.selectedTextColor;
    } else {
        label.textColor = textColorData;
    }
}

@end
*/