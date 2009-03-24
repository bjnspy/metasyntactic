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

#import "AutoResizingCell.h"

@interface AutoResizingCell()
@property (retain) UILabel* label_;
@property (retain) UIColor* textColorData_;
@end


@implementation AutoResizingCell

@synthesize label_;
@synthesize textColorData_;

property_wrapper(UILabel*, label, Label);
property_wrapper(UIColor*, textColorData, TextColorData);

- (void) dealloc {
    self.label = nil;
    self.textColorData = nil;

    [super dealloc];
}

- (id) init {
    if (self = [super initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:nil]) {
        self.textColorData = [UIColor blackColor];
        self.label = [[[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        self.label.font = self.font;
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.minimumFontSize = 12;
        self.label.lineBreakMode = UILineBreakModeMiddleTruncation;

        CGRect frame = self.label.frame;
        frame.origin.x = 10;
        self.label.frame = frame;

        [self.contentView addSubview:self.label];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];

    CGRect labelFrame = self.label.frame;
    CGRect contentFrame = self.contentView.frame;

    if (self.image != nil) {
        labelFrame.origin.x = 15 + self.image.size.width;
    }

    labelFrame.size.width = MIN(labelFrame.size.width, contentFrame.size.width - labelFrame.origin.x);
    labelFrame.origin.y = floor((contentFrame.size.height - labelFrame.size.height) / 2);

    self.label.frame = labelFrame;
    //[self.contentView bringSubviewToFront:label];
}


- (void) setText:(NSString*) text {
    //[super setText:text];
    self.label.text = text;
    [self.label sizeToFit];
}


- (NSString*) text {
    return self.label.text;
}


- (void) setTextColor:(UIColor*) color {
    self.label.textColor = color;
    self.textColorData = color;
}


- (void) setSelected:(BOOL) selected
            animated:(BOOL) animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.label.textColor = self.selectedTextColor;
    } else {
        self.label.textColor = self.textColorData;
    }
}

@end